{$I ScrCam.inc}

unit scReg;

interface

procedure Register;

implementation

uses
  // Use professional screen camera units
  scConsts,
  scAboutBox,
  ScrCam,

  // Use delphi standard units
  Classes,
  Forms,
  ToolsAPI,
  SysUtils,
  Graphics,
  {$IFDEF VERSION6}
  DesignIntf,
  DesignEditors;
  {$ELSE}
  dsgnintf;
  {$ENDIF}

type
 { TAboutProperty }
  TscAboutProperty = class(TStringProperty)
    procedure Edit; override;
    function  GetAttributes: TPropertyAttributes; override;
    function  GetValue: String; override;
  end;

// TAboutProperty --------------------------------------------------------------
procedure TscAboutProperty.Edit;
begin
  with TfrmAbout.Create(Application) do
    try
      ShowAbout(isComponentName, 'v' + isVersion + '   ' + isHistory);
    finally
      Free;
    end;
end;

function TscAboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paReadOnly, paDialog];
end;

function TscAboutProperty.GetValue: String;
begin
  Result := isVersion;
end;

// Show splash screen on runing delphi -----------------------------------------
{$IFDEF SPLASH}
{$R PSCLogo.res}
procedure RunSplashScreen;
var
  Bmp : TBitmap;
begin
  Bmp := TBitmap.Create;
  Bmp.LoadFromResourceName(hInstance, 'PSCLogo');
  try
    SplashScreenServices.AddPluginBitmap('Professional Screen Camera (by MRH Software)',
      Bmp.Handle, False, 'Freeware', '(version ' + isVersion + '   ' + isHistory + ')');
  except on E : Exception do
  end;
  Bmp.Free;
end;
{$ENDIF}

// Register all components to delphi IDE ---------------------------------------
procedure Register;
begin
{$IFDEF SPLASH}
  RunSplashScreen;
{$ENDIF}
  RegisterPropertyEditor(
    TypeInfo(String), TScreenCamera, 'About', TscAboutProperty);
  RegisterComponents('Screen Camera', [TScreenCamera]);
end;
//------------------------------------------------------------------------------

end.
