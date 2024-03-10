#Requires AutoHotkey v2.0
#Warn

/******* Keyboard layer *******/
IsKeyboardNavigationLayer := false

LAlt:: global IsKeyboardNavigationLayer := true
LAlt Up::
{
    global IsKeyboardNavigationLayer := false
    Send("{AltUp}")
    Send("{LWinUp}")
    Send("{ShiftUp}")
    Send("{CtrlUp}")
}

<#Tab::AltTab

HotIf (*) => IsKeyboardNavigationLayer
{
    Hotkey "*i", (*) => Send("{Blind}{Up}")
    Hotkey "*j", (*) => Send("{Blind}{Left}")
    Hotkey "*k", (*) => Send("{Blind}{Down}")
    Hotkey "*l", (*) => Send("{Blind}{Right}")
    Hotkey "*u", (*) => Send("{Blind}{Home}")
    Hotkey "*o", (*) => Send("{Blind}{End}")
    Hotkey "*y", (*) => Send("{Blind}{PgUp}")
    Hotkey "*n", (*) => Send("{Blind}{PgDn}")
    Hotkey "*a", (*) => Send("{Blind}{AltDown}")
    Hotkey "*a Up", (*) => Send("{Blind}{AltUp}")
    Hotkey "*s", (*) => Send("{Blind}{LWinDown}")
    Hotkey "*s Up", (*) => Send("{LWinUp}")
    Hotkey "*d", (*) => Send("{Blind}{ShiftDown}")
    Hotkey "*d Up", (*) => Send("{ShiftUp}")
    Hotkey "*f", (*) => Send("{Blind}{CtrlDown}")
    Hotkey "*f Up", (*) => Send("{CtrlUp}")
    Hotkey "*g", (*) => Send("{Blind}{RAltDown}")
    Hotkey "*g Up", (*) => Send("{RAltUp}")
    Hotkey "*q", (*) => Send("{Blind}{Esc}")
    Hotkey "*z", (*) => Send("{CtrlDown}{z}{CtrlUp}")
    Hotkey "*r", (*) => Send("{CtrlDown}{y}{CtrlUp}")
    Hotkey "*x", (*) => Send("{CtrlDown}{x}{CtrlUp}")
    Hotkey "*c", (*) => Send("{CtrlDown}{c}{CtrlUp}")
    Hotkey "*v", (*) => Send("{CtrlDown}{v}{CtrlUp}")
    Hotkey "*;", (*) => Send("{Blind}{Enter}")
    Hotkey "*h", (*) => Send("{Blind}{Backspace}")
    Hotkey "*'", (*) => Send("{Blind}{Del}")
    Hotkey "*w", (*) => Send("{CtrlDown}{s}{CtrlUp}")
    Hotkey "*e", (*) => Send("{CtrlDown}{d}{CtrlUp}")
    Hotkey "*F4", (*) => Send("{Blind}{AltDown}{F4}{AltUp}")
    *Tab:: Send "{Blind}{Alt down}{tab}"
}






/******* Symbols layer *******/
IsSymbolsLayer := false
IsSymbolsFirstChar := false

ih := InputHook("V")
ih.KeyOpt("{Space}", "N")
ih.OnKeyDown := SpaceDown
ih.OnKeyUp := SpaceUp

SpaceDown(InputHookObj, VK, SC)
{
    global IsSymbolsLayer := true
    global IsSymbolsFirstChar := true
}
SpaceUp(InputHookObj, VK, SC)
{
    global IsSymbolsLayer := false
}

ih.Start()

HotIf (*) => IsSymbolsLayer
{
    Hotkey "*q", (*) => SendSymbolInput("{!}")
    Hotkey "*w", (*) => SendSymbolInput("{@}")
    Hotkey "*e", (*) => SendSymbolInput("{#}")
    Hotkey "*r", (*) => SendSymbolInput("{$}")
    Hotkey "*t", (*) => SendSymbolInput("{%}")
    Hotkey "*y", (*) => SendSymbolInput("{^}")
    Hotkey "*u", (*) => SendSymbolInput("{&}")
    Hotkey "*i", (*) => SendSymbolInput("{*}")
    Hotkey "*o", (*) => SendSymbolInput("{(}")
    Hotkey "*p", (*) => SendSymbolInput("{)}")
    Hotkey "*a", (*) => SendSymbolInput("{1}")
    Hotkey "*s", (*) => SendSymbolInput("{2}")
    Hotkey "*d", (*) => SendSymbolInput("{3}")
    Hotkey "*f", (*) => SendSymbolInput("{4}")
    Hotkey "*g", (*) => SendSymbolInput("{5}")
    Hotkey "*h", (*) => SendSymbolInput("{6}")
    Hotkey "*j", (*) => SendSymbolInput("{7}")
    Hotkey "*k", (*) => SendSymbolInput("{8}")
    Hotkey "*l", (*) => SendSymbolInput("{9}")
    Hotkey "*;", (*) => SendSymbolInput("{0}")
    Hotkey "*'", (*) => SendSymbolInput("{}")
    Hotkey "*z", (*) => SendSymbolInput("{}")
    Hotkey "*x", (*) => SendSymbolInput("{}")
    Hotkey "*c", (*) => SendSymbolInput("{}")
    Hotkey "*v", (*) => SendSymbolInput("{}")
    Hotkey "*b", (*) => SendSymbolInput("{}")
    Hotkey "*n", (*) => SendSymbolInput("{}")
    Hotkey "*m", (*) => SendSymbolInput("{}")
    Hotkey "*,", (*) => SendSymbolInput("{}")
    Hotkey "*.", (*) => SendSymbolInput("{}")
    Hotkey "*/", (*) => SendSymbolInput("{}")
}

/* Jeśli pierwszy znak dodatkowo wysyła backspace usuwające spację */
SendSymbolInput(Text) {
    global IsSymbolsFirstChar
    if (IsSymbolsFirstChar) {
        SendInput "{Backspace}"
        IsSymbolsFirstChar := false
    }
    SendInput Text
}







/******* Mouse Layer *******/
InstallKeybdHook

IsMouseNavigationLayer := false

; mouse speed variables
global FORCE := 1.8
global RESISTANCE := 0.982
global VELOCITY_X := 0
global VELOCITY_Y := 0
CapsLock:: EnterMouseMode
CapsLock Up:: ExitMouseMode
HotIf (*) => IsMouseNavigationLayer
{
    Hotkey "*i", (*) => {}
    Hotkey "*j", (*) => {}
    Hotkey "*k", (*) => {}
    Hotkey "*l", (*) => {}
    Hotkey "*u", (*) => Click("Left")
    Hotkey "*o", (*) => Click("Right")
}

EnterMouseMode() {
    If (IsMouseNavigationLayer) {
        Return
    }
    global IsMouseNavigationLayer := true
    SetTimer(MoveCursor, 16)
}

ExitMouseMode() {
    global IsMouseNavigationLayer := false
}

Accelerate(velocity, pos, neg) {
    If (pos == 0 && neg == 0) {
        Return 0
    }
    ; smooth deceleration :)
    Else If (pos + neg == 0) {
        Return velocity * 0.666
    }
    ; physicszzzzz
    Else {
        Return velocity * RESISTANCE + FORCE * (pos + neg)
    }
}

MoveCursor() {
    LEFT := 0
    DOWN := 0
    UP := 0
    RIGHT := 0
    LEFT := LEFT - GetKeyState("j", "P")
    DOWN := DOWN + GetKeyState("k", "P")
    UP := UP - GetKeyState("i", "P")
    RIGHT := RIGHT + GetKeyState("l", "P")
    If (IsMouseNavigationLayer == false) {
        global VELOCITY_X := 0
        global VELOCITY_Y := 0
        ;TODO dać off timera
        ; sprawdzić czy działa: SetTimer , 0
        ; SetTimer,, Off
        SetTimer , 0
    }
    global VELOCITY_X := Accelerate(VELOCITY_X, LEFT, RIGHT)
    global VELOCITY_Y := Accelerate(VELOCITY_Y, UP, DOWN)
    RestoreDPI := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr") ; enable per-monitor DPI awareness
    MouseMove(VELOCITY_X, VELOCITY_Y, 0, "R")
}