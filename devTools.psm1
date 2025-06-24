function clear {cls}
function win-cmd {cmd}
function m-rand {
    param(
        [int]$mn = 0,
        [int]$mx = 2147483647  # max dla int32
    )
    Get-Random -Minimum $mn -Maximum $mx
}

	
