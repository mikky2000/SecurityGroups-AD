Import-module activedirectory

Write-Output "**************************************************************************"
Write-Output "Script To Find Empty Group(s) In Security OU or any Group in AD"
Write-Output "**************************************************************************"

$Username = (whoami).Split('\')[1]


$Data =@(
$GroupMembers = Get-ADGroup -Server "abc.xyz.co.ca" -Filter * -SearchBase "OU=SecurityGroups, DC=abc, DC=xyz, DC=co, DC=ca" -Properties * |select Name, Description, Members, WhenCreated

Write-Host -f Green "Searching the entire security group of " $GroupMembers.Count "..."

$GroupMembers |Where-Object {if($_.Members.Count -eq 0){"0"}} |

Select-Object  @{Name="Display Name";Expression={$_.Name}},
                @{Name="Description";Expression={$_.Description}},
                @{Name = "Users in Group"; Expression={if($_.Members.Count -eq 0){"0"}}},
                @{Name = "WhenUserWasCreated";Expression = {$_.whenCreated}}

                
)




$Data|FT
$Data | Export-Csv -Path C:\Users\$Username\Desktop\Data.csv -NoTypeInformation

Write-Host -F Green "CSV file is saved as Data.csv on desktop"

Read-Host "Press any key to exit app"