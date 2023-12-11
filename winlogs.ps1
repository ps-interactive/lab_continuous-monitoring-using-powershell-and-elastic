$userpass="elastic:yourpassword"
$userbyte=[System.Text.Encoding]::ASCII.GetBytes($userpass)
$b64text=[System.Convert]::ToBase64String($userbyte)
$authHeader="Basic $b64text"
$headers=@{
    Authorization=$authHeader
    "Content-Type"="application/x-ndjson"
}

$winlogs = Import-CSV /home/pslearner/lab/defenderlogs.txt

$body=@"
{ "mappings":{ "properties":{ "message":{"type":"text"} } } }
"@
$output = Invoke-RestMethod -Uri "https://172.31.24.22:9200/windowslogs" -Method Put -Headers $headers -Body $body -SkipCertificateCheck


$winlogs.ForEach({
    $body = ConvertTo-Json $_
    $output = Invoke-RestMethod -Uri "https://172.31.24.22:9200/windowslogs/_doc" -Method Post -Headers $headers -Body $body -SkipCertificateCheck
})
