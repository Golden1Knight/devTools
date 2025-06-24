function clear {cls}
function win-cmd {cmd}
function m-rand {
    param(
        [int]$mn = 0,
        [int]$mx = 2147483647  # max dla int32
    )
    Get-Random -Minimum $mn -Maximum $mx
}
function Get-GuidFromPython {
    param(
        [string]$PythonExe = "python",
        [string]$GitHubUrl = "https://raw.githubusercontent.com/Golden1Knight/devTools/main/guid_generator.py"
    )

    # Folder tymczasowy do pobrania skryptu
    $tempPath = Join-Path $env:TEMP "guid_generator.py"

    # Pobierz skrypt z GitHuba
    Invoke-WebRequest -Uri $GitHubUrl -OutFile $tempPath -UseBasicParsing

    # Sprawdź czy python jest dostępny
    if (-not (Get-Command $PythonExe -ErrorAction SilentlyContinue)) {
        throw "Python nie jest dostępny w ścieżce systemowej."
    }

    # Uruchom skrypt i złap wynik
    $guid = & $PythonExe $tempPath

    # Wyczyść pobrany plik jeśli chcesz (opcjonalnie)
    # Remove-Item $tempPath

    return $guid.Trim()
}


	
