library keyhook;

{ DLL のメモリ管理に関する重要なメモ: パラメータまたは関数結果として文字列を渡す
  手続きまたは関数を DLL がエクスポートする場合は、ShareMem をライブラリの
  uses 句およびプロジェクトの uses 句 ([プロジェクト｜ソースの表示] を選択) の
  最初に記載する必要があります。これは、
  DLL との間で渡されるすべての文字列に当てはまります。レコードやクラスに
  ネストされているものも同様です。ShareMem は共有メモリ マネージャ BORLNDMM.DLL に対するインターフェイス
  ユニットです。この DLL は作成対象の DLL と一緒に配置する必要が
  あります。BORLNDMM.DLL を使用しないようにするには、PChar 型または ShortString 型の
  パラメータを使って文字列情報を渡します。 }

uses
  keyhookcode in 'keyhookcode.pas';

exports
  StartMouseKeyHook,
  StopMouseKeyHook;

begin

end.
