#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

;Make ComboBox arrays
ArrayListIndex := 0
 loop, read, files\vcodecs.txt
 {
  ArrayList%A_Index% := A_LoopReadLine
  ArrayList0 = %A_Index%
    }
  Loop,%ArrayList0%
   List .= ArrayList%A_Index%  . "|" 

Gui Add, Button, x10 y246 w60 h47 gCommenceMagic, DO IT
Gui Add, Button, x87 y246 w64 h24 gEXTRA, OPTIONS
Gui Add, Button, x87 y269 w64 h24 gTESTIT, TEST
Gui Add, Button, x69 y246 w19 h47 gUDPCurruption, UDP
Gui Add, ComboBox, x16 y57 w130 vVcodec Choose8, %List%
Gui Add, Edit, x20 y31 w120 h21 vWebCamName, Integrated Webcam
Gui Add, Button, x30 y4 w100 h23 gGetWebcam, List WebCams
;Gui Add, Button, x87 y4 w60 h23, FFplay
Gui Add, Slider, x0 y151 w157 h32  Range1-90000 vGlitchAmount +Tooltip , 80
Gui Add, Slider, x0 y102 w157 h32 Range0-100 vVQuality +Tooltip , 32
Gui Add, Slider, x0 y202 w157 h32 Range50-50000 vBitrateVal +Tooltip, 50
GuiControl, Disable, BitrateVal
Gui Add, Checkbox, x32 y185 w120 h17 vBitrate gEnableBitrate, Force Bitrate?
Gui Add, Text, x47 y80 w72 h23 +0x200, Video Quality
Gui Add, Text, x46 y131 w72 h23 +0x200, Glitch Amount
Gui 1:-Sysmenu
Gui 1:Show, w161 h311, F.A.G.U.T
winget , hwnd,ID,F.A.G.U.T  ; this will set hwnd to the handle of the window 
WinSet, alwaysontop ,on,ahk_id %hwnd%

;Default settings
VideoFilters := "fps=60"
Resolution := "640x360"
CodecSettings := "-bf 0 -g 999999"
Return

GetWebCam:
msgbox, 
(
Choose your webcam device name from this list and replace 
'Integrated Webcam' with the proper name.
)
run, %ComSpec% /k ffmpeg -f dshow -list_devices true -i "MOVE ALONG SIR"
return

EnableBitrate:
GuiControlGet, Bitrate
if (Bitrate = 0) {
GuiControl, 1:Enable, VQuality
GuiControl, 1:Disable, BitrateVal
BRvar := " "
VQvar := "-q:v %VQuality%"
}

if (Bitrate = 1) {
GuiControl, 1:Enable, BitrateVal
GuiControl, 1:Disable, VQuality
BRvar := "-b:v %BitrateVal% "
VQvar := " "
}
return

EXTRA:
Gui 2:+LastFoundExist
if WinExist() {
    Gui, 2:Show
	return
}
Gui 2:Add, Button, x11 y230 w131 h40 gSaveSettings, GOOD TO GO
Gui 2:Add, Edit, x42 y29 w67 h21 vResolution, 640x360
Gui 2:Add, Edit, x17 y79 w120 h21 vVideoFilters, fps=60
Gui 2:Add, Text, x46 y54 w65 h23 +0x200, Video Filters
Gui 2:Add, Text, x35 y5 w87 h23 +0x200, Video Resolution
Gui 2:Add, Edit, x17 y193 w120 h21 vCodecSettings, -bf 0 -g 999999
Gui 2:Add, Text, x24 y173 w120 h18, Video Codec Settings
Gui 2:Add, Edit, x17 y136 w120 h21 vWao, 0088
Gui 2:Add, Text, x30 y116 w120 h18, Custom UDP Data
GuiControl, 2:Disable, wao
Gui, 2:-Sysmenu
Gui 2:Show, w153 h280, ayy lmao
WinSet, AlwaysOnTop,, ayy lmao
Return

SaveSettings:
Gui, 2:Submit, NoHide
sleep, 30
Gui, 2:Show, Hide
if (VideoFilters = "") {
global VideoFilters := "null"
}
return

CommenceMagic:
thread, interrupt, 0
thread, priority, 0
gosub, EnableBitrate
Gui,Submit, Nohide

transform, BRvar, Deref, %BRvar%
transform, VQvar, Deref, %VQvar%
ffmpegvar := "ffmpeg -f dshow -framerate 15 -vcodec mjpeg -i video=""%WebCamName%"" -s %Resolution% -f nut -c:v %VCodec% %BRvar% %VQvar% %CodecSettings% -strict -2 -bsf noise=%GlitchAmount% -vf %VideoFilters% -  | ffmpeg -i - -f libndi_newtek -vf hflip -pix_fmt uyvy422 ShittyWebcam2.0"
transform, ffmpegvar, Deref, %ffmpegvar%
 msgbox, %ffmpegvar%
Run, %ComSpec% /c %ffmpegvar%,,Min,pid2
return

UDPCurruption:
thread, interrupt, 0
thread, priority, 0
gosub, EnableBitrate
Gui,Submit, Nohide

transform, BRvar, Deref, %BRvar%
transform, VQvar, Deref, %VQvar%
ffmpegvar := "ffmpeg -f dshow -framerate 15 -vcodec mjpeg -i video=""%WebCamName%"" -s %Resolution% -f nut -c:v %VCodec% %BRvar% %VQvar% %CodecSettings% -strict -2 -bsf noise=%GlitchAmount% -vf %VideoFilters% udp:127.0.0.1:1337"
transform, ffmpegvar, Deref, %ffmpegvar%

Run, ffmpeg -f nut -i udp:127.0.0.1:1337 -f libndi_newtek -vf hflip -pix_fmt uyvy422 ShittyWebcam2.0,,Min
Sleep, 888
Run, %ComSpec% /c %ffmpegvar%,,Min,pid2
return

TESTIT:
thread, interrupt, 0
thread, priority, 0
gosub, EnableBitrate
Gui,Submit, Nohide

transform, BRvar, Deref, %BRvar%
ffmpegvar := "ffmpeg -f dshow -framerate 15 -vcodec mjpeg -i video=""%WebCamName%"" -s %Resolution% -f nut -c:v %VCodec% %BRvar% %CodecSettings% -q:v %VQuality% -strict -2 -bsf noise=%GlitchAmount% -vf %VideoFilters% -  | ffplay -i -"
transform, ffmpegvar, Deref, %ffmpegvar%
 msgbox, %ffmpegvar%
Runwait, %ComSpec% /k %ffmpegvar%,,,pid2
return


!s::
Process, Exist, cmd.exe
If errorlevel { 
  zPid:=errorlevel 
  winclose,ahk_pid %zPid%,,
  winwaitclose,ahk_pid %zPid%,,5 ; if the process exists attempt a clean close allowing five seconds to close.
  If errorlevel {
   process,close,%zPid% ; If clean close failed then terminate
    }
    Process, Close, ffmpeg.exe
	Sleep, 5
	Process, Close, ffmpeg.exe
	sleep, 5
    gosub, CommenceMagic
}
return

!d::
Process, Exist, cmd.exe
If errorlevel { 
  zPid:=errorlevel 
  winclose,ahk_pid %zPid%,,
  winwaitclose,ahk_pid %zPid%,,2 ; if the process exists attempt a clean close allowing five seconds to close.
  If errorlevel {
   process,close,%zPid% ; If clean close failed then terminate
    }
	Process, Close, ffmpeg.exe
	Sleep, 5
	Process, Close, ffmpeg.exe
	sleep, 5
    gosub, UDPCurruption
}
return

toggle:=0
!m::
toggle:=!toggle
if toggle = 1
 {
  WinHide, ahk_id %hwnd%
 }
else
{
  WinShow, ahk_id %hwnd%
  WinSet, alwaysontop ,on,ahk_id %hwnd%
}
return

!c::
Process,Close, ffplay.exe ; get that shit outta here
sleep, 200
Process,Close, ffmpeg.exe ; get that shit outta here
sleep, 200
Process,Close, cmd.exe ; get that shit outta here
sleep, 200
Process,Close, cmd.exe ; get that shit outta here
return

!b::
run, ShittyWebcam2.0.ahk
return

GuiEscape:
GuiClose:
Process, Exist, cmd.exe
If errorlevel { 
  zPid:=errorlevel 
  winclose,ahk_pid %zPid%,,
	Sleep, 10
    Process, Close, ffmpeg.exe
	Sleep, 10
	Process, Close, ffmpeg.exe
	Sleep, 10
	}
   ExitApp
	
