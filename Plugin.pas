{=========================================================================

                TTBase�v���O�C���e���v���[�g(Plugin.pas)

                ���̃t�@�C���͂ł��邾���ύX���Ȃ��B
                Main.pas�ɏ������������Ƃ������߂��܂��B

 =========================================================================}
unit Plugin;

interface

uses
  Windows, SysUtils;

const
  // �v���O�C���̃��[�h�^�C�v
  // TPluginInfo.PluginType
  ptAlwaysLoad = 0;  // ��Ƀ��[�h
  ptLoadAtUse  = 1;  // �R�}���h���Ă΂��Ƃ��������[�h
  ptSpecViolation = $FFFF; // TTBase�v���O�C���d�l�Ɉᔽ���Ă���DLL

  // ���j���[�\���Ɋւ���萔
  dmNone       = 0;  // �����o���Ȃ�
  dmToolMenu   = 2;  // �c�[�����j���[
  dmSystemMenu = 1;  // �V�X�e�����j���[
  dmHotKeyMenu = 4;  // �z�b�g�L�[
  dmUnChecked  = 0;  //
  dmChecked    = 8;  // ���j���[���`�F�b�N����Ă���
  dmEnabled    = 0;  //
  dmDisabled   = 16; // ���j���[���O���C�A�E�g����Ă���
  DISPMENU_MENU     = dmToolMenu or dmSystemMenu;
  DISPMENU_ENABLED  = dmDisabled;
  DISPMENU_CHECKED  = dmChecked;

  // ���O�o�͂Ɋւ���萔
  elNever      = 0;  //�o�͂��Ȃ�
  elError      = 1;  //�G���[
  elWarning    = 2;  //�x��
  elInfo       = 3;  //���
  elDebug      = 4;  //�f�o�b�O

type
  // --------------------------------------------------------
  //    �\���̒�`
  // --------------------------------------------------------
  // �R�}���h���\����
  PPluginCommandInfo = ^TPluginCommandInfo;
  TPluginCommandInfo = packed record
    Name: PChar;          // �R�}���h�̖��O�i�p���j
    Caption: PChar;       // �R�}���h�̐����i���{��j
    CommandID: Integer;   // �R�}���h�ԍ�
    Attr: Integer;        // �A�g���r���[�g�i���g�p�j
    ResID: Integer;       // ���\�[�X�ԍ��i���g�p�j
    DispMenu: Integer;    // ���j���[�ɏo�����ǂ����BHotKey�̑I����ʂ�4,
                          //    SysMenu:1 ToolMenu:2 None: 0
    TimerInterval: DWORD; // �R�}���h���s�^�C�}�[�Ԋu[msec] 0�ŋ@�\���g��Ȃ��B
    TimerCounter: DWORD;  // �V�X�e�������Ŏg�p
  end;
  PPluginCommandInfoArray = ^TPluginCommandInfoArray;
  TPluginCommandInfoArray = array[0..65535] of TPluginCommandInfo;

  // �v���O�C�����\����
  PPluginInfo = ^TPluginInfo;
  TPluginInfo = packed record
    NeedVersion: WORD;    // �v���O�C��I/F�v���o�[�W����
    Name: PChar;          // �v���O�C���̐����i���{��j
    Filename: PChar;      // �v���O�C���̃t�@�C�����i���΃p�X�j
    PluginType: WORD;     // �v���O�C���̃��[�h�^�C�v
    VersionMS: DWORD;     // �o�[�W����
    VersionLS: DWORD;     // �o�[�W����
    CommandCount: DWORD;  // �R�}���h��
    Commands: PPluginCommandInfoArray; // �R�}���h
    // �ȉ��V�X�e���ŁATTBase�{�̂Ŏg�p����
    LoadTime: DWORD;      // ���[�h�ɂ����������ԁimsec�j
  end;
  PPluginInfoArray = ^TPluginInfoArray;
  TPluginInfoArray = array[0..65535] of PPluginInfo;

// --------------------------------------------------------
//    �v���O�C�����G�N�X�|�[�g�֐�
// --------------------------------------------------------
  function  TTBEvent_InitPluginInfo(PluginFilename: PChar): PPluginInfo; stdcall; export;
  procedure TTBEvent_FreePluginInfo(PluginInfo: PPluginInfo); stdcall; export;
  function  TTBEvent_Init(PluginFilename: PChar; hPlugin: DWORD): BOOL; stdcall; export;
  procedure TTBEvent_Unload; stdcall; export;
  function  TTBEvent_Execute(CommandID: Integer; hWnd: THandle): BOOL; stdcall; export;
  procedure TTBEvent_WindowsHook(Msg: Word; wParam: DWORD; lParam: DWORD); stdcall; export;

// --------------------------------------------------------
//    �{�̑��G�N�X�|�[�g�֐�
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
//    �����֐�
// --------------------------------------------------------
  function CopyPluginInfo(Src: PPluginInfo): PPluginInfo;
  procedure FreePluginInfo(PluginInfo: PPluginInfo);
  procedure GetVersion(Filename: string; var VersionMS, VersionLS: DWORD);
  procedure WriteLog( logLevel: Integer; msg: String );
  function ExecutePluginCommand( pluginName: String; CmdID: Integer ): Boolean;

var
  PLUGIN_FILENAME: string;      // �v���O�C���̃t�@�C�����BTTBase����̑��΃p�X
  PLUGIN_HANDLE: DWORD;         // �v���O�C����TTBase�ŔF�����邽�߂̎��ʃR�[�h

implementation

uses
  Main;

// ****************************************************************
// *
// *         ���[�e�B���e�B���[�`��
// *
// --------------------------------------------------------
//    �v���O�C�����\���̂�Src���R�s�[���ĕԂ�
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
//  �v���O�C�����ō쐬���ꂽ�v���O�C�����\���̂�j������
// --------------------------------------------------------
procedure FreePluginInfo(PluginInfo: PPluginInfo);
begin
  TTBEvent_FreePluginInfo(PluginInfo);
end;

// --------------------------------------------------------
//    �o�[�W��������Ԃ�
// --------------------------------------------------------
procedure GetVersion(Filename: string; var VersionMS, VersionLS: DWORD);
var
  VersionHandle: Cardinal;
  VersionSize:DWORD;
  pVersionInfo:Pointer;
  itemLen : UInt;
  FixedFileInfo : PVSFixedFileInfo;
begin
  // ------- �t�@�C���Ƀo�[�W�����ԍ��𖄂ߍ���ł���ꍇ
  // ------- ���̃��[�`�����g���΁A���̃o�[�W�����ԍ���n�����Ƃ��ł���
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
//    ���O���o�͂���
// --------------------------------------------------------
procedure WriteLog( logLevel: Integer; msg: String );
begin
  //TTBase �� TTBPlugin_WriteLog ���G�N�X�|�[�g���Ă��Ȃ��ꍇ�͉������Ȃ�
  if @TTBPlugin_WriteLog = nil then Exit;
  TTBPlugin_WriteLog( PLUGIN_HANDLE, logLevel, PChar(msg) );
end;

// --------------------------------------------------------
//    �ق��̃v���O�C���̃R�}���h�����s����
// --------------------------------------------------------
function ExecutePluginCommand( pluginName: String; CmdID: Integer ): Boolean;
begin
  Result := False;
  //TTBase �� TTBPlugin_ExecuteCommand ���G�N�X�|�[�g���Ă��Ȃ��ꍇ�͉������Ȃ�
  if @TTBPlugin_ExecuteCommand = nil then Exit;
  Result := TTBPlugin_ExecuteCommand( PChar(pluginName), CmdID );
end;

// ****************************************************************
// *
// *         �v���O�C�� �C�x���g
// *
// --------------------------------------------------------
//    �v���O�C�����\���̂̃Z�b�g
// --------------------------------------------------------
function  TTBEvent_InitPluginInfo(PluginFilename: PChar): PPluginInfo; stdcall; export;
var
  i: Integer;
  pCI: PPluginCommandInfo;
begin
  // PluginFilename�ɂ́A�������g�̃t���p�X�������Ă���B
  // �����ۑ����Ă����āA�����̃o�[�W�����擾�Ɏg�����Ƃ��\�B�i���΃p�X�j
  PLUGIN_FILENAME := PluginFilename;
  GetMem(Result, sizeof(TPluginInfo));
  // �K�v�Ƃ���o�[�W�����B�����_�ł�0�B
  Result.NeedVersion := 0;
  // �v���O�C����
  GetMem(Result.Name, length(PLUGIN_NAME) + 1);
  StrCopy(Result.Name, PChar(PLUGIN_NAME));
  // �t�@�C�������R�s�[�i���΃p�X�j
  GetMem(Result.Filename, StrLen(PluginFilename) + 1);
  StrCopy(Result.Filename, PluginFilename);
  // ���[�h�^�C�v
  Result.PluginType := PLUGIN_TYPE;

  // �o�[�W�����̎擾
  GetVersion(PLUGIN_FILENAME, Result.VersionMS, Result.VersionLS);
  Result.CommandCount := COMMAND_COUNT;

  // �R�}���h���
  GetMem(Result.Commands, sizeof(TPluginCommandInfo) * COMMAND_COUNT);
  for i := 0 to COMMAND_COUNT - 1 do
  begin
    pCI := @Result.Commands[i];
    pCI^ := COMMAND_INFO[i];
    // �R�}���h���i�p���j
    GetMem (pCI.Name, length(COMMAND_INFO[i].Name) + 1);
    StrCopy(pCI.Name, PChar(COMMAND_INFO[i].Name));
    // �R�}���h�̐����i���{��j
    GetMem (pCI.Caption, length(COMMAND_INFO[i].Caption) + 1);
    StrCopy(pCI.Caption, PChar(COMMAND_INFO[i].Caption));
  end;
end;

// --------------------------------------------------------
//    �v���O�C�����\���̂̔j��
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
//    �v���O�C��������
// --------------------------------------------------------
function  TTBEvent_Init(PluginFilename: PChar; hPlugin: DWORD):
  BOOL; stdcall; export;
var
  hModule: THandle;
begin
  // �L���b�V���̂��߂ɁATTBPlugin_InitPluginInfo�͌Ă΂�Ȃ��ꍇ������
  // ���̂��߁AInit�ł�PLUGIN_FILENAME�̏��������s��
  PLUGIN_FILENAME := PluginFilename;
  // TTBase����A�v���O�C����F�����邽�߂̎��ʃR�[�h
  PLUGIN_HANDLE := hPlugin;
  // API�֐��̎擾
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
//    �v���O�C���A�����[�h���̏���
// --------------------------------------------------------
procedure TTBEvent_Unload; stdcall; export;
begin
  Unload;
end;

// --------------------------------------------------------
//    �R�}���h���s
// --------------------------------------------------------
function  TTBEvent_Execute(CommandID: Integer; hWnd: THandle): BOOL; stdcall; export;
begin
  Result := ExecuteCommand(CommandID, hWnd);
end;

// --------------------------------------------------------
//    �t�b�N�iShellHook,MouseHook)
// --------------------------------------------------------
procedure TTBEvent_WindowsHook(Msg: Word; wParam: DWORD; lParam: DWORD); stdcall; export;
begin
  HookProc(Msg, wParam, lParam);
end;

end.
