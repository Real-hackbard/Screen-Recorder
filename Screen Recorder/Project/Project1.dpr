program Project1;

uses
  Forms,
  Windows,
  Dialogs,
  SysUtils,
  Unit1 in 'Unit1.pas' {Form1},
  OptDlg in 'OptDlg.pas' {frmOption},
  FilterEffects in 'FilterEffects.pas' ;

{$R *.res}
var
  AppHandle : THandle;
  Buffer    : String;
begin
  Buffer    := ExtractFileName(UpperCase(ParamStr(0)));
  AppHandle := CreateMuteX(nil, False, PChar(Buffer));

  if WaitForSingleObject(AppHandle, 0) <> WAIT_TIMEOUT then begin
    Application.Initialize;
    Application.Title := 'Screen Recorder';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmOption, frmOption);
  Application.CreateForm(TfrmFilterEffects, frmFilterEffects);
  Application.Run;
    end
  else begin
    ShowMessage('This program already run in memory.');
    end;
end.
