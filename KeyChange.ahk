; KeyCHange
; sc07B→Enter

;arrow
sc079 & H::Send,{Blind}{Left}
sc079 & J::Send,{Blind}{Down}
sc079 & K::Send,{Blind}{Up}
sc079 & L::Send,{Blind}{Right}

;Alt+arrow
LAlt & H::Send,{Blind}{Lalt}{Left}
LAlt & J::Send,{Blind}{Lalt}{Down}
LAlt & K::Send,{Blind}{Lalt}{Up}
LAlt & L::Send,{Blind}{Lalt}{Right}

;BS Delete
sc079::Send,{BackSpace}
sc079 & sc027::Send,{BackSpace}
sc079 & sc028::Send,{Delete}
sc079 & w::Send,!{F4}

;ContextMenu
sc079 & M::Send,{APPSKEY}
sc079 & O::Send,{APPSKEY}{a} ; 管理者権限で実行

;For this script
sc079 & R::Reload   ;リロード
sc079 & e::Edit    ;編集

; taskbar
Enter & 1::Send,#1
Enter & 2::Send,#2
Enter & 3::Send,#3
Enter & 4::Send,#4
Enter & 5::Send,#5
Enter & 6::Send,#6
Enter & 7::Send,#7
Enter & 8::Send,#8
Enter & 9::Send,#9

;Enter
Enter::send,{Enter}
Shift & Enter::Send,+{Enter}
Ctrl & Enter::send,^{Enter}

;Windows +
Enter & r::Send,#r
Enter & e::Send,#e

Enter & h::Send,#{Left}
Enter & j::Send,#{Down}
Enter & k::Send,#{up}
Enter & l::Send,#{Right}

; Virtual Desktop
Enter & Left::Send,^#{Left}
Enter & Right::Send,^#{Right}
Enter & Up::Send,^#{d}
Enter & Down::Send,^#{F4}

;Goto
Enter & g::
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

; 日本語変換変換
sc070::
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
  if (isSpaceRepeat == true)  ;キーリピートしているかどうか
  {
    if (A_PriorKey != "Space") ;Space長押し中の他キー押し下げを検出
    {
      KeyWait, Space
      Send {Blind}{ShiftUp}    ;Shiftをリリース
      isSpaceRepeat := false
      Return
    }
    else Return
  }
  Send {Blind}{ShiftDown}   ;Shiftを押し下げ
  isSpaceRepeat := true
Return
;Spaceを離したとき
$*Space up::
  Send {Blind}{ShiftUp}    ;Shiftをリリース
  isSpaceRepeat := false
  if (A_PriorKey == "Space"){   ;Space単押しを検出
    Send {Blind}{Space}   ;Spaceを入力
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