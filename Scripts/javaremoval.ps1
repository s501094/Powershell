﻿#This script is used to remove any old Java versions, and leave only the newest.
#Developer: Ty Ellis
#Modified by: Ty Ellis
#Version 1.4 - Updated 2018-03-05
#			 - Now removes Java 8 and Below.
#            - Added uninstall default behaviour to never reboot (now uses msiexec.exe for uninstall)
#            - Now also detects and removes old Java non-update base versions (i.e. Java versions without Update #)
#
#
# IMPORTANT NOTE: Do not use this tool if you dont know what your doing.
$uninstalljava8andbelow = $true

#Declare version arrays
$32bitJava = @()
$64bitJava = @()
$32bitVersions = @()
$64bitVersions = @()

#Perform WMI query to find installed Java Updates
if ($UninstallJava8andBelow)
{
	$32bitJava += Get-WmiObject -Class Win32_Product | Where-Object {
		$_.Name -match "(?i)Java(\(TM\))*\s\d+(\sUpdate\s\d+)*$"
	}
	#Also find Java version 5, but handled slightly different as CPU bit is only distinguishable by the GUID
	$32bitJava += Get-WmiObject -Class Win32_Product | Where-Object {
		($_.Name -match "(?i)J2SE\sRuntime\sEnvironment\s\d[.]\d(\sUpdate\s\d+)*$") -and ($_.IdentifyingNumber -match "^\{32")
	}
}
else
{
	$32bitJava += Get-WmiObject -Class Win32_Product | Where-Object {
		$_.Name -match "(?i)Java((\(TM\) 7)|(\s\d+))(\sUpdate\s\d+)*$"
	}
}

#Perform WMI query to find installed Java Updates (64-bit)
if ($uninstalljava8andbelow)
{
	$64bitJava += Get-WmiObject -Class Win32_Product | Where-Object {
		$_.Name -match "(?i)Java(\(TM\))*\s\d+(\sUpdate\s\d+)*\s[(]64-bit[)]$"
	}
	#Also find Java version 5, but handled slightly different as CPU bit is only distinguishable by the GUID
	$64bitJava += Get-WmiObject -Class Win32_Product | Where-Object {
		($_.Name -match "(?i)J2SE\sRuntime\sEnvironment\s\d[.]\d(\sUpdate\s\d+)*$") -and ($_.IdentifyingNumber -match "^\{64")
	}
}
else
{
	$64bitJava += Get-WmiObject -Class Win32_Product | Where-Object {
		$_.Name -match "(?i)Java((\(TM\) 7)|(\s\d+))(\sUpdate\s\d+)*\s[(]64-bit[)]$"
	}
}

#Enumerate and populate array of versions
Foreach ($app in $32bitJava)
{
	if ($app -ne $null) { $32bitVersions += $app.Version }
}

#Enumerate and populate array of versions
Foreach ($app in $64bitJava)
{
	if ($app -ne $null) { $64bitVersions += $app.Version }
}

#Create an array that is sorted correctly by the actual Version (as a System.Version object) rather than by value.
$sorted32bitVersions = $32bitVersions | %{ New-Object System.Version ($_) } | sort
$sorted64bitVersions = $64bitVersions | %{ New-Object System.Version ($_) } | sort
#If a single result is returned, convert the result into a single value array so we don't run in to trouble calling .GetUpperBound later
if ($sorted32bitVersions -isnot [system.array]) { $sorted32bitVersions = @($sorted32bitVersions) }
if ($sorted64bitVersions -isnot [system.array]) { $sorted64bitVersions = @($sorted64bitVersions) }
#Grab the value of the newest version from the array, first converting 
$newest32bitVersion = $sorted32bitVersions[$sorted32bitVersions.GetUpperBound(0)]
$newest64bitVersion = $sorted64bitVersions[$sorted64bitVersions.GetUpperBound(0)]

Foreach ($app in $32bitJava)
{
	if ($app -ne $null)
	{
		# Remove all versions of Java, where the version is not newest version.
		if (($app.Version -ne $newest32bitVersion) -and ($newest32bitVersion -ne $null))
		{
			$appGUID = $app.Properties["IdentifyingNumber"].Value.ToString()
			Start-Process -FilePath "msiexec.exe" -ArgumentList "/qn /norestart /x $($appGUID)" -Wait -Passthru
			#write-host "Uninstalling 32-bit version: " $app
		}
	}
}

Foreach ($app in $64bitJava)
{
	if ($app -ne $null)
	{
		# Remove all versions of Java, where the version does not match the newest version.
		if (($app.Version -ne $newest64bitVersion) -and ($newest64bitVersion -ne $null))
		{
			$appGUID = $app.Properties["IdentifyingNumber"].Value.ToString()
			Start-Process -FilePath "msiexec.exe" -ArgumentList "/qn /norestart /x $($appGUID)" -Wait -Passthru
			#write-host "Uninstalling 64-bit version: " $app
		}
	}
}

