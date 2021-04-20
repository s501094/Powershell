<#	
=================================================================================
# Created with: 	Powershell v5.1												#
# Created on:   	3/28/2018													#
# Created by:   	tylere														#
# Organization: System Administrator/IAM Lead                                   #
# Filename: Contractor list populate											#
# Discription: searches for users based off contractor listing in office site	#
=================================================================================
#>

Import-Module ActiveDirectory

Get-ADUser -filter { physicalDeliveryOfficeName -eq 'Offsite/Contractor' } |

Select-Object SamAccountName |

Export-CSV -Path '\\intra.infousa.com\stc\Common\tylereScripttest\Contractors\contractorlist.csv'
