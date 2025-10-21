; ==========================================
; Xbox 手柄控制浏览器 (AutoHotkey v1.1 完全版)
#SingleInstance Force
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%


; === 参数配置 ===
PollInterval := 15
LeftDeadzone := 8000
RightDeadzone := 8000
MaxMovePerPoll := 20
ScrollScale := 1
InitialDelay := 300
RepeatInterval := 50

; === Xbox 按钮常量 ===
XINPUT_GAMEPAD_DPAD_UP    := 0x0001
XINPUT_GAMEPAD_DPAD_DOWN  := 0x0002
XINPUT_GAMEPAD_DPAD_LEFT  := 0x0004
XINPUT_GAMEPAD_DPAD_RIGHT := 0x0008
XINPUT_GAMEPAD_START      := 0x0010
XINPUT_GAMEPAD_BACK       := 0x0020
XINPUT_GAMEPAD_LEFT_THUMB := 0x0040
XINPUT_GAMEPAD_RIGHT_THUMB:= 0x0080
XINPUT_GAMEPAD_LEFT_SHOULDER  := 0x0100
XINPUT_GAMEPAD_RIGHT_SHOULDER := 0x0200
XINPUT_GAMEPAD_A          := 0x1000
XINPUT_GAMEPAD_B          := 0x2000
XINPUT_GAMEPAD_X          := 0x4000
XINPUT_GAMEPAD_Y          := 0x8000

; === 初始化变量 ===
prevButtons := 0
scrollAccumulator := 0
triggerDownHandled := false
triggerUpHandled := false
aHandled := false
bHandled := false
dpads := {Up:0, Down:0, Left:0, Right:0}
dpadsTimers := {Up:0, Down:0, Left:0, Right:0}

MouseGetPos, lastMouseX, lastMouseY
mouseInitialized := true


; === 尝试加载可用的 XInput DLL ===
xinputDlls := ["xinput1_4.dll", "xinput1_3.dll", "XInput9_1_0.dll"]
xinput := ""

for index, dll in xinputDlls
{
    if DllCall("GetModuleHandle", "Str", dll)
    {
        xinput := dll
        break
    }
    else
    {
        h := DllCall("LoadLibrary", "Str", dll)
        if (h)
        {
            xinput := dll
            break
        }
    }
}

if (xinput = "")
{
    MsgBox, 16, 错误, 未找到 XInput DLL，请确认已连接 Xbox 手柄。
    ExitApp
}


; === 主循环开始 ===
Loop
{
    VarSetCapacity(state, 20, 0)
    ret := DllCall(xinput . "\XInputGetState", "UInt", 0, "Ptr", &state, "UInt")
    if (ret != 0)
    {
        Sleep, %PollInterval%
        continue
    }

    wButtons := NumGet(state, 4, "UShort")
    bLeftTrigger := NumGet(state, 6, "UChar")
    bRightTrigger := NumGet(state, 7, "UChar")
    sThumbLX := NumGet(state, 8, "Short")
    sThumbLY := NumGet(state, 10, "Short")
    sThumbRX := NumGet(state, 12, "Short")
    sThumbRY := NumGet(state, 14, "Short")


; === 左摇杆控制鼠标（平滑移动） ===
lx := sThumbLX
ly := sThumbLY

if (Abs(lx) < LeftDeadzone)
    lx := 0
if (Abs(ly) < LeftDeadzone)
    ly := 0

if (lx != 0 or ly != 0)
{
    nx := lx / 32768.0
    ny := ly / 32768.0

    dx := Round(nx * MaxMovePerPoll)
    dy := Round(-ny * MaxMovePerPoll)

    if (!mouseInitialized)
    {
        MouseGetPos, lastMouseX, lastMouseY
        mouseInitialized := true
    }

    newx := lastMouseX + dx
    newy := lastMouseY + dy

    if (newx < 0)
        newx := 0
    if (newy < 0)
        newy := 0
    if (newx > A_ScreenWidth)
        newx := A_ScreenWidth
    if (newy > A_ScreenHeight)
        newy := A_ScreenHeight

    DllCall("SetCursorPos", "int", newx, "int", newy)
    lastMouseX := newx
    lastMouseY := newy
}


; === 右摇杆控制滚动（分段速度） ===
ry := sThumbRY
if (Abs(ry) < RightDeadzone)
    ry := 0

if (ry != 0)
{
    ny := ry / 32767.0
    absNy := Abs(ny)
    dir := (ny > 0) ? 1 : -1

    if (absNy <= 0.5)
        speed := (absNy * 0.5) / 3
    else if (absNy <= 0.9)
        speed := 0.083 + (absNy-0.5) * 2.0
    else
        speed := 0.883 + (absNy-0.9) * 4.5

    speed := speed * ScrollScale

    scrollAccumulator := scrollAccumulator + speed * dir
    if (Abs(scrollAccumulator) >= 1)
    {
        steps := Floor(Abs(scrollAccumulator))
        if (scrollAccumulator > 0)
Loop, %steps%                               
                Send, {WheelUp}
        else
            Loop, %steps%
                Send, {WheelDown}

        scrollAccumulator := scrollAccumulator - (scrollAccumulator > 0 ? steps : -steps)
    }
}


; === RT / LT 半屏滚动（直接发送 PgUp/PgDn） ===
if (bRightTrigger >= 128)
{
    if (!triggerDownHandled)
    {
        Send, {PgDn}
        triggerDownHandled := true
    }
}
else
    triggerDownHandled := false

if (bLeftTrigger >= 128)
{
    if (!triggerUpHandled)
    {
        Send, {PgUp}
        triggerUpHandled := true
    }
}
else
    triggerUpHandled := false


; === RB / LB 控制 Tab 切换 ===
changed := wButtons ^ prevButtons
if ((changed & XINPUT_GAMEPAD_RIGHT_SHOULDER) && (wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER))
    Send, {Tab}
if ((changed & XINPUT_GAMEPAD_LEFT_SHOULDER) && (wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER))
    Send, +{Tab}


; === D-Pad 映射键盘上下左右（按住先触发一次，再重复） ===
dpadsMap := {Up:XINPUT_GAMEPAD_DPAD_UP, Down:XINPUT_GAMEPAD_DPAD_DOWN, Left:XINPUT_GAMEPAD_DPAD_LEFT, Right:XINPUT_GAMEPAD_DPAD_RIGHT}
for dir, mask in dpadsMap
{
    pressed := wButtons & mask
    if (pressed)
    {
        now := A_TickCount
        if (!dpads[dir])
        {
            Send, {%dir%}
            dpads[dir] := true
            dpadsTimers[dir] := now + InitialDelay
        }
        else if (now >= dpadsTimers[dir])
        {
            Send, {%dir%}
            dpadsTimers[dir] := now + RepeatInterval
        }
    }
    else
    {
        dpads[dir] := false
    }
}


; === A/B 映射鼠标左右键（按下触发一次） ===
if ((wButtons & XINPUT_GAMEPAD_A) && !aHandled)
{
    Click, Left
    aHandled := true
}
else if (!(wButtons & XINPUT_GAMEPAD_A))
    aHandled := false

if ((wButtons & XINPUT_GAMEPAD_B) && !bHandled)
{
    Click, Right
    bHandled := true
}
else if (!(wButtons & XINPUT_GAMEPAD_B))
    bHandled := false


    prevButtons := wButtons
    Sleep, %PollInterval%
}
