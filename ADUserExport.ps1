﻿<#	
=================================================================================
# Created with: 	Powershell v5.1												#
# Created on:   	3/28/2018													#
# Created by:   	tylere														#
# Organization: Infogroup/Landesk Engineering									#
# Filename: Contractor list populate											#
# Discription: searches for users based off contractor listing in office site	#
=================================================================================
#>

Import-Module ActiveDirectory

Get-ADUser -filter { physicalDeliveryOfficeName -eq 'Offsite/Contractor' } |

Select-Object DistinguishedName |

Export-CSV -Path '\\stcsanisln01\lanadmin\Landesk_Engineering\Scripts\data\Contractorlist.csv'
