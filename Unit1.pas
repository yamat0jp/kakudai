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
    procedure WMAPP100(var Msg: TMessage); message WM_APP+$100;
  public
    { Public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function ChangeWindowMessageFilterEx(Msg: HWND; uInt: UInt; dwFlag:DWORD; int:integer): Boolean; stdcall; external 'user32.dll';

function StartMouseKeyHook(hWnd: HWND): Boolean; stdcall; external 'keyhook.dll';
procedure StopMouseKeyHook; stdcall; external 'keyhook.dll';

procedure TForm1.FormCreate(Sender: TObject);
begin
  if @ChangeWindowMessageFilterEx <> nil then
    ChangeWindowMessageFilterEx(Handle,WM_APP+$100,MSGFLT_ADD,0);
  StartMouseKeyHook(Handle);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  StopMouseKeyHook;
end;

procedure TForm1.WMAPP100(var Msg: TMessage);
var
  pEvent: PEventMSG;
begin
  pEvent:=PEventMSG(Msg.LParam);
  case pEvent.message of
  WM_MOUSEMOVE:
    Hide;
  WM_KEYDOWN:
    Show;
  end;
end;

end.
