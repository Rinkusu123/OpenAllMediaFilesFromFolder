#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
; #Warn
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 2 ; 2-anywhere; 1-start with text; 3-match exactly
; CoordMode, ToolTip|Pixel|Mouse|Caret|Menu [, Screen|Window|Client]
CoordMode,Pixel,Screen
CoordMode,ToolTip,Screen
FileEncoding, utf-8
; DetectHiddenWindows on
; SetBatchLines -1

; #include %A_ScriptDir%\lib\mExitApp.ahk
; Hotkey, LWin & Space, mExitApp, On ; #include below also should be used

fSingleParameter := false

if 0 = 0
    bp("Parameters not detected")
    
if 0 = 1
    {
    vTempParam = %1%
    mGetFullFilePath(vTempParam,vFilename,,vFileDir)
    fSingleParameter := true
    } ; if

; vFullPath := mGetFullFilePath(vPath,vFilename,vExtension,vFileDir)
if % fSingleParameter <> true
{
    loop, %0%
    {
        if % A_Index <> 1
            vFileList .= "`n"
        vFileList .= mGetFullFilePath(%A_Index%,vFilename,,vFileDir)
        if % A_Index = 1
            vPlaylistName := vFileDir . "\!" . SubStr(vFilename,1,8) . ".m3u"
    } ; loop, %0%
} ; if % fSingleParameter = true
else
{
    ; TODO get all files from files folder to vFileList 
    loop,files,%vFileDir%\*.*,F
    {
        if % A_Index <> 1
            vFileList .= "`n"
        if % A_LoopFileExt <> "m3u"
            AND A_LoopFileExt <> "ass"
            AND A_LoopFileExt <> "srt"
            AND A_LoopFileExt <> "txt"
            AND A_LoopFileExt <> "rar"
            vFileList .= mGetFullFilePath(A_LoopFileLongPath,vFilename,,vFileDir)
        if % A_Index = 1
            vPlaylistName := vFileDir . "\!" . SubStr(vFilename,1,8) . ".m3u"
    } ; loop
} ; else

; sort files by name
Sort, vFileList
; write playlist to files location folder
if % vPlaylistName = ""
    bp("Empty. Exiting.`nvPlaylistName:`n" . vPlaylistName)
ifExist %vPlaylistName%
    FileDelete %vPlaylistName%
FileAppend, %vFileList%, %vPlaylistName%

Run,%vPlaylistName%
