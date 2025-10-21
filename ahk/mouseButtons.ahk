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
