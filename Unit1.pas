unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private éŒ¾ }
    procedure WMAPP(var Msg: TMessage); message WM_APP;
    procedure WMAPP1(var Msg: TMessage); message WM_APP + 1;
  public
    { Public éŒ¾ }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function StartMouseIMEHook(hWnd: hWnd): Boolean; stdcall;
  external 'keyhook.dll';
procedure StopMouseIMEHook; stdcall; external 'keyhook.dll';

procedure TForm1.FormCreate(Sender: TObject);
begin
  ChangeWindowMessageFilter(WM_APP, MSGFLT_ADD);
  ChangeWindowMessageFilter(WM_APP + 1, MSGFLT_ADD);
  StartMouseIMEHook(Handle);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ChangeWindowMessageFilter(WM_APP, MSGFLT_REMOVE);
  ChangeWindowMessageFilter(WM_APP + 1, MSGFLT_REMOVE);
  StopMouseIMEHook;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  s1, s2: Cardinal;
  p: TPoint;
  i: Integer;
begin
  s1 := GetCurrentThreadID;
  s2 := GetWindowThreadProcessID(GetForegroundWindow);
  AttachThreadInput(s1, s2, true);
  GetCaretPos(p);
  AttachThreadInput(s1, s2, false);
  for i := 1 to 3 do
  begin
    if Left > p.X then
      Left := Left - 10;
    if Top > p.Y then
      Top := Top - 10;
    if Left + ClientWidth div 4 < p.X then
      Left := Left + 10;
    if Top + ClientHeight div 2 < p.Y then
      Top := Top + 10;
  end;
end;

procedure TForm1.WMAPP(var Msg: TMessage);
var
  pEvent: PEventMSG;
begin
  pEvent := PEventMSG(Msg.LParam);
  case pEvent.message of
    WM_MOUSEMOVE:
      Hide;
    WM_KEYDOWN:
      Show;
  end;
end;

procedure TForm1.WMAPP1(var Msg: TMessage);
begin
  Hide;
end;

end.
