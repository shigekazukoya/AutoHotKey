;方向キー
F13 & H::Send,{Blind}{Left}
F13 & J::Send,{Blind}{Down}
F13 & K::Send,{Blind}{Up}
F13 & L::Send,{Blind}{Right}

;Alt+方向キー
LAlt & H::Send,{Blind}{Lalt}{Left}
LAlt & J::Send,{Blind}{Lalt}{Down}
LAlt & K::Send,{Blind}{Lalt}{Up}
LAlt & L::Send,{Blind}{Lalt}{Right}

;Win+l 回避の為
f14::LWin
#l::
	Send,{Win Up}
	run,rundll32.exe user32.dll`,LockWorkStation
return

;BS Delete
F13::Send,{BackSpace}
+F13::Send {Delete}

;Home End PgUp Pgdn
F13 & T::Send,{Home}
F13 & E::Send,{End}
F13 & U::Send,{PgUp}
F13 & D::Send,{Pgdn}

F13 & M::Send,{APPSKEY}
F13 & w::Send,^{F4}
F13 & O::Send,{APPSKEY}{a} ; 管理者権限で実行
F13 & y::Send,{BackSpace}
F13 & R::Reload      ;リロード
F13 & f::Edit        ;編集

; task切り替え用
F13 & 1::Send,#1
F13 & 2::Send,#2
F13 & 3::Send,#3
F13 & 4::Send,#4
F13 & 5::Send,#5
F13 & 6::Send,#6
F13 & 7::Send,#7
F13 & 8::Send,#8
F13 & 9::Send,#9

; Keypirinha taskSwitcher
F13 & c::Send,!{Space} {s}{w}{i}{c}{h}{Tab}

;選択したパスのフォルダを開く もしくは検索
F13 & g::
ClipSaved := ClipboardAll
Send,^c
If (RegExMatch(Clipboard, "^https?://")) {
    Run, %Clipboard%
}
If (RegExMatch(Clipboard, "\\")) {
    Run, %Clipboard%, , UseErrorLevel
    If (ErrorLevel != 0) {
        Run, Explorer.exe
    }
}
else{
Run,https://www.google.co.jp/search?q="""%Clipboard%""
}

Clipboard := ClipSaved
ClipSaved =
Return


; 英語に変換
Lalt::
WinGet, vcurrentwindow, ID, A
    vimestate := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", vcurrentwindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)
if (vimestate == 1) {
	Send,{sc029}
}
return

; 日本語変換変換
F15::
WinGet, vcurrentwindow, ID, A
    vimestate := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", vcurrentwindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)
if (vimestate == 1) {
Return
}
Send,{sc029}
return
;ローマ字の再変換
+F15::
WinGet, vcurrentwindow, ID, A
    vimestate := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", vcurrentwindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)
if (vimestate == 1) {
Return
}
	ClipSaved := ClipboardAll
	c:=""
	e:=0
	while(c!=Clipboard or c==""){
		c:=Clipboard
		Send,+{Left}
		Clipboard =
		Send,^c
		ClipWait,1
		sl:=StrLen(Clipboard)
		if(sl==0){
			e:=1
			break
		} else if(RegExMatch(SubStr(Clipboard,1,1),"[\-\~]")){
			Send,+^{Left}
		} else if(RegExMatch(Clipboard,"[^0-9a-zA-Z\-\~]")){
			if(sl==1 or (sl==2 and RegExMatch(Clipboard,"[\r\n]"))){
				e:=1
				Send,+{Right}
			} else {
				Send,+{Right}
				Clipboard =
				Send,^c
				ClipWait,1
			}
			break
		} else {
			Send,+{Right}+^{Left}
		}
		Clipboard =
		Send,^c
		ClipWait,1
	}
		Send,{sc029}	;ここにIMEをオンにする処理
	if(e==0){
		Send,%Clipboard%
	}
	Clipboard := ClipSaved
	ClipSaved =
return

; SandS
;Spaceを押したとき
$*Space::
    if (isSpaceRepeat == true)    ;キーリピートしているかどうか
    {
        if (A_PriorKey != "Space") ;Space長押し中の他キー押し下げを検出
        {
            KeyWait, Space
            Send {Blind}{ShiftUp}       ;Shiftをリリース
            isSpaceRepeat := false
            Return
        }
        else Return
    }
    Send {Blind}{ShiftDown}     ;Shiftを押し下げ
    isSpaceRepeat := true
Return
;Spaceを離したとき
$*Space up::
    Send {Blind}{ShiftUp}       ;Shiftをリリース
    isSpaceRepeat := false
    if (A_PriorKey == "Space"){     ;Space単押しを検出
        Send {Blind}{Space}     ;Spaceを入力
    }
Return

; Vim用
#IfWinActive, ahk_exe Code.exe,
~j up::
Input, jout, I T0.1 V L1, {j}
if(ErrorLevel == "EndKey:J"){
	WinGet, vcurrentwindow, ID, A
    vimestate := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", vcurrentwindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)

    If (vimestate==1)
	{
    SendInput, {BackSpace 2}{Esc 3}
	}
}
Return

; Shift空打ち
$*~LShift::Send {Blind}{Shift}
LShift up::
    if (A_PriorKey == "LShift")
    {
        Send, {Esc}
    }
Return


; ForVS
#IfWinActive, ahk_exe devenv.exe,
return