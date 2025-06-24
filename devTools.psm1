function clear {cls}
function win-cmd {cmd}
function m-rand {
	param(
 		[int]$mn = 0
   		[int]$mx = 999999999999
        )
	Get-Random -Minimum $mn -Maximum $mx
}
	
