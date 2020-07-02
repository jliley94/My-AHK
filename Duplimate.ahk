#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CopiedStuff := ["this", "is", "for", "testing"] ; copy storage
CopiedCount := 0 ; storage count
currentlyPasting := 0 ; pasting state (used to disable up/down)

^+c:: ;special copy - add copied item to storage
{
    Send, ^c
    Sleep 50
    CopiedStuff.Push(clipboard) ; Append this line to the array.
    CopiedCount = CopiedStuff0
    ;msgbox, % CopiedStuff.MaxIndex()
    Return
}

^+v:: ; special paste - paste last stored + use up down to replace with other storage items
{
    currentlyPasting := 1 ; set paste state
    CopiedCount := CopiedStuff.MaxIndex() ; reset storage count
    Send, % CopiedStuff[CopiedStuff.MaxIndex()]  ; paste latest
    length := StrLen(CopiedStuff[CopiedCount]) ; get length of item
    Send, +{Left %length%} ; highlight item
    while (GetKeyState("v")) ;while v held (check for up / down) (ctrl / shift doesnt work for this)
    {
        if (GetKeyState("Up", "P") && CopiedCount > 1) {
            KeyWait UP ;wait for key to be released
            CopiedCount -= 1 ; navigate to storage item
            Send, % CopiedStuff[CopiedCount] ; paste item
            length := StrLen(CopiedStuff[CopiedCount])
            Send, +{Left %length%} ; highlight item
            ;msgbox, %length%
        }
        if (GetKeyState("Down", "P") && CopiedCount < CopiedStuff.MaxIndex()) {
            KeyWait DOWN ;wait for key to be released
            CopiedCount += 1 ; navigate to storage item
            Send, % CopiedStuff[CopiedCount] ; paste item
            length := StrLen(CopiedStuff[CopiedCount])
            Send, +{Left %length%} ; highlight item
        }
        if (GetKeyState("/", "P")) { ;list copies
            values := ""
            for index, element in CopiedStuff {
                values .= index . " is " . element . "`n"
            }
            MsgBox, % values
        }
        Sleep, 50
    }
    currentlyPasting := 0 ; set paste state
    Send, {Right} ; unhighlight selection
    Return
}

#If currentlyPasting ; disable default up / down functionality while chosing paste item
UP:: return
DOWN:: return