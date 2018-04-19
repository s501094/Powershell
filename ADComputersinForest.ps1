<#	
=================================================================================
# Created with: 	Powershell v5.1												#
# Created on:   	4/19/2018													#
# Created by:   	tylere														#
# Organization: Infogroup/Landesk Engineering									#
# Filename: Contractor list populate											#
# Discription: searches for users based off contractor listing in office site	#
=================================================================================
#>

Import-Module ActiveDirectory

Get-ADComputer -filter { Name -Like "*IUSA*" } -Properties Name, OperatingSystem | Select-Object Name, OperatingSystem |

Export-CSV -Path '\\stcsanisln01\lanadmin\Landesk_Engineering\Scripts\data\ComputersinAD.csv'

Get-ADComputer -Filter { Name -Like "V-*" } -Properties Name, OperatingSystem | Select-Object Name, OperatingSystem |

Export-Csv -Path '\\stcsanisln01\lanadmin\Landesk_Engineering\Scripts\data\VMsinAD.csv'