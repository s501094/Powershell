<#  
=================================================================================
# Created with:     Powershell v5.1                                             #
# Created on:       3/28/2018                                                   #
# Created by:       tylere                                                      #
# Organization: System Administrator/IAM Lead                                   #
# Filename: DLManageByChange                                                    #
# Discription: searches for users based off contractor listing in office site   #
#>

$DLTeam = Get-DistributionGroup -Filter {ManagedBy -eq "Intra.infousa.com/Corporate/Special/Users/Abdoo, Earl"}
foreach ($team in $DLTeam) {
    Set-DistributionGroup $team -ManagedBy "intra.infousa.com/Corporate/infoUSA/Papillion/National Accounts/Users/Jezerski, Tracey"
}