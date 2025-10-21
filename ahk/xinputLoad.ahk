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
