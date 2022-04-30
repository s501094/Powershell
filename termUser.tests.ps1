#
#                     .ed"""" """$$$$be.
#                   -"           ^""**$$$e.
#                ."                   '$$$c
#                /                      "4$$b
#               d  3                      $$$$
#               $  *                   .$$$$$$
#              .$  ^c           $$$$$e$$$$$$$$.
#              d$L  4.         4$$$$$$$$$$$$$$b
#              $$$$b ^ceeeee.  4$$ECL.F*$$$$$$$
#  e$""=.      $$$$P d$$$$F $ $$$$$$$$$- $$$$$$
# z$$b. ^c     3$$$F "$$$$b   $"$$$$$$$  $$$$*"      .=""$c
#4$$$$L        $$P"  "$$b   .$ $$$$$...e$$        .=  e$$$.
#^*$$$$$c  %..   *c    ..    $$ 3$$$$$$$$$$eF     zP  d$$$$$
#  "**$$$ec   "   %ce""    $$$  $$$$$$$$$$*    .r" =$$$$P""
#        "*$b.  "c  *$e.    *** d$$$$$"L$$    .d"  e$$***"
#          ^*$$c ^$c $$$      4J$$$$$% $$$ .e*".eeP"
#             "$$$$$$"'$=e....$*$$**$cz$$" "..d$*"
#               "*$$$  *=%4.$ L L$ P3$$$F $$$P"
#                  "$   "%*ebJLzb$e$$$$$b $P"
#                    %..      4$$$$$$$$$$ "
#                     $$$e   z$$$$$$$$$$%
#                      "*$c  "$$$$$$$P"
#                       ."""*$$$$$$$$bc
#                    .-"    .$***$$$"""*e.
#                 .-"    .e$"     "*$c  ^*b.
#          .=*""""    .e$*"          "*bc  "*$e..
#        .$"        .z*"               ^*$e.   "*****e.
#        $$ee$c   .d"                     "*$.        3.
#        ^*$E")$..$"                          *   .ee==d%
#           $.d$$$*                           *  J$$$e*
#            """""                              "$$$"
        #_____________________________________________
        #||-----------------------------------------||
        #||-----------------------------------------||
        #||------ Created By: Ty Ellis -------------||
        #||-----------Name: Terminiation script ----||
        #||-----------Date: Nov 18, 2016------------||
        #||-----------------------------------------||
        #||-----------------------------------------||
        #||-----------------------------------------||
        #||-----------------------------------------||
        #||-----------------------------------------||
        #_____________________________________________
Import-Module ActiveDirectory -DisableNameChecking
Connect-exopsession
function Write-Exception
{
    write-host "Something went wrong, see the error description below" -ForegroundColor Red -BackgroundColor white
    write-host “Error Type: $($_.Exception.GetType().FullName)” -ForegroundColor Red
    write-host “Error Message: $($_.Exception.Message)” -ForegroundColor Red
}

#try
#    {
#    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://virinfemlp004w/PowerShell/ -Authentication Kerberos -ErrorAction stop -WarningAction SilentlyContinue 
#    import-pssession $session -AllowClobber -DisableNameChecking | out-null
#    }
    
#catch
#    {
#    write-exception
#    $ErrorName = $Error[0].exception.GetType().fullname
#    $ErrorDescription = $Error[0].exception.Message
#    Throw $errorname
#        break
#    }

#Function to remove group memberships
Function Remove-Memberships
	{
		param([string]$loginID)  
 		$user = Get-ADUser $loginID -properties memberof
 		$userGroups = $user.memberof
		$userGroups | %{get-adgroup $_ | Remove-ADGroupMember -confirm:$false -member $loginID -ErrorAction Ignore}
		$userGroups = $null
	}

$a = (Get-Host).PrivateData
$a.WarningForegroundColor = "yellow"

#Prompt for manual entry/file input
$Answer = Read-Host "Would you like to use a file to import user data? (Y/N)"
$WarningPreference = 'silentlycontinue'
#Begin terminate user from file
If($Answer -eq "Y")
{
    $Confirmation = Read-Host "Please double check the information in the file. Are you sure you want to continue? (Y/N)"

    If($Confirmation -eq "Y")
        {
        Write-Host "You have chosen to proceed. Processing Termination" -BackgroundColor DarkCyan
        #Import file
        $file = "$env:USERPROFILE\documents\TerminateUsers.csv"
        $data = Import-Csv $file
        #Set disabled OU
        $disabledOU = "OU=Users,OU=Disabled Accounts, OU=Corporate, DC=*domain*, DC=*domain*, DC=com"
	
        $colOutput = @()
        foreach ($user in $data)
	        {
            #Grab variables from CSV

            $owner = $user.'Terminated Network User ID'
 		    $loginID = $user.'Terminated Network User ID'
                If ($owner -eq "")
                {
                Write-Host "Terminated Network User ID cannot be blank" -ForegroundColor Red
                break 
                }

            #Displayname required for Outlook functions
            $Identity = Get-ADUser -Identity $loginID -Properties Displayname |Select-Object -ExpandProperty Displayname 
            $manager = $user.'Provide Inbox Access To'
                If ($manager -eq " ")
                {
                Write-Host "Provide Inbox Access To cannot be blank" -ForegroundColor Red
                continue 
                }

            $NewOwner = $user.'Provide users email group ownership to'
                If ($newowner -eq " ")
                {
                Write-Host "Provide Users Email Group Ownership To cannot be blank" -ForegroundColor Red
                continue 
                }
            $NewOwnerID = $User.'Provide users email group ownership To'
		    If (Get-ADUser -Identity $loginID)
			    {
			    $date = Get-Date -Format MM/dd/yyyy
                #Disable account, change description, disable dialin, remove group memberships
                try
                {
			    Set-ADUser -Identity $loginID -Enabled $false
                Write-Host "Account Disabled" -Foregroundcolor green
                }
                catch
                {
                Write-exception
				}
				try
                {
			    Set-ADUser -Identity $loginID -Replace @{Description = "Terminated $date"}
                Write-Host "Notes Updated" -Foregroundcolor green
                }
                catch
                {
                Write-exception
				}
				try
				{
				Set-ADUser -Identity $loginID -Replace @{physicalDeliveryOfficeName = " "}
				Write-Host "Office Updated" -ForegroundColor Green
				}
				catch
				{
				Write-Exception
				}
				
				try
                {
			    Set-ADUser -Identity $loginID -Replace @{msNPAllowDialin = $False}
                Write-Host "Dialin Disabled" -Foregroundcolor green
                }
                catch
                {
                Write-exception
                }
                try
                {
                Remove-Memberships $loginID  
                write-host "Group Memberships Removed" -Foregroundcolor green
                }
                catch
                {
                Write-exception
                }
                try
                { 
                #Change loginID parameter     
                $loginID = Get-ADUser -Identity $loginID -Properties DistinguishedName 		
                #Move account to disabled OU
			    Move-ADObject -TargetPath $disabledOU -Identity $loginID
                write-host "Account Moved to the Disabled OU" -Foregroundcolor green
                }
                catch
                {
                Write-exception
                }
                try
                {
                Disable mailbox features and grant manager permissions
                Set-CASMailbox -Identity $Identity -ActiveSyncEnabled $False -ImapEnabled $False -OWAEnabled $False -PopEnabled $False 
                Write-host "ActiveSync, IMAP, OWA, and POP Disabled" -Foregroundcolor green
                Add-MailboxPermission -AccessRights FullAccess -Identity $Identity -User $manager | out-null
                Write-host "Exchange Full Access Permissions Granted to $Manager" -Foregroundcolor green
                }
                catch
                {
                Write-exception
                }
                try
                {
                $autoreplystate = Get-MailboxAutoReplyConfiguration -Identity $owner | select -ExpandProperty autoreplystate
                if($autoreplystate -eq 'Disabled')
                    {
                    set-mailboxautoreplyconfiguration -Identity $owner -AutoReplyState Enabled -Confirm:$false -externalaudience None -ExternalMessage "Sorry for the inconvenience, but the person you are trying to email is no longer with the company.  Thank you." -Internalmessage "Sorry for the inconvenience, but the person you are trying to email is no longer with the company.  Thank you."
                    write-host "Auto reply enabled for $owner" -Foregroundcolor green
                    }
                elseif($autoreplystate -eq 'Enabled')
                    {
                   write-host "Auto reply was already enabled for $owner so no changes will be made to the auto reply state or message" -foregroundcolor green
                    }
                }
                catch
                {
                Write-exception
                }            
                Try
                    {
                    Remove-Memberships $owner
                    Write-host "Group Memberships Removed" -Foregroundcolor green
                    }
                    Catch
                    {
                    Write-Host "Unable to remove all group memberships. Please manually remove them for $loginID" -ForegroundColor Red 
                    Write-Exception
                    }
                       
                     #Initiate email-group ownership script

                    $owner = Get-ADUser -Identity $owner -Properties distinguishedName | Select-Object distinguishedName
                    $ownerdn = $owner.distinguishedName
                    $data = Get-ADGroup -Filter {managedBy -eq $ownerdn} | Select-Object name, grouptype, mail, samaccountname
                    If ($data -eq $null)
                        {
                        Write-Host "No groups found managed by user." -Foregroundcolor green
                        }

                    Else
                    {
                          $newowner = Get-ADUser -Identity $manager -Properties distinguishedName | Select-Object distinguishedName
                          $newownerdn = $newowner.distinguishedName
                    ForEach ($group in $data)
                          {
                          Set-ADGroup -Identity $group.samaccountname -managedby $newownerdn}
                          Write-Host "The ownership of all groups has been reassigned to $newownerID" -Foregroundcolor green
                          }
                                        Write-Host "***Termination Successful*** `r`n `r`n" -BackgroundColor Cyan -ForegroundColor DarkBlue}  

	        Else
	            {
                #Error
		        Write-Host "User ID: $loginID not found" -ForegroundColor Red
	            }
            }
			    
        }

    Elseif ($Confirmation -eq "N")
        {
        Write-Host "You have chosen to end the task... Terminating" -ForegroundColor Red
        }
        Read-Host "Press enter to exit..."
}	

ElseIf($Answer -eq "N")
{
$colOutput = @()
Write-Host "Manual Entry Selected"

        #Gather user information
        $disabledOU = "OU=Users,OU=Disabled Accounts, OU=Corporate, DC=intra, DC=infousa, DC=com"

		$loginID = Read-Host -Prompt "Enter Terminated User ID: " 
        $email = Get-ADUser $loginID -Properties UserPrincipalName | select UserPrincipalName
        $mail = $email.UserPrincipalName
        if($loginID -eq "")
            {
                do
                {
                Write-host "Terminated User ID Cannot Be Blank" -ForegroundColor Red
                $loginID = Read-Host -Prompt "Enter Terminated User ID: " 
                }
                while($loginID -eq "")
                }
        if($loginID -ne "")
                {
                try
                {
                $Write = Get-ADUser -Identity $loginID -Properties name, employeetype, employeeID | select  Name, EmployeeType, EmployeeID
                write-host "`r`n" $write.Name "`r`n" $write.EmployeeType "`r`n" $write.EmployeeID "`r`n" -ForegroundColor Cyan
                }
                catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
                {
                Write-host "Terminated User ID not found!" -ForegroundColor Red
                remove-pssession $session
                BREAK
                }
                catch
                {
                Write-Exception
                }
            }
        $manager = Read-Host -Prompt "Enter The User ID of the person getting access to the mailbox: "
        if($manager -eq "")
            {
                do
                {
                Write-host "Field Cannot Be Blank" -ForegroundColor Red
                $manager = Read-Host -Prompt "Enter The User ID of the person getting access to the mailbox: "
                }
                while($manager -eq "")
            }
        if($manager -ne "")
        {
            try
                {
                $Write2 = Get-ADUser -Identity $manager -Properties name, employeetype, employeeID | select  Name, EmployeeType, EmployeeID
                write-host "`r`n" $write2.Name "`r`n" $write2.EmployeeType "`r`n" $write2.EmployeeID "`r`n" -ForegroundColor Cyan
                }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
                {
                Write-host "User ID not found!" -foregroundcolor Red
                remove-pssession $session
                BREAK
                }
            catch
                {
                Write-Exception
                }
        }




        $Confirmation2 = Read-Host "Please double check the information that you have provided. Are you sure that you want to continue? (Y/N)"
        $date = Get-Date -Format MM/dd/yyyy
        $owner = $loginID
	
    If($Confirmation2 -eq "Y")
        {
        Write-Host "You have chosen to proceed. Processing Termination" -BackgroundColor DarkCyan
		If (Get-ADUser -LDAPFilter "(sAMAccountName=$loginID)")
			{
			#Disable account, change description, disable dialin, remove group memberships
			TRY
            {
            Set-ADUser -Identity $loginID -Enabled $false
            Write-host "Account Disabled" -Foregroundcolor green
            }
            catch 
            {

                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "Account Not Disabled" -SmtpServer virinfemlp004w.intra.infousa.com -Body "Unable to Disable $loginID"
                continue
            } 
            try
            {
			Set-ADUser -Identity $loginID -Replace @{Description = "Terminated $date"}
            Write-host "Notes Updated" -Foregroundcolor green
            }
            catch 
            {

                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "Notes Not Updated" -SmtpServer virinfemlp004w.intra.infousa.com -Body "Notes Not Updated for $loginID"
                continue
            } 
			try
			{
			Set-ADUser -Identity $loginID -Replace @{physicalDeliveryOfficeName = " "}
			Write-Host "Office Removed" -ForegroundColor Green
			}
            catch 
            {

                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "Office Not Removed" -SmtpServer virinfemlp004w.intra.infousa.com -Body "Office Not Removed for $loginID"
                continue
			}
			try
            {
			Set-ADUser -Identity $loginID -Replace @{msNPAllowDialin = $False}
            Write-host "Dialin Disabled" -Foregroundcolor green
            }
            catch 
            {

                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "Dialin Disable Error" -SmtpServer virinfemlp004w.intra.infousa.com -Body "Dialin Disable Error $loginid"
                continue
            } 
			Try
            {
            Remove-Memberships $loginID
            Write-host "Group Memberships Removed" -Foregroundcolor green
            }
            Catch
            {
                Write-Host "Unable to remove all group memberships. Please manually remove them for $loginID" -ForegroundColor Red
                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "Group Membership Removal Issue" -SmtpServer virinfemlp004w.intra.infousa.com -Body "Unable to remove all group memberships. Please manually remove them for $loginID"
                continue
            } 

####################################################################################################################################################################################################


            try
            {
            Write-host "Disabling exchange ActiveSync, IMAP, OWA, and POP...." -Foregroundcolor green
            Set-CASMailbox -Identity $mail -ActiveSyncEnabled $False -ImapEnabled $False -OWAEnabled $False -PopEnabled $False 
            Write-host "ActiveSync, IMAP, OWA, and POP Disabled" -Foregroundcolor green
            }
            catch 
            {
                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "Disabling exchange ActiveSync, IMAP, OWA, and POP...." -SmtpServer virinfemlp004w.intra.infousa.com -Body $loginID
                continue
            } 



            try
            {
            Add-MailboxPermission -AccessRights FullAccess -Identity $mail -User $manager | out-null
            Write-host "Exchange Full Access Permissions Granted to $manager" -Foregroundcolor green
            }
            catch 
            {

                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "Failed to Grant Exchange Full Access Permissions to $Manager" -SmtpServer virinfemlp004w.intra.infousa.com -Body "User: $loginID"
                continue
            }



            try
            {
            $autoreplystate = Get-MailboxAutoReplyConfiguration -Identity $mail | select -ExpandProperty autoreplystate
            if($autoreplystate -eq 'Disabled')
                {
                set-mailboxautoreplyconfiguration -Identity $mail -AutoReplyState Enabled -Confirm:$false -externalaudience None -ExternalMessage “Sorry for the inconvenience, but the person you are trying to email is no longer with the company.  Thank you." -Internalmessage “Sorry for the inconvenience, but the person you are trying to email is no longer with the company.  Thank you.”
                write-host "Auto reply enabled for $loginID" -Foregroundcolor green
                }
            elseif($autoreplystate -eq 'Enabled')
                {
               write-host "Auto reply was already enabled for $loginID so no changes will be made to the auto reply state or message" -foregroundcolor green
                }
            }
            catch 
            {

                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "AutoReply not set for $loginID" -SmtpServer virinfemlp004w.intra.infousa.com -Body $loginID
                continue
            } 
                        
            Write-Host "Beginning removal of Licenses. " -ForegroundColor Green
            Write-Host ""
            write-host ""


            Connect-exopsession

            Write-Host "connecting to Cloud Exchange server.  " -ForegroundColor Green
            Write-Host ""
            write-host ""

            
            try
            {
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:ATP_ENTERPRISE -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:EMS -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:MCOMEETADV -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:STREAM -ErrorAction SilentlyContinue
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:POWER_BI_PRO -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:FLOWFREE -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:MICROSOFT_BUSINESS_CENTER -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:MCOEV -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:FORMS_PRO -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:MS_TEAMS_IW -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:DYN365_ENTERPRISE_PLAN1 -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:MEETING_ROOM -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:POWER_BI_STANDARD -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:MCOPSTNC -ErrorAction SilentlyContinue 
            Set-MsolUserLicense -UserPrincipalName $mail -RemoveLicenses azureinfogroup:TEAMS_COMMERCIAL_TRIAL -ErrorAction SilentlyContinue 
            
             
            write-host "All Licenses for $mail have been removed Except E3 or Webmail. " -foregroundcolor green
            }
            catch 
            {

                Send-MailMessage -From AM_Error_Report@infogroup.com -To Tyler.ellis@infogroup.com -Subject "License removal Issue" -SmtpServer virinfemlp004w.intra.infousa.com -Body "failed to remove license for $loginID"
                continue
            }         			
            
                        
################################################################################################################################################################
            
            
            #Change loginID parameter     
            $loginID = Get-ADUser -Identity $loginID -Properties DistinguishedName 		
            try
            {
            #Move account to disabled OU
			Move-ADObject -TargetPath $disabledOU -Identity $loginID
            Write-host "Account Moved to the Disabled OU" -Foregroundcolor green
            }
            catch 
            {

                Send-MailMessage -From emailaddress -To Emailaddress -Subject "Account Moved to the Disabled OU" -SmtpServer *smtpserver* -Body $loginID
                continue
            } 
               
                #Initiate email-group ownership script
            
                $owner = Get-ADUser -Identity $owner -Properties distinguishedName | Select-Object distinguishedName
                $ownerdn = $owner.distinguishedName
                $data = Get-ADGroup -Filter {managedBy -eq $ownerdn} | Select-Object name, grouptype, mail, samaccountname
                $data
                If ($data -eq $null)
                {
                Write-Host "No groups found managed by user." -Foregroundcolor green
                }

                Else
                {
                      $newowner = Get-ADUser -Identity $manager -Properties distinguishedName | Select-Object distinguishedName
                      $newownerdn = $newowner.distinguishedName
                ForEach ($group in $data)
                      {
                      Set-ADGroup -Identity $group.samaccountname -managedby $newownerdn}
                      Write-Host "The ownership of all groups has been reassigned to $newownerID" -Foregroundcolor green
                      }
                }  
            Write-Host "***Termination Successful***" -BackgroundColor Cyan -ForegroundColor DarkBlue
            Read-host "Thank you, Press enter to exit..."
            Exit
			}
		Else
			{
                #Error
				Write-Host "User ID: $loginID not found" -ForegroundColor Red
			}
        }
    Elseif($Confirmation2 -eq "N")
        {
        Write-Host "You have chosen to end the task... Terminating" -ForegroundColor Red
        }
        
Else
{
#Error
Write-Host "Invalid Entry, please try again..." -ForegroundColor Red
}
remove-pssession $session
