<#	
	.NOTES
=========================================================================
# Created with: 	Powershell v5.1										#
# Created on:   	3/28/2018											#
# Created by:   	tylere												#
# Organization: 	Infogroup/Landesk-Engineering						#
# Filename: Move users in selected csv to different OU in AD.			#	
=========================================================================
#>


Invoke-Item (start powershell '& \\stcsanisln01\lanadmin\landesk-engineering-scripts\ADuserExport.ps1')


# Import AD Module
import-module ActiveDirectory

$MoveList = Import-Csv -Path "\\stcsanisln01\lanadmin\Landesk_Engineering\Scripts\data\contractorlist.csv"
# Specify target OU.This is where users will be moved.
$TargetOU = "OU=Users,OU=Contractors,OU=Corporate,DC=intra,DC=infousa,DC=com"
# Import the users from CSV
$imported_csv = Import-Csv -Path "\\stcsanisln01\lanadmin\Landesk_Engineering\Scripts\data\contractorlist.csv"

foreach ($record in $imported_csv)
{
	# Get the users DistinguishedName
	get-aduser -Identity $record.distinguishedname
	# Move the user
	move-adobject -Identity $record.DistinguishedName -TargetPath $TargetOU
}
Write-Host " Done "
$total = ($MoveList).count
$total
Write-Host 'Accounts have been moved.'