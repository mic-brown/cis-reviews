$SharePointUrl = https://isolidkeypunch-admin.sharepoint.com

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Scope CurrentUser
Write-Host "CIS Microsoft 365 Foundations Benchmark" -ForegroundColor Green
Write-Host "v7.0.0 - 05-20-2026" -ForegroundColor Green
Write-Host "Microsoft SharePoint admin center" -ForegroundColor Green

if (-not (Get-Module -ListAvailable Microsoft.Online.SharePoint)) {
  Install-Module Microsoft.Online.SharePoint `
      -Repository PSGallery `
      -Scope CurrentUser `
      -Force
}
Import-Module "$PSScriptRoot\..\microsoft_365_foundations\perform_audit.psm1"
Import-Module Microsoft.Online.SharePoint -Scope Global

Connect-SPOService -Url $SharePointUrl

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
Start-Transcript ".\SharePoint-CIS-Audit-$Timestamp.txt"

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "7.2.1" `
  -Title "Ensure modern authentication for SharePoint applications is required" `
  -Code {
    Get-SPOTenant | ft LegacyAuthProtocolsEnabled
  } `
  -ValidationGuidance "Verify that the returned value is False."


Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "7.2.2" `
  -Title "Ensure modern authentication for SharePoint applications is required" `
  -Code {
    Get-SPOTenant | ft EnableAzureADB2BIntegration
  } `
  -ValidationGuidance "Verify that the returned value is False."

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "7.2.3" `
  -Title "Ensure external content sharing is restricted" `
  -Code {
    Get-SPOTenant | ft SharingCapability
  } `
  -ValidationGuidance "Verify that SharingCapability is set to one of the following values:/n
      o ExternalUserSharingOnly/n
      o ExistingExternalUserSharingOnly/n
      o Disabled"

Perform-Audit `
  -License "E3" `
  -Level "L2" `
  -Section "7.2.4" `
  -Title "Ensure OneDrive content sharing is restricted `
  -Code {
    Get-SPOTenant | ft OneDriveSharingCapability
  } `
  -ValidationGuidance "Verify that the returned value is Disabled."


Stop-Transcript


