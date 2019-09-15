{ =========================================================================

  TTBaseプラグインテンプレート(Main.pas)

  ========================================================================= }
unit Main;

interface

uses
  Windows, Plugin, SysUtils;

const
  // プラグインの名前（日本語も可能）
  PLUGIN_NAME = 'Kakuda';
  // ロードタイプ
  // ptLoadAtUseで、コマンド使用時のみロードされる
  // ptAlwaysLoadで、常駐
  PLUGIN_TYPE = ptLoadAtUse;
  // コマンドの数
  COMMAND_COUNT = 1;

const

  COMMAND_INFO: array [0 .. COMMAND_COUNT - 1] of TPluginCommandInfo =
    ((Name: 'ZoomJLetter'; // コマンド名（英名）
    Caption: '日本語入力用の拡大鏡'; // コマンドの説明
    CommandID: 0; // コマンドID。コマンドごとに一意に定義。
    Attr: 0; // コマンドアトリビュート（未使用）
    ResID: - 1; // リソースID（未使用）
    DispMenu: dmHotKeymenu;
    // メニューに出すかどうか
    TimerInterval: 0; // タイマー起動を使うなら間隔を設定[msec]。
    // 使わないときは0
    ));

  // --------------------------------------------------------
  // 関数宣言
  // --------------------------------------------------------
function ExecuteCommand(CmdIndex: DWORD; hWnd: THandle): Boolean;
function Init: Boolean;
procedure Unload;
procedure HookProc(Msg: Word; wParam: DWORD; lParam: DWORD);

implementation

uses Imm;

// --------------------------------------------------------
// コマンド実行時
// --------------------------------------------------------
function ExecuteCommand(CmdIndex: DWORD; hWnd: THandle): Boolean;
var
  Handle, Imc: HIMC;
  Conversion, Sentence: DWORD;
begin
  Handle := GetForeGroundWindow;
  ImmGetContext(Handle);
  try
    ImmGetConversionStatus(Imc, Conversion, Sentence);
    if Conversion and IME_CMODE_NATIVE = 0 then
      WinExec('C:\Windows\System32\Magnify.exe',SW_SHOWNORMAL);
  finally
    ImmReleaseContext(Handle, Imc);
  end;
  result:=true;
end;

// --------------------------------------------------------
// プラグイン初期化時の処理
// --------------------------------------------------------
function Init: Boolean;
begin
  Result := true;
end;

// --------------------------------------------------------
// プラグインアンロード時の処理
// --------------------------------------------------------
procedure Unload;
begin
end;

// --------------------------------------------------------
// フック(ShellHookのみ）
// --------------------------------------------------------
procedure HookProc(Msg: Word; wParam: DWORD; lParam: DWORD);
var
  Handle, Imc: HIMC;
  Conversion, Sentence: DWORD;
begin
  if Msg <> WM_IME_STARTCOMPOSITION  then
    Exit;
  Handle := GetForeGroundWindow;
  ImmGetContext(Handle);
  try
    ImmGetConversionStatus(Imc, Conversion, Sentence);
    if Conversion and IME_CMODE_NATIVE = 0 then
      WinExec('Project1.exe',SW_SHOWNORMAL);
  finally
    ImmReleaseContext(Handle, Imc);
  end;
end;

end.
