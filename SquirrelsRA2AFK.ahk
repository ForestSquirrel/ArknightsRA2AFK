SetWorkingDir, %A_ScriptDir%
#SingleInstance, force
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#include Gdip_All.ahk

If !pToken := Gdip_Startup()
{
	MsgBox "Gdiplus failed to start. Please ensure you have gdiplus on your system"
	ExitApp
}
OnExit("ExitFunc")

Width := 320, Height := 150
ctrGood := 0, ctrFailed := 0
wField := Width - 20
; Initialize the GUI
Gui, +AlwaysOnTop
Gui, Font, s10 c000000, Courier New
Gui, Add, Edit, x10 y10 w%wField% h40 vCounterEdit ReadOnly
Gui, Add, Edit, x10 y60 w%wField% h40 vProgressEdit ReadOnly
Gui, Add, Button, x10 y110 w%wField% h30 gRunAFK, Start
Gui, Show, w%Width% h%Height%, Squirrel's Auto RA2
return

RunAFK:
; zoom up 50 | 410
; zoom up -> base 50 | 490
; zoom resets to up after exit -> continue
Loop {
   text = Good runs:`t%ctrGood%`nFailed runs:`t%ctrFailed%
   UpdateCounters(text)
   UpdateProgress("Skipping intro")
   StartIntro()
   UpdateProgress("First day in progress:")
   FirstDay()
   UpdateProgress("Second day in progress")
   if !SecondDay(){
      Sleep, 2000
      DllCall("SetCursorPos", "int", 15, "int", 25)
      Sleep, 100
      resetMap()
      Sleep, 1000
      UpdateProgress("Starting new run")
      ctrFailed += 1
      Reset(False)
      Continue
   }
   UpdateProgress("Third day in progress")
   if !ThirdDay(){
      Sleep, 2000
      DllCall("SetCursorPos", "int", 15, "int", 25)
      Sleep, 100
      resetMap()
      Sleep, 1000
      UpdateProgress("Starting new run")
      ctrFailed += 1
      Reset(False)
      Continue
   }
   UpdateProgress("Starting new run")
   ctrGood += 1
   Reset(True)
   }
return

UpdateCounters(string) {
   GuiControl,, CounterEdit, %string%
}

UpdateProgress(string) {
   GuiControl,, ProgressEdit, %string%
}

resetMap(){
   ; Resets map by exiting & reentering RA2 
   ; Helps with coords for whole macro since this way map is always the same (not moved & max zoom)
   global
   ; Exit RA2
   DllCall("SetCursorPos", "int", 15, "int", 25)
   Sleep, 100
   ClickDll()
   Sleep, 1000
   ; Resume
   DllCall("SetCursorPos", "int", 1715, "int", 975)
   ClickDll()
   Sleep, 3000
}

zoomMin(){
   ; Minimizes map zoom
   global
   ; Move coursor to zoom slider
   DllCall("SetCursorPos", "int", 50, "int", 410)
   Sleep, 500
   ; LMB down
   DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0) ;lmb down
   Sleep, 500
   ; Move coursor 20 units down relative to its position
   DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 200)
   Sleep, 500
   ; Release LMB
   DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0) ;lmb up
   Sleep, 500
}

ClickDll(){
   ; Simple click function, operates on DLL calls
   global
   DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0)
   Sleep, 50
   DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0)
}

FirstDay(){
   global
   ; 1st node to 1st left enc (zoomed out) 775 | 545
   UpdateProgress("First day in progress:`nReseting map 1")
   resetMap()
   Sleep, 1000
   zoomMin()
   Sleep, 2000
   UpdateProgress("First day in progress:`nLocating 1st node")
   DllCall("SetCursorPos", "int", 775, "int", 545)
   Sleep, 100
   ClickDll() ; zoom to node
   Sleep, 1000
   ClickDll() ; open node
   Sleep, 1000
   UpdateProgress("First day in progress:`nDoing 1st node")
   DoNonEncounterNode()
   Sleep, 10000
   ; 2nd node to 1st left enc (zoomed out) 660 | 650
   UpdateProgress("First day in progress:`nReseting map 2")
   resetMap()
   Sleep, 1000
   zoomMin()
   Sleep, 2000
   UpdateProgress("First day in progress:`nLocating 2nd node")
   DllCall("SetCursorPos", "int", 660, "int", 650)
   Sleep, 100
   ClickDll() ; zoom to node
   Sleep, 1000
   ClickDll() ; open node
   Sleep, 1000
   UpdateProgress("First day in progress:`nDoing 2nd node")
   DoNonEncounterNode()
   Sleep, 10000
   ; end day
   UpdateProgress("First day in progress:`nReseting map & moving to day 2")
   resetMap() ; ????
   ; 1750 | 140  skip day
   DllCall("SetCursorPos", "int", 1750, "int", 140)
   Sleep, 100
   ClickDll()
   ; ##### Need confirm thingy (not)
   Sleep, 7000
   DllCall("SetCursorPos", "int", 690, "int", 895)
   Sleep, 100
   ClickDll()
   UpdateProgress("First day in progress:`nCooking session")
   Sleep, 8000
   Cook()
}

SecondDay(){
   global
   ; 1st enc (left)
   UpdateProgress("Second day in progress:`nReseting map 1")
   resetMap()
   Sleep, 1000
   zoomMin()
   Sleep, 2000
   UpdateProgress("Second day in progress:`nLocating 1st encounter")
   DllCall("SetCursorPos", "int", 555, "int", 750)
   Sleep, 100
   ClickDll() ; zoom to node
   Sleep, 1000
   ClickDll() ; open node
   Sleep, 2000
   UpdateProgress("Second day in progress:`nDoing 1st encounter")
   if !DoEncounter(){
      return False
   }
   ; 2nd enc (right)
   UpdateProgress("Second day in progress:`nReseting map 2")
   resetMap()
   Sleep, 1000
   zoomMin()
   Sleep, 2000
   UpdateProgress("Second day in progress:`nLocating 2nd encounter")
   DllCall("SetCursorPos", "int", 1110, "int", 710)
   Sleep, 100
   ClickDll() ; zoom to node
   Sleep, 1000
   ClickDll() ; open node
   Sleep, 2000
   UpdateProgress("Second day in progress:`nDoing 2nd encounter")
   if !DoEncounter(){
      return False
   }
   ; end day
   UpdateProgress("Second day in progress:`nReseting map & moving to day 3")
   resetMap() ; ????
   ; 1750 | 140  skip day
   DllCall("SetCursorPos", "int", 1750, "int", 140)
   Sleep, 100
   ClickDll()
   ; 960 895##### Need confirm thingy (not)
   Sleep, 7000
   DllCall("SetCursorPos", "int", 690, "int", 895)
   Sleep, 100
   ClickDll()
   UpdateProgress("Second day in progress:`nCooking session")
   Sleep, 8000
   Cook()
   return True
}

ThirdDay(){
   UpdateProgress("Third day in progress:`nReseting map 1")
   resetMap()
   Sleep, 1000
   zoomMin()
   Sleep, 2000
   UpdateProgress("Third day in progress:`nLocating 3rd node")
   DllCall("SetCursorPos", "int", 420, "int", 840)
   Sleep, 100
   ClickDll() ; zoom to node
   Sleep, 1000
   ClickDll() ; open node
   Sleep, 1000
   UpdateProgress("Third day in progress:`nDoing 3rd node")
   DoNonEncounterNode()
   Sleep, 10000
   
   UpdateProgress("Third day in progress:`nReseting map 2")
   resetMap()
   Sleep, 1000
   zoomMin()
   Sleep, 2000
   UpdateProgress("Third day in progress:`nLocating 3rd encounter")
   DllCall("SetCursorPos", "int", 525, "int", 895)
   Sleep, 100
   ClickDll() ; zoom to node
   Sleep, 1000
   ClickDll() ; open node
   Sleep, 2000
   UpdateProgress("Third day in progress:`nDoing 3rd encounter")
   DllCall("SetCursorPos", "int", 570, "int", 535)
   if !DoEncounter(){
      return False
   }
   UpdateProgress("Third day day in progress:`nReseting map & Restarting")
   resetMap() ; ????
   ; 1750 | 140  skip day
   DllCall("SetCursorPos", "int", 1750, "int", 140)
   Sleep, 100
   ClickDll()
   Loop, 2 {
      Sleep, 2000 ;????
      ClickDll()
   }
   ; 960 895##### Need confirm thingy (not)
   Sleep, 3000
   DllCall("SetCursorPos", "int", 690, "int", 895)
   Sleep, 100
   ClickDll()
   Sleep, 5000
   ClickDll()
   return True
}

Reset(flag){ ; True - succes | False - enc fail
   Sleep, 5000
   DllCall("SetCursorPos", "int", 1540, "int", 1005) ; menu
   Sleep, 100
   ClickDll()
   Sleep, 2000
   if flag {
      DllCall("SetCursorPos", "int", 1730, "int", 860) ; wipe
      Sleep, 100
      ClickDll()
   }
   else {
      DllCall("SetCursorPos", "int", 1670, "int", 860) ; wipe
      Sleep, 100
      ClickDll()
   }
   Sleep, 2000

   DllCall("SetCursorPos", "int", 1400, "int", 730) ; conf wipe
   Sleep, 100
   ClickDll()
   Sleep, 2000

   ClickDll()
   Sleep, 10000
}

Cook(){
   DllCall("SetCursorPos", "int", 850, "int", 1000) ; cook btn
   Sleep, 100
   ClickDll()
   Sleep, 1000
   DllCall("SetCursorPos", "int", 1410, "int", 860) ; +1
   Sleep, 100
   ClickDll()
   Sleep, 500
   DllCall("SetCursorPos", "int", 1800, "int", 860) ; confirm
   Sleep, 100
   ClickDll()
   Sleep, 3000
   ClickDll() ; repeat confirm (accept e-drimks)
   Sleep, 1000
   DllCall("SetCursorPos", "int", 110, "int", 80) ; exit
   Sleep, 100
   ClickDll()
   Sleep, 1000
}
; exit enc 110 | 80
; start node 1800 | 860
; start combat 1750 1010
; 1400 | 730 confirm no op
StartIntro(){
   global
   DllCall("SetCursorPos", "int", 1770, "int", 985) ; commenece btn
   Sleep, 100
   ClickDll()
   Sleep, 10000 ; eunectes trashtalks
   DllCall("SetCursorPos", "int", 960, "int", 500) ; commenece btn
   Sleep, 100
   ClickDll()
   Sleep, 3000
   DllCall("SetCursorPos", "int", 1800, "int", 860)
   Sleep, 100
   ClickDll()
   Sleep, 18000
   DllCall("SetCursorPos", "int", 1500, "int", 680) ; dlg pos spam click
   Sleep, 100
   Loop, 27 {
      ClickDll()
      if A_Index == 23
         Sleep, 5000
      Sleep, 1000
   }
   Sleep, 10000

   DllCall("SetCursorPos", "int", 110, "int", 80) ; exit
   Sleep, 100
   ClickDll()
   Sleep, 1000
   ; exit confirm
   DllCall("SetCursorPos", "int", 1400, "int", 730) ; exit confirm
   Sleep, 100
   ClickDll()
   Sleep, 15000
}

DoNonEncounterNode(){
   global
   ; start node 1800 | 860
   DllCall("SetCursorPos", "int", 1800, "int", 860)
   Sleep, 100
   ClickDll()
   Sleep, 1000
   ; start combat 1750 1010
   DllCall("SetCursorPos", "int", 1750, "int", 1010)
   Sleep, 100
   ClickDll()
   Sleep, 1000
   ; confirm no ops in squad
   DllCall("SetCursorPos", "int", 1400, "int", 730)
   Sleep, 100
   ClickDll()
   Sleep, 15000 ; encounter loading
   ; enc start
   DllCall("SetCursorPos", "int", 110, "int", 80)
   Sleep, 100
   ClickDll()
   Sleep, 1000
   ; exit confirm
   DllCall("SetCursorPos", "int", 1400, "int", 730)
   Sleep, 100
   ClickDll()
   Sleep, 5000
   ClickDll() ; get rewards
}

DoEncounter(){
   global
   ClickDll() ; fast forward description
   Sleep, 2000
   if (EncounterType() == 3){
      DllCall("SetCursorPos", "int", 1745, "int", 736)
      Sleep, 100  
   }
   else if (EncounterType() == 2){
      DllCall("SetCursorPos", "int", 1745, "int", 615)
      Sleep, 100  
   }
   else if (EncounterType() == 1){
      DllCall("SetCursorPos", "int", 1745, "int", 555)
      Sleep, 100
   }
   Loop, 2 {
      ClickDll() ; choice
      Sleep, 1000
   }
   pBitmap := Gdip_BitmapFromScreen("1757|207|3|3")
   if !isMonoColoredAreaBitmap(pBitmap, 3, 3, 0x1D1D1D, 3){
      Sleep, 3000
      ClickDll() ; choice
      Sleep, 1000
      DllCall("SetCursorPos", "int", 1780, "int", 620)
      Sleep, 100
      Loop, 3{
         ClickDll() ; choice
         Sleep, 1000
      }
      Sleep, 5000
      Gdip_DisposeImage(pBitmap)
      return True
   } else {
      Gdip_DisposeImage(pBitmap)
      DllCall("SetCursorPos", "int", 15, "int", 25)
      Sleep, 100
      ClickDll()
      Sleep, 1000
      return False
   }
}

isMonoColoredArea(coords, w, h, base_color) {
    coords := StrSplit(coords, "|")
    x := coords[1]
    y := coords[2]
    coords := x "|" y "|" w "|" h
    pBitmap := Gdip_BitmapFromScreen(coords)
    ; save bitmap 
    ; %dGdip_SaveBitmapToFile%(pBitmap, A_ScriptDir . "\test.png")
    x := 0
    y := 0
    white := 0
    total := 0
    loop %h%
    {
        loop %w%
        {
            color := Gdip_GetPixel(pBitmap, x, y) & 0x00FFFFFF ; ARGB to RGB
            if (color == base_color)
                white += 1
            total += 1
            x+= 1
        }
        x := 0
        y += 1
    }
    Gdip_DisposeImage(pBitmap)
    pWhite := white/total
    return ((pWhite = 1) ? True : False)

}

isMonoColoredAreaBitmap(pBitmap, w, h, base_color, eps) {
   x := 0
   y := 0
   valid := 0
   total := 0

   ; Extract the RGB components from the base color
   baseR := (base_color >> 16) & 0xFF
   baseG := (base_color >> 8) & 0xFF
   baseB := base_color & 0xFF

   loop %h%
   {
       loop %w%
       {
           ; Get the RGB color of the current pixel
           color := Gdip_GetPixel(pBitmap, x, y) & 0x00FFFFFF ; ARGB to RGB
           
           ; Extract the RGB components of the pixel
           r := (color >> 16) & 0xFF
           g := (color >> 8) & 0xFF
           b := color & 0xFF

           ; Check if the pixel color is within the ±3 range of the base color
           if ((r >= baseR - eps and r <= baseR + eps) 
            and (g >= baseG - eps and g <= baseG + eps) 
            and (b >= baseB - eps and b <= baseB + eps))
           {
               valid += 1
           }
           total += 1
           x += 1
       }
       x := 0
       y += 1
   }
   return (valid = total)
}

EncounterType(){ ; returns ammount of options in the encounter node (if u have acts)
   if isMonoColoredArea("1745|495|3|3", 3, 3, 0xC7C7C7) & isMonoColoredArea("1745|615|3|3", 3, 3, 0xC7C7C7) & isMonoColoredArea("1745|736|3|3", 3, 3, 0xC7C7C7)
      return 3
   if isMonoColoredArea("1745|495|3|3", 3, 3, 0xC7C7C7) & isMonoColoredArea("1745|615|3|3", 3, 3, 0xC7C7C7)
      return 2
   if isMonoColoredArea("1745|555|3|3", 3, 3, 0xC7C7C7)
      return 1
}

ExitFunc(ExitReason, ExitCode) {
    global
    Gdip_Shutdown(pToken)
    ExitApp
}

GuiEscape:
GuiClose:
ExitApp  ; All of the above labels will do this.
; 0x27311E
~Esc::
    ExitApp
Return