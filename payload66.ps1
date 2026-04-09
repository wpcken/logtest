# 1. 定義路徑變數
$url = 'https://github.com/wpcken/logtest/raw/refs/heads/main/agent.zip'
$zipPath = "$env:TEMP\agent.zip"
$destPath = "$env:TEMP\agent"

# 2. 下載壓縮檔
(New-Object Net.WebClient).DownloadFile($url, $zipPath)

# 3. 洗掉壓縮檔本身的 MOTW (Mark of the Web) 安全標籤
Unblock-File -Path $zipPath

# 4. 解壓縮到目標資料夾 (-Force 會直接覆蓋舊檔案，確保每次執行都是最新版)
Expand-Archive -Path $zipPath -DestinationPath $destPath -Force

# 5. 遞迴洗掉解壓縮出來的「所有檔案」的 MOTW 標籤 (避免 exe 被防毒攔截)
Get-ChildItem -Path $destPath -Recurse | Unblock-File

# 6. 背景啟動你的 Agent 執行檔，並設定正確的工作目錄
Start-Process -FilePath "$destPath\agent.exe" -WorkingDirectory $destPath