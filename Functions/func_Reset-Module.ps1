#Requires -Version 4.0

<#
 # Script FileName: func_Reset-Module.ps1
 # Current Version: A01
 # Description: Reset loaded custom module(s).
 # Created By: Adam Listek
 # Version Notes
 #      A01 - Initial Release
 #>

Function Reset-Module {
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
    )] # Terminate CmdletBinding

    Param(
        [Parameter(Position=0)][String]$Name
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

        $modules = Get-Module | Where Name -Match "LC-"

        Write-Verbose "$($modules | Out-String)"
    } # Terminate Begin

    Process {
        If ($name) {
            Write-Verbose "Reloading $name"

            Import-Module $name -Force -Global
        } Else {
            $modules | %{
                If (-Not $whatif) {
                    Write-Verbose "Reloading $($_.Name)"

                    Import-Module $_.Name -Force -Verbose:$verbose -Global
                } Else {
                    Write-Warning "Reloading $($_.Name)"
                } # Terminate If - WhatIf
            }
        } # Terminate If - Name
    } # Terminate Process
} # Terminate Function