<#
 # Script FileName: func_Add-Commit.ps1
 # Current Version: A01
 # Description: Commit and Push GIT Changes
 # Created By: Adam Listek
 # Version Notes
 #      A01 - Initial Release
 #>

Function Add-Commit {
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
    )] # Terminate CmdletBinding

    Param(
        [Parameter(Position=0)][String]$Message,
        [Switch]$RefreshRepository
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
    } # Terminate Begin

    Process {
        If (-not $Message) {
            $message = "[{2} - {0} {1} ({3})] Files Updated" -F `
                            (get-date).ToShortDateString(),`
                            (get-date).ToLongTimeString(),`
                            $env:USERNAME,
                            $env:COMPUTERNAME
        } # Terminate If - Message

        $measure = Measure-Command {
            & git add .
            & git commit -m "$message"
            & git push origin master
        }

        "Committed in: {0} seconds" -f $measure.Seconds

        If ($RefreshRepository) {
            Invoke-DBRefreshRepository
        } # Terminate If - Refresh Repository
    } # Terminate Process
} # Terminate Function