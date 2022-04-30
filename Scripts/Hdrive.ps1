#Capture login ID
$loginID = Read-Host "Enter UserID to create H: drive for:"
#check to see if AD account exists
If (Get-ADUser -LDAPFilter "(sAMAccountName=$loginID)")
{
	#set HomeDir path and create folder
	$location = '\\*server*\homes$\Standard\'
	New-Item -Path $location -Name $loginID -Type Directory
	$path = "$location\$loginID"
	# Create new, "blank", Security Descriptor
	$acl = New-Object System.Security.AccessControl.DirectorySecurity
	#Create User ACE
	$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
	$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
	$colRights = [System.Security.AccessControl.FileSystemRights]"Modify" 
	$objType =[System.Security.AccessControl.AccessControlType]::Allow
	$objUser = "*domain*\$loginID"
	$accessrule = New-Object System.Security.AccessControl.FileSystemAccessRule($objUser, $colRights, $InheritanceFlag, $PropagationFlag, $objType)
	$acl.AddAccessRule($accessrule)
	# Define the user as the owner of that folder
	$Account = New-Object System.Security.Principal.NTAccount("iusa\$loginID")
	$acl.SetOwner($Account)
	#Write ACL to folder
	Set-Acl $path $acl
	#Update AD with HomeDir folder
	$homepath = "\\*server*\$loginID$"
	$user = Get-aduser -LDAPFilter "(sAMAccountName=$loginID)" -SearchBase "dc=domain, dc=domain, dc=com" -Properties samaccountname, homeDirectory, HomeDrive | Select-Object samaccountname, homeDirectory, HomeDrive
	Set-ADUser -Identity $user.samaccountname -HomeDirectory $homepath -HomeDrive "H:"
}
else
{
Write-Host "AD Account $loginID does not exist"
}
