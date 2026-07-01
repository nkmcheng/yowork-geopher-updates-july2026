$port = 8734
# serve from the directory this script lives in
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:$port/")
$listener.Start()
Write-Output "Serving $root at http://127.0.0.1:$port/yowork-geopher-update.html"

$mime = @{
  ".html" = "text/html"
  ".mp4"  = "video/mp4"
  ".css"  = "text/css"
  ".js"   = "application/javascript"
  ".png"  = "image/png"
  ".webp" = "image/webp"
  ".svg"  = "image/svg+xml"
}

while ($listener.IsListening) {
  $context = $listener.GetContext()
  $request = $context.Request
  $response = $context.Response
  try {
    $relPath = [Uri]::UnescapeDataString($request.Url.LocalPath.TrimStart('/'))
    if ([string]::IsNullOrWhiteSpace($relPath)) { $relPath = "yowork-geopher-update.html" }
    $filePath = Join-Path $root $relPath

    if (Test-Path $filePath -PathType Leaf) {
      $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
      $contentType = $mime[$ext]
      if (-not $contentType) { $contentType = "application/octet-stream" }
      $response.ContentType = $contentType

      $fileInfo = Get-Item $filePath
      $fileLength = $fileInfo.Length
      $rangeHeader = $request.Headers["Range"]

      $fs = [System.IO.File]::OpenRead($filePath)
      try {
        if ($rangeHeader -and $rangeHeader.StartsWith("bytes=")) {
          $rangeSpec = $rangeHeader.Substring(6).Split("-")
          $start = [long]$rangeSpec[0]
          $end = if ($rangeSpec[1]) { [long]$rangeSpec[1] } else { $fileLength - 1 }
          $length = $end - $start + 1

          $response.StatusCode = 206
          $response.AddHeader("Content-Range", "bytes $start-$end/$fileLength")
          $response.ContentLength64 = $length
          $response.AddHeader("Accept-Ranges", "bytes")

          $fs.Seek($start, [System.IO.SeekOrigin]::Begin) | Out-Null
          $buffer = New-Object byte[] 65536
          $remaining = $length
          while ($remaining -gt 0) {
            $toRead = [Math]::Min($buffer.Length, $remaining)
            $read = $fs.Read($buffer, 0, $toRead)
            if ($read -le 0) { break }
            $response.OutputStream.Write($buffer, 0, $read)
            $remaining -= $read
          }
        } else {
          $response.AddHeader("Accept-Ranges", "bytes")
          $response.ContentLength64 = $fileLength
          $fs.CopyTo($response.OutputStream)
        }
      } finally {
        $fs.Close()
      }
    } else {
      $response.StatusCode = 404
      $bytes = [System.Text.Encoding]::UTF8.GetBytes("Not found")
      $response.OutputStream.Write($bytes, 0, $bytes.Length)
    }
  } catch {
    try { $response.StatusCode = 500 } catch {}
  } finally {
    $response.OutputStream.Close()
  }
}
