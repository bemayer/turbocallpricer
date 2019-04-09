
$endDate = Get-Date 31/07/2019
$iterations = 10


$tabl = @()
$line = @()
$date = Get-Date
$diff = ($endDate - $date).Days

for ($i=0; $i -le $diff; $i++) {
        if($date.AddDays($i).DayOfWeek -notin "Saturday", "Sunday") {
        $line += $date.AddDays($i)}

        for ($j=1; $j -le $iterations; $j++) {

        $("price_" + $j) = 100*(1+ (Get-RandomNormal)*0.2)
    }






for ($i=1; $i -le $iterations; $i++) {

$tabl = ($tabl | Select-Object *,("Iteration_" + $i))
    
}

$tabl

$Price_0 =100

for ($i=1; $i -le $iterations; $i++) {New-Variable -Name "Price_$i" -Value $i}
for ($i=1; $i -le $iterations; $i++) {Get-Variable -Name ("Price_" + ($i-1)) -ValueOnly}


function Get-RandomNormal
    {
    [CmdletBinding()]
    Param ( [double]$Mean = 0, [double]$StandardDeviation = 1 )
 
    $RandomNormal = $Mean + $StandardDeviation * [math]::Sqrt( -2 * [math]::Log( ( Get-Random -Minimum 0.0 -Maximum 1.0 ) ) ) * [math]::Cos( 2 * [math]::PI * ( Get-Random -Minimum 0.0 -Maximum 1.0 ) )
 
    return $RandomNormal
    }

(Get-RandomNormal)*0.2
