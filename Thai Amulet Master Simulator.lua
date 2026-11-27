$ErrorActionPreference = 'Stop'
$folder = Join-Path $env:LOCALAPPDATA 'Real\scripts\MCP\ThaiAmulet'
$modules = @(
    'MoyXHub_ThaiAmulet_AutoV13.lua',
    'MoyXHub_ThaiAmulet_AutoV21_Addon.lua',
    'MoyXHub_ThaiAmulet_JobsV20.lua',
    'MoyXHub_ThaiAmulet_RecoveryV23.lua',
    'MoyXHub_SidebarScroll.lua',
    'MoyXHub_MobileResponsive.lua'
)
$utf8 = New-Object System.Text.UTF8Encoding($false)
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('-- MoyXHub | Thai Amulet Master Simulator | V23-Mobile-Beta')
[void]$sb.AppendLine('-- Combined source; generated from six original files.')
[void]$sb.AppendLine('assert(game.PlaceId == 79029248570139, "Wrong place")')
foreach ($name in $modules) {
    $path = Join-Path $folder $name
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing source: $path" }
    $source = [System.IO.File]::ReadAllText($path, $utf8)
    if ([string]::IsNullOrWhiteSpace($source) -or $source -match '\.\.\. \[\d+ chars omitted\] \.\.\.') { throw "Incomplete source: $name" }
    $eq = '='
    while ($source.Contains(']' + $eq + ']')) { $eq += '=' }
    [void]$sb.AppendLine('do')
    [void]$sb.AppendLine(('    local fn, err = loadstring([' + $eq + '['))
    [void]$sb.Append($source)
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine((']' + $eq + '], "' + $name + '")'))
    [void]$sb.AppendLine(('    assert(fn, "' + $name + ': " .. tostring(err))'))
    [void]$sb.AppendLine('    fn()')
    [void]$sb.AppendLine('end')
}
$out = Join-Path $folder 'MoyXHub_ThaiAmulet_Full.lua'
[System.IO.File]::WriteAllText($out, $sb.ToString(), $utf8)
Write-Host "Created: $out"
Write-Host "Size: $((Get-Item -LiteralPath $out).Length) bytes"
