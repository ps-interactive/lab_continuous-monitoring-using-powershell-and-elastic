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
{
"query":{
"query_string" : {"default_field" : "message", "query" : "*MSEDGEWIN10*"}
}

}
"@

$output = Invoke-RestMethod -Uri "https://172.31.24.22:9200/windowslogs/_search?pretty" -Method Post -Headers $headers -Body $body -SkipCertificateCheck
