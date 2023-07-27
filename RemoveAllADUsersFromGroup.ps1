Import-Module ActiveDirectory

Write-Host "This script will delete all members of the specified AD group"

# Prompt user for group name
$group = Read-Host -Prompt "Type in group name"

#Retrieve all members in specified group using SamAccountName field
$groupMembers = Get-ADGroupMember $group | select SamAccountName -expandproperty SamAccountName

# Ask for a Y/N confirmation
$userconfirmation = Read-Host -Prompt "This will delete all group members, are you sure you'd like to continue?, enter Y/N"

# If userconfirmation is Y, delete everyone in specified group using foreach loop
if ($userconfirmation -eq "Y") 
{
    foreach ($user in $groupMembers) 
    {
        Remove-ADGroupMember -Identity $group -Members $user -Confirm:$FALSE
    }
    $groupMembers | Out-File ".\DeletedUsers.txt"
    Write-Host -ForegroundColor green -BackgroundColor white "All users deleted, should you need to restore, please see generated DeletedUsers.txt file."
}

# If userconfirmation is N, do nothing
else 
{
    Write-Host -ForegroundColor red -BackgroundColor white "No changes made"
}

