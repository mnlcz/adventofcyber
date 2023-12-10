Param
(
    [Parameter(Mandatory = $true, Position = 0)]
    [String]$Year,
    
    [Parameter(Mandatory = $true, Position = 1)]
    [String]$Day
)

$Root = Get-Location
$YearDir = Join-Path -Path $Root -ChildPath $Year

$DayName = "Día $Day"

New-Item -Path $YearDir -Name $DayName -ItemType Directory

$DayDir = Join-Path -Path $YearDir -ChildPath $DayName

New-Item -Path $DayDir -Name "img" -ItemType Directory

$MdTemplate = @"
# Advent of Cyber ${DayName}: ADDTODAYTOPIC

## Introducción

## Objetivos de aprendizaje

## Resolución
"@

Add-Content -Path "$DayDir/day$Day.md" -Value $MdTemplate -Encoding utf8