$userpass="elastic:yourpassword"
$userbyte=[System.Text.Encoding]::ASCII.GetBytes($userpass)
$b64text=[System.Convert]::ToBase64String($userbyte)
$authHeader="Basic $b64text"
$headers=@{
    Authorization=$authHeader
    "Content-Type"="application/x-ndjson"
}

$body=@"
{
    "mappings":{
        "properties":{
            "item":{"type":"text"},
            "ipaddr":{"type":"text"},
            "username":{"type":"text"},
            "useragent":{"type":"text"},
            "message":{"type":"text"}
        }
    }
}
"@

$output = Invoke-RestMethod -Uri "https://172.31.24.22:9200/suspectusers" -Method Put -Headers $headers -Body $body -SkipCertificateCheck

$showschema = Invoke-RestMethod -Uri "https://172.31.24.22:9200/suspectusers/_mapping" -Method Get -Headers $headers -SkipCertificateCheck
$showschema | ConvertTo-Json -Depth 5
