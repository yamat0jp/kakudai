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
  private
    { Private êÈåæ }
    procedure WMAPP100(var Msg: TMessage); message WM_APP;
    procedure WMAPP110(var Msg: TMessage); message WM_APP + 1;
  public
    { Public êÈåæ }
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

procedure TForm1.WMAPP100(var Msg: TMessage);
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

procedure TForm1.WMAPP110(var Msg: TMessage);
begin
  Hide;
end;

end.
