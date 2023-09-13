#Requires AutoHotkey v2.0-beta
; v1.22.11.0

if WinExist("명일방주") {
	Tries := GetValidInput("Enter tries count", "Try ", " times?")
	Time := GetValidInput("Enter time to wait", "Wait ", " seconds?")*1000
	
	While Tries > 0 {
		; Start
		RelativeClick("명일방주", 0.9, 0.875)
		Sleep 5000
		
		; Coffee
		RelativeClick("명일방주", 0.85, 0.80)
		Sleep 5000
		
		; Start
		RelativeClick("명일방주", 0.9, 0.875)
		Sleep 5000
		
		; InGame
		RelativeClick("명일방주", 0.875, 0.8)
		Sleep Time
		
		; GameResult
		RelativeClick("명일방주", 0.5, 0.5)
		Sleep 15000
		
		Tries -= 1
	}
	
	MsgBox("Macro ended at " A_MM "/" A_DD " " A_Hour ":" A_Min)
} else {
	MsgBox("명일방주 instance not exists")
}

GetValidInput(T, U, V) {
	A := "No"
	while A = "No" {
		R:= InputBox(T, , "W200 H100").Value
		if R = ""
			ExitApp
		A := MsgBox(U R V, , "YesNo")
	}
	return R
}

RelativeClick(T, Rx, Ry) {
	if WinGetPosEx(WinExist(T), &X, &Y, &W, &H) {
		IsFullscreen := false
		Count := SysGet(80) ; 80=SM_CMONITORS
		
		Loop Count {
			MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
			if X = Left and Y = Top and X+W = Right and Y+H = Bottom {
				IsFullscreen := true
			}
		}
	
		If IsFullscreen {
			ControlClick("X" Rx*W " Y" Ry*H, T, , , , "Pos")
		} else {
			ControlClick("X" Rx*(W-2)+1 " Y" Ry*(H-32)+31, T, , , , "Pos")
		}
	}
}

WinGetPosEx(HWND, &X := 0, &Y := 0, &W := 0, &H := 0) {
	Buf := Buffer(16)
	if !DllCall("dwmapi\DwmGetWindowAttribute", "Ptr", HWND, "UInt", 9, "Ptr", Buf.ptr, "UInt", 16) {
		X := NumGet(Buf, "Int")
		Y := NumGet(Buf, 4, "Int")
		W := NumGet(Buf, 8, "Int") - X
		H := NumGet(Buf, 12, "Int") - Y
		return true
	}
}