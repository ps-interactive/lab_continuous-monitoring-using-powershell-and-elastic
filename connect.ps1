$userpass="elastic:yourpassword"
$userbyte=[System.Text.Encoding]::ASCII.GetBytes($userpass)
$b64text=[System.Convert]::ToBase64String($userbyte)
$authHeader="Basic $b64text"
$headers=@{
    Authorization=$authHeader
    "Content-Type"="application/x-ndjson"
}

$output = Invoke-RestMethod -Uri "https://172.31.24.22:9200" -Method Get -Headers $headers -SkipCertificateCheck

$output

