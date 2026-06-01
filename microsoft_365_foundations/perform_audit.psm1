function Perform-Audit {
  param(
    [ValidateSet("E3", "E5")]
    [string]$License,
    [ValidateSet("L1", "L2")]
    [string]$Level,
    [string]$Section,
    [string]$Title,
    [scriptblock]$Code,
    [string]$ValidationGuidance
  )
  Write-Host "============================================================" -ForegroundColor Green
  Write-Host "[$Section] $Title`n"

  Write-Host "Profile Applicability:"
  switch ($License) {
      "E3" {
          Write-Host "* E3 Level $Level`n"
      }
      "E5" {
          Write-Host "* E3 Level $Level"
          Write-Host "* E5 Level $Level`n"
      }
  }

  if ($Code) {
    try {
      & $Code
    } catch {
      Write-Host "ERROR:" -ForegroundColor Red
      Write-Host $_
    }
  } else {
    Write-Host "Manual Test Required" -ForegroundColor Cyan
  }
  Write-Host ""
  Write-Host "Validation Guidance:" -ForegroundColor Cyan
  Write-Host $ValidationGuidance

  Write-Host "============================================================" -ForegroundColor Green

  $Choice = Read-Host "[ENTER] Continue  |  Q Quit"

  if ($Choice.ToUpper() -eq "Q") {
    throw "Audit stopped by user"
  } else {
    Clear-Host
  }
}
