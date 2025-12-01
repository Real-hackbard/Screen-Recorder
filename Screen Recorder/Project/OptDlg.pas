
unit OptDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Unit1, Math, ScrCam;

{$WARNINGS OFF}
{$RANGECHECKS OFF}

type
  TfrmOption = class(TForm)
    Compressor: TGroupBox;
    VideoCompressor: TComboBox;
    VideoQuality: TTrackBar;
    Label1: TLabel;
    LabelQuality: TLabel;
    GroupBox1: TGroupBox;
    ConfigB: TButton;
    Button2: TButton;
    Button3: TButton;
    EditKeyFrames: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    TrackBarRecord: TTrackBar;
    Label4: TLabel;
    Label6: TLabel;
    labelmspFrecord: TLabel;
    AudioFormat: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    AudioVolume: TTrackBar;
    Label10: TLabel;
    AudioInput: TComboBox;
    Label11: TLabel;
    LabelVolume: TLabel;
    Label12: TLabel;
    TrackBarPlayback: TTrackBar;
    Label7: TLabel;
    labelFPSPlayback: TLabel;
    Label5: TLabel;
    Label13: TLabel;
    AutoMode: TCheckBox;
    AudioRecord: TCheckBox;
    Button1: TButton;
    Button4: TButton;
    procedure ConfigBClick(Sender: TObject);
    procedure TrackBarPlaybackChange(Sender: TObject);
    procedure VideoQualityChange(Sender: TObject);
    procedure AudioVolumeChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure AudioInputClick(Sender: TObject);
    procedure TrackBarRecordChange(Sender: TObject);
    procedure AutoModeClick(Sender: TObject);
    procedure AudioRecordClick(Sender: TObject);
    procedure VideoCompressorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshCompressorButtons;
    procedure UpdateAdjustSliderVal;
  public
    { Public declarations }
    Auto: Boolean;
    LmspFRecord,
    LFPSPlayback: Integer;
  end;

var
  frmOption: TfrmOption;

const
  CurrectFPS = 60; 

implementation

{$R *.dfm}
procedure TfrmOption.ConfigBClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := VideoCompressor.ItemIndex;
  Form1.ScrCamera.CompressorConfigure(Idx, WindowHandle);
end;

procedure TfrmOption.RefreshCompressorButtons;
var
  Idx: Integer;
  About, Config: Boolean;
begin
  Idx := VideoCompressor.ItemIndex;
  Form1.ScrCamera.CompressorHasFeatures(Idx, About, Config);
  ConfigB.Enabled := Config;
end;

procedure TfrmOption.UpdateAdjustSliderVal;
begin
  if AutoMode.Checked then
  begin
    LFPSPlayback := TrackBarPlayback.Position;
    TrackBarRecord.Position := 1000 div TrackBarPlayback.Position;
    LmspFRecord  := 1000 div TrackBarPlayback.Position;
  end else begin
    LmspFRecord  := TrackBarRecord.Position;
    LFPSPlayback := TrackBarPlayback.Position;
  end;

  LabelmspfRecord.Caption  := Format('%d Millisecond', [LmspFRecord]);
  LabelFPSPlayback.Caption := Format('%d fps', [LFPSPlayback]);
  LabelQuality.Caption     := IntToStr(VideoQuality.Position);
  LabelVolume.Caption      := IntToStr(AudioVolume.Position);
  Form1.ScrCamera.SetAudioInputVolume(AudioInput.Items[AudioInput.ItemIndex], AudioVolume.Position);
end;

procedure TfrmOption.TrackBarPlaybackChange(Sender: TObject);
begin
  UpdateAdjustSliderVal;
  Form1.StatusBar1.Panels[7].Text := IntToStr(TrackBarPlayback.Position);
end;

procedure TfrmOption.VideoQualityChange(Sender: TObject);
begin
  UpdateAdjustSliderVal;
  Form1.StatusBar1.Panels[9].Text := IntToStr(VideoQuality.Position);
end;

procedure TfrmOption.AudioVolumeChange(Sender: TObject);
begin
  UpdateAdjustSliderVal;
end;

procedure TfrmOption.Button2Click(Sender: TObject);
begin
  UpdateAdjustSliderVal;
  Form1.ScrCamera.SelectedCompressor := VideoCompressor.ItemIndex;
  Form1.ScrCamera.CompressionQuality := VideoQuality.Position * 1000;
  Form1.ScrCamera.KeyFramesEvery     := StrToInt(EditKeyFrames.Text);
  Form1.ScrCamera.Record_MSPF        := LmspFRecord;
  Form1.ScrCamera.PlayBack_FPS       := LFPSPlayback;
  Form1.ScrCamera.UseAudioRecord     := AudioRecord.Checked;
  Form1.ScrCamera.AudioFormatsIndex  := AudioFormat.ItemIndex;
end;

procedure TfrmOption.FormShow(Sender: TObject);
begin
  VideoCompressor.Items.Assign(Form1.ScrCamera.VideoCodecsList);
  AudioFormat.Items.Assign(Form1.ScrCamera.AudioFormatsList);
  AudioInput.Items.Assign(Form1.ScrCamera.AudioInputNames);
  VideoCompressor.ItemIndex := Form1.ScrCamera.SelectedCompressor;
  AudioFormat.ItemIndex := Form1.ScrCamera.AudioFormatsIndex;
  AudioInput.ItemIndex  := Form1.ScrCamera.GetAudioInputIndex;

  if Form1.ScrCamera.GetAudioInfo[AudioInput.ItemIndex].AudioInputEnabled then
  begin
    if AudioRecord.Checked then
    begin
      AudioVolume.Enabled := True;
      LabelVolume.Enabled := True;
    end;

  AudioVolume.Position := Form1.ScrCamera.GetAudioInfo[AudioInput.ItemIndex].AudioInputVolume;
  end else begin
    AudioVolume.Position := 0;
    AudioVolume.Enabled  := False;
    LabelVolume.Enabled  := False;
  end;

  AutoModeClick(Self);
  TrackBarRecord.Position   := Form1.ScrCamera.Record_MSPF;
  TrackBarPlayback.Position := Form1.ScrCamera.PlayBack_FPS;
  EditKeyFrames.Text    := Format('%d', [Form1.ScrCamera.KeyFramesEvery]);
  VideoQuality.Position := Form1.ScrCamera.CompressionQuality div 100;
  RefreshCompressorButtons;
end;

procedure TfrmOption.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmOption.AudioInputClick(Sender: TObject);
begin
  Form1.ScrCamera.AudioInputNames;
  Form1.ScrCamera.SetAudioInput(AudioInput.Items[AudioInput.ItemIndex]);
  if Form1.ScrCamera.GetAudioInfo[AudioInput.ItemIndex].AudioInputEnabled then
  begin
    AudioVolume.Enabled  := True;
    LabelVolume.Enabled  := True;
    AudioVolume.Position := Form1.ScrCamera.GetAudioInfo[AudioInput.ItemIndex].AudioInputVolume;
  end else begin
    AudioVolume.Position := 0;
    AudioVolume.Enabled  := False;
    LabelVolume.Enabled  := False;
  end;
end;

procedure TfrmOption.TrackBarRecordChange(Sender: TObject);
begin
  UpdateAdjustSliderVal;
end;

procedure TfrmOption.AutoModeClick(Sender: TObject);
begin
  if AutoMode.Checked then
  begin
    TrackBarRecord.Enabled := False;
    TrackBarPlayback.Max := CurrectFPS;
  end else begin
    TrackBarRecord.Enabled := True;
    TrackBarPlayback.Max := 1000;
  end;
  Label7.Caption := IntToStr(TrackBarPlayback.Max) + ' fps';
end;

procedure TfrmOption.AudioRecordClick(Sender: TObject);
begin
  if AudioRecord.Checked then
  begin
    Form1.StatusBar1.Panels[5].Text := 'on';
    Label9.Enabled         := True;
    AudioFormat.Enabled    := True;
    Label11.Enabled        := True;
    AudioInput.Enabled     := True;
    Label10.Enabled        := True;

    if Form1.ScrCamera.GetAudioInfo[AudioInput.ItemIndex].AudioInputEnabled then
    begin
      AudioVolume.Enabled  := True;
      LabelVolume.Enabled  := True;
      AudioVolume.Position := Form1.ScrCamera.GetAudioInfo[AudioInput.ItemIndex].AudioInputVolume;
    end else begin
      AudioVolume.Enabled  := False;
      LabelVolume.Enabled  := False;
      AudioVolume.Position := 0;
    end;
  end else
  begin
    Form1.StatusBar1.Panels[5].Text := 'off';
    Label9.Enabled         := False;
    AudioFormat.Enabled    := False;
    Label11.Enabled        := False;
    AudioInput.Enabled     := False;
    Label10.Enabled        := False;
    AudioVolume.Enabled    := False;
    LabelVolume.Enabled    := False;
  end;
end;

procedure TfrmOption.VideoCompressorClick(Sender: TObject);
begin
	RefreshCompressorButtons;
  Form1.StatusBar1.Panels[1].Text := 'yes';
end;

procedure TfrmOption.Button1Click(Sender: TObject);
begin
  VideoCompressor.ItemIndex := 3;
  VideoQuality.Max := 10;
  AudioRecord.Checked := true;
  AudioFormat.ItemIndex := 15;
  AudioVolume.Position := 90;
  //AutoMode.Checked := false;
  //TrackBarRecord.Position := 1;
  //EditKeyFrames.Text := '500';
  TrackBarPlayback.Position := 24;
end;

procedure TfrmOption.Button4Click(Sender: TObject);
begin
  VideoCompressor.ItemIndex := -1;
  VideoQuality.Max := 9;
  AudioRecord.Checked := false;
  AudioFormat.ItemIndex := 2;
  AudioVolume.Position := 90;
  AutoMode.Checked := true;
  TrackBarRecord.Position := 50;
  EditKeyFrames.Text := '300';
  TrackBarPlayback.Position := 30;
end;

end.
