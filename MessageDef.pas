{=========================================================================

                        TTBase MessageDef.pas

 =========================================================================}
unit MessageDef;

interface

uses
  Windows;

var
  // TTBPlugin_WindowsHookで、Msgパラメータにこれらがやってきます。
  // 内容は、MSDNで、WH_SHELLの該当ID, WH_MOUSEのHC_ACTIONを参照してください。
  TTB_HSHELL_ACTIVATESHELLWINDOW: Word;
  TTB_HSHELL_GETMINRECT: Word;
  TTB_HSHELL_LANGUAGE: Word;
  TTB_HSHELL_REDRAW: Word;
  TTB_HSHELL_TASKMAN: Word;
  TTB_HSHELL_WINDOWACTIVATED: Word;
  TTB_HSHELL_WINDOWCREATED: Word;
  TTB_HSHELL_WINDOWDESTROYED: Word;
  TTB_HMOUSE_ACTION: Word;

  // 内部使用。TaskTrayアイコン関係のメッセージです
  TTB_ICON_NOTIFY: Word;
  // TTBase.datをTTBaseにロードさせます
  TTB_LOAD_DATA_FILE: Word;
  // TTBase.datをTTBaseにセーブさせます
  TTB_SAVE_DATA_FILE: Word;

implementation

const
  TTB_ICON_NOTIFY_MESSAGE = 'TTBase ICON NOTIFY';
  TTB_LOAD_DATA_FILE_MESSAGE = 'TTBase LOAD DATA FILE';
  TTB_SAVE_DATA_FILE_MESSAGE = 'TTBase SAVE DATA FILE';
  TTB_HSHELL_ACTIVATESHELLWINDOW_MESSAGE = 'TTBase HShell Activate ShellWindow';
  TTB_HSHELL_GETMINRECT_MESSAGE  = 'TTBase HShell GetMinRect';
  TTB_HSHELL_LANGUAGE_MESSAGE  = 'TTBase HShell Language';
  TTB_HSHELL_REDRAW_MESSAGE  = 'TTBase HShell Redraw';
  TTB_HSHELL_TASKMAN_MESSAGE  = 'TTBase HShell TaskMan';
  TTB_HSHELL_WINDOWACTIVATED_MESSAGE  = 'TTBase HShell WindowActivated';
  TTB_HSHELL_WINDOWCREATED_MESSAGE  = 'TTBase HShell WindowCreated';
  TTB_HSHELL_WINDOWDESTROYED_MESSAGE  = 'TTBase HShell WindowDestroyed';
  TTB_HMOUSE_ACTION_MESSAGE = 'TTBase HMouse Action';

initialization
  TTB_ICON_NOTIFY := RegisterWindowMessage(TTB_ICON_NOTIFY_MESSAGE);
  TTB_LOAD_DATA_FILE := RegisterWindowMessage(TTB_LOAD_DATA_FILE_MESSAGE);
  TTB_SAVE_DATA_FILE := RegisterWindowMessage(TTB_SAVE_DATA_FILE_MESSAGE);
  TTB_HSHELL_ACTIVATESHELLWINDOW := RegisterWindowMessage(TTB_HSHELL_ACTIVATESHELLWINDOW_MESSAGE);
  TTB_HSHELL_GETMINRECT := RegisterWindowMessage(TTB_HSHELL_GETMINRECT_MESSAGE);
  TTB_HSHELL_LANGUAGE := RegisterWindowMessage(TTB_HSHELL_LANGUAGE_MESSAGE);
  TTB_HSHELL_REDRAW := RegisterWindowMessage(TTB_HSHELL_REDRAW_MESSAGE);
  TTB_HSHELL_TASKMAN := RegisterWindowMessage(TTB_HSHELL_TASKMAN_MESSAGE);
  TTB_HSHELL_WINDOWACTIVATED := RegisterWindowMessage(TTB_HSHELL_WINDOWACTIVATED_MESSAGE);
  TTB_HSHELL_WINDOWCREATED := RegisterWindowMessage(TTB_HSHELL_WINDOWCREATED_MESSAGE);
  TTB_HSHELL_WINDOWDESTROYED := RegisterWindowMessage(TTB_HSHELL_WINDOWDESTROYED_MESSAGE);
  TTB_HMOUSE_ACTION := RegisterWindowMessage(TTB_HMOUSE_ACTION_MESSAGE);

end.
