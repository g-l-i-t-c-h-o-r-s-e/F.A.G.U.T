#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
#Include Socket.ahk

;Make ComboBox arrays
ArrayListIndex := 0
 loop, read, files\vcodecs.txt
 {
  ArrayList%A_Index% := A_LoopReadLine
  ArrayList0 = %A_Index%
    }
  Loop,%ArrayList0%
   List .= ArrayList%A_Index%  . "|" 

ArrayListIndex := 1
 loop, read, files\acodecs.txt
 {
  ArrayList%A_Index% := A_LoopReadLine
  ArrayList1 = %A_Index%
    }
  Loop,%ArrayList1%
   List1 .= ArrayList%A_Index%  . "|"

ShowVideoEdition:
Gui 1:+LastFoundExist
if WinExist() {
    Gui, 1:Show
	Gui, 3:Hide
	return
}
Gui Font, s10
Gui Add, Button, x31 y5 w46 h23 gVideoInput, Input
Gui Font
Gui Font, s10
Gui Add, Button, x84 y5 w46 h23 gShowAudioEdition, Audio
Gui Font
Gui Add, CheckBox, x16 y10 w13 h13 vVideoInputVar gDisableVideoCustomInput
Gui Add, Button, x10 y290 w60 h47 gCommenceMagic, DO IT
Gui Add, Button, x87 y290 w64 h24 gVideoOptions, OPTIONS
Gui Add, Button, x87 y313 w64 h24 gTESTIT, TEST
Gui Add, Button, x69 y290 w19 h47 gUDPCurruption, UDP
Gui Add, ComboBox, x17 y93 w130 vVcodec Choose8, %List%
Gui Add, DropDownList, x22 y67 w120 vWebCamName, Integrated Webcam
Gui Add, Button, x31 y40 w100 h23 vListWebcams gGetDevices, List Devices
;Gui Add, Button, x87 y4 w60 h23, FFplay
Gui Add, Slider, x0 y195 w157 h32 Range1-90000 vGlitchAmount +Tooltip , 80
Gui Add, Slider, x0 y146 w157 h32 Range0-100 vVQuality +Tooltip , 32
Gui Add, Slider, x0 y246 w157 h32 Range50-50000 vBitrateVal +Tooltip, 50
GuiControl, Disable, BitrateVal
Gui Add, Checkbox, x32 y229 w120 h17 vBitrate gEnableBitrate, Force Bitrate?
Gui Add, Checkbox, x32 y176 w12 h17 Checked vGlitchVar gDisableGlitch,
Gui Add, Text, x47 y124 w72 h23 +0x200, Video Quality
Gui Add, Text, x48 y176 w72 h15 +0x200, Glitch Amount

;Video Device Options
Gui Add, Button, x16 y45 w13 h13 gVideoDeviceOptions,

Gui 1:-Sysmenu
Gui 1:Show, w161 h351,F.A.G.U.T
winget , hwnd,ID,F.A.G.U.T  ; this will set hwnd to the handle of the window 
WinSet, alwaysontop ,on,ahk_id %hwnd%
GuiControl, Choose, WebCamName, 1

 ;Default Video settings
VideoFilters := "fps=60"
Resolution := "640x360"
CodecSettings := "-bf 0 -g 999999"
NoiseVar := "-bsf noise=36000"
CustomUDPval := "0088"
VideoDeviceOptionVar := "-f dshow -framerate 15 -vcodec mjpeg"
Return


VideoInput:
FileSelectFile, UserVideoInput,,,Select An Input Video File for Playback...
 if ErrorLevel {
msgbox,4096,Yo, Uh, You didn't select shit cap'n.
GuiControl,1:, VideoInputVar, 0
return
}
else
UserVideoInput := "-i " . chr(0x22) . UserVideoInput . chr(0x22) ; Encloses file location in quotes.
GuiControl,1:, VideoInputVar, 1
return


VideoDeviceOptions:
Gui, Submit, NoHide
global newWebCamName := WebCamName

Gui 8:+LastFoundExist
if WinExist() {
    Gui, 8:Show
	return
}
Gui 8:Add, Text, x33 y5 w120 h23 +0x200, In Case FFmpeg Crashes
Gui 8:Add, Edit, x32 y28 w120 h21 vVideoDeviceOptionVar,-framerate 15 -vcodec mjpeg
   
   global VideoDeviceOptionVar := VideoDeviceOptionVar
   
OnMessage(0x100, "OnKeyDown3")
OnKeyDown3(wParam3)
{
if (A_Gui = 8 && wParam3 = 13) ;Close GUI after hitting ENTER Key 
{
 Gui, 8:Submit, NoHide

  VideoDeviceOptionVar := "-f dshow " . VideoDeviceOptionVar
  
 Gui, 8:Show, Hide
 ;msgbox, %VideoDeviceOptionVar%
return
 }
}
Gui 8:-Sysmenu
Gui 8:Show, w185 h65, DirectShow Video Device Options
Gui,8:+AlwaysOnTop
Return

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

DisableGlitch:
   GuiControlGet, GlitchVar
    if (GlitchVar = 1) {
     GuiControl, 1:Enable, GlitchAmount
 NoiseVar := "-bsf noise=%GlitchAmount%"
}

    if (GlitchVar = 0) {
     GuiControl, 1:Disable, GlitchAmount
 NoiseVar := " "
}
return

DisableVideoCustomInput:
    GuiControlGet, VideoInputVar
     if (VideoInputVar = 0) {
 UserVideoInput := "%VideoDeviceOptionVar% -i video=""%WebCamName%"""
}

     if (VideoInputVar = 1) {
 UserVideo := UserVideoInput
 msgbox, Device Input Disabled.
}
return

VideoOptions:
Gui 2:+LastFoundExist
if WinExist() {
    Gui, 2:Show
	return
}
Gui 2:Add, Button, x11 y336 w131 h40 gSaveSettings, GOOD TO GO
Gui 2:Add, Edit, x42 y29 w67 h21 vResolution, 640x360
Gui 2:Add, Edit, x17 y79 w120 h21 vVideoFilters, fps=60
Gui 2:Add, Text, x46 y60 w65 h17 +0x200, Video Filters
Gui 2:Add, Text, x35 y10 w87 h16 +0x200, Video Resolution
Gui 2:Add, Edit, x17 y284 w120 h21 vCodecSettings, -bf 0 -g 999999
Gui 2:Add, Text, x24 y264 w120 h18, Video Codec Settings
Gui 2:Add, Button, x47 y312 w59 h18 gSpeedUpStream, speed up

Gui 2:Add, Edit, x17 y136 w120 h21 vCustomUDPval, 0088
Gui 2:Add, Text, x30 y116 w120 h18, Custom UDP Data
Gui 2:Add, Text, x7 y163 w68 h18, Repeat String
Gui 2:Add, ComboBox, x8 y182 w62 vUDPRepeatAmount Choose1, 0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui 2:Add, Text, x83 y163 w68 h18, Loop Amount
Gui 2:Add, ComboBox, x84 y182 w62 vUDPLoopAmount Choose1, 0|1|3|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100|105|110|115|120|125|130|135|140|145|150|155|160|175|180|195|200
Gui 2:Add, Text, x26 y210 w127 h18, String Size (Var Cap)
Gui 2:Add, Edit, x45 y230 w62 vUDPVarCapacitySize, 2064

;Disabled until I can figure this out.
GuiControl, 2:Disable, UDPRepeatAmount
GuiControl, 2:Disable, UDPLoopAmount
GuiControl, 2:Disable, UDPVarCapacitySize
GuiControl, 2:Disable, CustomUDPval

Gui, 2:-Sysmenu
Gui 2:Show, w153 h395, ayy lmao
WinSet, AlwaysOnTop,, ayy lmao
Return

SpeedUpStream:
    k += 2
    m := Mod(k, 3)
    s := Floor(m) 
    
	sleep, 10
    s_settings := ["fps=60"
                , "mpdecimate,setpts=N/FRAME_RATE/TB"
                , ""] ;Last setting left blank as I've seen it to speed up to realtime in some cases.
				
    speedSetting := s_settings[s+1]

    sleep, 10
    GuiControl, 2:, VideoFilters, %SpeedSetting%
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
Gui,Submit, Nohide
thread, interrupt, 0
thread, priority, 0
gosub, EnableBitrate
gosub, DisableGlitch
gosub, DisableVideoCustomInput

transform, BRvar, Deref, %BRvar%
transform, VQvar, Deref, %VQvar%
transform, NoiseVar, Deref, %NoiseVar%
transform, UserVideoInput, Deref, %UserVideoInput%
ffmpegvar := "ffmpeg %UserVideoInput% -s %Resolution% -f nut -c:v %VCodec% %BRvar% %VQvar% %CodecSettings% -strict -2 %NoiseVar% -vf %VideoFilters% -  | ffmpeg -i - -f libndi_newtek -vf hflip -pix_fmt uyvy422 ShittyWebcam2.0"
transform, ffmpegvar, Deref, %ffmpegvar%
 ;msgbox, %ffmpegvar%
Run, %ComSpec% /c %ffmpegvar%,,Min,pid2
return

UDPCurruption:
Gui,Submit, Nohide
thread, interrupt, 0
thread, priority, 0
gosub, DisableGlitch
gosub, EnableBitrate
gosub, DisableVideoCustomInput

transform, BRvar, Deref, %BRvar%
transform, VQvar, Deref, %VQvar%
transform, NoiseVar, Deref, %NoiseVar%
transform, UserVideoInput, Deref, %UserVideoInput%
ffmpegvar := "ffmpeg %UserVideoInput% -s %Resolution% -f nut -c:v %VCodec% %BRvar% %VQvar% %CodecSettings% -strict -2 %NoiseVar% -vf %VideoFilters% udp:127.0.0.1:1337"
transform, ffmpegvar, Deref, %ffmpegvar%

Run, ffmpeg -f nut -i udp:127.0.0.1:1337 -f libndi_newtek -vf hflip -pix_fmt uyvy422 ShittyWebcam2.0,,Min
Sleep, 888
Run, %ComSpec% /c %ffmpegvar%,,Min,pid2
return

TESTIT:
Gui,Submit, Nohide
thread, interrupt, 0
thread, priority, 0
gosub, DisableGlitch
gosub, EnableBitrate
gosub, DisableVideoCustomInput

transform, BRvar, Deref, %BRvar%
transform, VQvar, Deref, %VQvar%
transform, NoiseVar, Deref, %NoiseVar%
transform, UserVideoInput, Deref, %UserVideoInput%
ffmpegvar := "ffmpeg %UserVideoInput% -s %Resolution% -f nut -c:v %VCodec% %BRvar% %VQvar% %CodecSettings% -strict -2 %NoiseVar% -vf %VideoFilters% -  | ffplay -i -"
transform, ffmpegvar, Deref, %ffmpegvar%
 msgbox, %ffmpegvar%
Runwait, %ComSpec% /k %ffmpegvar%,,,pid2
return


ShowAudioEdition:
Gui 3:+LastFoundExist
if WinExist() {
    Gui, 3:Show
	Gui, 1:Hide
	return
}
Gui, 1:Show, Hide
Gui 3:Font, s10
Gui 3:Add, Button, x31 y5 w46 h23 gShowVideoEdition, Video
Gui 3:Font
Gui 3:Font, s10
Gui 3:Add, Button, x84 y5 w46 h23 gAudioInput, Input
Gui 3:Font
Gui 3:Add, CheckBox, x132 y10 w13 h13 vAudioInputVar gDisableAudioCustomInput
Gui 3:Add, Button, x10 y290 w60 h47 gCommenceAudioMagic, DO IT
Gui 3:Add, Button, x87 y290 w64 h24 gAudioOptions, OPTIONS
Gui 3:Add, Button, x87 y313 w64 h24 gAudioTESTIT, TEST
Gui 3:Add, Button, x69 y290 w19 h47 gAudioUDPCurruption, UDP
Gui 3:Add, ComboBox, x17 y93 w130 vAcodec Choose8, %List1%
Gui 3:Add, DropDownList, x22 y67 w120 vMicrophoneName, Integrated Webcam
Gui 3:Add, Button, x31 y40 w100 h23 vListDevices gGetDevices, List Devices
;Gui Add, Button, x87 y4 w60 h23, FFplay
Gui 3:Add, Slider, x0 y195 w157 h32 Range1-90000 vAudioGlitchAmount +Tooltip , 80
Gui 3:Add, Slider, x0 y146 w157 h32 Range0-100 vAQuality +Tooltip , 32
Gui 3:Add, Slider, x0 y246 w157 h20 Range50-50000 vAudioBitrateVal +Tooltip, 50
GuiControl, 3:Disable, AudioBitrateVal
Gui 3:Add, Checkbox, x32 y229 w85 h17 vAudioBitrate gEnableAudioBitrate, Force Bitrate?
Gui 3:Add, Checkbox, x32 y176 w12 h17 Checked vAudioGlitchVar gDisableAudioGlitch,
Gui 3:Add, Text, x47 y124 w72 h23 +0x200, Audio Quality
Gui 3:Add, Text, x48 y176 w72 h15 +0x200, Glitch Amount

Gui 3:Add, Button, x116 y177 w14 h14 gCustomAudioGlitchAmount,
Gui 3:Add, Button, x116 y231 w14 h14 GCustomAudioBitrateAmount,

Gui 3:Add, Edit, x59 y269 w39 h20 +Center vAudioContainerFormat, nut
Gui 3:-Sysmenu
Gui 3:Show, w161 h351,F.A.G.U.T-AUDIO
winget , hwnd,ID,F.A.G.U.T-AUDIO  ; this will set hwnd to the handle of the window 
WinSet, alwaysontop ,on,ahk_id %hwnd%
GuiControl, 3:Choose, WebCamName, 7

 ;Default Audio settings
Resolution := "640x360"
AudioCodecSettings := "-ar 8000 -ac 2"
AudioNoiseVar := "-bsf noise=36000"
AudioCustomUDPval := "0088"
UserAudioInput := "-f lavfi -i sine=300"
AudioFilters := "-af anull"
IsCustomGlitch := "0"
Return

CustomAudioGlitchAmount:
Gui, 6:Submit, NoHide
global DefGlVar := CustomAudioGlitchAmountVar

Gui 6:Add, Text, x33 y5 w120 h23 +0x200, Custom Glitch Amount
Gui 6:Add, Edit, x32 y28 w120 h21 vCustomAudioGlitchAmountVar, %DefGlVar%
Gui 6:Add, CheckBox, x139 y10 w14 h14 +Checked vIsCustomGlitch gEnableCustomGlitch
OnMessage(0x100, "OnKeyDown")
OnKeyDown(wParam)
{
if (A_Gui = 6 && wParam = 13) ;Close GUI after hitting ENTER Key 
{
 Gui, 6:Submit, NoHide
 
  AudioGlitchAmount := CustomAudioGlitchAmountVar
  
 Gui, 6:Destroy
return
 }
}
Gui 6:-Sysmenu
Gui 6:Show, w185 h65, Because The Slider Can Be An Gay
Gui,6:+AlwaysOnTop
  ;msgbox, %DefGlVar%
Return


CustomAudioBitrateAmount:
Gui, 7:Submit, NoHide
global DefBrVar := CustomAudioBitrateAmountVar

Gui 7:Add, Text, x33 y5 w120 h23 +0x200, Custom Bitrate Amount
Gui 7:Add, Edit, x32 y28 w120 h21 vCustomAudioBitrateAmountVar, %DefBrVar%
Gui 7:Add, CheckBox, x139 y10 w14 h14 +Checked vIsCustomAudioBitrate gEnableCustomAudioBitrate
OnMessage(0x100, "OnKeyDown2")
OnKeyDown2(wParam)
{
if (A_Gui = 7 && wParam = 13) ;Close GUI after hitting ENTER Key 
{
 Gui, 7:Submit, NoHide
 
  AudioBitrateVal := CustomAudioBitrateAmountVar
  
 Gui, 7:Destroy
return
 }
}
Gui 7:-Sysmenu
Gui 7:Show, w185 h65, Because The Slider Can Be An Gay
Gui,7:+AlwaysOnTop
Return


AudioInput:
FileSelectFile, UserAudioInput,,,Select An Input Audio File for Playback...
 if ErrorLevel {
msgbox,4096,Yo, Uh, You didn't select shit cap'n.
GuiControl,3:, AudioInputVar, 0
return
}
 else
UserAudioInput := "-i " . chr(0x22) . UserAudioInput . chr(0x22) ; Encloses file location in quotes.
GuiControl, 3:, AudioInputVar, 1
return


EnableAudioBitrate:
  GuiControlGet, AudioBitrate
 if (AudioBitrate = 0) {
   GuiControl, 3:Enable, AQuality
   GuiControl, 3:Disable, AudioBitrateVal
 AudioBRvar := " "
 AQvar := "-q:a %AQuality%"
}

  if (AudioBitrate = 1) {
   GuiControl, 3:Enable, AudioBitrateVal
   GuiControl, 3:Disable, AQuality
 AudioBRvar := "-b:a %AudioBitrateVal% "
 AQvar := " "
}
return

DisableAudioGlitch:
 GuiControlGet, AudioGlitchVar
  if (AudioGlitchVar = 1) {
  GuiControl, 3:Enable, AudioGlitchAmount
 AudioNoiseVar := "-bsf noise=%AudioGlitchAmount%"
}

  if (AudioGlitchVar = 0) {
  GuiControl, 3:Disable, AudioGlitchAmount
 AudioNoiseVar := " "
}
return

DisableAudioCustomInput:
  GuiControlGet, AudioInputVar
 if (AudioInputVar = 0) {
 UserAudioInput := "-f dshow -i audio=""%MicrophoneName%"""
}

 if (AudioInputVar = 1) {
 UserAudioInput := UserAudioInput
  ;msgbox, Device Input Disabled.
}
return

EnableCustomGlitch:
  if (IsCustomGlitch = 0) {
 AudioNoiseVar := "-bsf noise=%AudioGlitchAmount%"
   ;msgbox, %AudioNoiseVar%
}

  if (IsCustomGlitch = 1) {
 AudioNoiseVar := "-bsf noise=%CustomAudioGlitchAmountVar%"
   ;msgbox, %AudioNoiseVar%
}
  if (AudioGlitchVar = 0 && IsCustomGlitch = 0) { ;bug fix to allow turning off audio glitches
 AudioNoiseVar := " "
}
return

EnableCustomAudioBitrate:
  if (IsCustomAudioBitrate = 0) {
 AudioBRvar := AudioBRvar
  ;msgbox, %AudioNoiseVar%
}

  if (IsCustomAudioBitrate = 1) {
 AudioBRvar := "-b:a %CustomAudioBitrateAmountVar% "
  ;msgbox, %AudioNoiseVar%
}
return

CheckAudioFormat:
   GuiControlGet, AudioContainerFormat
  if (AudioContainerFormat = "") {
 global AudioContainerFormat := ""
}
else
 AudioContainerFormat := "-f " . AudioContainerFormat
return

AudioOptions:
Gui 4:+LastFoundExist
if WinExist() {
    Gui, 4:Show
	return
}
Gui 4:Add, Button, x11 y336 w131 h40 gSaveAudioSettings, GOOD TO GO
Gui 4:Add, Edit, x42 y29 w67 h21 vTimestamp, 00:00:00
Gui 4:Add, Edit, x17 y79 w120 h21 vAudioFilters,
Gui 4:Add, Text, x46 y60 w65 h17 +0x200, FFplay Filters
Gui 4:Add, Text, x35 y10 w87 h16 +0x200, Start Timestamp
Gui 4:Add, Edit, x17 y284 w120 h21 vAudioCodecSettings, -ar 8000
Gui 4:Add, Text, x24 y264 w120 h18, Audio Codec Settings
Gui 4:Add, Button, x47 y312 w59 h18 gSpeedUpAudio, speed up

Gui 4:Add, Edit, x17 y136 w120 h21 vCustomUDPval, 0088
Gui 4:Add, Text, x30 y116 w120 h18, Custom UDP Data
Gui 4:Add, Text, x7 y163 w68 h18, Repeat String
Gui 4:Add, ComboBox, x8 y182 w62 vUDPRepeatAmount Choose1, 0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20
Gui 4:Add, Text, x83 y163 w68 h18, Loop Amount
Gui 4:Add, ComboBox, x84 y182 w62 vUDPLoopAmount Choose1, 0|1|3|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100|105|110|115|120|125|130|135|140|145|150|155|160|175|180|195|200
Gui 4:Add, Text, x26 y210 w127 h18, String Size (Var Cap)
Gui 4:Add, Edit, x45 y230 w62 vUDPVarCapacitySize, 2064

;Disabled until I can figure this out.
GuiControl, 4:Disable, UDPRepeatAmount
GuiControl, 4:Disable, UDPLoopAmount
GuiControl, 4:Disable, UDPVarCapacitySize
GuiControl, 4:Disable, CustomUDPval

Gui, 4:-Sysmenu
Gui 4:Show, w153 h395, ayy lmao
WinSet, AlwaysOnTop,, ayy lmao
Return

SpeedUpAudio:
    k += 2
    m := Mod(k, 3)
    s := Floor(m) 
    
	sleep, 10
    s_settings := ["-fflags nobuffer -flags low_delay -framedrop -strict -2"
                , "-af asetpts=N/SAMPLE_RATE/TB"
                , "-af atempo=1.3"] ;Last setting left blank as I've seen it to speed up to realtime in some cases.
				
    AudiospeedSetting := s_settings[s+1]

    sleep, 10
    GuiControl, 4:, AudioFilters, %AudiospeedSetting%
Return

SaveAudioSettings:
 Gui, 4:Submit, NoHide
sleep, 30
 Gui, 4:Show, Hide
  if (AudioFilters = "") {
 global AudioFilters := "-af anull"
}

if (Timestamp = "") {
 global Timestamp := ""
}
else
 global Timestamp := "-ss " . Timestamp
return

CommenceAudioMagic:
SetTitleMatchMode, 1
thread, interrupt, 0
thread, priority, 0
Gui, 3:Submit, Nohide
Gui, 6:Submit, Nohide
gosub, CheckAudioFormat
gosub, EnableAudioBitrate
gosub, DisableAudioGlitch
gosub, DisableAudioCustomInput
gosub, EnableCustomGlitch
gosub, EnableCustomAudioBitrate

   WinHide, ahk_id %hwnd%

transform, AudioContainerFormat, Deref, %AudioContainerFormat%
transform, AudioBRvar, Deref, %AudioBRvar%
transform, AQvar, Deref, %AQvar%
transform, AudioNoiseVar, Deref, %AudioNoiseVar%
transform, UserAudioInput, Deref, %UserAudioInput% 
ffmpegAudiovar := "ffmpeg %UserAudioInput% %AudioContainerFormat% -c:a %ACodec% %AudioBRvar% %AQvar% %AudioCodecSettings% -strict -2 %AudioNoiseVar% -  | ffplay -i - %AudioFilters%"
transform, ffmpegAudiovar, Deref, %ffmpegAudiovar%
 ;msgbox, %ffmpegAudiovar%
   Run, mmsys.cpl
    WinWait,Sound
    ControlSend,SysListView321,{Down 4} ;Select VAC Device
	sleep, 60
    ControlClick,&Set Default
	sleep, 60
    ControlClick,&Set Default
	sleep, 60
    ControlClick,OK
	sleep, 60
	ControlClick,OK
   sleep, 60
{
 run, %ComSpec% /k %ffmpegAudioVar%,,Min
 }
   WinWait,pipe
   WinMinimize, pipe
    Run, mmsys.cpl
    WinWait,Sound
    ControlSend,SysListView321,{Down} ;Select Normal Default Device
	sleep, 60
    ControlClick,&Set Default
	sleep, 60
	ControlClick,&Set Default
	sleep, 60
    ControlClick,OK
	sleep, 60
	ControlClick,OK
	sleep, 60
	
	sleep, 1000
	WinShow, ahk_id %hwnd%
  return


AudioTESTIT:
Gui, 3:Submit, Nohide
Gui, 6:Submit, Nohide
SetTitleMatchMode, 2

gosub, CheckAudioFormat
gosub, EnableAudioBitrate
gosub, DisableAudioGlitch
gosub, DisableAudioCustomInput
gosub, EnableCustomGlitch
gosub, EnableCustomAudioBitrate

transform, AudioContainerFormat, Deref, %AudioContainerFormat%
transform, AudioBRvar, Deref, %AudioBRvar%
transform, AQvar, Deref, %AQvar%
transform, AudioNoiseVar, Deref, %AudioNoiseVar%
transform, UserAudioInput, Deref, %UserAudioInput% 
ffmpegAudiovar := "ffmpeg %Timestamp% %UserAudioInput% %AudioContainerFormat% -c:a %ACodec% %AudioBRvar% %AQvar% %AudioCodecSettings% -strict -2 %AudioNoiseVar% -  | ffplay -i - %AudioFilters%"
transform, ffmpegAudiovar, Deref, %ffmpegAudiovar%

 msgbox, %ffmpegAudiovar%
run, %ComSpec% /k %ffmpegAudioVar%
return


AudioUDPCurruption:
SetTitleMatchMode, 1
thread, interrupt, 0
thread, priority, 0
Gui, 3:Submit, Nohide
Gui, 6:Submit, Nohide

gosub, CheckAudioFormat
gosub, EnableAudioBitrate
gosub, DisableAudioGlitch
gosub, DisableAudioCustomInput
gosub, EnableCustomGlitch
gosub, EnableCustomAudioBitrate

   WinHide, ahk_id %hwnd%

transform, AudioContainerFormat, Deref, %AudioContainerFormat%
transform, AudioBRvar, Deref, %AudioBRvar%
transform, AQvar, Deref, %AQvar%
transform, AudioNoiseVar, Deref, %AudioNoiseVar%
transform, UserAudioInput, Deref, %UserAudioInput% 
 
ffmpegAudiovar := "ffmpeg %Timestamp% %UserAudioInput% %AudioContainerFormat% -c:a %ACodec% %AudioBRvar% %AQvar% %AudioCodecSettings% -strict -2 %AudioNoiseVar% udp:127.0.0.1:1337"
ffplayAudiovar := "ffplay -i udp:127.0.0.1:1337 %AudioFilters%"

transform, ffmpegAudiovar, Deref, %ffmpegAudiovar%
transform, ffplayAudiovar, Deref, %ffplayAudiovar%
 ;msgbox, %ffmpegAudiovar%

   Run, mmsys.cpl,,Max
    WinWait,Sound
	sleep, 100
    ControlSend,SysListView321,{Down 4} ;Select VAC Device
    ControlClick,&Set Default
    ControlClick,OK
{
 run, %ComSpec% /k %ffplayAudioVar%,,Min
 sleep, 1000
 run, %ComSpec% /k %ffmpegAudioVar%,,Min
 }
   WinWait, udp
   WinMinimize, udp:
    Run, mmsys.cpl,,Max
    WinWait,Sound
	sleep, 100
    ControlSend,SysListView321,{Down} ;Select Normal Default Device
	ControlClick,&Set Default
	ControlClick,OK
	
	sleep, 1000
	WinShow, ahk_id %hwnd%
  return




GetDevices:
MakeList := ""
DirtyList := ""
msgbox,4096,,
(
Choose your webcam device name from this list,
       I haven't pruned the audio devices yet.
)
gibdevice := "ffmpeg -f dshow -list_devices true -i null"
List := ComObjCreate("WScript.Shell").Exec(gibdevice).StdErr.ReadAll()
List.Visible := false

text := List
texts := StrSplit(text, "`n", "`r")
for i, thisText in texts {
  RegExMatch(thisText, "O)^\[(?:\w+)\s*@\s*(?:[[:xdigit:]]+)\]\s*""(.*?)""$", thisMatch)
  MakeList .= "|" . thisMatch.Value(1)
  }
  
  DirtyList := StrReplace(MakeList, "||||", "|") ;Remove Duplicate "|" pipe bars.
  StringTrimLeft, DeviceList, DirtyList, 4 ;Remove Duplicate "|" pipe bars at beginning.
  DeviceList := StrReplace(DeviceList, "|||", "|=====================================|") ;Split Video & Audio devices

GuiControl,, WebCamName, |%DeviceList%
 ;GuiControl, Disable, ListWebcams
GuiControl, Choose, WebCamName, 2
 ;Control, ShowDropDown,, ComboBox2

ifWinExist, F.A.G.U.T-AUDIO
{
GuiControl,3:, MicrophoneName, |%DeviceList%
 ;GuiControl, 3:Disable, ListDevices
GuiControl, 3:Choose, MicrophoneName, 7
 ;Control, ShowDropDown,, ComboBox2
return
}
return

!s::
gosub, DisableGlitch
gosub, EnableBitrate
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
gosub, DisableGlitch
gosub, EnableBitrate
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

;Generates and streams random data
!b::
run, ShittyWebcam2.0.ahk
return

;Streams custom input data, WIP
!n::
return ;Disable For Now...
{
sleep, 10
VarSetCapacity(sTest, UDPVarCapacitySize)
sTest := CustomUDPval
{
 loop, UDPRepeatAmount
 sTest := sTest . sTest
 }
sleep, 1000
DllCall("MulDiv", int, &sTest, int, 1, int, 1, str)

UDP := new SocketUDP()
UDP.Connect(["127.0.0.1", "1337"])
; The following line has seemingly no effect
; UDP.SetBroadcast(True)

amount := 1
while amount < UDPLoopAmount
{
 UDP.Send(&sTest, UDPVarCapacitySize) ; Call UDP.Send, give it the address of the buffer, and the length of the buffer
  amount +=1
sleep, 60
}

if (amount = UDPLoopAmount) {
VarSetCapacity(sTest, 0)
return
 }
}
return

toggletwo:=0
!k::
toggletwo:=!toggletwo
if toggletwo = 1
 {
  run, files/ShittyWebcam.exe
 }
else
{
Process, Close, ShittyWebcam.exe
}
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
