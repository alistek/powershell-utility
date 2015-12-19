<#
 # Script FileName: func_Update-Repository.ps1
 # Current Version: A01
 # Description: Update Repository GIT Changes
 # Created By: Adam Listek
 # Version Notes
 #      A01 - Initial Release
 #>

Function Update-Repository {
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
    )] # Terminate CmdletBinding

    Param() # Terminate Param

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
        $measure = Measure-Command {
            & git pull origin master
        }

        "Updated in: {0} seconds" -f $measure.Seconds
    } # Terminate Process
} # Terminate Function