function devTools {
    param (
        [Parameter(Mandatory)]
        [ValidateSet("compare")]
        [string]$command,

        [Parameter(Mandatory)]
        [string]$folder1,

        [Parameter(Mandatory)]
        [string]$folder2,

        [switch]$onfi,
        [switch]$ond
    )

    if ($command -eq "compare") {

        $items1 = Get-ChildItem -Path $folder1 -Recurse -File
        $items2 = Get-ChildItem -Path $folder2 -Recurse -File

        $sumSize1 = ($items1 | Measure-Object -Property Length -Sum).Sum
        $sumSize2 = ($items2 | Measure-Object -Property Length -Sum).Sum

        $created1 = ($items1 | Sort-Object CreationTime | Select-Object -First 1).CreationTime
        $created2 = ($items2 | Sort-Object CreationTime | Select-Object -First 1).CreationTime

        $modified1 = ($items1 | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
        $modified2 = ($items2 | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime

        $count1 = $items1.Count
        $count2 = $items2.Count

        $relative1 = $items1 | ForEach-Object { $_.FullName.Substring($folder1.Length).TrimStart("\") }
        $relative2 = $items2 | ForEach-Object { $_.FullName.Substring($folder2.Length).TrimStart("\") }

        $allFiles = ($relative1 + $relative2 | Sort-Object -Unique)

        $col1 = $folder1
        $col2 = $folder2

        $summary = @(
            [PSCustomObject]@{ "$col1" = $folder1;          "$col2" = $folder2 },
            [PSCustomObject]@{ "$col1" = "$sumSize1 bytes"; "$col2" = "$sumSize2 bytes" },
            [PSCustomObject]@{ "$col1" = "$created1";       "$col2" = "$created2" },
            [PSCustomObject]@{ "$col1" = "$modified1";      "$col2" = "$modified2" },
            [PSCustomObject]@{ "$col1" = "$count1 files";   "$col2" = "$count2 files" }
        )

        $fileRows = @()
        foreach ($file in $allFiles) {
            $f1 = if ($relative1 -contains $file) { $file } else { "" }
            $f2 = if ($relative2 -contains $file) { $file } else { "" }

            if ($onfi -and ($f1 -ne "" -and $f2 -ne "")) {
                continue  # pomijaj wspólne
            }

            $fileRows += [PSCustomObject]@{
                "$col1" = $f1
                "$col2" = $f2
            }
        }

        if ($ond) {
            $summary | Format-Table -AutoSize
        }
        elseif ($onfi) {
            $fileRows | Format-Table -AutoSize
        }
        else {
            ($summary + $fileRows) | Format-Table -AutoSize
        }
    }
}
