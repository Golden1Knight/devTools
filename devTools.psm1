function clear {cls}
function win-cmd {
	param(
 		[string[]]$Args
    )

 	$cmdLine = $Args -join " "
    cmd.exe /c $cmdLine
}
	
