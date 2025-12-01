unit FilterEffects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ScrCam, IniFiles;

type
  TfrmFilterEffects = class(TForm)
    BrightnessBox: TGroupBox;
    BrightnessTrackBar: TTrackBar;
    BrightnessLabel: TLabel;
    ContrastBox: TGroupBox;
    ContrastLabel: TLabel;
    ContrastTrackBar: TTrackBar;
    ColorAdjustingBox: TGroupBox;
    DarknessLabel: TLabel;
    DarknessTrackBar: TTrackBar;
    SaturationBox: TGroupBox;
    SaturationLabel: TLabel;
    SaturationTrackBar: TTrackBar;
    SolarizeBox: TGroupBox;
    NoiseLabel: TLabel;
    NoiseTrackBar: TTrackBar;
    ScreenRotation: TRadioGroup;
    OkBtn: TButton;
    UseBrightnessEffect: TCheckBox;
    UseContrastEffect: TCheckBox;
    UseDarknessEffect: TCheckBox;
    UseSaturationEffect: TCheckBox;
    UseColorNoiseEffect: TCheckBox;
    UseScreenRotation: TCheckBox;
    DefaultValueBtn: TButton;
    UseMonoNoiseEffect: TCheckBox;
    GroupBox1: TGroupBox;
    PosterizeLabel: TLabel;
    PosterizeTrackBar: TTrackBar;
    UsePosterizeEffect: TCheckBox;
    GroupBox2: TGroupBox;
    RedLabel: TLabel;
    RedValueTrackBar: TTrackBar;
    UseColorAdjustEffect: TCheckBox;
    GreenValueTrackBar: TTrackBar;
    BlueValueTrackBar: TTrackBar;
    GreenLabel: TLabel;
    BlueLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    StatusBar1: TStatusBar;
    GroupBox3: TGroupBox;
    CheckGrayScale: TCheckBox;
    CheckSepia: TCheckBox;
    CheckReverseColor: TCheckBox;
    procedure CheckGrayScaleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure UseBrightnessEffectClick(Sender: TObject);
    procedure BrightnessTrackBarChange(Sender: TObject);
    procedure ContrastTrackBarChange(Sender: TObject);
    procedure DarknessTrackBarChange(Sender: TObject);
    procedure SaturationTrackBarChange(Sender: TObject);
    procedure NoiseTrackBarChange(Sender: TObject);
    procedure UseContrastEffectClick(Sender: TObject);
    procedure UseDarknessEffectClick(Sender: TObject);
    procedure UseSaturationEffectClick(Sender: TObject);
    procedure UseColorNoiseEffectClick(Sender: TObject);
    procedure UseScreenRotationClick(Sender: TObject);
    procedure ScreenRotationClick(Sender: TObject);
    procedure DefaultValueBtnClick(Sender: TObject);
    procedure UseMonoNoiseEffectClick(Sender: TObject);
    procedure PosterizeTrackBarChange(Sender: TObject);
    procedure UsePosterizeEffectClick(Sender: TObject);
    procedure UseColorAdjustEffectClick(Sender: TObject);
    procedure RedValueTrackBarChange(Sender: TObject);
    procedure GreenValueTrackBarChange(Sender: TObject);
    procedure BlueValueTrackBarChange(Sender: TObject);
    procedure CheckSepiaClick(Sender: TObject);
    procedure CheckReverseColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure WriteOptions;
    procedure ReadOptions;
  end;

var
  frmFilterEffects: TfrmFilterEffects;
  TIF : TIniFile;

implementation

uses Unit1;

{$R *.dfm}
function MainDir: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure TfrmFilterEffects.WriteOptions;    // ################### Options Write
var
  OPT : string;
begin
   OPT := 'Options';

   TIF := TIniFile.Create(MainDir + 'Data\Options\OptionsEffects.ini');
   with TIF do
   begin
    WriteBool(OPT,'BrightnessEffect',UseBrightnessEffect.Checked);
    WriteInteger(OPT,'Brightness',BrightnessTrackBar.Position);
    WriteBool(OPT,'ContrastEffect',UseContrastEffect.Checked);
    WriteInteger(OPT,'Contrast',ContrastTrackBar.Position);
    WriteBool(OPT,'DarknessEffect',UseDarknessEffect.Checked);
    WriteInteger(OPT,'Darkness',DarknessTrackBar.Position);
    WriteBool(OPT,'SaturationEffect',UseSaturationEffect.Checked);
    WriteInteger(OPT,'Saturation',SaturationTrackBar.Position);
    WriteBool(OPT,'ColorNoiseEffect',UseColorNoiseEffect.Checked);
    WriteBool(OPT,'MonoNoiseEffect',UseMonoNoiseEffect.Checked);
    WriteInteger(OPT,'Noise',NoiseTrackBar.Position);
    WriteBool(OPT,'PosterizeEffect',UsePosterizeEffect.Checked);
    WriteInteger(OPT,'Posterize',PosterizeTrackBar.Position);
    WriteBool(OPT,'ColorAdjustEffect',UseColorAdjustEffect.Checked);
    WriteBool(OPT,'GrayScale',CheckGrayScale.Checked);
    WriteInteger(OPT,'Red',RedValueTrackBar.Position);
    WriteInteger(OPT,'Green',GreenValueTrackBar.Position);
    WriteInteger(OPT,'Blue',BlueValueTrackBar.Position);
    WriteBool(OPT,'ReverseColor',CheckReverseColor.Checked);
    WriteBool(OPT,'Sepia',CheckSepia.Checked);
    Free;
   end;
end;

procedure TfrmFilterEffects.ReadOptions;    // ################### Options Read
var OPT:string;
begin
  OPT := 'Options';
  if FileExists(MainDir + 'Data\Options\OptionsEffects.ini') then
  begin
  TIF:=TIniFile.Create(MainDir + 'Data\Options\OptionsEffects.ini');
  with TIF do
  begin
    UseBrightnessEffect.Checked:=ReadBool(OPT,'BrightnessEffect',UseBrightnessEffect.Checked);
    BrightnessTrackBar.Position:=ReadInteger(OPT,'Brightness',BrightnessTrackBar.Position);
    UseContrastEffect.Checked:=ReadBool(OPT,'ContrastEffect',UseContrastEffect.Checked);
    ContrastTrackBar.Position:=ReadInteger(OPT,'Contrast',ContrastTrackBar.Position);
    UseDarknessEffect.Checked:=ReadBool(OPT,'DarknessEffect',UseDarknessEffect.Checked);
    DarknessTrackBar.Position:=ReadInteger(OPT,'Darkness',DarknessTrackBar.Position);
    UseSaturationEffect.Checked:=ReadBool(OPT,'SaturationEffect',UseSaturationEffect.Checked);
    SaturationTrackBar.Position:=ReadInteger(OPT,'Saturation',SaturationTrackBar.Position);
    UseColorNoiseEffect.Checked:=ReadBool(OPT,'ColorNoiseEffect',UseColorNoiseEffect.Checked);
    UseMonoNoiseEffect.Checked:=ReadBool(OPT,'MonoNoiseEffect',UseMonoNoiseEffect.Checked);
    NoiseTrackBar.Position:=ReadInteger(OPT,'Noise',NoiseTrackBar.Position);
    UsePosterizeEffect.Checked:=ReadBool(OPT,'PosterizeEffect',UsePosterizeEffect.Checked);
    PosterizeTrackBar.Position:=ReadInteger(OPT,'Posterize',PosterizeTrackBar.Position);
    UseColorAdjustEffect.Checked:=ReadBool(OPT,'ColorAdjustEffect',UseColorAdjustEffect.Checked);
    CheckGrayScale.Checked:=ReadBool(OPT,'GrayScale',CheckGrayScale.Checked);
    RedValueTrackBar.Position:=ReadInteger(OPT,'Red',RedValueTrackBar.Position);
    GreenValueTrackBar.Position:=ReadInteger(OPT,'Green',GreenValueTrackBar.Position);
    BlueValueTrackBar.Position:=ReadInteger(OPT,'Blue',BlueValueTrackBar.Position);
    CheckReverseColor.Checked:=ReadBool(OPT,'ReverseColor',CheckReverseColor.Checked);
    CheckSepia.Checked:=ReadBool(OPT,'Sepia',CheckSepia.Checked);
    Free;
  end;
  end;
end;

procedure TfrmFilterEffects.Button1Click(Sender: TObject);
begin
  WriteOptions;
  Button1.Enabled := false;
  StatusBar1.Panels[0].Text := 'Settings saved done..';
end;

procedure TfrmFilterEffects.CheckSepiaClick(Sender: TObject);
begin
  if CheckSepia.Checked then
  begin
    CheckGrayScale.Checked := False;
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseSepia];
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseSepia];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.CheckReverseColorClick(Sender: TObject);
begin
  if CheckReverseColor.Checked then  begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseReverseColor];
  end else begin 
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseReverseColor];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.CheckGrayScaleClick(Sender: TObject);
begin
  if CheckGrayScale.Checked then begin
    CheckSepia.Checked := False;
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseGrayScale];
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseGrayScale];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.FormShow(Sender: TObject);
begin
  ReadOptions;

  UseBrightnessEffect.Checked     := UseBrightness in Form1.ScrCamera.UseFilters;
  BrightnessTrackBar.Position     := Form1.ScrCamera.FilterValues.ValueBrightness;
  BrightnessLabel.Caption         := IntToStr(Form1.ScrCamera.FilterValues.ValueBrightness);

  UseContrastEffect.Checked       := UseContrast in Form1.ScrCamera.UseFilters;
  ContrastTrackBar.Position       := Form1.ScrCamera.FilterValues.ValueContrast;
  ContrastLabel.Caption           := IntToStr(Form1.ScrCamera.FilterValues.ValueContrast);

  UseDarknessEffect.Checked       := UseDarkness in Form1.ScrCamera.UseFilters;
  DarknessTrackBar.Position       := Form1.ScrCamera.FilterValues.ValueContrast;
  DarknessLabel.Caption           := IntToStr(Form1.ScrCamera.FilterValues.ValueContrast);

  UseSaturationEffect.Checked     := UseSaturation in Form1.ScrCamera.UseFilters;
  SaturationTrackBar.Position     := Form1.ScrCamera.FilterValues.ValueSaturation;
  SaturationLabel.Caption         := IntToStr(Form1.ScrCamera.FilterValues.ValueSaturation);

  UseColorNoiseEffect.Checked     := UseColorNoise in Form1.ScrCamera.UseFilters;
  UseMonoNoiseEffect.Checked      := UseMonoNoise in Form1.ScrCamera.UseFilters;

  if UseColorNoiseEffect.Checked then
    NoiseTrackBar.Position        := Form1.ScrCamera.FilterValues.ValueColorNoise
  else
    NoiseTrackBar.Position        := Form1.ScrCamera.FilterValues.ValueMonoNoise;

  NoiseLabel.Caption              := IntToStr(NoiseTrackBar.Position);

  UsePosterizeEffect.Checked      := UsePosterize in Form1.ScrCamera.UseFilters;
  PosterizeTrackBar.Position      := Form1.ScrCamera.FilterValues.ValuePosterize;

  UseScreenRotation.Checked       := UseRotateImage in Form1.ScrCamera.UseFilters;

  case Form1.ScrCamera.FilterValues.TypeScreenRotate of
    RLeft       : ScreenRotation.ItemIndex := 0;
    RRight      : ScreenRotation.ItemIndex := 1;
    RReverse    : ScreenRotation.ItemIndex := 2;
    RHorizontal : ScreenRotation.ItemIndex := 3;
    RVertical   : ScreenRotation.ItemIndex := 4;
  end;

  CheckGrayScale.Checked          := UseGrayScale in Form1.ScrCamera.UseFilters;
  CheckSepia.Checked              := UseSepia in Form1.ScrCamera.UseFilters;
  CheckReverseColor.Checked       := UseReverseColor in Form1.ScrCamera.UseFilters;
end;

procedure TfrmFilterEffects.GreenValueTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValueGreenColor := GreenValueTrackBar.Position;
  GreenLabel.Caption := IntToStr(GreenValueTrackBar.Position);
  Button1.Enabled := true; StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.OkBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFilterEffects.PosterizeTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValuePosterize := PosterizeTrackBar.Position;
  PosterizeLabel.Caption := IntToStr(PosterizeTrackBar.Position);
  Button1.Enabled := true; StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.RedValueTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValueRedColor := RedValueTrackBar.Position;
  RedLabel.Caption := IntToStr(RedValueTrackBar.Position);
  Button1.Enabled := true; StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UseBrightnessEffectClick(Sender: TObject);
begin
  if UseBrightnessEffect.Checked then
  begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseBrightness]
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseBrightness];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.BlueValueTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValueBlueColor := BlueValueTrackBar.Position;
  BlueLabel.Caption := IntToStr(BlueValueTrackBar.Position);
  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.BrightnessTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValueBrightness := BrightnessTrackBar.Position;
  BrightnessLabel.Caption := IntToStr(BrightnessTrackBar.Position);
  Button1.Enabled := true; StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.ContrastTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValueContrast := ContrastTrackBar.Position;
  ContrastLabel.Caption := IntToStr(ContrastTrackBar.Position);
  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.DarknessTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValueDarkness := DarknessTrackBar.Position;
  DarknessLabel.Caption := IntToStr(DarknessTrackBar.Position);
  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.SaturationTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValueSaturation := SaturationTrackBar.Position;
  SaturationLabel.Caption := IntToStr(SaturationTrackBar.Position);
  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.NoiseTrackBarChange(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.ValueColorNoise := NoiseTrackBar.Position;
  Form1.ScrCamera.FilterValues.ValueMonoNoise := NoiseTrackBar.Position;
  NoiseLabel.Caption := IntToStr(NoiseTrackBar.Position);
  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UseContrastEffectClick(Sender: TObject);
begin
  if UseContrastEffect.Checked then
  begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseContrast];
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseContrast];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UseDarknessEffectClick(Sender: TObject);
begin
  if UseDarknessEffect.Checked then
  begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseDarkness];
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseDarkness];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UseMonoNoiseEffectClick(Sender: TObject);
begin
  if UseMonoNoiseEffect.Checked then
  begin
    UseColorNoiseEffect.Checked := False;
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseMonoNoise];
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseMonoNoise];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UsePosterizeEffectClick(Sender: TObject);
begin
  if UsePosterizeEffect.Checked then
  begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UsePosterize];
  end else  begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UsePosterize];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UseSaturationEffectClick(Sender: TObject);
begin
  if UseSaturationEffect.Checked then
  begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseSaturation]
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseSaturation];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UseColorAdjustEffectClick(Sender: TObject);
begin
  if UseColorAdjustEffect.Checked then
  begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseColorAdjust];
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseColorAdjust];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UseColorNoiseEffectClick(Sender: TObject);
begin
  if UseColorNoiseEffect.Checked then
  begin
    UseMonoNoiseEffect.Checked := False;
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseColorNoise];
  end else begin
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseColorNoise];
  end;

  Button1.Enabled := true;
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmFilterEffects.UseScreenRotationClick(Sender: TObject);
begin
  if UseScreenRotation.Checked then
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters + [UseRotateImage]
  else
    Form1.ScrCamera.UseFilters := Form1.ScrCamera.UseFilters - [UseRotateImage];
end;

procedure TfrmFilterEffects.ScreenRotationClick(Sender: TObject);
begin
  Form1.ScrCamera.FilterValues.TypeScreenRotate := TScreenRotate(ScreenRotation.ItemIndex);
end;

procedure TfrmFilterEffects.DefaultValueBtnClick(Sender: TObject);
begin
  BrightnessTrackBar.Position  := 0;
  ContrastTrackBar.Position    := 0;
  DarknessTrackBar.Position    := 0;
  SaturationTrackBar.Position  := 255;
  NoiseTrackBar.Position       := 0;
  PosterizeTrackBar.Position   := 1;
  RedValueTrackBar.Position    := 0;
  GreenValueTrackBar.Position  := 0;
  BlueValueTrackBar.Position   := 0;
  ScreenRotation.ItemIndex     := 0;
  UseBrightnessEffect.Checked  := False;
  UseContrastEffect.Checked    := False;
  UseDarknessEffect.Checked    := False;
  UseSaturationEffect.Checked  := False;
  UseColorNoiseEffect.Checked  := False;
  UseMonoNoiseEffect.Checked   := False;
  UsePosterizeEffect.Checked   := False;
  UseColorAdjustEffect.Checked := False;
  UseScreenRotation.Checked    := False;
  CheckGrayScale.Checked       := False;
  CheckSepia.Checked           := False;
  CheckReverseColor.Checked    := False;
end;



end.
