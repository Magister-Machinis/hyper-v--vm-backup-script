[Cmdletbinding()]
param(
[parameter(mandatory=$true)][string]$destination=$(throw "enter destination folder"),
[parameter(mandatory=$true)][int]$backupdepth=$(throw "enter number of backups to keep"),
[string]$password=$null
)

$name = Get-Date -format "yyyy-MM-dd-HH-mm"

Get-VM | ForEach-Object {Export-VM -Name $_.Name -Path "$env:TEMP\$name" -CaptureLiveState CaptureSavedState -AsJob} | Wait-Job

if ([string]::IsNullOrEmpty($password))
{
	"'C:\Program Files\7-Zip\7z.exe' a -mx=9 -sdel '$destination\$name.7z' '$env:TEMP\$name'"
}
else
{
	"'C:\Program Files\7-Zip\7z.exe' a -mx=9 -p='$password' -sdel '$destination\$name.7z' '$env:TEMP\$name'"
}


while ((Get-ChildItem "$destination" -filter *.7z | measure-object).Count > $backupdepth)
{
	Get-ChildItem -Path "$destination" -filter *.7z | sort creationtime | select -First 1 | Remove-Item
}
