$startDate = Get-Date 
$endDate = Get-Date 31/12/2030
$iterations = 1000
$spotPrice = 11.84
$volatility = 0.0318
$chinagov10y = 0.0332
$dailyVolatility = $true



$diff = ($endDate - $startDate).Days
if ($dailyVolatility) {$mu = $annualVolatility} else {$mu = $annualVolatility / [math]::Sqrt(252)}
$rf = [math]::Pow(1+$chinagov10y,(1/252)) - 1

$tabl = @()
$prlt = @()

for ($j=1; $j -le $iterations; $j++) {
$prit = New-Object PSObject
$prit | Add-Member "Iteration" ("Iteration_" + $j) 
$prit | Add-Member "Price" ($spotprice -as [Double])
$prlt += $prit
}

for ($i=0; $i -le $diff; $i++) {
        if($startDate.AddDays($i).DayOfWeek -notin "Saturday", "Sunday") {

        for ($j=1; $j -le $iterations; $j++) {

            $Price = $prlt[($j-1)].Price
            $Price = $Price*(1+$rf+(Get-RandomNormal)*$mu)
            $prlt[($j-1)].Price = $Price
            $iter = New-Object PSObject
            $iter | Add-Member "Date" $startDate.AddDays($i).ToString("dd/MM/yyyy")
            $iter | Add-Member "Iteration" ("Iteration_" + $j.ToString())
            $iter | Add-Member "Price" $Price

            $tabl += $iter
        }

    }
}


function Get-RandomNormal
    {
    [CmdletBinding()]
    Param ( [double]$Mean = 0, [double]$StandardDeviation = 1 )
 
    $RandomNormal = $Mean + $StandardDeviation * [math]::Sqrt( -2 * [math]::Log( ( Get-Random -Minimum 0.0 -Maximum 1.0 ) ) ) * [math]::Cos( 2 * [math]::PI * ( Get-Random -Minimum 0.0 -Maximum 1.0 ) )
 
    return $RandomNormal
    }

$tabl | Export-Csv "matrix.csv" -Delimiter ";"
