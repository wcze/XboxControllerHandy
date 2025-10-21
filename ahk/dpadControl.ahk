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
