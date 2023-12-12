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
"query":{
"query_string" : {"default_field" : "*", "query" : "Defender*"}
},
"fields": [
"blah",
"blah"
]


}
"@

$output = Invoke-RestMethod -Uri "https://172.31.24.22:9200/windowslogs/_search?pretty" -Method Post -Headers $headers -Body $body -SkipCertificateCheck

$output.hits.hits._source
