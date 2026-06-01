Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Scope CurrentUser
Write-Host "CIS Microsoft 365 Foundations Benchmark" -ForegroundColor Green
Write-Host "v7.0.0 - 05-20-2026" -ForegroundColor Green
Write-Host "Microsoft Teams admin center" -ForegroundColor Green


if (-not (Get-Module -ListAvailable MicrosoftTeams)) {
  Install-Module MicrosoftTeams `
      -Repository PSGallery `
      -Scope CurrentUser `
      -Force
}
Import-Module "$PSScriptRoot\..\microsoft_365_foundations\perform_audit.psm1"
Import-Module MicrosoftTeams -Scope Global

Connect-MicrosoftTeams

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
Start-Transcript ".\Teams-CIS-Audit-$Timestamp.txt"

Perform-Audit `
  -License "E3" `
  -Level "L2" `
  -Section "8.1.1" `
  -Title "Ensure external file sharing in Teams is enabled for only approved cloud storage services" `
  -Code {
    $Params = @(
    'AllowDropbox'
    'AllowBox'
    'AllowGoogleDrive'
    'AllowShareFile'
    'AllowEgnyte'
    )
    Get-CsTeamsClientConfiguration -Identity Global | fl $Params
  } `
  -ValidationGuidance "Verify that only authorized providers are set to True and all others False."

Perform-Audit `
  -License "E5" `
  -Level "L1" `
  -Section "8.1.2" `
  -Title "Ensure users can't send emails to a channel email address" `
  -Code {
    Get-CsTeamsClientConfiguration -Identity Global | fl AllowEmailIntoChannel
  } `
  -ValidationGuidance "Ensure the returned value is False."

Perform-Audit `
  -License "E3" `
  -Level "L3" `
  -Section "8.2.1" `
  -Title "Ensure external domains are restricted in the Teams admin center" `
  -Code {
    Get-CsExternalAccessPolicy -Identity Global
  } `
  -ValidationGuidance "Verify that EnableFederationAccess is False."

Perform-Audit `
  -License "E3" `
  -Level "L2" `
  -Section "8.2.1" `
  -Title "Ensure external domains are restricted in the Teams admin center" `
  -Code {
    Get-CsExternalAccessPolicy -Identity Global
  } `
  -ValidationGuidance "Verify that EnableFederationAccess is False."

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "8.2.2" `
  -Title "Ensure communication with unmanaged Teams users is disabled" `
  -Code {
    Get-CsExternalAccessPolicy -Identity Global
  } `
  -ValidationGuidance "Verify that EnableTeamsConsumerAccess is set to False."

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "8.2.3" `
  -Title "Ensure external Teams users cannot initiate conversations" `
  -Code {
    Get-CsExternalAccessPolicy -Identity Global
  } `
  -ValidationGuidance "Verify that EnableTeamsConsumerInbound is False"

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "8.2.4" `
  -Title "EEnsure the organization cannot communicate with accounts in trial Teams tenants" `
  -Code {
    Get-CsTenantFederationConfiguration
  } `
  -ValidationGuidance "Verify that ExternalAccessWithTrialTenants is set to Blocked."

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "8.4.1" `
  -Title "Ensure app permission policies are configured" `
  -ValidationGuidance "@
    For Third-party apps verify Let users install and use available apps
    For Custom apps verify Let users install and use available apps by default is Off.
    For Custom apps verify Let users interact with custom apps in preview is Off.@"

  Perform-Audit `
  -License "E3" `
  -Level "L2" `
  -Section "8.5.1" `
  -Title "Ensure anonymous users can't join a meeting" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl AllowAnonymousUsersToJoinMeeting
  } `
  -ValidationGuidance "Verify that the returned value is False."

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "8.5.2" `
  -Title "Ensure anonymous users and dial-in callers can't start a meeting" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl AllowAnonymousUsersToStartMeeting
  } `
  -ValidationGuidance "Verify that the returned value is False."

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "8.5.3" `
  -Title "Ensure only people in my org can bypass the lobby" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl AutoAdmittedUsers
  } `
  -ValidationGuidance "@Verify that the returned value is one of the following strings:
    o InvitedUsers
    o EveryoneInCompanyExcludingGuests
    o OrganizerOnly@"

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "8.5.4" `
  -Title "Ensure users dialing in can't bypass the lobby" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl AllowPSTNUsersToBypassLobby
  } `
  -ValidationGuidance "Verify that the value is False."

Perform-Audit `
  -License "E3" `
  -Level "L2" `
  -Section "8.5.5" `
  -Title "Ensure meeting chat does not allow anonymous users" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl MeetingChatEnabledType
  } `
  -ValidationGuidance "@Verify that the returned value is EnabledExceptAnonymous or a more restrictive 
    value EnabledInMeetingOnlyForAllExceptAnonymous or Disabled.@"

Perform-Audit `
  -License "E3" `
  -Level "L2" `
  -Section "8.5.6" `
  -Title "Ensure only organizers and co-organizers can present" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl DesignatedPresenterRoleMode
  } `
  -ValidationGuidance "Verify that the returned value is OrganizerOnlyUserOverride."

Perform-Audit `
  -License "E3" `
  -Level "L1" `
  -Section "8.5.7" `
  -Title "Ensure external participants can't give or request control" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl AllowExternalParticipantGiveRequestControl
  } `
  -ValidationGuidance "Verify that the returned value is False."

Perform-Audit `
  -License "E3" `
  -Level "L2" `
  -Section "8.5.8" `
  -Title "Ensure external meeting chat is off" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl
    AllowExternalNonTrustedMeetingChat
  } `
  -ValidationGuidance "Verify that the returned value is False."

Perform-Audit `
  -License "E3" `
  -Level "L2" `
  -Section "8.5.9" `
  -Title "Ensure meeting recording is off by default" `
  -Code {
    Get-CsTeamsMeetingPolicy -Identity Global | fl AllowCloudRecording
  } `
  -ValidationGuidance "Verify that the returned value is False."

Stop-Transcript