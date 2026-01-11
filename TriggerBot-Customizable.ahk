#NoEnv 
#persistent
#MaxThreadsPerHotkey 2
#KeyHistory 0
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
CoordMode, Pixel, Screen
SoundBeep, 300, 200
SoundBeep, 400, 200
 
;===================================================================================
;CUSTOMIZABLE SETTINGS
;HOTKEYS & MODES		
key_hold_mode	:= 	"F2"		; Toggle hold mode (switch between tap and spray)
key_off		    := 	"F4"		; Turn off all modes
key_gui_hide	:=	"HOME"		; Hide GUI		
key_exit	    := 	"END"		; Exit script	
key_hold	    :=	"XButton2" 	; Key to hold for auto fire	
key_toggle      :=  "T"         ; Key to toggle triggerbot on/off
 
;SETTINGS
pixel_box	:=	2.5		    ; Box size for pixel search
pixel_sens	:=	50		    ; Sensitivity (higher = more forgiving, better performance)
pixel_color	:=	0xA145A3	    ; Color code to search for (default purple)
tap_time	:=	10		    ; Delay in MS between shots (tuned for faster clicks)
spray_mode    := false          ; Spray mode initially off
 
;===================================================================================
; VARIABLES
triggerbot_on := false  ; Initially, triggerbot is off
 
; GUI Setup (Upgraded with feedback)
Gui,2:Font,Cdefault,Fixedsys
Gui,2:Color,Black
Gui,2:Color, EEAA99
Gui,2:Add,Progress, x10 y20 w100 h23 Disabled BackgroundFuchsia vC3
Gui,2:Add,Text, xp yp wp hp cWhite BackgroundTrans Center 0x200 vB3 gStart,on
Gui,2:Add,Progress, x10 y20 w100 h23 Disabled BackgroundFuchsia vC2
Gui,2:Add,Text, xp yp wp hp cWhite BackgroundTrans Center 0x200 vB2 gStart,hold mode
Gui,2:Add,Progress, x10 y20 w100 h23 Disabled BackgroundFuchsia vC1
Gui,2:Add,Text, xp yp wp hp cWhite BackgroundTrans Center 0x200 vB1 gStart,AM - off
Gui,2: Show, x10 y1 w200 h60
Gui 2:+LastFound +ToolWindow +AlwaysOnTop -Caption
WinSet, TransColor, EEAA99
 
; Boundaries for pixel scanning
leftbound:= A_ScreenWidth/2-pixel_box
rightbound:= A_ScreenWidth/2+pixel_box
topbound:= A_ScreenHeight/2-pixel_box
bottombound:= A_ScreenHeight/2+pixel_box 
 
;===================================================================================
; HOTKEYS
hotkey, %key_hold_mode%, holdmode_toggle   ; Toggle spray/hold mode
hotkey, %key_off%, offloop
hotkey, %key_gui_hide%, guihide
hotkey, %key_exit%, terminate
Hotkey, %key_toggle%, toggle_triggerbot  ; Toggle key for triggerbot
 
return
 
;===================================================================================
; SCRIPT START
start:
gui,2:submit,nohide
terminate:
SoundBeep, 300, 200
SoundBeep, 200, 200
Sleep 400
exitapp
 
;===================================================================================
; Toggle activation state for the triggerbot
toggle_triggerbot:
triggerbot_on := !triggerbot_on  ; Toggle the triggerbot state
if (triggerbot_on) {
    SoundBeep, 300, 200
    SetTimer, checkTriggerbot, 5  ; Set pixel search timer to every 5ms for balance
} else {
    SoundBeep, 200, 200
    Click Up  ; Release the LButton when turning off the triggerbot
    SetTimer, checkTriggerbot, Off
}
return
 
;===================================================================================
; Toggle spray/hold mode
holdmode_toggle:
spray_mode := !spray_mode  ; Toggle between spray and regular tap mode
if (spray_mode) {
    SoundBeep, 600, 200
} else {
    SoundBeep, 300, 200
    Click Up  ; Release the LButton when exiting spray mode
}
return
 
;===================================================================================
; MAIN LOOPS
checkTriggerbot:
if (triggerbot_on && !KeyCheck()) {  ; Triggerbot only runs when toggle is ON and WASD not pressed
    if (spray_mode) {
        HoldSpray()  ; Spray mode: Hold down LButton
    } else {
        PixelSearch()  ; Regular tap mode
    }
}
return
