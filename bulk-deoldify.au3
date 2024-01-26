#include <Array.au3>
#include <File.au3>
#include <WinAPIFiles.au3>

; these are copy-and-paste lines for testing purposes
;_ArrayDisplay($arr, "alert")
;MsgBox(0, "alert", $str)

Local $cwd = _WinAPI_GetCurrentDirectory()

Local $blackAndWhiteFolderPath = $cwd
Local $originalFolderPath = $blackAndWhiteFolderPath & "\original";
Local $coloredFolderPath = $blackAndWhiteFolderPath & "\colored";
Local $deOldifyExePath = $blackAndWhiteFolderPath & "\" & getFiles($blackAndWhiteFolderPath, "exe")[1]
Local $photos = getFiles($blackAndWhiteFolderPath, "jpg")

; create the required folders
If Not FileExists($originalFolderPath) Then
	DirCreate($originalFolderPath)
EndIf
If Not FileExists($coloredFolderPath) Then
	DirCreate($coloredFolderPath)
EndIf

For $i = 1 to UBound($photos) -1
    deOldify($photos[$i])
Next

Func getFiles($dir, $fileExtension)
	Local $files = _FileListToArrayRec($dir, "*." & $fileExtension, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT)

	If @error = 1 Then
		MsgBox($MB_SYSTEMMODAL, "", "Path " & $dir & " is invalid.")
		Exit
	EndIf
	If @error = 4 Then
		MsgBox($MB_SYSTEMMODAL, "", "No " & $fileExtension & " files were found.")
		Exit
	EndIf
	
	Return $files
EndFunc

Func deOldify($filename)
	Run($deOldifyExePath)

	; change to match any substring in the title
	Opt("WinTitleMatchMode", 2)
	Local $wndMain = WinWaitActive("DeOldify")
	; revert back to match the title from the start which is default
	;Opt("WinTitleMatchMode", 1)

	Local $posMainWnd = WinGetPos($wndMain)

	; click the open button
	AutoItSetOption("MouseCoordMode", 1)
	MouseMove ($posMainWnd[0] + 200, $posMainWnd[1] + 200)
	MouseClick("left")

	; in the open window, pick the file to deoldify
	pickFile("[CLASS:#32770]", "[CLASS:Button; INSTANCE:1]", $blackAndWhiteFolderPath, $filename)

	; click the deoldify button
	MouseMove ($posMainWnd[0] + 280, $posMainWnd[1] + 355)
	MouseClick("left")

	; wait for the deoldifying process to complete, that is, when the button's text gets changeed to "Done!"
	While 1
		$var = ControlGetText($wndMain, "", "[CLASS:WindowsForms10.Window.8.app.0.34f5582_r8_ad1; INSTANCE:6]")
		Sleep(1000)
		If $var = "Done!" Then 
			ExitLoop
		EndIf
	WEnd

	; click the save button
	MouseMove ($posMainWnd[0] + 430, $posMainWnd[1] + 200)
	MouseClick("left")

	; in the save window, pick where to save
	pickFile("Save colorized", "[CLASS:Button; INSTANCE:2]", $coloredFolderPath)
	
	WinClose($wndMain)
	
	; move the original file to another folder so that it won't get picked next time
	FileMove($blackAndWhiteFolderPath & "\" & $filename, $originalFolderPath & "\" & $filename)
EndFunc

Func changePathInAddressBar($wnd, $dir)
	; click the address bar to make editable
	Local $pos = WinGetPos(ControlGetHandle($wnd, "", "[CLASS:ToolbarWindow32; INSTANCE:4]"))
	MouseMove($pos[0], $pos[1])
	MouseClick("left")

	Sleep(1000)

	; change the path in the address bar
	ControlSetText($wnd, "", "[CLASS:Edit; INSTANCE:2]", $dir)
	Send("{Enter}")
EndFunc

; pick to open or save
Func pickFile($title, $btnOk, $dir, $filename = "")
	Local $wnd = WinWaitActive($title)

	changePathInAddressBar($wnd, $dir)

	Sleep(1000)

	; set the filename
	If $filename Then
		ControlSetText($wnd, "", "[CLASS:Edit; INSTANCE:1]", $filename)

		Sleep(1000)
	EndIf

	; click ok
	ControlClick($wnd, "", $btnOk)

	Sleep(1000)
EndFunc