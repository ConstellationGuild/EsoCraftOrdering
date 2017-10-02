cls
$sourceDir = ".\CraftOrdering"
$targetDir = [Environment]::GetFolderPath("MyDocuments") + "\Elder Scrolls Online\live\AddOns\CraftOrdering"
if (Test-Path $targetDir) {
    Remove-Item -path $targetDir -Recurse -Force
}
Copy-Item $sourceDir $targetDir -recurse -container

$date = Get-Date
Write-Host $date -ForegroundColor Green
Write-Host "Addon deployed to $targetDir" -ForegroundColor Green