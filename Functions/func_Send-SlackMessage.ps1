#Requires -Version 4.0

<#
 # Script FileName: func_Send-SlackMessage.ps1
 # Current Version: A01
 # Description: Send message to Slack Channel.
 # Created By: Adam Listek
 # Version Notes
 #      A01 - Initial Release
 #>

Function Send-SlackMessage {
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
    )] # Terminate CmdletBinding

    Param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)][String]$Message,
        [Parameter(Mandatory=$true, Position=1)][String]$Channel,
        [Parameter(Position=1)][String]$BotName = 'PowershellBot',
        [Parameter(Position=1)][ValidateSet("full","none")][String]$ParseMode = 'full',
        [Parameter(Position=1)][String]$IconURL,
        [Parameter(Position=1)][String]$IconEmoji,
        [Parameter(Mandatory=$true, Position=2)][String]$ApiKey,
        [Parameter(Mandatory=$true, Position=3)][String]$Organization,

        [Switch]$asUser = $false,
        [Switch]$unfurlLinks = $true,
        [Switch]$unfurlMedia = $false
    ) # Terminate Param

	Begin {
        If ($MyInvocation.BoundParameters.Verbose -match $true) {
            $local:VerbosePreference = "Continue"
            $local:ErrorActionPreference = "Continue"
            $local:verbose = $true
        } Else {
            $local:VerbosePreference = "SilentlyContinue"
            $local:ErrorActionPreference = "SilentlyContinue"
            $local:verbose = $false
        } # Terminate If - Verbose Parameter Check

        If ($MyInvocation.BoundParameters.Debug -eq $true) {
            $local:debug = $true
        } Else {
            $local:debug = $false
        } # Terminate Preferences

        If ($MyInvocation.BoundParameters.WhatIf -eq $true) {
            $local:whatif = $true
        } Else {
            $local:whatif = $false
        } # Terminate Preferences

        # Current Script Name
        $scriptName = $MyInvocation.MyCommand.Name

        $url = "https://$organization.slack.com/api"
    } # Terminate Begin

    Process {
        Write-Verbose $apikey
        Write-Verbose $url
        Write-Verbose ($header | Out-String)

        $body = [Ordered]@{
            "token"        = $ApiKey
            "channel"      = "#$($Channel)"
            "text"         = '```' + $($message | Out-String) + '```'
            "parse"        = $ParseMode
            "username"     = $BotName
            "as_user"      = $asUser
            "unfurl_links" = $unfurlLinks
            "unfurl_media" = $unfurlMedia
        }

        If ($IconURL)   { $body.Add("icon_url",$IconURL) }

        If ($IconEmoji) { $body.Add("icon_emoji",$IconEmoji) }

        If ($pscmdlet.ShouldProcess("$body", "Send Message")) {
            Try {
                $response = Invoke-RestMethod -Uri "$url/chat.postMessage" -Body $body -Method POST
            } Catch {
                Write-Host $error[0] -BackgroundColor Red
                Break
            } # Terminate Try-Catch

            If ($response) {
                $response | fl *
            } Else {
                Write-Host "Something went wrong..." -BackgroundColor Red
            } # Terminate If - Response
        } # Terminate WhatIF
    } # Terminate Process
} # Terminate Function