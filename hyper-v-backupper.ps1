[Cmdletbinding()]
param(
[parameter(mandatory=$true)][string]$destination=$(throw "enter destination folder"),
[parameter(mandatory=$true)][int]$backupdepth=$(throw "enter number of backups to keep"),
[string]$password=$null,
[string]$intermediarydir=$env:TEMP
)

$name = Get-Date -format "yyyy-MM-dd-HH-mm"

Get-VM | ForEach-Object {Export-VM -Name $_.Name -Path "$intermediarydir\$name" -CaptureLiveState CaptureSavedState -AsJob} | Wait-Job

if ([string]::IsNullOrEmpty($password))
{
	& "$env:ProgramFiles\7-Zip\7z.exe" a -mx=9  "$destination\$name.7z" "$intermediarydir\$name"
}
else
{
	& "$env:ProgramFiles\7-Zip\7z.exe" a -mx=9 -p="$password" "$destination\$name.7z" "$intermediarydir\$name"
}
"$intermediarydir\$name" | Remove-Item

while ((Get-ChildItem "$destination" -filter *.7z | measure-object).Count -gt $backupdepth)
{
	Get-ChildItem -Path "$destination" -filter *.7z | sort creationtime | select -First 1 | Remove-Item
}
