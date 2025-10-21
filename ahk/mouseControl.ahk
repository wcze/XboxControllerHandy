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
