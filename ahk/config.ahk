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
