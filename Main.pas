{ =========================================================================

  TTBase�v���O�C���e���v���[�g(Main.pas)

  ========================================================================= }
unit Main;

interface

uses
  Windows, Plugin, SysUtils;

const
  // �v���O�C���̖��O�i���{����\�j
  PLUGIN_NAME = 'Kakuda';
  // ���[�h�^�C�v
  // ptLoadAtUse�ŁA�R�}���h�g�p���̂݃��[�h�����
  // ptAlwaysLoad�ŁA�풓
  PLUGIN_TYPE = ptLoadAtUse;
  // �R�}���h�̐�
  COMMAND_COUNT = 1;

const

  COMMAND_INFO: array [0 .. COMMAND_COUNT - 1] of TPluginCommandInfo =
    ((Name: 'ZoomJLetter'; // �R�}���h���i�p���j
    Caption: '���{����͗p�̊g�勾'; // �R�}���h�̐���
    CommandID: 0; // �R�}���hID�B�R�}���h���ƂɈ�ӂɒ�`�B
    Attr: 0; // �R�}���h�A�g���r���[�g�i���g�p�j
    ResID: - 1; // ���\�[�XID�i���g�p�j
    DispMenu: dmHotKeymenu;
    // ���j���[�ɏo�����ǂ���
    TimerInterval: 0; // �^�C�}�[�N�����g���Ȃ�Ԋu��ݒ�[msec]�B
    // �g��Ȃ��Ƃ���0
    ));

  // --------------------------------------------------------
  // �֐��錾
  // --------------------------------------------------------
function ExecuteCommand(CmdIndex: DWORD; hWnd: THandle): Boolean;
function Init: Boolean;
procedure Unload;
procedure HookProc(Msg: Word; wParam: DWORD; lParam: DWORD);

implementation

uses Imm;

// --------------------------------------------------------
// �R�}���h���s��
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
// �v���O�C�����������̏���
// --------------------------------------------------------
function Init: Boolean;
begin
  Result := true;
end;

// --------------------------------------------------------
// �v���O�C���A�����[�h���̏���
// --------------------------------------------------------
procedure Unload;
begin
end;

// --------------------------------------------------------
// �t�b�N(ShellHook�̂݁j
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
