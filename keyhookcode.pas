unit keyhookcode;

interface

uses Windows, Winapi.Messages;

function StartMouseIMEHook(hWnd: hWnd): Boolean; stdcall;
procedure StopMouseIMEHook; stdcall;

implementation

type
  PHookInfo = ^THookInfo;

  THookInfo = record
    HookMouse: HHook;
    HookIME: HHook;
    HostWnd: hWnd;
  end;

var
  hMapFile: THandle;

const
  MapFileName = 'keyhook';

function MapFileMemory(out hMap: THandle; out pMap: Pointer): integer;
begin
  hMap := OpenFileMapping(FILE_MAP_ALL_ACCESS, false, MapFileName);
  if hMap = 0 then
  begin
    result := -1;
    Exit;
  end;
  pMap := MapViewOfFile(hMap, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if pMap = nil then
  begin
    result := -2;
    CloseHandle(hMap);
    Exit;
  end;
  result := 0;
end;

procedure UnMapFileMemory(hMap: THandle; pMap: Pointer);
begin
  if pMap <> nil then
    UnMapViewOfFile(pMap);
  if hMap <> 0 then
    CloseHandle(hMap);
end;

function MouseHookProc(nCode: integer; wPar: WPARAM; lPar: LPARAM)
  : LRESULT; stdcall;
var
  lpMap: Pointer;
  LMapWnd: THandle;
begin
  result := 0;
  if MapFileMemory(LMapWnd, lpMap) = 0 then
    Exit;
  if nCode < 0 then
    result := CallNextHookEx(PHookInfo(lpMap)^.HookMouse, nCode, wPar, lPar)
  else
  begin
    if nCode = HC_ACTION then
      PostMessage(PHookInfo(lpMap)^.HostWnd, WM_APP + $100, wPar, 0);
    result := CallNextHookEx(PHookInfo(lpMap)^.HookMouse, nCode, wPar, lPar);
  end;
  UnMapFileMemory(LMapWnd, lpMap);
end;

function IMEHookProc(nCode: integer; wPar: WPARAM; lPar: LPARAM)
  : LRESULT; stdcall;
var
  lpMap: Pointer;
  LMapWnd: THandle;
begin
  result := 0;
  if MapFileMemory(LMapWnd, lpMap) = 0 then
    Exit;
  if nCode < 0 then
    result := CallNextHookEx(PHookInfo(lpMap)^.HookIME, nCode, wPar, lPar)
  else
  begin
    if nCode = HC_ACTION then
      PostMessage(PHookInfo(lpMap)^.HostWnd, WM_APP + $110, wPar, 0);
  end;
  UnMapFileMemory(LMapWnd, lpMap);
end;

function StartMouseIMEHook(hWnd: hWnd): Boolean; stdcall;
var
  lpMap: Pointer;
  LMapWnd: THandle;
begin
  result := false;
  MapFileMemory(LMapWnd, lpMap);
  if lpMap = nil then
  begin
    LMapWnd := 0;
    Exit;
  end;
  with PHookInfo(lpMap)^ do
  begin
    HostWnd := hWnd;
    HookMouse := SetWindowsHookEx(WH_MOUSE, Addr(MouseHookProc), hInstance, 0);
    HookIME := SetWindowsHookEx(WH_CALLWNDPROC, Addr(IMEHookProc),
      hInstance, 0);
    if (HookMouse > 0) and (HookIME > 0) then
      result := true;
  end;
  UnMapFileMemory(LMapWnd, lpMap);
end;

procedure StopMouseIMEHook; stdcall;
var
  lpMap: Pointer;
  LMapWnd: THandle;
begin
  if PHookInfo(lpMap)^.HookMouse > 0 then
    UnHookWindowsHookEx(PHookInfo(lpMap)^.HookMouse);
  if PHookInfo(lpMap)^.HookIME > 0 then
    UnHookWindowsHookEx(PHookInfo(lpMap)^.HookIME);
  UnMapFileMemory(LMapWnd, lpMap);
end;

initialization

hMapFile := CreateFileMapping(High(NativeUInt), nil, PAGE_READWRITE, 0,
  SizeOf(THookInfo), MapFileName);

finalization

if hMapFile <> 0 then
  CloseHandle(hMapFile);

end.
