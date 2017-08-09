      $UserObject = [PSCustomObject]@{
        'UserPrincipalName' = "Bianca.Schulten@test.verstegen-online.de"
        'ObjectGuid' = "223457"
        'Mail' = "Bianca.Schulten@test.verstegen-online.de"
        'Country' = "DE"
        'ImmutableId' = "31uuS2M4B0a4JMbPcEbw8g=="
      }

$KeyFile = "AES.key"
$Key = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file $KeyFile

$PasswordFile = "AESpassword.txt"
$KeyFile = "AES.key"
$Key = Get-Content $KeyFile
$Password = "S2402v88#2018" | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile