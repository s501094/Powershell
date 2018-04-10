$DLTeam = Get-DistributionGroup -Filter {ManagedBy -eq "Intra.infousa.com/Corporate/Special/Users/Abdoo, Earl"}
foreach ($team in $DLTeam) {
    Set-DistributionGroup $team -ManagedBy "intra.infousa.com/Corporate/infoUSA/Papillion/National Accounts/Users/Jezerski, Tracey"
}