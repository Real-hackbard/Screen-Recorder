unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScrCam, ExtCtrls, ComCtrls, XPMan, Buttons, ShellApi,
  jpeg, Spin, IniFiles;

{$WARNINGS OFF}
{$HINTS OFF}
{$RANGECHECKS OFF}

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Progress: TProgressBar;
    SaveDialog: TSaveDialog;
    ScrCamera: TScreenCamera;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    CheckBox10: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox1: TCheckBox;
    RegSelect: TRadioGroup;
    Label14: TLabel;
    ComboBox4: TComboBox;
    ComboBox1: TComboBox;
    Label10: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    UpDownTop: TUpDown;
    Label3: TLabel;
    Edit2: TEdit;
    UpDownLeft: TUpDown;
    Edit3: TEdit;
    UpDownWidth: TUpDown;
    Label4: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    UpDownHeight: TUpDown;
    Label13: TLabel;
    ComboBox3: TComboBox;
    TabSheet4: TTabSheet;
    CheckBox7: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton8: TSpeedButton;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Edit9: TEdit;
    UpDown4: TUpDown;
    CheckBox8: TCheckBox;
    Image2: TImage;
    Image1: TImage;
    Label25: TLabel;
    StatusBar1: TStatusBar;
    TabSheet5: TTabSheet;
    GroupBox2: TGroupBox;
    VideoCodec: TLabel;
    ElapsedTime: TLabel;
    RealCapturing: TLabel;
    CurrentCaptured: TLabel;
    FramesCaptured: TLabel;
    DropedFrames: TLabel;
    VideoCodecValue: TLabel;
    RealCapturingValue: TLabel;
    CurrentCapturedValue: TLabel;
    FramesCapturedValue: TLabel;
    DropedFramesValue: TLabel;
    ElapsedTimeValue: TLabel;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit5: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Edit6: TEdit;
    UpDown3: TUpDown;
    Edit7: TEdit;
    CheckBox9: TCheckBox;
    Bevel2: TBevel;
    Image3: TImage;
    CheckBox2: TCheckBox;
    Edit10: TEdit;
    Edit11: TEdit;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    Bevel3: TBevel;
    Label26: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    ComboBox2: TComboBox;
    ComboBox6: TComboBox;
    Shape1: TShape;
    Label31: TLabel;
    Label32: TLabel;
    Shape2: TShape;
    SpeedButton6: TSpeedButton;
    Panel3: TPanel;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    SpeedButton7: TSpeedButton;
    Edit8: TEdit;
    GroupBox3: TGroupBox;
    Label15: TLabel;
    Label44: TLabel;
    ComboBox5: TComboBox;
    ComboBox7: TComboBox;
    Label11: TLabel;
    Label12: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure RegSelectClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox7Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure ScrCameraUpdate(Sender: TObject);
    procedure ScrCameraError(Sender: TObject; ErrorMessage: String);
    procedure ScrCameraStart(Sender: TObject);
    procedure ScrCameraStop(Sender: TObject);
    procedure ScrCameraPreview(Sender: TObject; PreviewBitmap: TBitmap;
      Preview, Recording: Boolean);
    procedure ScrCameraSaving(Sender: TObject; Percent: Integer;
      StatusCaption: String; var Continue: Boolean);
    procedure ScrCameraDeleting(Sender: TObject; Percent: Integer;
      StatusCaption: String; var Continue: Boolean);
    procedure ScrCameraOverlay(Sender: TObject; HDCBitmap: HDC; bmpWidth,
      bmpHeight: Integer);
    procedure ScrCameraPause(Sender: TObject);
    procedure ScrCameraResume(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ComboBox5Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure UpDown4Changing(Sender: TObject; var AllowChange: Boolean);
    procedure ComboBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox6DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox6Change(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure CheckBox12Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TimerON : TTimerRecord;
    AllowExit,
    FCancel : Boolean;
    procedure WriteOptions;
    procedure ReadOptions;
  end;

var
  Form1: TForm1;
  TIF : TIniFile;

const
  COLOR_NUM = 15;
  ColorConst: array [0..COLOR_NUM] of TColor = (clBlack,
    clMaroon, clGreen, clOlive, clNavy,
    clPurple, clTeal, clGray, clSilver, clRed,
    clLime, clYellow, clBlue, clFuchsia,
    clAqua, clWhite);
  ColorNames: array [0..COLOR_NUM] of string = ('Black',
    'Maroon', 'Green', 'Olive', 'Navy',
    'Purple', 'Teal', 'Gray', 'Silver', 'Red',
    'Lime', 'Yellow', 'Blue', 'Fuchsia',
    'Aqua', 'White');

implementation

uses OptDlg, FilterEffects;

{$R *.dfm}
function MainDir: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure TForm1.WriteOptions;    // ################### Options Write
var
  OPT : string;
begin
   OPT := 'Options';

   if not DirectoryExists(MainDir + 'Data\Options\')
   then ForceDirectories(MainDir + 'Data\Options\');

   TIF := TIniFile.Create(MainDir + 'Data\Options\Options.ini');
   with TIF do
   begin
    WriteBool(OPT,'RecCursorArea',CheckBox1.Checked);
    WriteBool(OPT,'DrawRectangle',CheckBox3.Checked);
    WriteBool(OPT,'DrawCross',CheckBox4.Checked);
    WriteBool(OPT,'MinimizeApp',CheckBox5.Checked);
    WriteBool(OPT,'RestoreApp',CheckBox6.Checked);
    WriteBool(OPT,'Preview',CheckBox8.Checked);
    WriteBool(OPT,'OverlayDrawing',CheckBox2.Checked);
    WriteBool(OPT,'AddFilter',CheckBox10.Checked);
    WriteBool(OPT,'RecMonitorsAll',CheckBox7.Checked);
    WriteString(OPT,'SelDir',Edit8.Text);
    WriteString(OPT,'RefreshRate',Edit9.Text);
    WriteInteger(OPT,'ColorMode',Combobox3.ItemIndex);
    WriteInteger(OPT,'CurrentMonitor',Combobox4.ItemIndex);
    WriteInteger(OPT,'VideoPriority',Combobox1.ItemIndex);
    WriteInteger(OPT,'CompressMode',Combobox5.ItemIndex);
    WriteBool(OPT,'TimeCapture',CheckBox9.Checked);
    WriteBool(OPT,'ActivMessage1',CheckBox11.Checked);
    WriteString(OPT,'Message',Edit10.Text);
    WriteInteger(OPT,'X1',SpinEdit1.Value);
    WriteInteger(OPT,'Y1',SpinEdit2.Value);
    WriteInteger(OPT,'C1',Combobox2.ItemIndex);
    WriteBool(OPT,'ActivMessage2',CheckBox12.Checked);
    WriteString(OPT,'Message2',Edit11.Text);
    WriteInteger(OPT,'X2',SpinEdit3.Value);
    WriteInteger(OPT,'Y2',SpinEdit4.Value);
    WriteInteger(OPT,'C2',Combobox6.ItemIndex);
    WriteInteger(OPT,'Bitrate',Combobox7.ItemIndex);


   //WriteBool(OPT,'SaveOptions',CheckBox1.Checked);
   //WriteInteger(OPT,'Compress',Combobox1.ItemIndex);
   //WriteInteger(OPT,'Overlay',RadioGroup1.ItemIndex);
    Free;
   end;
end;

procedure TForm1.ReadOptions;    // ################### Options Read
var OPT:string;
begin
  OPT := 'Options';
  if FileExists(MainDir + 'Data\Options\Options.ini') then
  begin
  TIF:=TIniFile.Create(MainDir + 'Data\Options\Options.ini');
  with TIF do
  begin
    CheckBox1.Checked:=ReadBool(OPT,'RecCursorArea',CheckBox1.Checked);
    CheckBox3.Checked:=ReadBool(OPT,'DrawRectangle',CheckBox3.Checked);
    CheckBox4.Checked:=ReadBool(OPT,'DrawCross',CheckBox4.Checked);
    CheckBox5.Checked:=ReadBool(OPT,'MinimizeApp',CheckBox5.Checked);
    CheckBox6.Checked:=ReadBool(OPT,'RestoreApp',CheckBox6.Checked);
    CheckBox8.Checked:=ReadBool(OPT,'Preview',CheckBox8.Checked);
    CheckBox2.Checked:=ReadBool(OPT,'OverlayDrawing',CheckBox2.Checked);
    CheckBox10.Checked:=ReadBool(OPT,'AddFilter',CheckBox10.Checked);
    CheckBox7.Checked:=ReadBool(OPT,'RecMonitorsAll',CheckBox7.Checked);
    Edit8.Text:=ReadString(OPT,'SelDir',Edit8.Text);
    Edit9.Text:=ReadString(OPT,'RefreshRate',Edit9.Text);
    ComboBox1.ItemIndex:=ReadInteger(OPT,'ColorMode',ComboBox3.ItemIndex);
    ComboBox4.ItemIndex:=ReadInteger(OPT,'CurrentMonitor',ComboBox4.ItemIndex);
    ComboBox1.ItemIndex:=ReadInteger(OPT,'VideoPriority',ComboBox1.ItemIndex);
    ComboBox5.ItemIndex:=ReadInteger(OPT,'CompressMode',ComboBox5.ItemIndex);
    CheckBox9.Checked:=ReadBool(OPT,'TimeCapture',CheckBox9.Checked);
    CheckBox11.Checked:=ReadBool(OPT,'ActivMessage1',CheckBox11.Checked);
    Edit10.Text:=ReadString(OPT,'Message',Edit10.Text);
    SpinEdit1.Value:=ReadInteger(OPT,'X1',SpinEdit1.Value);
    SpinEdit2.Value:=ReadInteger(OPT,'Y1',SpinEdit2.Value);
    ComboBox2.ItemIndex:=ReadInteger(OPT,'C1',ComboBox2.ItemIndex);
    CheckBox12.Checked:=ReadBool(OPT,'ActivMessage2',CheckBox12.Checked);
    Edit11.Text:=ReadString(OPT,'Message2',Edit11.Text);
    SpinEdit3.Value:=ReadInteger(OPT,'X2',SpinEdit3.Value);
    SpinEdit4.Value:=ReadInteger(OPT,'Y2',SpinEdit4.Value);
    ComboBox6.ItemIndex:=ReadInteger(OPT,'C2',ComboBox6.ItemIndex);
    ComboBox7.ItemIndex:=ReadInteger(OPT,'Bitrate',ComboBox7.ItemIndex);


  //CheckBox1.Checked:=ReadBool(OPT,'SaveOptions',CheckBox1.Checked);
  //Combobox1.ItemIndex:=ReadInteger(OPT,'Compress',combobox1.ItemIndex);
  //RadioGroup1.ItemIndex:=ReadInteger(OPT,'Overlay',RadioGroup1.ItemIndex);
  Free;
  end;
  end;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  SpeedButton6.Enabled := false;
  //WriteOptions;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : integer;
begin
  Panel1.DoubleBuffered := true;
  for i := Low(ColorNames) to High(ColorNames) do ComboBox2.Items.Add(ColorNames[i]);
  for i := Low(ColorNames) to High(ColorNames) do ComboBox6.Items.Add(ColorNames[i]);

  AllowExit := True;
  FCancel   := False;

  if CheckBox8.Checked = true then
  begin
    RegSelectClick(Self);
    ScrCamera.ShowPreview := CheckBox8.Checked;
  end;

  Image3.Picture.Bitmap.LoadFromFile(MainDir + 'Data\myLogo\Logo.bmp');

  if Edit8.Text = '' then
  begin
    Edit8.Text := MainDir + 'Data\Record\Video.avi';
  end;

  

  Application.ProcessMessages;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then
  begin
    CheckBox3.Enabled := true;
    CheckBox4.Enabled := true;
  end else begin
    CheckBox3.Enabled := false;
    CheckBox4.Enabled := false;
  end;

  SpeedButton6.Enabled := true;
  ScrCamera.RecordCursor := CheckBox1.Checked;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
  ScrCamera.DrawAreaCapture := CheckBox3.Checked;
end;                              

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
  ScrCamera.LineRectClear := CheckBox4.Checked;
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
  ScrCamera.MinimizeAppOnStart := CheckBox5.Checked;
end;

procedure TForm1.CheckBox6Click(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
  ScrCamera.RestoreAppOnStop := CheckBox6.Checked;
end;

procedure TForm1.CheckBox8Click(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
  RegSelectClick(Self);
  ScrCamera.ShowPreview := CheckBox8.Checked;
end;

procedure TForm1.CheckBox9Click(Sender: TObject);
begin
  TimerON.TimerON    := CheckBox9.Checked;
  TimerON.Hour       := StrToInt(Edit5.Text);
  TimerON.Min        := StrToInt(Edit6.Text);
  TimerON.Sec        := StrToInt(Edit7.Text);
  ScrCamera.SetTimer := TimerON;
  if CheckBox9.Checked then begin
    Label6.Enabled  := True;
    Label7.Enabled  := True;
    Label8.Enabled  := True;
    Edit5.Enabled   := True;
    UpDown1.Enabled := True;
    Edit6.Enabled   := True;
    UpDown2.Enabled := True;
    Edit7.Enabled   := True;
    UpDown3.Enabled := True;
  end else begin
    Label6.Enabled  := False;
    Label7.Enabled  := False;
    Label8.Enabled  := False;
    Edit5.Enabled   := False;
    UpDown1.Enabled := False;
    Edit6.Enabled   := False;
    UpDown2.Enabled := False;
    Edit7.Enabled   := False;
    UpDown3.Enabled := False;
  end;
    SpeedButton6.Enabled := true;
end;

procedure TForm1.Edit5Change(Sender: TObject);
begin
  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  TimerON.TimerON    := CheckBox9.Checked;
  TimerON.Hour       := StrToInt(Edit5.Text);
  TimerON.Min        := StrToInt(Edit6.Text);
  TimerON.Sec        := StrToInt(Edit7.Text);
  ScrCamera.SetTimer := TimerON;
end;

procedure TForm1.RegSelectClick(Sender: TObject);
begin
  if not ScrCamera.IsRecording then begin
    ScrCamera.VideoPriority := TThreadPriority(ComboBox1.ItemIndex);
    case ComboBox3.ItemIndex of
      0: ScrCamera.Colors := pf8bit;
      1: ScrCamera.Colors := pf16bit;
      2: ScrCamera.Colors := pf24bit;
      3: ScrCamera.Colors := pf32bit;
    end;
    ScrCamera.RecordType         := TTypeRecord(ComboBox5.ItemIndex);
    ScrCamera.RecordCursor       := CheckBox1.Checked;
    ScrCamera.OvelayDrawing      := CheckBox2.Checked;
    ScrCamera.DrawAreaCapture    := CheckBox3.Checked;
    ScrCamera.LineRectClear      := CheckBox4.Checked;
    ScrCamera.MinimizeAppOnStart := CheckBox5.Checked;
    ScrCamera.RestoreAppOnStop   := CheckBox6.Checked;
    ScrCamera.RecordAllMonitors  := CheckBox7.Checked;
    ScrCamera.ShowPreview        := CheckBox8.Checked;
    ScrCamera.EffectToOvelayDraw := CheckBox10.Checked;

    TimerON.TimerON    := CheckBox9.Checked;
    TimerON.Hour       := StrToInt(Edit5.Text);
    TimerON.Min        := StrToInt(Edit6.Text);
    TimerON.Sec        := StrToInt(Edit7.Text);
    ScrCamera.SetTimer := TimerON;

    case RegSelect.ItemIndex of
      0: begin
           Edit1.Enabled := False;
           Edit2.Enabled := False;
           Edit3.Enabled := False;
           Edit4.Enabled := False;
           CheckBox3.Enabled := True;
           CheckBox4.Enabled := True;
           ScrCamera.ScreenArea.ScreenRegion := SelObject;
         end;
      1: begin
           Edit1.Enabled := False;
           Edit2.Enabled := False;
           Edit3.Enabled := False;
           Edit4.Enabled := False;
           CheckBox3.Enabled := True;
           CheckBox4.Enabled := True;
           ScrCamera.ScreenArea.ScreenRegion := FreeHand;
         end;
      2: begin
           ScrCamera.ScreenArea.ScreenTop    := StrToInt(Edit1.Text);
           ScrCamera.ScreenArea.ScreenLeft   := StrToInt(Edit2.Text);
           ScrCamera.ScreenArea.ScreenWidth  := StrToInt(Edit3.Text);
           ScrCamera.ScreenArea.ScreenHeight := StrToInt(Edit4.Text);
           Edit1.Enabled := False;
           Edit2.Enabled := False;
           Edit3.Enabled := True;
           Edit4.Enabled := True;
           CheckBox3.Enabled := True;
           CheckBox4.Enabled := True;
           ScrCamera.ScreenArea.ScreenRegion := FixedMoving;
         end;
      3: begin
           ScrCamera.ScreenArea.ScreenTop    := StrToInt(Edit1.Text);
           ScrCamera.ScreenArea.ScreenLeft   := StrToInt(Edit2.Text);
           ScrCamera.ScreenArea.ScreenWidth  := StrToInt(Edit3.Text);
           ScrCamera.ScreenArea.ScreenHeight := StrToInt(Edit4.Text);
           Edit1.Enabled := True;
           Edit2.Enabled := True;
           Edit3.Enabled := True;
           Edit4.Enabled := True;
           CheckBox3.Enabled := True;
           CheckBox4.Enabled := True;
           ScrCamera.ScreenArea.ScreenRegion := FixedStable;
         end;
      4: begin
           Edit1.Text := IntToStr(ScrCamera.ScreenArea.ScreenTop);
           Edit2.Text := IntToStr(ScrCamera.ScreenArea.ScreenLeft);
           Edit3.Text := IntToStr(ScrCamera.ScreenArea.ScreenWidth);
           Edit4.Text := IntToStr(ScrCamera.ScreenArea.ScreenHeight);
           Edit1.Enabled := False;
           Edit2.Enabled := False;
           Edit3.Enabled := False;
           Edit4.Enabled := False;
           CheckBox3.Enabled := False;
           CheckBox4.Enabled := False;
           ScrCamera.SetSizeFullScreen;
           ScrCamera.ScreenArea.ScreenRegion := FullScreen;
         end;
    end;
    UpDownTop.Enabled    := Edit1.Enabled;
    UpDownLeft.Enabled   := Edit2.Enabled;
    UpDownWidth.Enabled  := Edit3.Enabled;
    UpDownHeight.Enabled := Edit4.Enabled;
    end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  ScrCamera.VideoPriority := TThreadPriority(ComboBox1.ItemIndex);
  SpeedButton6.Enabled := true;
end;

procedure TForm1.Edit1Change(Sender: TObject);
var  W, H: Integer;
begin
  ScrCamera.GetMinimumScreenSize(W, H);
  UpDownTop.Min    := H;
  UpDownLeft.Min   := W;
  UpDownWidth.Min  := W;
  UpDownHeight.Min := H;

  ScrCamera.GetMaximumScreenSize(W, H);
  UpDownTop.Max    := H;
  UpDownLeft.Max   := W;
  UpDownWidth.Max  := W;
  UpDownHeight.Max := H;

  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  if StrToInt(Edit1.Text) > UpDownTop.Max then
    Edit1.Text := IntToStr(UpDownTop.Max);

  ScrCamera.ScreenArea.ScreenTop := StrToInt(Edit1.Text);

  if not CheckBox8.Checked then
    RegSelectClick(Self);
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Sender is TEdit then
    begin
      if Key in [#8, '0'..'9'] then
         Exit;
      Key := #0;
    end;
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
begin
  case ComboBox3.ItemIndex of
    0: ScrCamera.Colors := pf8bit;
    1: ScrCamera.Colors := pf16bit;
    2: ScrCamera.Colors := pf24bit;
    3: ScrCamera.Colors := pf32bit;
  end;  SpeedButton6.Enabled := true;
end;

procedure TForm1.Edit2Change(Sender: TObject);
var
  W, H: Integer;
begin
  ScrCamera.GetMinimumScreenSize(W, H);
  UpDownTop.Min    := H;
  UpDownLeft.Min   := W;
  UpDownWidth.Min  := W;
  UpDownHeight.Min := H;

  ScrCamera.GetMaximumScreenSize(W, H);
  UpDownTop.Max    := H;
  UpDownLeft.Max   := W;
  UpDownWidth.Max  := W;
  UpDownHeight.Max := H;

  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  if StrToInt(Edit2.Text) > UpDownLeft.Max then
    Edit2.Text := IntToStr(UpDownLeft.Max);

  ScrCamera.ScreenArea.ScreenLeft := StrToInt(Edit2.Text);

  if not CheckBox8.Checked then
    RegSelectClick(Self);
end;

procedure TForm1.Edit3Change(Sender: TObject);
var
  W, H: Integer;
begin
  ScrCamera.GetMinimumScreenSize(W, H);
  UpDownTop.Min    := H;
  UpDownLeft.Min   := W;
  UpDownWidth.Min  := W;
  UpDownHeight.Min := H;

  ScrCamera.GetMaximumScreenSize(W, H);
  UpDownTop.Max    := H;
  UpDownLeft.Max   := W;
  UpDownWidth.Max  := W;
  UpDownHeight.Max := H;

  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  if StrToInt(Edit3.Text) > UpDownWidth.Max then
    Edit3.Text := IntToStr(UpDownWidth.Max);

  ScrCamera.ScreenArea.ScreenWidth := StrToInt(Edit3.Text);

  if not CheckBox8.Checked then
    RegSelectClick(Self);
end;

procedure TForm1.Edit4Change(Sender: TObject);
var
  W, H: Integer;
begin
  ScrCamera.GetMinimumScreenSize(W, H);
  UpDownTop.Min    := H;
  UpDownLeft.Min   := W;
  UpDownWidth.Min  := W;
  UpDownHeight.Min := H;

  ScrCamera.GetMaximumScreenSize(W, H);
  UpDownTop.Max    := H;
  UpDownLeft.Max   := W;
  UpDownWidth.Max  := W;
  UpDownHeight.Max := H;

  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  if StrToInt(Edit4.Text) > UpDownHeight.Max then
    Edit4.Text := IntToStr(UpDownHeight.Max);

  ScrCamera.ScreenArea.ScreenHeight := StrToInt(Edit4.Text);

  if not CheckBox8.Checked then
    RegSelectClick(Self);
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked = true then
  begin
  CheckBox11.Enabled := true; CheckBox12.Enabled := true;
  StatusBar1.Panels[11].Text := 'Activated';
  end else begin
  CheckBox11.Enabled := false; CheckBox12.Enabled := false;
  CheckBox11.Checked := false; CheckBox12.Checked := false;
  StatusBar1.Panels[11].Text := 'Dactivated';
  end;

  SpeedButton6.Enabled := true;
  ScrCamera.OvelayDrawing := CheckBox2.Checked;
end;

procedure TForm1.Edit9Change(Sender: TObject);
begin
  if TEdit(Sender).Text = '' then TEdit(Sender).Text := '0';
  if StrToInt(Edit9.Text) > UpDown4.Max then Edit9.Text := IntToStr(UpDown4.Max);
  ScrCamera.UpdateRate := StrToInt(Edit9.Text);
  SpeedButton6.Enabled := true;
end;

procedure TForm1.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  if Sender is TEdit then
    begin
      if Key in [#8, '0'..'9'] then
         Exit;
      Key := #0;
    end;
end;

procedure TForm1.CheckBox7Click(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
  ScrCamera.RecordAllMonitors := CheckBox7.Checked;
  if not CheckBox7.Checked then begin
    ComboBox4.Enabled := True;
    Label14.Enabled := True;
    end
  else begin
    ComboBox4.Enabled := False;
    Label14.Enabled := False;
    end;
end;

procedure TForm1.ComboBox4Change(Sender: TObject);
begin
  ScrCamera.CurrentMonitor := ComboBox4.ItemIndex + 1;
  SpeedButton6.Enabled := true;
end;

procedure TForm1.ComboBox5Change(Sender: TObject);
begin
  ScrCamera.RecordType := TTypeRecord(ComboBox5.ItemIndex);
  SpeedButton6.Enabled := true;
  if ComboBox5.ItemIndex = 0 then begin
  StatusBar1.Panels[1].Text := 'No'; end else begin
  StatusBar1.Panels[1].Text := 'Yes'; end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  i: Integer;
begin
  ReadOptions;

  for I := 1 to ScrCamera.MonitorsCount do
    ComboBox4.Items.Add(IntToStr(I));
  ComboBox4.ItemIndex := ScrCamera.CurrentMonitor - 1;

  Edit1.Text := '0';
  Edit2.Text := '0';
  Edit3.Text := '300';
  Edit4.Text := '300';
  CheckBox1.OnClick(sender);
  CheckBox3.OnClick(sender);
  CheckBox4.OnClick(sender);
  ComboBox5.OnChange(sender);
  ComboBox7.OnChange(sender);

  StatusBar1.SetFocus;
end;

procedure TForm1.CheckBox10Click(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
  ScrCamera.EffectToOvelayDraw := CheckBox10.Checked;
end;

procedure TForm1.ScrCameraUpdate(Sender: TObject);
begin
  VideoCodecValue.Caption      := Format('%s', [ScrCamera.VideoCodecName]);
  ElapsedTimeValue.Caption     := Format('%s', [ScrCamera.ElapsedTime]);
  StatusBar1.Panels[3].Text    := Format('%s', [ScrCamera.ElapsedTime]);
  RealCapturingValue.Caption   := Format('%f', [ScrCamera.RealCapturingFPS]);
  CurrentCapturedValue.Caption := Format('%f', [ScrCamera.CurrentCapturedFPS]);
  FramesCapturedValue.Caption  := Format('%d', [ScrCamera.CapturedFrames]);
  DropedFramesValue.Caption    := Format('%d', [ScrCamera.DropedFrames]);
end;

procedure TForm1.ScrCameraError(Sender: TObject; ErrorMessage: String);
begin
  MessageBox(Application.MainForm.Handle, PChar(ErrorMessage), 'Error', MB_OK);
end;

procedure TForm1.ScrCameraStart(Sender: TObject);
begin
  ComboBox3.Enabled    := False;
  ComboBox5.Enabled    := False;
  Edit8.Enabled        := False;
  SpeedButton7.Enabled := False;
  SpeedButton1.Enabled := False;
  SpeedButton2.Enabled := True;
  SpeedButton3.Enabled := True;
  SpeedButton4.Enabled := False;
  RegSelect.Enabled    := False;
  Edit1.Enabled        := False;
  Edit2.Enabled        := False;
  Edit3.Enabled        := False;
  Edit4.Enabled        := False;
  UpDownTop.Enabled    := Edit1.Enabled;
  UpDownLeft.Enabled   := Edit2.Enabled;
  UpDownWidth.Enabled  := Edit3.Enabled;
  UpDownHeight.Enabled := Edit4.Enabled;
end;

procedure TForm1.ScrCameraStop(Sender: TObject);
begin
  ComboBox3.Enabled    := True;
  ComboBox5.Enabled    := True;
  Edit8.Enabled        := True;
  SpeedButton7.Enabled := True;
  SpeedButton1.Enabled := True;
  SpeedButton2.Enabled := False;
  SpeedButton3.Enabled := False;
  SpeedButton4.Enabled := True;
  RegSelect.Enabled    := True;
  RegSelectClick(Self);
end;

procedure TForm1.ScrCameraPreview(Sender: TObject; PreviewBitmap: TBitmap;
  Preview, Recording: Boolean);
begin
  if Preview then begin
    if not Recording then begin
      //Label9.Caption := 'Preview... (Cancel=Esc)';
      end
    else begin
      if not ScrCamera.IsPaused then
        //Label9.Caption := 'Recording... (Cancel=Esc)--(Stop=Shift+Esc)--(Pause=Pause Key)'
      else
        //Label9.Caption := 'Paused... (Press pause key to resume)'
      end;
    end
  else begin
    if not Recording then
      //Label9.Caption := 'Preview Off...'
    else
      if not ScrCamera.IsPaused then
        //Label9.Caption := 'Recording... (Cancel=Esc)--(Stop=Shift+Esc)--(Pause=Pause Key)'
      else
        //Label9.Caption := 'Paused... (Press pause key to resume)'
    end;

  if Assigned(PreviewBitmap) then
    Image1.Picture.Assign(PreviewBitmap)
  else
    Image1.Picture.Bitmap := nil;

  Edit1.Text := IntToStr(ScrCamera.ScreenArea.ScreenTop);
  Edit2.Text := IntToStr(ScrCamera.ScreenArea.ScreenLeft);
  Edit3.Text := IntToStr(ScrCamera.ScreenArea.ScreenWidth);
  Edit4.Text := IntToStr(ScrCamera.ScreenArea.ScreenHeight);

  if Preview <> CheckBox8.Checked then
    CheckBox8.Checked := Preview;
end;

procedure TForm1.ScrCameraSaving(Sender: TObject; Percent: Integer;
  StatusCaption: String; var Continue: Boolean);
begin
  Application.ProcessMessages;
  AllowExit := False;
  if not FCancel then begin
    if not SpeedButton8.Enabled then begin
      SpeedButton8.Enabled := True;
      end;
    Progress.Position := Percent;
    if Percent = 100 then begin
      FCancel         := False;
      SpeedButton8.Enabled := False;
      Progress.Position := 0;
      AllowExit       := True;
      end;
    Continue          := True;
    end
  else begin
    FCancel           := False;
    SpeedButton8.Enabled   := False;
    Progress.Position := 0;
    AllowExit         := True;
    Continue          := False;
    end;
end;

procedure TForm1.ScrCameraDeleting(Sender: TObject; Percent: Integer;
  StatusCaption: String; var Continue: Boolean);
begin
  Application.ProcessMessages;
  AllowExit := False;
  if not FCancel then begin
    if not SpeedButton8.Enabled then begin
      SpeedButton8.Enabled := True;
      end;
    Progress.Position := Percent;
    if Percent = 100 then begin
      FCancel         := False;
      SpeedButton8.Enabled := False;
      Progress.Position := 0;
      AllowExit       := True;
      end;
    Continue          := True;
    end
  else begin
    FCancel           := False;
    SpeedButton8.Enabled   := False;
    Progress.Position := 0;
    AllowExit         := True;
    Continue          := False;
    end;
end;

procedure TForm1.ScrCameraOverlay(Sender: TObject; HDCBitmap: HDC; bmpWidth,
  bmpHeight: Integer);
var AppName, Ver    : String; Size   : TSize; Bmp    : TBitmap; Canvas : TCanvas;
begin
  AppName := Edit10.Text;
  Ver     := Edit11.Text;

  SetBkMode(HDCBitmap, TRANSPARENT);
  if CheckBox11.Checked = true then begin
  GetTextExtentPoint32(HDCBitmap, PChar(AppName), Length(AppName), Size);
  SetTextColor(HDCBitmap, ColorToRGB(clBlack));
  TextOut(HDCBitmap, (bmpWidth div SpinEdit1.Value) - (Size.cx div 2) + 1,
                     (bmpHeight div 2) + SpinEdit2.Value + 2, PChar(AppName),
                     Length(AppName));
  SetTextColor(HDCBitmap, ColorToRGB(Shape1.Brush.Color));
  TextOut(HDCBitmap, (bmpWidth div SpinEdit1.Value) - (Size.cx div 2),
                     (bmpHeight div 2) + SpinEdit2.Value , PChar(AppName),
                     Length(AppName));
  end;

  if CheckBox12.Checked = true then begin
  GetTextExtentPoint32(HDCBitmap, PChar(Ver), Length(Ver), Size);
  SetTextColor(HDCBitmap, ColorToRGB(clBlack));
  TextOut(HDCBitmap, (bmpWidth div SpinEdit3.Value) - (Size.cx div 2) + 1,
                     (bmpHeight div 2) + SpinEdit4.Value + 2, PChar(Ver),
                     Length(Ver));
  SetTextColor(HDCBitmap, ColorToRGB(Shape2.Brush.Color));
  TextOut(HDCBitmap, (bmpWidth div SpinEdit3.Value) - (Size.cx div 2),
                     (bmpHeight div 2) + SpinEdit4.Value, PChar(Ver),
                     Length(Ver));
  end;

  // Draw logo trademark over image
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Data\myLogo\Logo.bmp');
    Bmp.Transparent := True;
    Bmp.Canvas.Lock;
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := HDCBitmap;
      Canvas.Lock;
      Canvas.Draw(((bmpWidth div 1) - (Bmp.Width div 1)),
                  ((bmpHeight div 1) - (Bmp.Height)), Bmp);
      Canvas.Unlock; finally Canvas.Free; end; finally
    Bmp.Canvas.Unlock; Bmp.FreeImage; Bmp.Free;
  end;
end;

procedure TForm1.ScrCameraPause(Sender: TObject);
begin
  SpeedButton3.Caption := 'Resume';
end;

procedure TForm1.ScrCameraResume(Sender: TObject);
begin
  SpeedButton3.Caption := 'Pause';
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if AllowExit then
    CanClose := True
  else
    CanClose := False;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   if Edit8.Text = '' then
   begin
    Beep;
    ShowMessage('Select Save Directory !');
    Exit;
   end;

  if Edit8.Text <> '' then
    ScrCamera.StartRecording(Edit8.Text);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if ScrCamera.IsRecording then
    ScrCamera.StopRecording;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  if ScrCamera.IsRecording then
    if not ScrCamera.IsPaused then
      ScrCamera.PauseRecording
    else
      ScrCamera.ResumeRecording;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  frmOption.ShowModal;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
   frmFilterEffects.ShowModal;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteOptions;

  if ScrCamera.ShowPreview then ScrCamera.ShowPreview := False;
  if ScrCamera.IsRecording then
  begin
    AllowExit := False;
    ScrCamera.StopRecording;
    AllowExit := true;
  end;

  ScrCamera.Destroy;
  Application.Terminate;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
  SaveDialog.InitialDir := ExtractFilePath(Edit8.Text);
  SaveDialog.FileName   := Edit8.Text;
  if SaveDialog.Execute then
    Edit8.Text := SaveDialog.FileName;
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
  FCancel := True;
end;

procedure TForm1.UpDown4Changing(Sender: TObject;
var AllowChange: Boolean);
begin
  SpeedButton6.Enabled := true;
end;

procedure TForm1.ComboBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
   with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top,
    ComboBox2.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24, Rect.Top + 15);
  end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
    if ComboBox2.ItemIndex = 0 then begin Shape1.Brush.Color  := clBlack;  end;
    if ComboBox2.ItemIndex = 1 then begin Shape1.Brush.Color  := clMaroon;  end;
    if ComboBox2.ItemIndex = 2 then begin Shape1.Brush.Color  := clGreen;  end;
    if ComboBox2.ItemIndex = 3 then begin Shape1.Brush.Color  := clOlive;  end;
    if ComboBox2.ItemIndex = 4 then begin Shape1.Brush.Color  := clNavy;  end;
    if ComboBox2.ItemIndex = 5 then begin Shape1.Brush.Color  := clPurple;  end;
    if ComboBox2.ItemIndex = 6 then begin Shape1.Brush.Color  := clTeal;  end;
    if ComboBox2.ItemIndex = 7 then begin Shape1.Brush.Color  := clGray;  end;
    if ComboBox2.ItemIndex = 8 then begin Shape1.Brush.Color  := clSilver;  end;
    if ComboBox2.ItemIndex = 9 then begin Shape1.Brush.Color  := clRed;  end;
    if ComboBox2.ItemIndex = 10 then begin Shape1.Brush.Color  := clLime;  end;
    if ComboBox2.ItemIndex = 11 then begin Shape1.Brush.Color  := clYellow;  end;
    if ComboBox2.ItemIndex = 12 then begin Shape1.Brush.Color  := clBlue;  end;
    if ComboBox2.ItemIndex = 13 then begin Shape1.Brush.Color  := clFuchsia;  end;
    if ComboBox2.ItemIndex = 14 then begin Shape1.Brush.Color  := clAqua;  end;
    if ComboBox2.ItemIndex = 15 then begin Shape1.Brush.Color  := clWhite;  end;
    SpeedButton6.Enabled := true;
end;

procedure TForm1.ComboBox6DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top,
    ComboBox6.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24, Rect.Top + 15);
  end;
end;

procedure TForm1.ComboBox6Change(Sender: TObject);
begin
    if ComboBox6.ItemIndex = 0 then begin Shape2.Brush.Color  := clBlack;  end;
    if ComboBox6.ItemIndex = 1 then begin Shape2.Brush.Color  := clMaroon;  end;
    if ComboBox6.ItemIndex = 2 then begin Shape2.Brush.Color  := clGreen;  end;
    if ComboBox6.ItemIndex = 3 then begin Shape2.Brush.Color  := clOlive;  end;
    if ComboBox6.ItemIndex = 4 then begin Shape2.Brush.Color  := clNavy;  end;
    if ComboBox6.ItemIndex = 5 then begin Shape2.Brush.Color  := clPurple;  end;
    if ComboBox6.ItemIndex = 6 then begin Shape2.Brush.Color  := clTeal;  end;
    if ComboBox6.ItemIndex = 7 then begin Shape2.Brush.Color  := clGray;  end;
    if ComboBox6.ItemIndex = 8 then begin Shape2.Brush.Color  := clSilver;  end;
    if ComboBox6.ItemIndex = 9 then begin Shape2.Brush.Color  := clRed;  end;
    if ComboBox6.ItemIndex = 10 then begin Shape2.Brush.Color  := clLime;  end;
    if ComboBox6.ItemIndex = 11 then begin Shape2.Brush.Color  := clYellow;  end;
    if ComboBox6.ItemIndex = 12 then begin Shape2.Brush.Color  := clBlue;  end;
    if ComboBox6.ItemIndex = 13 then begin Shape2.Brush.Color  := clFuchsia;  end;
    if ComboBox6.ItemIndex = 14 then begin Shape2.Brush.Color  := clAqua;  end;
    if ComboBox6.ItemIndex = 15 then begin Shape2.Brush.Color  := clWhite;  end;
    SpeedButton6.Enabled := true;
end;

procedure TForm1.CheckBox11Click(Sender: TObject);
begin
  if CheckBox11.Checked = true then begin
    Edit10.Enabled := true;
    ComboBox2.Enabled := true;
    Label27.Enabled := true;
    Label28.Enabled := true;
    Label31.Enabled := true;
    SpinEdit1.Enabled := true;
    SpinEdit2.Enabled := true;
  end else begin
    Edit10.Enabled := false;
    ComboBox2.Enabled := false;
    Label27.Enabled := false;
    Label28.Enabled := false;
    Label31.Enabled := false;
    SpinEdit1.Enabled := false;
    SpinEdit2.Enabled := false;
  end;
  SpeedButton6.Enabled := true;
end;

procedure TForm1.CheckBox12Click(Sender: TObject);
begin
   if CheckBox12.Checked = true then begin
     Edit11.Enabled := true;
     ComboBox6.Enabled := true;
     Label29.Enabled := true;
     Label30.Enabled := true;
     Label32.Enabled := true;
     SpinEdit3.Enabled := true;
     SpinEdit4.Enabled := true;
   end else begin
     Edit11.Enabled := false;
     ComboBox6.Enabled := false;
     Label29.Enabled := false;
     Label30.Enabled := false;
     Label32.Enabled := false;
     SpinEdit3.Enabled := false;
     SpinEdit4.Enabled := false;
   end;
   SpeedButton6.Enabled := true;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
   SpeedButton6.Enabled := true;
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
   SpeedButton6.Enabled := true;
end;

procedure TForm1.Edit10Change(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
end;

procedure TForm1.Edit11Change(Sender: TObject);
begin
   SpeedButton6.Enabled := true;
end;

procedure TForm1.SpinEdit3Change(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
end;

procedure TForm1.SpinEdit4Change(Sender: TObject);
begin
  SpeedButton6.Enabled := true;
end;

procedure TForm1.ComboBox7Change(Sender: TObject);
begin
  ScrCamera.CompressionQuality := ComboBox7.ItemIndex;
  SpeedButton6.Enabled := true;
end;

end.
