<#
 # Script FileName: func_Get-ExternalIP.ps1
 # Current Version: A01
 # Description: Retrieve External IP
 # Created By: Adam Listek
 # Version Notes
 #      A01 - Initial Release
 #>

Function Get-ExternalIP {
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

        # https://www.ipify.org/
        $url = 'https://api.ipify.org?format=json'
    } # Terminate Begin

    Process {
        Try {
            $response = Invoke-WebRequest -Uri "$url" -Method GET
        } Catch {
            Write-Host $error[0] -BackgroundColor Red
            Break
        } # Terminate Try-Catch

        If ($response) {
            $response | ConvertFrom-Json | Select -ExpandProperty IP
        } Else {
            Write-Host "Something went wrong..." -BackgroundColor Red
        } # Terminate If - Response
    } # Terminate Process
} # Terminate Function