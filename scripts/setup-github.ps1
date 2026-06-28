# Push general-partner to GitHub
# Run after: gh auth login

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "GitHub CLI (gh) is not installed. Run: winget install GitHub.cli"
}

$status = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Not logged in to GitHub. Run: gh auth login" -ForegroundColor Yellow
    exit 1
}

$existing = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Remote origin already exists: $existing"
    git push -u origin main
    exit $LASTEXITCODE
}

Write-Host "Creating GitHub repo and pushing..."
gh repo create general-partner `
    --public `
    --source=. `
    --remote=origin `
    --description "General-purpose thinking partner agent for Cursor (brainstorming, organization, research, tasks)" `
    --push

if ($LASTEXITCODE -eq 0) {
    gh repo view --json url -q .url
    Write-Host "Done." -ForegroundColor Green
}
