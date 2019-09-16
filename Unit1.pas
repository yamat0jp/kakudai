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
    procedure WMAPP100(var Msg: TMessage); message WM_APP + $100;
    procedure WMAPP110(var Msg: TMessage); message WM_APP + $110;
  public
    { Public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function ChangeWindowMessageFilterEx(hWnd: hWnd; Msgt: Cardinal; dwFlag: DWORD;
  int: integer): Boolean; stdcall; external 'user32.dll';
function StartMouseIMEHook(hWnd: hWnd): Boolean; stdcall;
  external 'keyhook.dll';
procedure StopMouseIMEHook; stdcall; external 'keyhook.dll';

procedure TForm1.FormCreate(Sender: TObject);
begin
  ChangeWindowMessageFilterEx(Handle, WM_APP + $100, MSGFLT_ADD, 0);
  ChangeWindowMessageFilterEx(Handle, WM_APP + $110, MSGFLT_ADD, 0);
  StartMouseIMEHook(Handle);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ChangeWindowMessageFilterEX(Handle, WM_APP + $100, MSGFLT_REMOVE, 0);
  ChangeWindowMessageFilterEX(Handle, WM_APP + $110, MSGFLT_REMOVE, 0);
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
