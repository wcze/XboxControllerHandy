; === RB / LB 控制 Tab 切换 ===
changed := wButtons ^ prevButtons
if ((changed & XINPUT_GAMEPAD_RIGHT_SHOULDER) && (wButtons & XINPUT_GAMEPAD_RIGHT_SHOULDER))
    Send, {Tab}
if ((changed & XINPUT_GAMEPAD_LEFT_SHOULDER) && (wButtons & XINPUT_GAMEPAD_LEFT_SHOULDER))
    Send, +{Tab}
