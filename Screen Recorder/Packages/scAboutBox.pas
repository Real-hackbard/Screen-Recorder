unit scAboutBox;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmAbout = class(TForm)
    Image1: TImage;
    ButtonOk: TButton;
    lbComponentName: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbVersion: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label7: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowAbout(ComponentName: String; Version: String);
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.ShowAbout(ComponentName: String; Version: String);
begin
  lbComponentName.Caption := ComponentName;
  lbVersion.Caption := Version;
  ShowModal;
end;

end.
