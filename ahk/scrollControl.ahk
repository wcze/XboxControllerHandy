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
