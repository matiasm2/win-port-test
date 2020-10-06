#region Parameters
param(
    [string[]] $File
)
#endregion

if (-not $File) {Write-Warning 'Ingrese la ruta al archivo con las ip a escanear.';exit};

$formatteddate = Get-Date -UFormat "%d%m%Y%H%M";
$file=get-content $File;
$file | ForEach-Object {
	$qryOutput = (.\PortQry.exe -n $($_.split(" ")[0]) -e $($_.split(" ")[1]) -p tcp) | Out-String
	Write-Output($qryOutput) >> "./$($formatteddate).log";
    if( $qryOutput | Select-String -Pattern ": LISTENING"){
        Write-Output("$($_.split(" ")[0]),$($_.split(" ")[1]),LISTENING") >> "./$($formatteddate).csv";
        Write-Output("$($_.split(" ")[0]),$($_.split(" ")[1]),LISTENING");
    }if( $qryOutput | Select-String -Pattern ": NOT LISTENING") {
        Write-Output("$($_.split(" ")[0]),$($_.split(" ")[1]),NOT LISTENING") >> "./$($formatteddate).csv";
        Write-Output("$($_.split(" ")[0]),$($_.split(" ")[1]),NOT LISTENING");
    }if( $qryOutput | Select-String -Pattern ": FILTERED"){
        Write-Output("$($_.split(" ")[0]),$($_.split(" ")[1]),FILTERED") >> "./$($formatteddate).csv";
        Write-Output("$($_.split(" ")[0]),$($_.split(" ")[1]),FILTERED");
    }if( $qryOutput | Select-String -Pattern "Failed to resolve name to IP address"){
        Write-Output("$($_.split(" ")[0]),$($_.split(" ")[1]),FILTERED") >> "./$($formatteddate).csv";
        Write-Output("$($_.split(" ")[0]),$($_.split(" ")[1]),FILTERED");
    }
}

Write-Output("Resultados guardados en: $($formatteddate).csv");
exit;