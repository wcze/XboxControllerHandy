; ==========================================
; XboxControllerHandy 配置文件
; 可调整手柄操作参数
; ==========================================

; === 手柄轮询与死区设置 ===
PollInterval := 15          ; 手柄轮询间隔 (ms)
LeftDeadzone := 8000        ; 左摇杆死区阈值
RightDeadzone := 8000       ; 右摇杆死区阈值

; === 鼠标移动设置 ===
MaxMovePerPoll := 20        ; 左摇杆每轮最大移动像素（非精调模式）
PrecisionSpeed := 2         ; 按住 X 键时精调模式移动速度

; === 右摇杆滚动设置 ===
ScrollScale := 1            ; 右摇杆滚动灵敏度

; === D-Pad 自动重复设置 ===
InitialDelay := 300         ; 按住后第一次重复前延迟 (ms)
RepeatInterval := 50        ; 按住后重复间隔 (ms)

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
