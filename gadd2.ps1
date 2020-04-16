$csvfile = Read-Host "CSV�t�@�C���������Ă�������"
$emails = Import-Csv -Path $csvfile | Select-Object email

If ($false -eq $?) {
    exit
}

$gmail = Read-Host "Group Address�����Ă�������"

$credential = Get-Credential

If ($false -eq $?) {
    exit
}

Connect-AzureAD -Credential $credential

If ($false -eq $?) {
    Disconnect-AzureAD
    exit
}

$group = Get-AzureADMSGroup -Filter "Mail eq `'$gmail`'"

If ($false -eq $?) {
    Disconnect-AzureAD
    exit
}

foreach ($e in $emails) {
    Write-Host $e.email
    $User = (Get-AzureADUser -ObjectId $e.email)
    # $User | FT DisplayName,UserPrincipalName
    Add-AzureAdGroupMember -ObjectId $group.Id -RefObjectId $User.ObjectId
}

Disconnect-AzureAD
