#Monte carlo iterations
$iterations = 10000


#Market parameters
$spotPrice = 11.62
$mu = 0.0318


#Options parameters
$startDate = Get-Date (Get-Date -Format d)
$endDate = Get-Date 30/06/2030
$strike = 8.074509
$barrier = 8.76


#Exercise dates at end of quarters
$firstMonthsofQuarters = (1,4,7,10)
$exerciseDates = @()
for ($y=$startDate.Year; $y -le ($endDate.Year+1); $y++) {
    foreach ($m in $firstMonthsofQuarters) 
        { 
        $exerciseDates += (-4..-1 | % { (Get-Date (Get-Date -Year $y -Month $m -Day 1 -Format d)).AddDays($_) } | Where-Object { $_.DayOfWeek -notin 'Saturday', 'Sunday' } | Select-Object -Last 1)
        }
    }


#Gaussian generator
function Get-RandomNormal
    {
    [CmdletBinding()]
    Param ( [double]$Mean = 0, [double]$StandardDeviation = 1 )
 
    $RandomNormal = $Mean + $StandardDeviation * [math]::Sqrt( -2 * [math]::Log( ( Get-Random -Minimum 0.0 -Maximum 1.0 ) ) ) * [math]::Cos( 2 * [math]::PI * ( Get-Random -Minimum 0.0 -Maximum 1.0 ) )
 
    return $RandomNormal
    }


#Monte carlo computations
$sumpayoff = 0
$avgpayoff = 0
$date = $startDate

for ($i=1; $i -le $iterations; $i++) {

    $price = $spotPrice
    $payoff = $null
    $j = 0

    while($date -le $endDate -and $payoff -eq $null) {
    
    $date = $startDate.AddDays($j)

        if($date.DayOfWeek -notin "Saturday", "Sunday") {
            
            $norm = Get-RandomNormal
            $price = $price*(1+$norm*$mu)

            if($price -le $barrier) {$payoff = 0}
            if($date -in $exerciseDates -and $price -gt $strike) {$payoff = $price - $strike}
            if($date -in $exerciseDates -and $price -le $strike) {$payoff = 0}

        }
    
    $j++

    }

    if ($payoff) {$sumpayoff = $sumpayoff + $payoff}

}

$avgpayoff = $sumpayoff / $iterations


#Show result
"Turbo call estimated price:"
$avgpayoff


#Wait for exit
if (!$psISE) {
Write-Host "Press any key to exit..."
$x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
