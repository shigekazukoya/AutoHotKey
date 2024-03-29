 *Space::
  if (isSpaceRepeat == true)
  {
    if (A_PriorKey != "Space")
    {
      KeyWait, Space
      Send {Blind}{ShiftUp}
      isSpaceRepeat := false
      Return
    }
    else Return
  }
  Send {Blind}{ShiftDown}
  isSpaceRepeat := true
Return

$*Space up::
  Send {Blind}{ShiftUp}
  isSpaceRepeat := false
  if (A_PriorKey == "Space"){
    Send {Blind}{Space}
  }
Return


; KeyCHane
; sc07B→Enter

; arrow
BackSpace & H::Send,{Blind}{Left}
BackSpace & J::Send,{Blind}{Down}
BackSpace & K::Send,{Blind}{Up}
BackSpace & L::Send,{Blind}{Right}

;Alt+arrow
LAlt & H::Send,{Blind}{Lalt}{Left}
LAlt & J::Send,{Blind}{Lalt}{Down}
LAlt & K::Send,{Blind}{Lalt}{Up}
LAlt & L::Send,{Blind}{Lalt}{Right}

;BS Delete
BackSpace::Send,{BackSpace}
BackSpace & sc027::Send,{BackSpace}
BackSpace & sc028::Send,{Delete}
BackSpace & w::Send,!{F4}

;ContextMenu
BackSpace & M::Send,{APPSKEY}

;For this script
BackSpace & R::Reload
BackSpace & e::Edit

!sc027::send,^{F12}

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
Enter & q::Send,#1

;Enter
Enter::send,{Enter}
Shift & Enter::Send,+{Enter}
Ctrl & Enter::send,^{Enter}

Enter & BackSpace::Send,{AltDown}{Tab}{AltUp}

;Windows +
Enter & r::Send,#r
Enter & e::Send,#{7}

Enter & h::Send,#{Left}
Enter & j::Send,#{Down}
Enter & k::Send,#{up}
Enter & l::Send,#{Right}

; Virtual Desktop
Enter & Left::Send,^#{Left}
Enter & Right::Send,^#{Right}
Enter & Up::Send,^#{d}
Enter & Down::Send,^#{F4}


sc070:: Send,{sc029}

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

#IfWinActive ahk_exe EXCEl.EXE
    Shift & Space::send,+{Space}
    +^sc027::send, +{Space}+^{sc027}
    +^!sc027::send, ^{Space}+^{sc027}
    ^l::send,+{Space}^{-}
    tab::send,^{PgDn}
    +tab::send,^{PgUp}
    !Up:: send,+{Space}^{x}{Up}+{Space}+^{sc027}
    !Down:: send,+{Space}^{x}{Down 2}+{Space}+^{sc027}
    !+Down:: send,+{Space}^{c}{Down}+{Space}+^{sc027}
    !Right:: send,^{x}{Right 2}{AppsKey}{e}{Enter}
    !Left:: send,^{x}{Left}{AppsKey}{e}{Enter}
    ^q::send,^{_}^{&}

return

; #IfWinActive 仕事術.xlsx - Cent Browser.xlsx, ahk_class Chrome_WidgetWin_1
; #IfWinActive xlsx
#IfWinActive,xlsx ahk_class Chrome_WidgetWin_1
; #IfWinActive Cent Browser
    Shift & Space::send,+{Space}
    +^sc027::send, +{Space}+^{sc027}
    +^!sc027::send, ^{Space}+^{sc027}
    ^l::send,+{Space}^{-}
    tab::send,^!{PgDn}
    +tab::send,^!{PgUp}
    ; ^q::send,{Alt}{h}{b}{n}{Alt}{h}{b}{s}
return


; for vim-ime
#If WinActive("ahk_exe Joplin.exe") || WinActive("ahk_exe wezterm-gui.exe") || WinActive("ahk_exe mintty.exe") || WinActive("ahk_exe WindowsTerminal.exe") || WinActive("ahk_exe Code.exe")
~j up::
Input, jout, I T0.1 V L1, {j}
if(ErrorLevel == "EndKey:J"){
	WinGet, vcurrentwindow, ID, A
  vimestate := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", vcurrentwindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)

  If (vimestate==1)
	{
		Send,{BackSpace 2}^{[ 2}
	}
}
Return
