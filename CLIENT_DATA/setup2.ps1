# Quelle Base Script https://de.switch-case.com/68391193 oder serverfault... mod AK

$AdminsGroupSID = "S-1-5-32-544"
$UsersGroupSID = "S-1-5-32-545"
$GuestsGroupSID = "S-1-5-32-546"





$UserNames = @("Admin1;Lehrer;Schueler")
$UserPasswords = @("pwadmin3KKJ!!!;pwlKehrer1211K2!;pwlKehrer1211K2")
$UserGroups = @("Administratoren;Benutzer;Benutzer")

$ArrayUserNames = $Usernames.split(";")
$ArrayUserPasswords = $UserPasswords.split(";")
$ArrayGroups = $UserGroups.split(";")

# start checking array sizes
if ($ArrayUserNames.Length -ne $ArrayGroups -ne $ArrayUserPasswords) {
  write-host "Array sizes of Usergroups, Usernames or Userpasswords does not fit"
  exit 1
}

$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

# start looping
For ($i=0; $i -lt $ArrayUserNames.Length; $i++) {
  $ObjLocalUser = $null
  Try {
    Write-Verbose "Searching for $($ArrayUserNames[$i]) in LocalUser DataBase"
    $ObjLocalUser = Get-LocalUser $ArrayUserNames[$i]
    Write-Verbose "User $($ArrayUserNames[$i]) was found"
  }

  Catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
    "User $($ArrayUserNames[$i]) was not found" | Write-Warning
  }

  Catch {
    "An unspecifed error occured" | Write-Error
    Exit 2# Stop Powershell! 
  }

  #Create the user if it was not found (Example)
  If (!$ObjLocalUser) {
    Write-Verbose "Creating User $($ArrayUserNames[$i])" #(Example)
    $SecurePassword = ConvertTo-SecureString $ArrayUserPasswords[$i] -AsPlainText -Force
    New-LocalUser -Name $ArrayUserNames[$i] -Password $SecurePassword -AccountNeverExpires -PasswordNeverExpires -FullName $ArrayUserNames[$i] -UserMayNotChangePassword
    # Add User to group
    Add-LocalGroupMember -Group $ArrayGroups[$i] -Member $ArrayUserNames[$i] 
  }
}

#>

#Remove-LocalUser -ErrorAction SilentlyContinue