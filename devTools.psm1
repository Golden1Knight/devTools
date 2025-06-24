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
function p-fdtext {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text,
	[string]$PythonExe = "python",
        [string]$ScriptUrl = "https://raw.githubusercontent.com/Golden1Knight/devTools/main/fonted_text_tool.py"
    )
        # Ścieżka do tymczasowego pobrania skryptu
    $tempScript = Join-Path $env:TEMP "fonted_text_tool.py"

    # Pobierz skrypt z GitHuba
    Invoke-WebRequest -Uri $ScriptUrl -OutFile $tempScript -UseBasicParsing

    # Sprawdź, czy python jest dostępny
    if (-not (Get-Command $PythonExe -ErrorAction SilentlyContinue)) {
        throw "Python nie jest dostępny w ścieżce systemowej."
    }

    # Sprawdź, czy biblioteka pyfiglet jest zainstalowana, jeśli nie - zainstaluj ją
    $checkModuleScript = @"
try:
    import pyfiglet
except ImportError:
    import subprocess
    import sys
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'pyfiglet'])
"@

    # Zapisz ten kod do pliku tymczasowego
    $checkModulePath = Join-Path $env:TEMP "check_pyfiglet.py"
    $checkModuleScript | Out-File -FilePath $checkModulePath -Encoding utf8

    # Uruchom skrypt sprawdzający i instalujący bibliotekę
    & $PythonExe $checkModulePath

    # Teraz uruchom właściwy skrypt z przekazanym tekstem
    # Używamy cudzysłowów, aby tekst był przekazany jako jeden argument
    $output = & $PythonExe $tempScript $Text

    # Zwróć wynik
    return $output.Trim()
}


	
