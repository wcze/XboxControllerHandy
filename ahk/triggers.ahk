; === RT / LT 半屏滚动（直接发送 PgUp/PgDn） ===
if (bRightTrigger >= 128)
{
    if (!triggerDownHandled)
    {
        Send, {PgDn}
        triggerDownHandled := true
    }
}
else
    triggerDownHandled := false

if (bLeftTrigger >= 128)
{
    if (!triggerUpHandled)
    {
        Send, {PgUp}
        triggerUpHandled := true
    }
}
else
    triggerUpHandled := false
