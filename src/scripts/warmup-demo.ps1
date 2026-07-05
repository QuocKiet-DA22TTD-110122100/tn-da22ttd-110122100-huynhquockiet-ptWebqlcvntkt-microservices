# ============================================================
# warmup-demo.ps1 — Làm ấm toàn bộ services trước khi demo
#
# Vấn đề: trên máy ít RAM, request ĐẦU TIÊN tới mỗi service có thể
# mất 30-60s (JVM chưa JIT, Hikari pool chưa mở connection, Redis
# handshake...). Chạy script này ngay sau `docker compose up` để
# request đầu tiên "trước mặt hội đồng" luôn nhanh.
#
# Cách dùng:
#   .\scripts\warmup-demo.ps1                        # mặc định gateway :8080
#   .\scripts\warmup-demo.ps1 -GatewayUrl http://127.0.0.1:8080 -Rounds 3
#
# Xử lý lỗi thường gặp:
#   - Login 401 "Invalid credentials": DB seed hash cũ — xem
#     src/docker/seed/full-auth-seed.sql (mật khẩu chuẩn Admin@123456).
#   - HR 401 "Token sai hoặc hết hạn" với token mới: hr-service cache
#     JWKS cũ sau khi auth/kms restart → `docker restart minimal-hr`.
#   - Gateway không phản hồi dù container healthy: kiểm tra
#     `docker ps -a --filter name=gateway` — container có thể Exited
#     sau khi Docker Desktop restart → `docker start minimal-gateway`.
# ============================================================
param(
    # 127.0.0.1 thay vì localhost: PowerShell 5.1 phân giải localhost ra ::1 (IPv6)
    # và treo nếu Docker chỉ forward IPv4 — curl tự fallback nhưng .NET thì không.
    [string]$GatewayUrl = "http://127.0.0.1:8080",
    [string]$Username   = "admin",
    [string]$Password   = "Admin@123456",
    [int]$Rounds        = 2,
    [int]$HealthTimeoutSec = 300
)

$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Invoke-Timed {
    param([string]$Label, [scriptblock]$Call)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        & $Call | Out-Null
        $sw.Stop()
        "{0,-38} {1,8:N0} ms   OK" -f $Label, $sw.ElapsedMilliseconds
    } catch {
        $sw.Stop()
        "{0,-38} {1,8:N0} ms   FAIL ({2})" -f $Label, $sw.ElapsedMilliseconds, $_.Exception.Message.Split("`n")[0]
    }
}

# ── 1. Đợi gateway sẵn sàng ──────────────────────────────────
Write-Host "Đợi gateway $GatewayUrl sẵn sàng (tối đa $HealthTimeoutSec giây)..." -ForegroundColor Cyan
$deadline = (Get-Date).AddSeconds($HealthTimeoutSec)
$gatewayReady = $false
while ((Get-Date) -lt $deadline) {
    try {
        Invoke-WebRequest -UseBasicParsing -Uri "$GatewayUrl/actuator/health" -TimeoutSec 10 | Out-Null
        $gatewayReady = $true
        break
    } catch {
        Start-Sleep -Seconds 5
    }
}
if (-not $gatewayReady) {
    Write-Host "Gateway chưa phản hồi sau $HealthTimeoutSec giây — kiểm tra docker compose." -ForegroundColor Red
    exit 1
}
Write-Host "Gateway OK.`n" -ForegroundColor Green

# ── 2. Làm ấm từng service qua gateway ───────────────────────
# Vòng 1 chịu cold-start (chậm); vòng cuối phải nhanh — đó là
# trải nghiệm người demo sẽ thấy.
for ($round = 1; $round -le $Rounds; $round++) {
    Write-Host "── Vòng $round/$Rounds ──────────────────────────────" -ForegroundColor Cyan

    # Login trước để lấy token (đồng thời warm Argon2 + Redis + JWT)
    $token = $null
    $loginBody = (@{ username = $Username; password = $Password } | ConvertTo-Json -Compress)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $resp = Invoke-RestMethod -Method Post -Uri "$GatewayUrl/api/xac-thuc/dang-nhap" `
            -ContentType "application/json" -Body $loginBody -TimeoutSec 120
        $sw.Stop()
        $token = $resp.accessToken
        if (-not $token) { $token = $resp.access_token }
        "{0,-38} {1,8:N0} ms   OK" -f "POST /api/xac-thuc/dang-nhap", $sw.ElapsedMilliseconds
    } catch {
        $sw.Stop()
        "{0,-38} {1,8:N0} ms   FAIL ({2})" -f "POST /api/xac-thuc/dang-nhap", $sw.ElapsedMilliseconds, $_.Exception.Message.Split("`n")[0]
    }

    $headers = @{}
    if ($token) { $headers = @{ Authorization = "Bearer $token" } }

    Invoke-Timed "GET /api/hr/employees?size=1" {
        Invoke-RestMethod -Uri "$GatewayUrl/api/hr/employees?page=0&size=1" -Headers $headers -TimeoutSec 120
    }
    Invoke-Timed "GET /api/hr/departments?size=1" {
        Invoke-RestMethod -Uri "$GatewayUrl/api/hr/departments?page=0&size=1" -Headers $headers -TimeoutSec 120
    }
    Invoke-Timed "GET /api/projects" {
        Invoke-RestMethod -Uri "$GatewayUrl/api/projects" -Headers $headers -TimeoutSec 120
    }
    Invoke-Timed "GET /api/tasks" {
        Invoke-RestMethod -Uri "$GatewayUrl/api/tasks" -Headers $headers -TimeoutSec 120
    }
    Invoke-Timed "GET /api/xac-thuc/quan-tri/tai-khoan" {
        Invoke-RestMethod -Uri "$GatewayUrl/api/xac-thuc/quan-tri/tai-khoan" -Headers $headers -TimeoutSec 120
    }
    Invoke-Timed "GET /api/xac-thuc/quan-tri/vai-tro" {
        Invoke-RestMethod -Uri "$GatewayUrl/api/xac-thuc/quan-tri/vai-tro" -Headers $headers -TimeoutSec 120
    }
    Write-Host ""
}

Write-Host "Warm-up xong — vòng cuối ở trên là tốc độ người dùng sẽ thấy." -ForegroundColor Green
