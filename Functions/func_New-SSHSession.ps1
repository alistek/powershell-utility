#Requires -Version 4.0

<#
 # Script FileName: func_New-SSHSession.ps1
 # Current Version: A02
 # Description: Create new SSH session via BitVise SSH Client.
 # Created By: Adam Listek
 # Version Notes
 #      A01 - Initial Release
 #      A02 - Updates
 #>

Function New-SSHSession {
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
    )] # Terminate CmdletBinding

    Param(
        [Parameter(Mandatory=$true, Position=0)][String]$Name,
        [Parameter(Position=1)][String]$Key = "C:\Users\Adam Listek\.ssh\id_rsa_sunphoenix_digitalocean",
        [Parameter(Position=2)][String]$Port = "55567",
        [Parameter(Position=3)][String]$Username = "root",
        [Parameter(Mandatory=$true, Position=4)][String]$ApiKey
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

        $droplets = Get-DOMachine -ApiKey:$ApiKey -Verbose:$verbose

        Write-Verbose "$($droplets | Out-String)"

        Sleep -Seconds 2

        If (-not $droplets) {
            $droplets = Get-DOMachine -apikey:$ApiKey -Verbose:$verbose

            Sleep -Seconds 2
        } # Terminate If - No Droplets, try again
    } # Terminate Begin

    Process {
        If ($droplets) {
            $droplet = $droplets | Where Name -eq $name

            $ip = $droplet.networks.v4 | Where type -eq "public" | Select -ExpandProperty ip_address

            If (-Not $whatif) {
                Try {
                    & stermc "$Username@$ip" "-port=$Port" "-keypairFile=$key"
                } Catch { 
                    Write-Host "Error!" -BackgroundColor Red
                } # Terminate Try-Catch
            } Else {
                Write-Warning "Connecting to $ip"
            } # Terminate If - Whatif
        } Else {
            Write-Host "No droplets" -BackgroundColor Red
        } # Terminate If - Droplets
    } # Terminate Process
} # Terminate Function