module autosave;

// By Deen O'Connor

pragma(lib, "user32");

import std.stdio;
import core.thread;
import std.conv : to;
import std.datetime.systime;
import core.time : dur;
import core.sys.windows.windows;
import core.sys.windows.winuser;

static void* wndHandle;

void main(string[] args) {
    while (true) {
        wndHandle = null;
        EnumWindows(&wndEnumerator, 0);
        if (wndHandle !is null) {
            SendMessageA(wndHandle, 0x111, 0x102, 0);
            writeln("[" ~ Clock.currTime.toSimpleString() ~ "] : Saved successfully");
        }
        Thread.sleep(dur!"minutes"(5));
        //Thread.sleep(dur!"seconds"(15));
    }
}

extern (Windows) int wndEnumerator(void* hWnd, int lparam) nothrow {
    wchar[4] text;
    int result = GetWindowText(hWnd, text.ptr, 4);
    if (result == 0) {
        return 1;
    }
    if (text[0..3] == "SAI"w) {
        wndHandle = hWnd;
        SetLastError(ERROR_SUCCESS);
        return 0;
    } else {
        return 1;
    }
}
