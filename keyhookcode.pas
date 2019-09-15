unit keyhookcode;

interface

uses Windows, Winapi.Messages;

function StartMouseKeyHook(hWnd: HWND): Boolean; stdcall;
procedure StopMouseKeyHook; stdcall;

implementation

type
  PHookInfo = ^THookInfo;

  THookInfo = record
    HookMouseKey: HHook;
    HostWnd: HWND;
  end;

var
  hMapFile: THandle;

const
  MapFileName = 'keyhook.dll';

function MapFileMemory(hMap: THandle; pMap: Pointer): integer;
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
    result := -1;
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

function MouseKeyHookProc(nCode: integer; wPar: WPARAM; lPar: LPARAM)
  : LRESULT; stdcall;
var
  lpMap: Pointer;
  LMapWnd: THandle;
begin
  if MapFileMemory(LMapWnd, lpMap) = 0 then
    Exit;
  if nCode < 0 then
    result := CallNextHookEx(PHookInfo(lpMap)^.HookMouseKey, nCode, wPar, lPar)
  else
  begin
    if nCode = HC_ACTION then
      PostMessage(PHookInfo(lpMap)^.HostWnd, WM_APP + $100, wPar, 0);
    result := CallNextHookEx(PHookInfo(lpMap)^.HookMouseKey, nCode, wPar, lPar);
  end;
  UnMapFileMemory(LMapWnd,lpMap);
end;

function StartMouseKeyHook(hWnd: HWND): Boolean; stdcall;
var
  lpMap: Pointer;
  lpMapWnd: THandle;
begin
  result:=false;
  MapFileMemory(lpMapWnd,lpMap);
  if lpMap = nil then
  begin
    lpMapWnd:=0;
    exit;
  end;
  with PHookInfo(lpMap)^ do
  begin
    HostWnd:=hWnd;
    HookMouseKey:=SetWindowsHookEx(lpMapWnd,MouseKeyHookProc,hInstance,0);
    if HookMouseKey > 0 then
      result:=true;
  end;
  UnMapFileMemory(lpMapWnd,lpMap);
end;

procedure StopMouseKeyHook; stdcall;
var
  lpMap: Pointer;
  lpMapWnd: THandle;
begin
  if PHookInfo(lpMap)^.HookMouseKey > 0 then
    UnHookWindowsHookEx(PHookInfo(lpMap)^.HookMouseKey);
end;

initialization
  hMapFile:=CreateFileMapping(High(NativeUInt),nil,PAGE_READWRITE,0,SizeOf(THookInfo),MapFileName);

finalization
  if hMapFile <> 0 then
    CloseHandle(hMapFile);

end.
