; === 左摇杆控制鼠标（平滑移动 + 推动幅度加速） ===
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

    ; 定义非线性加速度曲线（轻推慢、重推快）
    getSpeedFactor(val) {
        absVal := Abs(val)
        if (absVal <= 0.4)
            return absVal * 0.1
        else if (absVal <= 0.8)
            return 0.2 + (absVal - 0.4) * 0.5
        else
            return 0.68 + (absVal - 0.8) * 3.0
    }

    ; 根据摇杆推力计算速度系数
    speedX := getSpeedFactor(nx)
    speedY := getSpeedFactor(ny)

    ; 计算移动量（非线性加速）
    dx := Round(speedX * MaxMovePerPoll * (nx > 0 ? 1 : -1))
    dy := Round(-speedY * MaxMovePerPoll * (ny > 0 ? 1 : -1))  ; 上推 = 鼠标上移

    ; 初始化鼠标位置，避免第一次瞬移
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
