library PluginKakuda;

{ DLL �ł̃������Ǘ��ɂ���:
  �������� DLL ��������Ԃ�l�Ƃ��� String �^���g���֐�/�葱�����G�N�X�|�[
  �g����ꍇ�A�ȉ��� USES �߂Ƃ��� DLL ���g���v���W�F�N�g�\�[�X�� USES ��
  �̗����ɁA�ŏ��Ɍ���郆�j�b�g�Ƃ��� ShareMem ���w�肵�Ȃ���΂Ȃ�܂���B
  �i�v���W�F�N�g�\�[�X�̓��j���[����[�v���W�F�N�g�b�\�[�X�\��] ��I�Ԃ���
  �ŕ\������܂��j
  ����͍\���̂�N���X�ɖ��ߍ��܂�Ă���ꍇ���܂� String �^�� DLL �Ƃ��
  ��肷��ꍇ�ɕK���K�v�ƂȂ�܂��B
  ShareMem �͋��p�������}�l�[�W���ł��� BORLNDMM.DLL �Ƃ̃C���^�[�t�F�[�X
  �ł��B���Ȃ��� DLL �ƈꏏ�ɔz�z����K�v������܂��BBORLNDMM.DLL ���g����
  �������ɂ́APChar �܂��� ShortString �^���g���ĕ�����̂���������
  �Ȃ��Ă��������B}

uses
  SysUtils,
  Classes,
  Plugin in 'Plugin.pas',
  Main in 'Main.pas',
  MessageDef in 'MessageDef.pas';

exports
  TTBEvent_InitPluginInfo,
  TTBEvent_FreePluginInfo,
  TTBEvent_Init,
  TTBEvent_Unload,
  TTBEvent_Execute,
  TTBEvent_WindowsHook;


{$R *.RES}

begin
end.
