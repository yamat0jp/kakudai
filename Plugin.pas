{=========================================================================

                TTBaseプラグインテンプレート(Plugin.pas)

                このファイルはできるだけ変更しない。
                Main.pasに処理を書くことをお勧めします。

 =========================================================================}
unit Plugin;

interface

uses
  Windows, SysUtils;

const
  // プラグインのロードタイプ
  // TPluginInfo.PluginType
  ptAlwaysLoad = 0;  // 常にロード
  ptLoadAtUse  = 1;  // コマンドが呼ばれるときだけロード
  ptSpecViolation = $FFFF; // TTBaseプラグイン仕様に違反しているDLL

  // メニュー表示に関する定数
  dmNone       = 0;  // 何も出さない
  dmToolMenu   = 2;  // ツールメニュー
  dmSystemMenu = 1;  // システムメニュー
  dmHotKeyMenu = 4;  // ホットキー
  dmUnChecked  = 0;  //
  dmChecked    = 8;  // メニューがチェックされている
  dmEnabled    = 0;  //
  dmDisabled   = 16; // メニューがグレイアウトされている
  DISPMENU_MENU     = dmToolMenu or dmSystemMenu;
  DISPMENU_ENABLED  = dmDisabled;
  DISPMENU_CHECKED  = dmChecked;

  // ログ出力に関する定数
  elNever      = 0;  //出力しない
  elError      = 1;  //エラー
  elWarning    = 2;  //警告
  elInfo       = 3;  //情報
  elDebug      = 4;  //デバッグ

type
  // --------------------------------------------------------
  //    構造体定義
  // --------------------------------------------------------
  // コマンド情報構造体
  PPluginCommandInfo = ^TPluginCommandInfo;
  TPluginCommandInfo = packed record
    Name: PChar;          // コマンドの名前（英名）
    Caption: PChar;       // コマンドの説明（日本語）
    CommandID: Integer;   // コマンド番号
    Attr: Integer;        // アトリビュート（未使用）
    ResID: Integer;       // リソース番号（未使用）
    DispMenu: Integer;    // メニューに出すかどうか。HotKeyの選択画面は4,
                          //    SysMenu:1 ToolMenu:2 None: 0
    TimerInterval: DWORD; // コマンド実行タイマー間隔[msec] 0で機能を使わない。
    TimerCounter: DWORD;  // システム内部で使用
  end;
  PPluginCommandInfoArray = ^TPluginCommandInfoArray;
  TPluginCommandInfoArray = array[0..65535] of TPluginCommandInfo;

  // プラグイン情報構造体
  PPluginInfo = ^TPluginInfo;
  TPluginInfo = packed record
    NeedVersion: WORD;    // プラグインI/F要求バージョン
    Name: PChar;          // プラグインの説明（日本語）
    Filename: PChar;      // プラグインのファイル名（相対パス）
    PluginType: WORD;     // プラグインのロードタイプ
    VersionMS: DWORD;     // バージョン
    VersionLS: DWORD;     // バージョン
    CommandCount: DWORD;  // コマンド個数
    Commands: PPluginCommandInfoArray; // コマンド
    // 以下システムで、TTBase本体で使用する
    LoadTime: DWORD;      // ロードにかかった時間（msec）
  end;
  PPluginInfoArray = ^TPluginInfoArray;
  TPluginInfoArray = array[0..65535] of PPluginInfo;

// --------------------------------------------------------
//    プラグイン側エクスポート関数
// --------------------------------------------------------
  function  TTBEvent_InitPluginInfo(PluginFilename: PChar): PPluginInfo; stdcall; export;
  procedure TTBEvent_FreePluginInfo(PluginInfo: PPluginInfo); stdcall; export;
  function  TTBEvent_Init(PluginFilename: PChar; hPlugin: DWORD): BOOL; stdcall; export;
  procedure TTBEvent_Unload; stdcall; export;
  function  TTBEvent_Execute(CommandID: Integer; hWnd: THandle): BOOL; stdcall; export;
  procedure TTBEvent_WindowsHook(Msg: Word; wParam: DWORD; lParam: DWORD); stdcall; export;

// --------------------------------------------------------
//    本体側エクスポート関数
// --------------------------------------------------------
type
  TTTBPlugin_GetPluginInfo = function (hPlugin: DWORD): PPluginInfo; stdcall;
  TTTBPlugin_SetPluginInfo = procedure (hPlugin: DWORD; PluginInfo: PPluginInfo); stdcall;
  TTTBPlugin_FreePluginInfo = procedure (PluginInfo: PPluginInfo); stdcall;
  TTTBPlugin_SetMenuProperty = procedure (hPlugin: DWORD; CommandID: Integer;
    ChangeFlag, Flag: DWORD); stdcall;
  TTTBPlugin_GetAllPluginInfo = function : PPluginInfoArray; stdcall;
  TTTBPlugin_FreePluginInfoArray = procedure (PluginInfoArray: PPluginInfoArray); stdcall;
  TTTBPlugin_SetTaskTrayIcon = procedure (hIcon: THandle; Tips: PChar); stdcall;
  TTTBPlugin_WriteLog = procedure ( hPlugin: DWORD; logLevel: Integer; msg: PChar ); stdcall;
  TTTBPlugin_ExecuteCommand = function ( PluginName: PChar; CmdID: Integer ): BOOL; stdcall;

var
  TTBPlugin_GetPluginInfo: TTTBPlugin_GetPluginInfo;
  TTBPlugin_SetPluginInfo: TTTBPlugin_SetPluginInfo;
  TTBPlugin_FreePluginInfo: TTTBPlugin_FreePluginInfo;
  TTBPlugin_SetMenuProperty: TTTBPlugin_SetMenuProperty;
  TTBPlugin_GetAllPluginInfo: TTTBPlugin_GetAllPluginInfo;
  TTBPlugin_FreePluginInfoArray: TTTBPlugin_FreePluginInfoArray;
  TTBPlugin_SetTaskTrayIcon: TTTBPlugin_SetTaskTrayIcon;
  TTBPlugin_WriteLog: TTTBPlugin_WriteLog;
  TTBPlugin_ExecuteCommand: TTTBPlugin_ExecuteCommand;

// --------------------------------------------------------
//    内部関数
// --------------------------------------------------------
  function CopyPluginInfo(Src: PPluginInfo): PPluginInfo;
  procedure FreePluginInfo(PluginInfo: PPluginInfo);
  procedure GetVersion(Filename: string; var VersionMS, VersionLS: DWORD);
  procedure WriteLog( logLevel: Integer; msg: String );
  function ExecutePluginCommand( pluginName: String; CmdID: Integer ): Boolean;

var
  PLUGIN_FILENAME: string;      // プラグインのファイル名。TTBaseからの相対パス
  PLUGIN_HANDLE: DWORD;         // プラグインをTTBaseで認識するための識別コード

implementation

uses
  Main;

// ****************************************************************
// *
// *         ユーティリティルーチン
// *
// --------------------------------------------------------
//    プラグイン情報構造体のSrcをコピーして返す
// --------------------------------------------------------
function CopyPluginInfo(Src: PPluginInfo): PPluginInfo;
var
  i: Integer;
  pCommandInfo: PPluginCommandInfo;
begin
  New(Result);
  Result^ := Src^;
  GetMem(Result.Name, StrLen(Src.Name) + 1);
  StrCopy(Result.Name, Src.Name);
  GetMem(Result.Filename, StrLen(Src.Filename) + 1);
  StrCopy(Result.Filename, Src.Filename);
  GetMem(Result.Commands, sizeof(TPluginCommandInfo) * Result.CommandCount);
  for i := 0 to Src.CommandCount - 1 do
  begin
    pCommandInfo := @Result.Commands[i];
    pCommandInfo^ := Src.Commands^[i];
    GetMem (pCommandInfo.Name, StrLen(Src.Commands^[i].Name) + 1);
    StrCopy(pCommandInfo.Name, Src.Commands^[i].Name);
    GetMem (pCommandInfo.Caption, StrLen(Src.Commands^[i].Caption) + 1);
    StrCopy(pCommandInfo.Caption, Src.Commands^[i].Caption);
  end;
end;

// --------------------------------------------------------
//  プラグイン側で作成されたプラグイン情報構造体を破棄する
// --------------------------------------------------------
procedure FreePluginInfo(PluginInfo: PPluginInfo);
begin
  TTBEvent_FreePluginInfo(PluginInfo);
end;

// --------------------------------------------------------
//    バージョン情報を返す
// --------------------------------------------------------
procedure GetVersion(Filename: string; var VersionMS, VersionLS: DWORD);
var
  VersionHandle: Cardinal;
  VersionSize:DWORD;
  pVersionInfo:Pointer;
  itemLen : UInt;
  FixedFileInfo : PVSFixedFileInfo;
begin
  // ------- ファイルにバージョン番号を埋め込んでいる場合
  // ------- このルーチンを使えば、そのバージョン番号を渡すことができる
  VersionMS := 0;
  VersionLS := 0;
  VersionSize := GetFileVersionInfoSize(PChar(Filename), VersionHandle);
  if VersionSize = 0 then Exit;
    GetMem(pVersionInfo,VersionSize);
  try
    if GetFileVersionInfo(PChar(Filename),
                          VersionHandle,
                          VersionSize,
                          pVersionInfo) then
      if VerQueryValue(pVersionInfo,'\',Pointer(FixedFileInfo),itemLen) then
      begin
        VersionMS := FixedFileInfo^.dwFileVersionMS;
        VersionLS := FixedFileInfo^.dwFileVersionLS;
      end;
  finally
    FreeMem(pVersionInfo,VersionSize);
  end;
end;

// --------------------------------------------------------
//    ログを出力する
// --------------------------------------------------------
procedure WriteLog( logLevel: Integer; msg: String );
begin
  //TTBase が TTBPlugin_WriteLog をエクスポートしていない場合は何もしない
  if @TTBPlugin_WriteLog = nil then Exit;
  TTBPlugin_WriteLog( PLUGIN_HANDLE, logLevel, PChar(msg) );
end;

// --------------------------------------------------------
//    ほかのプラグインのコマンドを実行する
// --------------------------------------------------------
function ExecutePluginCommand( pluginName: String; CmdID: Integer ): Boolean;
begin
  Result := False;
  //TTBase が TTBPlugin_ExecuteCommand をエクスポートしていない場合は何もしない
  if @TTBPlugin_ExecuteCommand = nil then Exit;
  Result := TTBPlugin_ExecuteCommand( PChar(pluginName), CmdID );
end;

// ****************************************************************
// *
// *         プラグイン イベント
// *
// --------------------------------------------------------
//    プラグイン情報構造体のセット
// --------------------------------------------------------
function  TTBEvent_InitPluginInfo(PluginFilename: PChar): PPluginInfo; stdcall; export;
var
  i: Integer;
  pCI: PPluginCommandInfo;
begin
  // PluginFilenameには、自分自身のフルパスが入っている。
  // これを保存しておいて、自分のバージョン取得に使うことが可能。（相対パス）
  PLUGIN_FILENAME := PluginFilename;
  GetMem(Result, sizeof(TPluginInfo));
  // 必要とするバージョン。現時点では0。
  Result.NeedVersion := 0;
  // プラグイン名
  GetMem(Result.Name, length(PLUGIN_NAME) + 1);
  StrCopy(Result.Name, PChar(PLUGIN_NAME));
  // ファイル名をコピー（相対パス）
  GetMem(Result.Filename, StrLen(PluginFilename) + 1);
  StrCopy(Result.Filename, PluginFilename);
  // ロードタイプ
  Result.PluginType := PLUGIN_TYPE;

  // バージョンの取得
  GetVersion(PLUGIN_FILENAME, Result.VersionMS, Result.VersionLS);
  Result.CommandCount := COMMAND_COUNT;

  // コマンド情報
  GetMem(Result.Commands, sizeof(TPluginCommandInfo) * COMMAND_COUNT);
  for i := 0 to COMMAND_COUNT - 1 do
  begin
    pCI := @Result.Commands[i];
    pCI^ := COMMAND_INFO[i];
    // コマンド名（英名）
    GetMem (pCI.Name, length(COMMAND_INFO[i].Name) + 1);
    StrCopy(pCI.Name, PChar(COMMAND_INFO[i].Name));
    // コマンドの説明（日本語）
    GetMem (pCI.Caption, length(COMMAND_INFO[i].Caption) + 1);
    StrCopy(pCI.Caption, PChar(COMMAND_INFO[i].Caption));
  end;
end;

// --------------------------------------------------------
//    プラグイン情報構造体の破棄
// --------------------------------------------------------
procedure TTBEvent_FreePluginInfo(PluginInfo: PPluginInfo); stdcall; export;
var
  i: Integer;
begin
  for i := 0 to PluginInfo.CommandCount - 1 do
  begin
    FreeMem(PluginInfo.Commands^[i].Name);
    FreeMem(PluginInfo.Commands^[i].Caption);
  end;
  FreeMem(PluginInfo.Commands);
  FreeMem(PluginInfo.Filename);
  FreeMem(PluginInfo.Name);
  FreeMem(PluginInfo);
end;

// --------------------------------------------------------
//    プラグイン初期化
// --------------------------------------------------------
function  TTBEvent_Init(PluginFilename: PChar; hPlugin: DWORD):
  BOOL; stdcall; export;
var
  hModule: THandle;
begin
  // キャッシュのために、TTBPlugin_InitPluginInfoは呼ばれない場合がある
  // そのため、InitでもPLUGIN_FILENAMEの初期化を行う
  PLUGIN_FILENAME := PluginFilename;
  // TTBaseから、プラグインを認識するための識別コード
  PLUGIN_HANDLE := hPlugin;
  // API関数の取得
  hModule := GetModuleHandle(nil);
  @TTBPlugin_GetAllPluginInfo := GetProcAddress(hModule, PChar('TTBPlugin_GetAllPluginInfo'));
  @TTBPlugin_FreePluginInfoArray := GetProcAddress(hModule, PChar('TTBPlugin_FreePluginInfoArray'));
  @TTBPlugin_GetPluginInfo := GetProcAddress(hModule, PChar('TTBPlugin_GetPluginInfo'));
  @TTBPlugin_SetPluginInfo := GetProcAddress(hModule, PChar('TTBPlugin_SetPluginInfo'));
  @TTBPlugin_FreePluginInfo := GetProcAddress(hModule, PChar('TTBPlugin_FreePluginInfo'));
  @TTBPlugin_SetMenuProperty := GetProcAddress(hModule, PChar('TTBPlugin_SetMenuProperty'));
  @TTBPlugin_SetTaskTrayIcon := GetProcAddress(hModule, PChar('TTBPlugin_SetTaskTrayIcon'));
  @TTBPlugin_WriteLog := GetProcAddress(hModule, PChar('TTBPlugin_WriteLog'));
  @TTBPlugin_ExecuteCommand := GetProcAddress(hModule, PChar('TTBPlugin_ExecuteCommand'));

  Result := Init;
end;

// --------------------------------------------------------
//    プラグインアンロード時の処理
// --------------------------------------------------------
procedure TTBEvent_Unload; stdcall; export;
begin
  Unload;
end;

// --------------------------------------------------------
//    コマンド実行
// --------------------------------------------------------
function  TTBEvent_Execute(CommandID: Integer; hWnd: THandle): BOOL; stdcall; export;
begin
  Result := ExecuteCommand(CommandID, hWnd);
end;

// --------------------------------------------------------
//    フック（ShellHook,MouseHook)
// --------------------------------------------------------
procedure TTBEvent_WindowsHook(Msg: Word; wParam: DWORD; lParam: DWORD); stdcall; export;
begin
  HookProc(Msg, wParam, lParam);
end;

end.
