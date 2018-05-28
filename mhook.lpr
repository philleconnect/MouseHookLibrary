{$mode delphi}

library hook;

uses
  Windows,
  Messages;

const
  WH_MOUSE_LL = 14;

var
  HookHandle: Cardinal = 0;
  WindowHandle: Cardinal = 0;
  enabled: boolean = false;

function MouseHookProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM):
 LRESULT; stdcall;
begin
  if (enabled = true) then begin
    result:=1;
  end
  else begin
    result:=CallNextHookEx(HookHandle, nCode, wParam, lParam);
  end;
end;

function InstallMouseHook(Hwnd: Cardinal): Boolean; stdcall;
begin
  Result := False;
  if HookHandle = 0 then begin
    HookHandle := SetWindowsHookEx(WH_MOUSE_LL, @MouseHookProc,
    HInstance, 0);
    WindowHandle := Hwnd;
    Result := TRUE;
  end;
  enabled:=false;
end;

function UninstallMouseHook: Boolean; stdcall;
begin
  Result := UnhookWindowsHookEx(HookHandle);
  HookHandle := 0;
end;

function ControlMouseHook(mode: boolean): Boolean; stdcall;
begin
  if (mode = true) then begin
    enabled:=true;
  end
  else begin
    enabled:=false;
  end;
  result:=true;
end;

exports
  InstallMouseHook,
  UninstallMouseHook,
  ControlMouseHook;
end.
