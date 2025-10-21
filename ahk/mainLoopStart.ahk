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
