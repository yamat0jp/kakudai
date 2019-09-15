library PluginKakuda;

{ DLL でのメモリ管理について:
  もしこの DLL が引数や返り値として String 型を使う関数/手続きをエクスポー
  トする場合、以下の USES 節とこの DLL を使うプロジェクトソースの USES 節
  の両方に、最初に現れるユニットとして ShareMem を指定しなければなりません。
  （プロジェクトソースはメニューから[プロジェクト｜ソース表示] を選ぶこと
  で表示されます）
  これは構造体やクラスに埋め込まれている場合も含め String 型を DLL とやり
  取りする場合に必ず必要となります。
  ShareMem は共用メモリマネージャである BORLNDMM.DLL とのインターフェース
  です。あなたの DLL と一緒に配布する必要があります。BORLNDMM.DLL を使うの
  を避けるには、PChar または ShortString 型を使って文字列のやり取りをおこ
  なってください。}

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
