;方向キー
BackSpace & H::Send,{Blind}{Left}
BackSpace & J::Send,{Blind}{Down}
BackSpace & K::Send,{Blind}{Up}
BackSpace & L::Send,{Blind}{Right}

;Alt+方向キー
LAlt & H::Send,{Blind}{Lalt}{Left}
LAlt & J::Send,{Blind}{Lalt}{Down}
LAlt & K::Send,{Blind}{Lalt}{Up}
LAlt & L::Send,{Blind}{Lalt}{Right}

;Win+l 回避の為
; f14::LWin
; #l::
; 	Send,{Win Up}
; 	run,rundll32.exe user32.dll`,LockWorkStation
; return

;BS Delete
BackSpace::Send,{BackSpace}
+BackSpace::Send {Delete}

;Home End PgUp Pgdn
BackSpace & M::Send,{APPSKEY}
BackSpace & w::Send,^{F4}
BackSpace & O::Send,{APPSKEY}{a} ; 管理者権限で実行
BackSpace & y::Send,{BackSpace}

BackSpace & R::Reload      ;リロード
BackSpace & f::Edit        ;編集

; task切り替え用
BackSpace & 1::Send,#1
BackSpace & 2::Send,#2
BackSpace & 3::Send,#3
BackSpace & 4::Send,#4
BackSpace & 5::Send,#5
BackSpace & 6::Send,#6
BackSpace & 7::Send,#7
BackSpace & 8::Send,#8
BackSpace & 9::Send,#9
; task切り替え用
Enter & 1::Send,#1
Enter & 2::Send,#2
Enter & 3::Send,#3
Enter & 4::Send,#4
Enter & 5::Send,#5
Enter & 6::Send,#6
Enter & 7::Send,#7
Enter & 8::Send,#8
Enter & 9::Send,#9

;enterに機能追加
Enter & r::Send,#r
Enter & h::Send,#{Left}
Enter & j::Send,#{Down}
Enter & k::Send,#{up}
Enter & l::Send,#{Right}

Enter::send,{Enter}
Shift & Enter::Send,+{Enter}
Ctrl & Enter::send,^{Enter}

; 仮想デスクトップ用
Enter & Left::Send,^#{Left}
Enter & Right::Send,^#{Right}
Enter & Up::Send,^#{D}
Enter & Down::Send,^#{F4}

; Keypirinha taskSwitcher
BackSpace & c::Send,!{Space} {s}{w}{i}{c}{h}{Tab}

;選択したパスのフォルダを開く もしくは検索
BackSpace & g::
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
; WinGet, vcurrentwindow, ID, A
;     vimestate := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", vcurrentwindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)
; if (vimestate == 1) {
	Send,{Esc}
; }
return

; 日本語変換変換
sc070::
; WinGet, vcurrentwindow, ID, A
;     vimestate := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", vcurrentwindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)
; if (vimestate == 1) {
; Return
; }
Send,{sc029}
return
;ローマ字の再変換
+sc070::
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