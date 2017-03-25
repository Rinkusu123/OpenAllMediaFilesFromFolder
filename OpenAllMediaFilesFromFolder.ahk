/*
 Copyright 2017 Rinkusu123

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

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

; Extensions file check [
vPathNameToIniFile := A_ScriptDir . "\ini_OpenAllMediaFilesFromFolder.ini"
vIniVarDefaultValue := "m3u,ass,srt,txt,rar,jpg,jpeg,png,doc,sub"
; mReadIniCreate(vIniKeyName,vIniSection,vDefaultValue,vIniFileNameAndPath)
mReadIniCreate("Extensions_skip","Main",vIniVarDefaultValue,vPathNameToIniFile)
; Extensions file check ]

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
        
        ; Check for non media file extension [
        fAddLine := true
        vFileExtensionToCheck := A_LoopFileExt
        loop,parse,Extensions_skip,CSV
        {
            if % vFileExtensionToCheck = A_LoopField
                fAddLine := false
        } ; loop
        
        if % fAddLine = true {
        ; Getting filename with full path
        vFullFileName := mGetFullFilePath(A_LoopFileLongPath,vFilename,,vFileDir)
        ; Adding new line to playlist var
        vPlayListFileLine := A_LoopFileName
        vFileList .= ".\" . vPlayListFileLine
        } ; if
        ; Check for non media file extension ]
        
        if % A_Index = 1
            vPlaylistName := vFileDir . "\!" . SubStr(vFilename,1,8) . ".m3u"
    } ; loop
} ; else

; sort files by name
Sort, vFileList
; write playlist to files location folder
if % vPlaylistName = ""
    bp("Empty. Exiting.`nvPlaylistName:`n" . vPlaylistName)
; bp("vFileList:`n" . vFileList) ; TODO 
ifExist %vPlaylistName%
    FileDelete %vPlaylistName%
FileAppend, %vFileList%, %vPlaylistName%

Run,%vPlaylistName%
