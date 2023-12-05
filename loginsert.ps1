$userpass="elastic:yourpassword"
$userbyte=[System.Text.Encoding]::ASCII.GetBytes($userpass)
$b64text=[System.Convert]::ToBase64String($userbyte)
$authHeader="Basic $b64text"
$headers=@{
    Authorization=$authHeader
    "Content-Type"="application/x-ndjson"
}

$suspectusers = Import-CSV /home/pslearner/lab/users.csv

$suspectusers.ForEach({
    $entry=New-Object -TypeName PSCustomObject
    Add-Member -InputObject $entry -MemberType NoteProperty -Name "Item" -Value $suspectusers[$_].id
    Add-Member -InputObject $entry -MemberType NoteProperty -Name "ipaddr" -Value $suspectusers[$_].ip_address
    Add-Member -InputObject $entry -MemberType NoteProperty -Name "username" -Value $suspectusers[$_].username
    Add-Member -InputObject $entry -MemberType NoteProperty -Name "useragent" -Value $suspectusers[$_].useragent

    $body = @"
    $($entry | ConvertTo-Json)
    "@

    $output = Invoke-RestMethod -Uri "https://172.31.24.22:9200/suspectusers/_doc" -Method Post -Headers $headers -Body $body -SkipCertificateCheck

})

$output=Invoke-RestMethod -Uri "https://172.31.24.22:9200/suspectusers/_search?size=1000" -Method Get -Headers $headers -SkipCertificateCheck

$output.hits.hits._source
