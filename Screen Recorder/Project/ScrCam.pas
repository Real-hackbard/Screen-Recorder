
{$I ScrCam.inc}

{$WARNINGS OFF}
{$HINTS OFF}
{$RANGECHECKS OFF}

unit ScrCam;

interface

uses
  //=======================================
  // Use professional screen camera units
  scVfw,
  scFlashWnd,
  scFreeHandWnd,
  scSelObjWnd,
  scConsts,
  scHighTimer,
  scImageEffects, 
  //=======================================
  scWaveMixer,
  scWaveUtils,
  scWaveRecorders,
  //=======================================
  // Use delphi standard units
  Windows, Messages,
  SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms,
  Dialogs, StdCtrls,
  ExtCtrls, MMSystem,
  Math;
  //=======================================

type
  TSCEvent = procedure(Sender: TObject) of object;

  TSCErrorEvent = procedure(Sender: TObject;
    ErrorMessage: string) of object;

  TPreviewEvent = procedure(Sender: TObject; PreviewBitmap: TBitmap;
    Preview: Boolean; Recording: Boolean) of object;

  TSaveEvent = procedure(Sender: TObject; Percent: Integer;
    StatusCaption: String; var Continue: Boolean) of object;

  TOverlayEvent = procedure(Sender: TObject; HDCBitmap: HDC;
    bmpWidth, bmpHeight: Integer) of object;

  TRecordAVIThread = class;

  TTimerRecord = record
    TimerON : Boolean;
    Hour    : Byte;
    Min     : Byte;
    Sec     : Byte;
  end;

  THMSM = record
    Hour        : Integer;
    Minute      : Integer;
    Second      : Integer;
    MilliSecond : Integer;
  end;

  AudioInfo = record
    AudioInputName    : String;
    AudioInputVolume  : Integer;
    AudioInputEnabled : Boolean;
  end;

  TGetAudioInfo = array of AudioInfo;

  TScreenRegion = (SelObject, FreeHand, FixedMoving, FixedStable, FullScreen);

  TScreenRotate = (RLeft, RRight, RReverse, RHorizontal, RVertical);

  TOperation = (None, Success, Fail);

  TICINFOS = array[0..100] of TICINFO;

  TTypeRecord = (NoCompress, CompressOnFly, CompressAfterRecord);

  TUseFilter = (UseReverseColor, UseGrayScale, UseSepia, UseRotateImage,
                UseColorNoise, UseMonoNoise, UsePosterize, UseColorAdjust,
                UseSaturation, UseDarkness, UseBrightness, UseContrast);
  TUseFilters = set of TUseFilter;

  TScreenArea = class(TPersistent)
  private
    FScreenRegion : TScreenRegion;
    FScreenLeft,
    FScreenTop,
    FScreenWidth,
    FScreenHeight : Integer;
    procedure SetScreenWidth(Value: Integer);
    procedure SetScreenHeight(Value: Integer);
  published
    property ScreenRegion : TScreenRegion read FScreenRegion write FScreenRegion;
    property ScreenLeft   : Integer       read FScreenLeft   write FScreenLeft;
    property ScreenTop    : Integer       read FScreenTop    write FScreenTop;
    property ScreenWidth  : Integer       read FScreenWidth  write SetScreenWidth;
    property ScreenHeight : Integer       read FScreenHeight write SetScreenHeight;
  end;

  TFilterValues = class(TPersistent)
  private
    FColorNoise,
    FMonoNoise,
    FPosterize,
    FRedColor,
    FGreenColor,
    FBlueColor,
    FSaturation,
    FBrightness,
    FDarkness,
    FContrast     : Integer;
    FScreenRotate : TScreenRotate;
    procedure SetFilterValues(Index: Integer; Value: Integer);
  published
    property TypeScreenRotate : TScreenRotate read FScreenRotate write FScreenRotate;
    property ValueColorNoise  : Integer index 0 read FColorNoise write SetFilterValues;
    property ValueMonoNoise   : Integer index 1 read FMonoNoise  write SetFilterValues;
    property ValuePosterize   : Integer index 2 read FPosterize  write SetFilterValues;
    property ValueRedColor    : Integer index 3 read FRedColor   write SetFilterValues;
    property ValueGreenColor  : Integer index 4 read FGreenColor write SetFilterValues;
    property ValueBlueColor   : Integer index 5 read FBlueColor  write SetFilterValues;
    property ValueSaturation  : Integer index 6 read FSaturation write SetFilterValues;
    property ValueDarkness    : Integer index 7 read FDarkness   write SetFilterValues;
    property ValueBrightness  : Integer index 8 read FBrightness write SetFilterValues;
    property ValueContrast    : Integer index 9 read FContrast   write SetFilterValues;
  end;

  TScreenCamera = class(TComponent)
  private
    FCurrentCapturedFPS,
    FRealCapturingFPS     : Extended;
    FourCC,
    CompfccHandler        : DWORD;
    FOnUpdate,
    FOnStart,
    FOnStop,
    FOnPause,
    FOnResume             : TSCEvent;
    FOnError              : TSCErrorEvent;
    FOnPreview            : TPreviewEvent;
    FOnSaving,
    FOnDeleting           : TSaveEvent;
    FOnOverlay            : TOverlayEvent;
    FVideoCompressorInfo  : TICINFOS;
    FFrame                : TFlashingWnd;
    FPreviewTimer         : THighTimer;
    FCursorPos            : TMouse;
    FRecordAVIThread      : TRecordAVIThread;
    nColors               : TPixelFormat;
    Bits,
    MaxXScreen,
    MaxYScreen,
    FComputedFrameNo,
    FActualFrameNo,
    FSkippedFrames,
    FHotKey1,
    FHotKey2,
    FHotKey3,
    FHotKey4,
    FPlaybackFPS,
    FMSPFRecord,
    FKeyFramesEvery,
    FSelectedCompressor,
    FCompressionQuality,
    FAudioFormatsIndex,
    FCurrentMonitor,
    FUpdateRate,
    FVideoCompressorCount,
    FAudioInputIndex      : Integer;
    FPriority             : TThreadPriority;
    FPauseRecording,
    FRecordCursor,
    FAudioRecord,
    FFlashingRect,
    FLineRectClear,
    FMinimize,
    FRestore,
    FShowPreview,
    RecordState,
    FSelectObject,
    FAutoPan,
    FFullScreen,
    FSelCodecRepeat,
    FOvelayDrawing,
    FEffectToOvelayDraw,
    FRecordAllMonitors,
    FOnRecordPreview,
    FFreeHandMode         : Boolean;
    FUseFilters           : TUseFilters;
    FRegColor,
    FRegColor1,
    FRegColor2            : TColor;
    FAudioInputNames,
    FVideoCodecList,
    FAudioFormatList      : TStringList;
    FTimerRecord          : TTimerRecord;
    FAbout,
    FElapsedTime          : String;
    StrCodec              : String;
    FWndHandle            : HWnd;
    FRecordType           : TTypeRecord;
    TempCompressed        : APAVIStream;
    FFilterValues         : TFilterValues;
    FScreenArea           : TScreenArea;
    FAudioInfo            : TGetAudioInfo;
    //..........................................................................
    procedure SetRecordType(Value: TTypeRecord);
    procedure SetCurrentMonitor(Value: Integer);
    procedure SetUseFilters(Value: TUseFilters);
    procedure SetNColors(Value: TPixelFormat);
    procedure SetPriority(Value: TThreadPriority);
    procedure SetInterval(Value: Integer);
    procedure SetUpdateRate(Value: Integer);
    procedure SetScreenArea(Value: TScreenArea);
    procedure SetAllFilterValues(Value: TFilterValues);
    procedure SetQuality(Value: Integer);
    procedure SetRecord_MSPF(Value: Integer);
    procedure SetLineRectClear(Value: Boolean);
    procedure SetShowPreview(Value: Boolean);
    procedure GlobalHotKey(var Msg: TMessage);
    procedure ThreadDone(Sender: TObject);
    procedure FFrameMinimize(Sender: TObject);
    procedure FShowPreviewTimer(Sender: TObject);
    procedure LoadAVIFileToStream(const FileName: WideString;
      var TempAVIStream: PAVIStream);
    procedure SetVersion(Value: String);
    function FinalSaveAvi(const FileName: WideString; nStreams: Integer;
      Streams: APAVISTREAM): Boolean;
    function FFreeHandFrameDraw: Boolean;
    function FSelObjectFrameDraw: Boolean;
    function GetVideoCompressorsInfo: TStringList;
    function GetAudioFormatsInfo: TStringList;
    function GetAudioInputsNames: TStringList;
    function GetMonitorsCount: Integer;
    function GetRecordType: TTypeRecord;
    function GetCurrentMonitor: Integer;
    function GetNColors: TPixelFormat;
    function GetPriority: TThreadPriority;
    function GetInterval: Integer;
    function GetUpdateRate: Integer;
    function GetQuality: Integer;
    function GetRecord_MSPF: Integer;
    function GetLineRectClear: Boolean;
    function GetShowPreview: Boolean;
    function CaptureScreenFrame(Mode: Integer; TempImage: TBitmap;
      Left, Top, Width, Height: Integer; ReverseColor: Boolean): PBitmapInfoHeader;
    function RecordVideo(szFileName: WideString): Integer;
    function HBitmap2DDB(HBitmap: HBitmap; nBits: LongWord): THandle;
    function MilliSecond2Time(TimeAtMillisecond: Extended): THMSM;
    function GetVersion: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowAbout;
    procedure SetAudioInput(InputName: string);
    procedure SetAudioInputVolume(InputName: string; Volume: Integer);
    procedure StopRecording;
    procedure PauseRecording;
    procedure ResumeRecording;
    procedure CompressorHasFeatures(Compressor: Byte;
      var HasAbout: Boolean; var hasConfig: Boolean);
    procedure CompressorAbout(Compressor: Byte; WND: HWND);
    procedure CompressorConfigure(Compressor: Byte; WND: HWND);
    procedure SetSizeFullScreen;
    procedure GetMinimumScreenSize(var W, H: Integer);
    procedure GetMaximumScreenSize(var W, H: Integer);
    function StartRecording(szFileName: String): Boolean;
    // report values (read-only)
    property CapturedFrames     : Integer          read FActualFrameNo;     // Number of captured frames
    property DropedFrames       : Integer          read FSkippedFrames;     // show skipped frames on recording
    property RealCapturingFPS   : Extended         read FRealCapturingFPS;  // Real capturing FPS rate = should be Playback-fps rate on fast machines!
    property CurrentCapturedFPS : Extended         read FCurrentCapturedFPS;// Current captured FPS rate = should be Playback-fps rate on fast machines!
    property ElapsedTime        : String           read FElapsedTime;       // Show elapsed time
    property VideoCodecName     : String           read StrCodec;           // Show used codec name
    property VideoCodecsList    : TStringList      read GetVideoCompressorsInfo; // Get list of video codecs
    property AudioFormatsList   : TStringList      read GetAudioFormatsInfo;// Get of list audio formats
    property AudioInputNames    : TStringList      read GetAudioInputsNames;// Get audio input information

    property IsRecording        : Boolean          read RecordState;        // Test recording state
    property IsPaused           : Boolean          read FPauseRecording;    // Test pause in recording
    property MonitorsCount      : Integer          read GetMonitorsCount;   // Get number of monitors
    // options
    property ShowPreview        : Boolean          read GetShowPreview      write SetShowPreview;
    property AudioFormatsIndex  : Integer          read FAudioFormatsIndex  write FAudioFormatsIndex;
    property GetAudioInputIndex : Integer          read FAudioInputIndex    write FAudioInputIndex; // audio input index
    property GetAudioInfo       : TGetAudioInfo    read FAudioInfo          write FAudioInfo;       // audio input information
  protected
  published
    // options
    property About              : String           read FAbout              write FAbout stored False;
    property PSC_Version        : String           read GetVersion          write SetVersion;
    property RecordType         : TTypeRecord      read GetRecordType       write SetRecordType;
    property CurrentMonitor     : Integer          read GetCurrentMonitor   write SetCurrentMonitor;
    property RecordAllMonitors  : Boolean          read FRecordAllMonitors  write FRecordAllMonitors;
    property UpdateRate         : Integer          read GetUpdateRate       write SetUpdateRate;
    property PlayBack_FPS       : Integer          read GetInterval         write SetInterval;
    property Record_MSPF        : Integer          read GetRecord_MSPF      write SetRecord_MSPF;
    property KeyFramesEvery     : Integer          read FKeyFramesEvery     write FKeyFramesEvery;
    property CompressionQuality : Integer          read GetQuality          write SetQuality;
    property Colors             : TPixelFormat     read GetNColors          write SetNColors;
    property RegionColor1       : TColor           read FRegColor1          write FRegColor1;
    property RegionColor2       : TColor           read FRegColor2          write FRegColor2;
    property SelectedCompressor : Integer          read FSelectedCompressor write FSelectedCompressor;
    property UseAudioRecord     : Boolean          read FAudioRecord        write FAudioRecord;
    property RecordCursor       : Boolean          read FRecordCursor       write FRecordCursor;
    property DrawAreaCapture    : Boolean          read FFlashingRect       write FFlashingRect;
    property LineRectClear      : Boolean          read GetLineRectClear    write SetLineRectClear;
    property MinimizeAppOnStart : Boolean          read FMinimize           write FMinimize;
    property RestoreAppOnStop   : Boolean          read FRestore            write FRestore;
    property VideoPriority      : TThreadPriority  read GetPriority         write SetPriority;
    property SetTimer           : TTimerRecord     read FTimerRecord        write FTimerRecord;
    property OvelayDrawing      : Boolean          read FOvelayDrawing      write FOvelayDrawing;
    property EffectToOvelayDraw : Boolean          read FEffectToOvelayDraw write FEffectToOvelayDraw;

    property ScreenArea         : TScreenArea      read FScreenArea         write SetScreenArea;

    property FilterValues       : TFilterValues    read FFilterValues       write SetAllFilterValues;
    property UseFilters         : TUseFilters      read FUseFilters         write SetUseFilters;
    // events
    property OnError            : TSCErrorEvent    read FOnError            write FOnError;
    property OnUpdate           : TSCEvent         read FOnUpdate           write FOnUpdate;
    property OnStart            : TSCEvent         read FOnStart            write FOnStart;
    property OnStop             : TSCEvent         read FOnStop             write FOnStop;
    property OnPause            : TSCEvent         read FOnPause            write FOnPause;
    property OnResume           : TSCEvent         read FOnResume           write FOnResume;
    property OnPreview          : TPreviewEvent    read FOnPreview          write FOnPreview;
    property OnSaving           : TSaveEvent       read FOnSaving           write FOnSaving;
    property OnDeleting         : TSaveEvent       read FOnDeleting         write FOnDeleting;
    property OnOverlay          : TOverlayEvent    read FOnOverlay          write FOnOverlay;
  end;

  TRecordAVIThread = class(TThread)
  private
    FScrCam: TScreenCamera;
  protected
    procedure Execute; override;
  public
    constructor Create(ScrCam: TScreenCamera);
  end;

implementation

var
  TimeExpended1,
  OldUpdateTime1,
  InitialTime1,
  OldTime1,
  OldTime2         : Extended;
  FSuccess         : TOperation;
  SC               : TScreenCamera;
  TempVideoFile,
  TempAudioFile,
  FFileName        : WideString;
  CancelRecording,
  SavingSuccess,
  StartRegionSel   : Boolean;
  Hur, Min, Sec,
  Mil, X1, Y1,
  X2, Y2           : Integer;

procedure TFilterValues.SetFilterValues(Index: Integer; Value: Integer);
begin
  case Index of
    0:
      if FColorNoise <> Value then
        FColorNoise := Value;
    1:
      if FMonoNoise <> Value then
        FMonoNoise := Value;
    2:
      if FPosterize <> Value then
        FPosterize := Value;
    3:
      if FRedColor <> Value then
        FRedColor := Value;
    4:
      if FGreenColor <> Value then
        FGreenColor := Value;
    5:
      if FBlueColor <> Value then
        FBlueColor := Value;
    6:
      if FSaturation <> Value then
        FSaturation := Value;
    7:
      if FDarkness <> Value then
        FDarkness := Value;
    8:
      if FBrightness <> Value then
        FBrightness := Value;
    9:
      if FContrast <> Value then
        FContrast := Value;
  end;
end;

procedure FreeFrame(var alpbi: PBitmapInfoHeader);
begin
	if alpbi <> nil then begin
//    ZeroMemory(alpbi, SizeOf(TBitmapInfoHeader));
   	GlobalFreePtr(alpbi);
	  alpbi := nil;
    end;
end;

function PowerDeleteFile(FileName: WideString): Boolean;
const
  TryCount = 50;
var
  I         : Integer;
  C         : Boolean;
  OldCursor : TCursor;

  function IsFileInUse(FileName: String): Boolean;
  var
    hFileRes: HFile;
  begin
    Result := False;
    if not FileExists(FileName) then Exit;
    hFileRes := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE, 0,
                           nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    Result := (hFileRes = INVALID_HANDLE_VALUE);
    if not Result then CloseHandle(hFileRes);
  end;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crAppStart;
  C := True;
  if (not IsFileInUse(FileName)) and (FileExists(FileName)) then begin
    I := 1;
    while I <= TryCount do begin
      if FileExists(FileName) then begin
        if Assigned(SC) then begin
          if Assigned(SC.OnDeleting) then
            SC.OnDeleting(SC, I * 2, DeletingMsg, C);
          if not C then begin
            SC.OnDeleting(SC, 100, '', C);
            Result := False;
            Break;
            end;
          end;
        Result := DeleteFile(FileName);
        end
      else begin
        if Assigned(SC) then
          if Assigned(SC.OnDeleting) then
            SC.OnDeleting(SC, 100, '', C);
        Result := True;
        Break;
        end;
      Inc(I);
      end;
    end
  else begin
    I := 1;
    while I <= TryCount do begin
      if FileExists(FileName) then begin
        if Assigned(SC) then begin
          if Assigned(SC.OnDeleting) then
            SC.OnDeleting(SC, I * 2, DeletingMsg, C);
          if not C then begin
            SC.OnDeleting(SC, 100, '', C);
            Result := False;
            Break;
            end;
          end;
        Result := MoveFileEx(PChar(FileName),
                             nil,
                             MOVEFILE_REPLACE_EXISTING or
                             MOVEFILE_DELAY_UNTIL_REBOOT);
        end
      else begin
        if Assigned(SC) then
          if Assigned(SC.OnDeleting) then
            SC.OnDeleting(SC, 100, '', C);
        Result := True;
        Break;
        end;
      Inc(I);
      end;
    end;
  Screen.Cursor := OldCursor;
end;

function TScreenCamera.MilliSecond2Time(TimeAtMillisecond: Extended): THMSM;
var
  HMSM : THMSM;
  S1,
  S2   : String;
begin
  HMSM.Hour   := ABS(Trunc(TimeAtMillisecond / 3600000));
  HMSM.Minute := ABS(Trunc((TimeAtMillisecond - (HMSM.Hour * 3600000)) / 60000));
  HMSM.Second := ABS(Trunc((TimeAtMillisecond -
                          ((HMSM.Hour * 3600000) +
                           (HMSM.Minute * 60000))) / 1000));
  S1 := FloatToStr(Frac(ABS((TimeAtMillisecond -
                           ((HMSM.Hour * 3600000) +
                            (HMSM.Minute * 60000))) / 1000)));
  if Pos('0.', S1) <> 0 then begin
    Delete(S1, Pos('0.', S1), 2);
    S2 := Copy(S1, 1, 3);
    HMSM.MilliSecond := StrToInt(S2);
    end
  else
    HMSM.MilliSecond := 0;
  Result := HMSM;
end;

//---------------------------------------------------

procedure TScreenCamera.GetMinimumScreenSize(var W, H: Integer);
begin
  if FRecordAllMonitors then begin
    W := Screen.DesktopLeft;
    H := Screen.DesktopTop;
    end
  else begin
    W := Screen.Monitors[FCurrentMonitor - 1].Left;
    H := Screen.Monitors[FCurrentMonitor - 1].Top;
    end;
end;

//---------------------------------------------------

procedure TScreenCamera.GetMaximumScreenSize(var W, H: Integer);
begin
  if FRecordAllMonitors then begin
    W := Screen.DesktopWidth;
    H := Screen.DesktopHeight;
    end
  else begin
    W := Screen.Monitors[FCurrentMonitor - 1].Width;
    H := Screen.Monitors[FCurrentMonitor - 1].Height;
    end;
end;

//---------------------------------------------------

procedure TScreenCamera.SetSizeFullScreen;
begin
  if FRecordAllMonitors then begin
    FScreenArea.FScreenLeft := Screen.DesktopLeft;
    FScreenArea.FScreenTop  := Screen.DesktopTop;
    FScreenArea.SetScreenWidth(Screen.DesktopWidth);
    FScreenArea.SetScreenHeight(Screen.DesktopHeight);
    end
  else begin
    FScreenArea.FScreenLeft := Screen.Monitors[FCurrentMonitor - 1].Left;
    FScreenArea.FScreenTop  := Screen.Monitors[FCurrentMonitor - 1].Top;
    FScreenArea.SetScreenWidth(Screen.Monitors[FCurrentMonitor - 1].Left +
                               Screen.Monitors[FCurrentMonitor - 1].Width);
    FScreenArea.SetScreenHeight(Screen.Monitors[FCurrentMonitor - 1].Top +
                                Screen.Monitors[FCurrentMonitor - 1].Height);
    end;
end;

//---------------------------------------------------

function TScreenCamera.GetMonitorsCount: Integer;
begin
  Result := Screen.MonitorCount;
end;

function TScreenCamera.GetRecordType: TTypeRecord;
begin
  Result := FRecordType;
end;

procedure TScreenCamera.SetRecordType(Value: TTypeRecord);
begin
  if Value <> FRecordType then
    FRecordType := Value;
end;

function TScreenCamera.GetCurrentMonitor: Integer;
begin
  Result := FCurrentMonitor;
end;

procedure TScreenCamera.SetCurrentMonitor(Value: Integer);
begin
  if (Value <> FCurrentMonitor) and
     (Value <= GetMonitorsCount) and
     (not (Value < 1)) then
    FCurrentMonitor := Value;
end;

function TScreenCamera.GetVersion: String;
begin
  Result := isVersion;
end;

procedure TScreenCamera.SetVersion(Value: String);
begin
  Value := Value;
end;

function TScreenCamera.GetNColors: TPixelFormat;
begin
  Result := nColors;
end;

procedure TScreenCamera.SetNColors(Value: TPixelFormat);
begin
  nColors := Value;
  case nColors of
    pf8bit  : Bits := 8;
    pf15bit,
    pf16bit :
      begin
        nColors := pf16bit;
        Bits    := 16;
      end;
    pf24bit : Bits := 24;
    pf32bit : Bits := 32;
    else
      begin
        nColors := pf32bit;
        Bits    := 32;
      end;
  end;
end;

function TScreenCamera.GetPriority: TThreadPriority;
begin
  Result := FPriority;
end;

procedure TScreenCamera.SetPriority(Value: TThreadPriority);
begin
  if FPriority <> Value then begin
    FPriority := Value;
    if Assigned(FRecordAVIThread) then
      FRecordAVIThread.Priority := FPriority;
    end;
end;

function TScreenCamera.GetInterval: Integer;
begin
  Result := FPlaybackFPS;
end;

procedure TScreenCamera.SetInterval(Value: Integer);
begin
  if (FPlaybackFPS <> Value) and
     (Value <= 1000) and
     (Value > 0) then
    FPlaybackFPS := Value;
end;

function TScreenCamera.GetUpdateRate: Integer;
begin
  Result := FUpdateRate;
end;

procedure TScreenCamera.SetUpdateRate(Value: Integer);
begin
  if (FUpdateRate <> Value) and
     (Value <= 500) and
     (Value > 0) then
    FUpdateRate := Value;
end;

procedure TScreenCamera.SetScreenArea(Value: TScreenArea);
begin
  FScreenArea.Assign(Value);
end;


procedure TScreenCamera.SetAllFilterValues(Value: TFilterValues);
begin
  FFilterValues.Assign(Value);
end;

function TScreenCamera.GetQuality: Integer;
begin
  Result := FCompressionQuality;
end;

procedure TScreenCamera.SetQuality(Value: Integer);
begin
  if (FCompressionQuality <> Value) and
     (Value <= 10000) and
     (Value > 0) then
    FCompressionQuality := Value;
end;

function TScreenCamera.GetRecord_MSPF: Integer;
begin
  Result := FMSPFRecord;
end;

procedure TScreenCamera.SetRecord_MSPF(Value: Integer);
begin
  if (FMSPFRecord <> Value) and
     ((Value <= 1000) and
     (Value > 0)) then
    FMSPFRecord := Value;
end;


procedure TScreenCamera.SetUseFilters(Value: TUseFilters);
begin
  if (UseColorNoise in FUseFilters) and (UseMonoNoise in Value) then
    Value := Value - [UseColorNoise];
  if (UseMonoNoise in FUseFilters) and (UseColorNoise in Value) then
    Value := Value - [UseMonoNoise];
  FUseFilters := Value;
end;

procedure TScreenArea.SetScreenWidth(Value: Integer);
begin
  if (FScreenWidth <> Value) then
    FScreenWidth := Value;
end;


procedure TScreenArea.SetScreenHeight(Value: Integer);
begin
  if (FScreenHeight <> Value) then
    FScreenHeight := Value;
end;

function TScreenCamera.GetLineRectClear: Boolean;
begin
  Result := FLineRectClear;
end;

procedure TScreenCamera.SetLineRectClear(Value: Boolean);
begin
  if (FLineRectClear <> Value) then
    FLineRectClear := Value;
end;

function TScreenCamera.GetShowPreview: Boolean;
begin
  Result := FShowPreview;
end;

procedure TScreenCamera.SetShowPreview(Value: Boolean);
begin
  OldUpdateTime1 := 0;
  OldTime2       := 0;
  InitialTime1   := TimeGetTime; {GetTickCount;};
  if FShowPreview <> Value then
    FShowPreview := Value;
  if FShowPreview then begin
    if not Assigned(FPreviewTimer) then begin
      FPreviewTimer := THighTimer.Create(Self);
      FPreviewTimer.OnTimer := FShowPreviewTimer;
      FPreviewTimer.ThreadPriority := FPriority;
      FPreviewTimer.Synchronize := True;
      FPreviewTimer.UseThread := True;
      end;
    FPreviewTimer.Interval := 1000 div FPlaybackFPS;
    FPreviewTimer.Enabled := False;
    if Assigned(FFrame) then
      ShowWindow(FFrame.Handle, SW_HIDE);
    FPreviewTimer.Enabled := True;
    end
  else begin
    if not RecordState then begin
      if Assigned(FPreviewTimer) then begin
        FPreviewTimer.Enabled := False;
        FPreviewTimer := nil;
        end;
      if Assigned(FFrame) then
        ShowWindow(FFrame.Handle, SW_HIDE);
      if Assigned(FOnPreview) then
        FOnPreview(Self, nil, False, False);
      end
    else begin
      if Assigned(FOnPreview) then
        FOnPreview(Self, nil, False, True);
      end;
    end;
end;

constructor TScreenCamera.Create(AOwner: TComponent);
var
  TempDir   : String;
  GetLength : DWORD;
  I         : Integer;
begin
  inherited Create(AOwner);
  SetLength(TempDir, MAX_PATH + 1);
  {$IFDEF VERSION14}
  GetLength := GetTempPath(MAX_PATH, PWideChar(TempDir));
  {$ELSE}
  GetLength := GetTempPath(MAX_PATH, PAnsiChar(TempDir));
  {$ENDIF}
  SetLength(TempDir, GetLength);
  if Copy(TempDir, Length(TempDir), 1) <> '\' then
    TempDir := TempDir + '\';
  TempVideoFile          := TempDir + 'tmpVideoStream.avi';
  TempAudioFile          := TempDir + 'tmpAudioStream.wav';
  RecordState            := False;
	MaxXScreen             := Screen.DesktopWidth;
	MaxYScreen             := Screen.DesktopHeight;
  FRecordType            := CompressOnFly; // On fly compress image captured
	FourCC                 := mmioFOURCC('M', 'S', 'V', 'C');
  FVideoCodecList        := TStringList.Create;
  StrCodec               := 'MS Video Codec';
  FVideoCodecList.Add(StrCodec);
  FSelCodecRepeat        := False;
  FAudioFormatList       := TStringList.Create;
  FAudioInputNames       := TStringList.Create;
  SavingSuccess          := False;
  StartRegionSel         := False;
  X1                     := 0;
  Y1                     := 0;
  X2                     := 0;
  Y2                     := 0;
  FTimerRecord.TimerON   := False;
  FTimerRecord.Hour      := 0;
  FTimerRecord.Min       := 0;
  FTimerRecord.Sec       := 0;
  FUpdateRate            := 250;
  FMSPFRecord            := 20;
  FPlaybackFPS           := 50;
  FKeyFramesEvery        := 300;
  FCompressionQuality    := 10000;
  FVideoCompressorCount  := 0;
  FSelectedCompressor    := -1;
  FPriority              := tpNormal;
	SetNColors(pf32bit);
  FPauseRecording        := False;
  FRegColor1             := clRed;
  FRegColor2             := clLime;
  FRegColor              := FRegColor1;
  FRecordCursor          := True;
  FFlashingRect          := True;
  FLineRectClear         := True;
  FMinimize              := True;
  FRestore               := True;
  FAudioRecord           := False;
  FSelectObject          := False;
  FAutoPan               := False;
  FFreeHandMode          := False;
  FFullScreen            := False;
  FOnRecordPreview       := False;
  FAudioFormatsIndex     := -1;
  FSuccess               := None;
  FAutoPan               := False;
  FRecordAVIThread       := nil;
  FOvelayDrawing         := False;
  FEffectToOvelayDraw    := False;

  FScreenArea := TScreenArea.Create;
  FScreenArea.FScreenRegion   := FixedMoving;
  FScreenArea.FScreenLeft     := 0;
  FScreenArea.FScreenTop      := 0;
  FScreenArea.FScreenWidth    := 300;
  FScreenArea.FScreenHeight   := 300;

  FFilterValues := TFilterValues.Create;
  FFilterValues.FScreenRotate := RLeft;  // ( RLeft, RRight, RReverse, RHorizontal, RVertical )
  FFilterValues.FColorNoise   := 0;      // 0 ~ 255  0 = Normal
  FFilterValues.FMonoNoise    := 0;      // 0 ~ 255  0 = Normal
  FFilterValues.FPosterize    := 1;      // 1 ~ 255  1 = Normal
  FFilterValues.FRedColor     := 0;      // -255 ~ 255  0 = Normal
  FFilterValues.FGreenColor   := 0;      // -255 ~ 255  0 = Normal
  FFilterValues.FBlueColor    := 0;      // -255 ~ 255  0 = Normal
  FFilterValues.FSaturation   := 255;    // 0 ~ 2550  255 = Normal
  FFilterValues.FBrightness   := 0;      // -2550 ~ 255  0 = Normal
  FFilterValues.FDarkness     := 0;      // 0 ~ 255  0 = Normal
  FFilterValues.FContrast     := 0;      // -255 ~ 2550 0 = Normal

  FUseFilters := [];                     // No selected filter

  FCurrentMonitor    := 1;               // Current monitor ( 1 ~ GetMonitorsCount() )
  FRecordAllMonitors := False;
  FAudioInputIndex   := 0;
  GetAudioFormatsInfo;                   // Initialize audio formats
  GetAudioInputsNames;                   // Initialize audio inputs
  GetVideoCompressorsInfo;               // Initialize video Compressors
  Application.OnMinimize := FFrameMinimize;
  // All application hot keys
  if not (csDesigning in ComponentState) then begin
    FWndHandle := AllocateHWnd(GlobalHotKey);
    FHotKey1   := GlobalAddAtom('HotKey 1');
    RegisterHotKey(FWndHandle, FHotKey1, MOD_SHIFT, VK_ESCAPE);
    FHotKey2   := GlobalAddAtom('HotKey 2');
    RegisterHotKey(FWndHandle, FHotKey2, 0, VK_ESCAPE);
    FHotKey3   := GlobalAddAtom('HotKey 3');
    RegisterHotKey(FWndHandle, FHotKey3, MOD_CONTROL, VK_RETURN);
    FHotKey4   := GlobalAddAtom('HotKey 4');
    RegisterHotKey(FWndHandle, FHotKey4, 0, VK_PAUSE);
    end;
  SC := Self;
end;

destructor TScreenCamera.Destroy;
begin
  if RecordState then begin
    RecordState := False;
    FSuccess    := Fail;
    end;
  if Assigned(SC) then
    SC := nil;
  if Assigned(FPreviewTimer) then begin
    FPreviewTimer.Enabled := False;
    FPreviewTimer.Destroy;
    end;
  if Assigned(FFrame) then
    FFrame.Free;
  FVideoCodecList.Free;
  FAudioFormatList.Free;
  FAudioInputNames.Free;
  FFilterValues.Free;
  FScreenArea.Free;
  if not (csDesigning in ComponentState) then begin
    UnRegisterHotKey(FWndHandle, FHotKey1);
    UnRegisterHotKey(FWndHandle, FHotKey2);
    UnRegisterHotKey(FWndHandle, FHotKey3);
    UnRegisterHotKey(FWndHandle, FHotKey4);
    end;
  if FWndHandle <> 0 then
    DeAllocateHWnd(FWndHandle);
  FWndHandle := 0;
  // If already exist temp files try to delete them
  PowerDeleteFile(TempVideoFile);
  PowerDeleteFile(TempAudioFile);
  inherited Destroy;
end;

procedure TScreenCamera.ShowAbout;
begin
 {
  with TfrmAbout.Create(Self) do
    try
      //ShowAbout(isComponentName, 'v' + isVersion + '    ' + isHistory);
    finally
      Free;
    end;
    }
end;

function TScreenCamera.FFreeHandFrameDraw: Boolean;
begin
  FreeHandWindow := TFreeHandWindow.Create(Application);
  try
    SetWindowPos(FreeHandWindow.Handle,
                 HWND_TOPMOST,
                 0,
                 0,
                 0,
                 0,
                 SWP_NOREPOSITION or
                 SWP_NOMOVE or
                 SWP_NOSIZE or
                 SWP_NOACTIVATE);
    if FreeHandWindow.ShowModal = mrOK then begin
      FScreenArea.FScreenLeft := FreeHandWindow.PRegion.Left;
      FScreenArea.FScreenTop  := FreeHandWindow.PRegion.Top;
      FScreenArea.SetScreenWidth(FreeHandWindow.PRegion.Right);
      FScreenArea.SetScreenHeight(FreeHandWindow.PRegion.Bottom);
      if FRecordAllMonitors then begin
        if FScreenArea.FScreenLeft < Screen.DesktopLeft then begin
          FScreenArea.SetScreenWidth(FScreenArea.FScreenWidth - (Screen.DesktopLeft - FScreenArea.FScreenLeft));
          FScreenArea.FScreenLeft := Screen.DesktopLeft;
          end;
        if FScreenArea.FScreenTop < Screen.DesktopTop then begin
          FScreenArea.SetScreenHeight(FScreenArea.FScreenHeight - (Screen.DesktopTop - FScreenArea.FScreenTop));
          FScreenArea.FScreenTop := Screen.DesktopTop;
          end;
        if (FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) > (Screen.DesktopLeft + Screen.DesktopWidth) then
          FScreenArea.SetScreenWidth(FScreenArea.FScreenWidth - ((FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) -
                                    (Screen.DesktopLeft + Screen.DesktopWidth)));
        if (FScreenArea.FScreenTop + FScreenArea.FScreenHeight) > (Screen.DesktopTop + Screen.DesktopHeight) then
          FScreenArea.SetScreenHeight(FScreenArea.FScreenHeight - ((FScreenArea.FScreenTop + FScreenArea.FScreenHeight) -
                                     (Screen.DesktopTop + Screen.DesktopHeight)));
        end
      else begin
        if FScreenArea.FScreenLeft < Screen.Monitors[FCurrentMonitor - 1].Left then begin
          FScreenArea.SetScreenWidth(FScreenArea.FScreenWidth - (Screen.Monitors[FCurrentMonitor - 1].Left - FScreenArea.FScreenLeft));
          FScreenArea.FScreenLeft := Screen.Monitors[FCurrentMonitor - 1].Left;
          end;
        if FScreenArea.FScreenTop < Screen.Monitors[FCurrentMonitor - 1].Top then begin
          FScreenArea.SetScreenHeight(FScreenArea.FScreenHeight - (Screen.Monitors[FCurrentMonitor - 1].Top - FScreenArea.FScreenTop));
          FScreenArea.FScreenTop := Screen.Monitors[FCurrentMonitor - 1].Top;
          end;
        if (FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) > (Screen.Monitors[FCurrentMonitor - 1].Left +
                                           Screen.Monitors[FCurrentMonitor - 1].Width) then
          FScreenArea.SetScreenWidth(FScreenArea.FScreenWidth - ((FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) -
                                         (Screen.Monitors[FCurrentMonitor - 1].Left +
                                          Screen.Monitors[FCurrentMonitor - 1].Width)));
        if (FScreenArea.FScreenTop + FScreenArea.FScreenHeight) > (Screen.Monitors[FCurrentMonitor - 1].Top +
                                           Screen.Monitors[FCurrentMonitor - 1].Height) then
          FScreenArea.SetScreenHeight(FScreenArea.FScreenHeight - ((FScreenArea.FScreenTop + FScreenArea.FScreenHeight) -
                                           (Screen.Monitors[FCurrentMonitor - 1].Top +
                                            Screen.Monitors[FCurrentMonitor - 1].Height)));
        end;
      FScreenArea.FScreenRegion := FixedStable;
      if StartRegionSel then begin
        StartRegionSel := False;
        if FFileName <> '' then
          StartRecording(FFileName);
        end;
      Result := True;
      end
    else
      Result := False;
  finally;
    FreeHandWindow.Free;
    end;
end;

function TScreenCamera.FSelObjectFrameDraw: Boolean;
begin
  SelObjWindow := TSelObjWindow.Create(Application);
  try
    if SelObjWindow.ShowModal = mrOK then begin
      FScreenArea.FScreenLeft := SelObjWindow.PRegion.Left;
      FScreenArea.FScreenTop  := SelObjWindow.PRegion.Top;
      FScreenArea.SetScreenWidth(SelObjWindow.PRegion.Right);
      FScreenArea.SetScreenHeight(SelObjWindow.PRegion.Bottom);
      if FRecordAllMonitors then begin
        if FScreenArea.FScreenLeft < Screen.DesktopLeft then begin
          FScreenArea.SetScreenWidth(FScreenArea.FScreenWidth - (Screen.DesktopLeft - FScreenArea.FScreenLeft));
          FScreenArea.FScreenLeft := Screen.DesktopLeft;
          end;
        if FScreenArea.FScreenTop < Screen.DesktopTop then begin
          FScreenArea.SetScreenHeight(FScreenArea.FScreenHeight - (Screen.DesktopTop - FScreenArea.FScreenTop));
          FScreenArea.FScreenTop := Screen.DesktopTop;
          end;
        if (FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) > (Screen.DesktopLeft + Screen.DesktopWidth) then
          FScreenArea.SetScreenWidth(FScreenArea.FScreenWidth - ((FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) -
                                    (Screen.DesktopLeft + Screen.DesktopWidth)));
        if (FScreenArea.FScreenTop + FScreenArea.FScreenHeight) > (Screen.DesktopTop + Screen.DesktopHeight) then
          FScreenArea.SetScreenHeight(FScreenArea.FScreenHeight - ((FScreenArea.FScreenTop + FScreenArea.FScreenHeight) -
                                     (Screen.DesktopTop + Screen.DesktopHeight)));
        end
      else begin
        if FScreenArea.FScreenLeft < Screen.Monitors[FCurrentMonitor - 1].Left then begin
          FScreenArea.SetScreenWidth(FScreenArea.FScreenWidth - (Screen.Monitors[FCurrentMonitor - 1].Left - FScreenArea.FScreenLeft));
          FScreenArea.FScreenLeft := Screen.Monitors[FCurrentMonitor - 1].Left;
          end;
        if FScreenArea.FScreenTop < Screen.Monitors[FCurrentMonitor - 1].Top then begin
          FScreenArea.SetScreenHeight(FScreenArea.FScreenHeight - (Screen.Monitors[FCurrentMonitor - 1].Top - FScreenArea.FScreenTop));
          FScreenArea.FScreenTop := Screen.Monitors[FCurrentMonitor - 1].Top;
          end;
        if (FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) > (Screen.Monitors[FCurrentMonitor - 1].Left +
                                           Screen.Monitors[FCurrentMonitor - 1].Width) then
          FScreenArea.SetScreenWidth(FScreenArea.FScreenWidth - ((FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) -
                                         (Screen.Monitors[FCurrentMonitor - 1].Left +
                                          Screen.Monitors[FCurrentMonitor - 1].Width)));
        if (FScreenArea.FScreenTop + FScreenArea.FScreenHeight) > (Screen.Monitors[FCurrentMonitor - 1].Top +
                                           Screen.Monitors[FCurrentMonitor - 1].Height) then
          FScreenArea.SetScreenHeight(FScreenArea.FScreenHeight - ((FScreenArea.FScreenTop + FScreenArea.FScreenHeight) -
                                           (Screen.Monitors[FCurrentMonitor - 1].Top +
                                            Screen.Monitors[FCurrentMonitor - 1].Height)));
        end;
      FScreenArea.FScreenRegion := FixedStable;
      if StartRegionSel then begin
        StartRegionSel := False;
        if FFileName <> '' then
          StartRecording(FFileName);
        end;
      Result := True;
      end
    else
      Result := False;
  finally;
    SelObjWindow.Free;
    end;
end;

procedure TScreenCamera.FShowPreviewTimer(Sender: TObject);
var
  mImage     : TBitmap;
  RemindTime : THMSM;
  CurentTime : Extended;
begin
  FPreviewTimer.Interval := 1000 div FPlaybackFPS;
  TimeExpended1 := TimeGetTime {GetTickCount} - InitialTime1;
  OldTime1      := TimeGetTime; {GetTickCount;}

  if not RecordState then begin
    case FScreenArea.FScreenRegion of
      SelObject  : begin
                     FSelectObject := True;
                     FFreeHandMode := False;
                     FAutoPan      := False;
                     FFullScreen   := False;
                   end;
      FreeHand   : begin
                     FSelectObject := False;
                     FFreeHandMode := True;
                     FAutoPan      := False;
                     FFullScreen   := False;
                   end;
      FixedMoving: begin
                     FSelectObject := False;
                     FFreeHandMode := False;
                     FAutoPan      := True;
                     FFullScreen   := False;
                   end;
      FixedStable: begin
                     FSelectObject := False;
                     FFreeHandMode := False;
                     FAutoPan      := False;
                     FFullScreen   := False;
                   end;
      FullScreen : begin
                     FSelectObject := False;
                     FFreeHandMode := False;
                     FAutoPan      := False;
                     FFullScreen   := True;
                   end;
      end;
    end
  else begin
    if (FScreenArea.FScreenRegion = FreeHand) or
       (FScreenArea.FScreenRegion = SelObject) then begin
      FScreenArea.FScreenRegion := FixedStable;
      FSelectObject := False;
      FFreeHandMode := False;
      FAutoPan      := False;
      FFullScreen   := False;
      end;
    end;

  if StartRegionSel or FShowPreview or (RecordState and not FFullScreen) then begin
    if FFullScreen then begin
      SetSizeFullScreen;
      end
    else begin
      if FFreeHandMode then begin
        FPreviewTimer.Enabled := False;
        FPreviewTimer.Enabled := FFreeHandFrameDraw;
        if not FPreviewTimer.Enabled then begin
          Exit;
          end;
        end
      else begin
        if FSelectObject then begin
          FPreviewTimer.Enabled := False;
          FPreviewTimer.Enabled := FSelObjectFrameDraw;
          if not FPreviewTimer.Enabled then begin
            Exit;
            end;
          end
        else begin
          if FAutoPan then begin
            FScreenArea.FScreenLeft := FCursorPos.CursorPos.X - (FScreenArea.FScreenWidth div 2);
            FScreenArea.FScreenTop  := FCursorPos.CursorPos.Y - (FScreenArea.FScreenHeight div 2);
            if FRecordAllMonitors then begin
              if FScreenArea.FScreenLeft < Screen.DesktopLeft then
                FScreenArea.FScreenLeft := Screen.DesktopLeft;
              if FScreenArea.FScreenTop < Screen.DesktopTop then
                FScreenArea.FScreenTop  := Screen.DesktopTop;
              if (FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) > Screen.DesktopWidth then
                FScreenArea.FScreenLeft := (Screen.DesktopWidth - FScreenArea.FScreenWidth);
              if (FScreenArea.FScreenTop + FScreenArea.FScreenHeight) > Screen.DesktopHeight then
                FScreenArea.FScreenTop  := (Screen.DesktopHeight - FScreenArea.FScreenHeight);
              end
            else begin
              if FScreenArea.FScreenLeft < Screen.Monitors[FCurrentMonitor - 1].Left then
                FScreenArea.FScreenLeft := Screen.Monitors[FCurrentMonitor - 1].Left;
              if FScreenArea.FScreenTop < Screen.Monitors[FCurrentMonitor - 1].Top then
                FScreenArea.FScreenTop  := Screen.Monitors[FCurrentMonitor - 1].Top;
              if (FScreenArea.FScreenLeft + FScreenArea.FScreenWidth) > (Screen.Monitors[FCurrentMonitor - 1].Left +
                                                 Screen.Monitors[FCurrentMonitor - 1].Width) then
                FScreenArea.FScreenLeft := ((Screen.Monitors[FCurrentMonitor - 1].Left +
                                 Screen.Monitors[FCurrentMonitor - 1].Width) - FScreenArea.FScreenWidth);
              if (FScreenArea.FScreenTop + FScreenArea.FScreenHeight) > (Screen.Monitors[FCurrentMonitor - 1].Top +
                                                 Screen.Monitors[FCurrentMonitor - 1].Height) then
                FScreenArea.FScreenTop  := ((Screen.Monitors[FCurrentMonitor - 1].Top +
                                 Screen.Monitors[FCurrentMonitor - 1].Height) - FScreenArea.FScreenHeight);
              end;
            end;
          end;
        end;
      end;
    if (FFlashingRect) then begin
      if not Assigned(FFrame) then
        FFrame := TFlashingWnd.Create(Self);

      //Update color around region
      if (TimeExpended1 >= OldTime2 + FUpdateRate) then begin
        OldTime2 := TimeExpended1;
        if FRegColor = FRegColor1 then
          FRegColor := FRegColor2
        else
          FRegColor := FRegColor1;
        end;

      if (not RecordState) and FShowPreview then begin
        FFrame.SetUpRegion(FScreenArea.FScreenLeft,
                           FScreenArea.FScreenTop,
                           FScreenArea.FScreenWidth,
                           FScreenArea.FScreenHeight,
                           FLineRectClear,
                           PreviewMsg);
        FFrame.PaintBorder(FRegColor,
                           PreviewMsg);
        end
      else begin
        if (RecordState) then begin
          if not FPauseRecording then begin
            FFrame.SetUpRegion(FScreenArea.FScreenLeft,
                               FScreenArea.FScreenTop,
                               FScreenArea.FScreenWidth,
                               FScreenArea.FScreenHeight,
                               FLineRectClear,
                               RecordingMsg);
            FFrame.PaintBorder(FRegColor,
                               RecordingMsg);
            end
          else begin
            FFrame.SetUpRegion(FScreenArea.FScreenLeft,
                               FScreenArea.FScreenTop,
                               FScreenArea.FScreenWidth,
                               FScreenArea.FScreenHeight,
                               FLineRectClear,
                               PauseMsg);
            FFrame.PaintBorder(FRegColor,
                               PauseMsg);
            end;
          end;
        end;
      ShowWindow(FFrame.Handle, SW_SHOW);
      SetWindowPos(FFrame.Handle,
                   HWND_TOPMOST,
                   0,
                   0,
                   0,
                   0,
                   SWP_NOREPOSITION or
                   SWP_NOMOVE or
                   SWP_NOSIZE or
                   SWP_NOACTIVATE);
      end
    else begin
      if Assigned(FFrame) then
        ShowWindow(FFrame.Handle, SW_HIDE);
      end;
    if Assigned(FOnPreview) then begin
      if FShowPreview and not RecordState then
        begin
          mImage := TBitmap.Create;
          try
            CaptureScreenFrame(0,
                               mImage,
                               FScreenArea.FScreenLeft,
                               FScreenArea.FScreenTop,
                               FScreenArea.FScreenWidth,
                               FScreenArea.FScreenHeight,
                               UseReverseColor in FUseFilters);
            if mImage.Canvas.TryLock then
              try
                FOnPreview(Self, mImage, True, False);
              finally
                mImage.Canvas.UnLock;
              end;
          finally
            mImage.Free;
          end;
        end
      else begin
        if (FShowPreview) and (RecordState)
           //Notice: some of sizes on record mode for preview equal memory crashing.
           and not (FScreenArea.FScreenWidth  > 640)  // Width of region
           and not (FScreenArea.FScreenHeight > 480)  // Height of region
           then
          FOnRecordPreview := True
        else begin
          FOnRecordPreview := False;
          if RecordState then
            FOnPreview(Self, nil, False, True)
          else
            FOnPreview(Self, nil, False, False);
          end;
        end;
      end;
    end
  else begin
    if Assigned(FFrame) then
      ShowWindow(FFrame.Handle, SW_HIDE);
    FOnRecordPreview := False;
    if Assigned(FOnPreview) then begin
      if RecordState then
        FOnPreview(Self, nil, False, True)
      else
        FOnPreview(Self, nil, False, False);
      end;
    end;
  if FShowPreview and not RecordState then begin
    RemindTime := MilliSecond2Time(TimeExpended1);
    Hur := RemindTime.Hour;
    Min := RemindTime.Minute;
    Sec := RemindTime.Second;
    Mil := RemindTime.MilliSecond;
    FElapsedTime := IntToStr(Hur) + ' : ' +
                    IntToStr(Min) + ' : ' +
                    IntToStr(Sec) + ' : ' +
                    IntToStr(Mil);
    StrCodec            := '';
    FActualFrameNo      := 0;
    FSkippedFrames      := 0;
    FCurrentCapturedFPS := 0;

    CurentTime := TimeGetTime {GetTickCount};
    if (CurentTime - OldTime1) > 0 then
      FRealCapturingFPS := 1000 / (CurentTime - OldTime1)
    else
      FRealCapturingFPS := 1000;

    if (TimeExpended1 >= OldUpdateTime1 + FUpdateRate) then begin
      OldUpdateTime1 := TimeExpended1;
      if Assigned(FOnUpdate) then FOnUpdate(Self);
      end;
    OldTime1 := CurentTime;
    end;
end;

procedure TScreenCamera.FFrameMinimize(Sender: TObject);
begin
  if Assigned(FFrame) then
    if FFrame.Showing then
      SendMessage(FFrame.Handle, WM_SYSCOMMAND, SC_RESTORE, 0)
end;

procedure TScreenCamera.GlobalHotKey(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_HOTKEY:
      begin
        if Msg.WParam = FHotKey1 then begin
          FSuccess := Success;
          if RecordState then begin
            RecordState := False;
            if not FShowPreview then
              SetShowPreview(False)
            else
              SetShowPreview(True);
            end;
          end;

        if Msg.WParam = FHotKey2 then begin
          FSuccess := Fail;

          if Assigned(FreeHandWindow) then
            if FreeHandWindow.Showing then
              FreeHandWindow.ModalResult := mrCancel;

          if Assigned(SelObjWindow) then
            if SelObjWindow.Showing then begin
              SelObjWindow.Timer1.Enabled := False;
              SelObjWindow.ModalResult := mrCancel;
              end;

          StartRegionSel := False;

          if FShowPreview or RecordState then
            if FRestore then
              Application.Restore;

          if FShowPreview and not RecordState then
            SetShowPreview(False);

          if RecordState then begin
            RecordState := False;
            if not FShowPreview then
              SetShowPreview(False)
            else
              SetShowPreview(True);
            end;
          end;

        if Msg.WParam = FHotKey3 then begin
          if Assigned(SelObjWindow) then
            if SelObjWindow.Showing then begin
              SelObjWindow.Timer1.Enabled := False;
              if (FScreenArea.FScreenWidth <> 0) and (FScreenArea.FScreenHeight <> 0) then
                SelObjWindow.ModalResult := mrOk
              else
                FreeHandWindow.ModalResult := mrCancel;
              end;

          if RecordState then begin
            RecordState := False;
            if not FShowPreview then
              SetShowPreview(False)
            else
              SetShowPreview(True);
            end;
          end;

        if Msg.WParam = FHotKey4 then begin
          if FPauseRecording then
            FPauseRecording := False
          else
            FPauseRecording := True;
          end;
      end;
  end;
end;

procedure TScreenCamera.CompressorAbout(Compressor: Byte; WND: HWND);
var
  icv: hic;
begin
  if Compressor >= FVideoCompressorCount then Exit;
	icv := ICOpen(FVideoCompressorInfo[Compressor].fccType,
                FVideoCompressorInfo[compressor].fccHandler,
                ICMODE_QUERY);
	if (icv <> 0) then
  begin
  	ICAbout(icv, WND);
    ICClose(icv);
  end;
end;

procedure TScreenCamera.CompressorConfigure(Compressor: Byte; WND: HWND);
var
  icv: hic;
begin
  if Compressor >= FVideoCompressorCount then Exit;
	icv := ICOpen(FVideoCompressorInfo[Compressor].fccType,
                FVideoCompressorInfo[Compressor].fccHandler,
                ICMODE_QUERY);
	if (icv <> 0) then
  begin
  	ICConfigure(icv, WND);
    ICClose(icv);
  end;
end;


procedure TScreenCamera.CompressorHasFeatures(Compressor: Byte;
  var hasAbout: Boolean; var hasConfig: Boolean);
var
  icv: hic;
begin
  hasAbout  := False;
  hasConfig := False;
  if Compressor >= FVideoCompressorCount then Exit;
	icv := ICOpen(FVideoCompressorInfo[Compressor].fccType,
                FVideoCompressorInfo[Compressor].fccHandler,
                ICMODE_QUERY);
	if (icv <> 0) then
  begin
  	hasAbout  := ICQueryAbout(icv);
  	hasConfig := ICQueryConfigure(icv);
    ICClose(icv);
  end;
end;

function TScreenCamera.HBitmap2DDB(HBitmap: HBitmap; nBits: LongWord): THandle;
var
	hDIB     : THandle;
  aHDC     : HDC;
	hSDC     : HDC;
  hDesktop : HWND;
	Bitmap   : Windows.TBitmap;
	wLineLen : LongWord;
	dwSize   : DWORD;
	wColSize : DWORD;
	lpbi     : PBitmapInfoHeader;
	lpBits   : PByte;
  Msg      : TMessage;
  InfoSize : Integer;
  MsgStr   : String;

  procedure SetBitmapInfoHeader(var nlpbi: PBitmapInfoHeader);
  begin
    nlpbi^.biSize          := SizeOf(BitmapInfoHeader);
    nlpbi^.biWidth         := Bitmap.bmWidth;
	  nlpbi^.biHeight        := Bitmap.bmHeight;
	  nlpbi^.biPlanes        := 1;
    nlpbi^.biBitCount      := nBits;
	  nlpbi^.biCompression   := BI_RGB;
  	nlpbi^.biSizeImage     := dwSize - SizeOf(BitmapInfoHeader) - wColSize;
	  nlpbi^.biXPelsPerMeter := 0;
  	nlpbi^.biYPelsPerMeter := 0;
	  nlpbi^.biClrImportant  := 0;
    if nBits <= 8 then
      nlpbi^.biClrUsed     := (1 shl nBits)
    else
      nlpbi^.biClrUsed     := 0;
  end;

  label Error;

begin
  CancelRecording := False;
	GetObject(HBitmap, SizeOf(Bitmap), @Bitmap);
	wLineLen := (Bitmap.bmWidth * nBits + 31) div 32 * 4;
  if (nBits <= 8) then
    wColSize := SizeOf(RGBQUAD) * (1 shl nBits)
  else
    wColSize := 0;
	dwSize := SizeOf(BitmapInfoHeader) + wColSize + (wLineLen * Bitmap.bmHeight);


	hDIB := GlobalAlloc(GHND, dwSize);
	if (hDIB = 0) then begin
		Result := hDIB;
    CancelRecording := True;
    MsgStr := ErrorMsg1;
    goto Error;
    end;


	lpbi := GlobalLock(hDIB);
	if not Assigned(lpbi) then begin
		Result := hDIB;
    CancelRecording := True;
    MsgStr := ErrorMsg2;
    goto Error;
    end;


  SetBitmapInfoHeader(lpbi);


  if nBits <= 8 then
    InfoSize := lpbi^.biSize + lpbi^.biClrUsed * SizeOf(RGBQUAD)
  else
    InfoSize := lpbi^.biSize;

	lpBits   := PByte(LongWord(lpbi) + InfoSize);
  hDesktop := GetDesktopWindow;
  hSDC     := GetWindowDC(hDesktop);
	aHDC     := CreateCompatibleDC(hSDC);

  if GetDIBits(aHDC,
               HBitmap,
               0,
               Bitmap.bmHeight,
               lpBits,
               PBitmapInfo(lpbi)^,
               DIB_RGB_COLORS) = 0 then begin
    CancelRecording := True;
    MsgStr := ErrorMsg3;
    end;


  SetBitmapInfoHeader(lpbi);

  ReleaseDC(hDesktop, hSDC);
	DeleteDC(aHDC);
	GlobalUnlock(hDIB);
	Result := hDIB;

Error:

  if CancelRecording then begin
    Msg.Msg    := WM_HOTKEY;
    Msg.WParam := FHotKey2;
    GlobalHotKey(Msg);
    if Assigned(FOnError) then FOnError(Self, MsgStr);
    FSuccess := Fail;
    RecordState := False;
    if Assigned(FOnStop) then FOnStop(Self);
    end;
end;


function TScreenCamera.CaptureScreenFrame(Mode: Integer; TempImage: TBitmap;
  Left, Top, Width, Height: Integer; ReverseColor: Boolean): PBitmapInfoHeader;
var
  hbm        : HBitmap;
  hMemDC     : HBitmap;
	hScreenDC  : HDC;
  hDesktop   : HWND;
  IconInf    : TIconInfo;
  CursorInf  : TCursorInfo;
  Icon       : TIcon;
  pBM_HEADER : PBitmapInfoHeader;
  CopySrc    : Integer;
  TmBitmap,
  tmpBitmap  : TBitmap;

begin
  case ReverseColor of
    False : CopySrc := SRCCOPY;
    True  : CopySrc := NOTSRCCOPY;
  end;
  hDesktop  := GetDesktopWindow;
  hScreenDC := GetWindowDC(hDesktop);
  hMemDC    := CreateCompatibleDC(hScreenDC);
  hbm       := CreateCompatibleBitmap(hScreenDC, Width, Height);
  SelectObject(hMemDC, hbm);
  BitBlt(hMemDC,
         0,
         0,
         Width,
         Height,
         hScreenDC,
         Left,
         Top,
         CopySrc);

  if (FRecordCursor) then begin
    Icon := TIcon.Create;
    try
      CursorInf.cbSize := SizeOf(TCursorInfo);
      if GetCursorInfo(CursorInf) then
        if CursorInf.Flags = CURSOR_SHOWING then begin
          Icon.Handle := CursorInf.hCursor;
          if GetIconInfo(Icon.Handle, IconInf) then
            try
              DrawIcon(hMemDC,
                       CursorInf.ptScreenPos.X - (IconInf.xHotspot + Left),
                       CursorInf.ptScreenPos.Y - (IconInf.yHotspot + Top),
                       Icon.Handle);
            finally
              DeleteObject(IconInf.hbmMask);
              DeleteObject(IconInf.hbmColor);
              end;
          end;
    finally
      Icon.Free;
      end;
    end;
  if FEffectToOvelayDraw then
    if Assigned(FOnOverlay) and FOvelayDrawing then begin
      BitBlt(hMemDC,
             0,
             0,
             Width,
             Height,
             hMemDC,
             0,
             0,
             CopySrc);
      FOnOverlay(Self, hMemDC, Width, Height);
      BitBlt(hMemDC,
             0,
             0,
             Width,
             Height,
             hMemDC,
             0,
             0,
             CopySrc);
      end;
  tmpBitmap := TBitmap.Create;
  try
    tmpBitmap.Width  := Width;
    tmpBitmap.Height := Height;
    if tmpBitmap.Canvas.TryLock then begin
      try
        BitBlt(tmpBitmap.Canvas.Handle,
               0,
               0,
               Width,
               Height,
               hMemDC,
               0,
               0,
               SRCCOPY);
        tmpBitmap.PixelFormat := nColors;
        if UseBrightness in FUseFilters then
          if CheckResolution(tmpBitmap) then

            BrightnessEffect(tmpBitmap, FFilterValues.FBrightness)
          else begin
            FUseFilters := FUseFilters - [UseBrightness];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UseContrast in FUseFilters then
          if CheckResolution(tmpBitmap) then
            ContrastEffect(tmpBitmap, FFilterValues.FContrast)
          else begin
            FUseFilters := FUseFilters - [UseContrast];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UseDarkness in FUseFilters then
          if CheckResolution(tmpBitmap) then
            DarknessEffect(tmpBitmap, FFilterValues.FDarkness)
          else begin
            FUseFilters := FUseFilters - [UseDarkness];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UseSaturation in FUseFilters then
          if CheckResolution(tmpBitmap) then
            SaturationEffect(tmpBitmap, FFilterValues.FSaturation)
          else begin
            FUseFilters := FUseFilters - [UseSaturation];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UseColorNoise in FUseFilters then
          if CheckResolution(tmpBitmap) then
            ColorNoiseEffect(tmpBitmap, FFilterValues.FColorNoise)
          else begin
            FUseFilters := FUseFilters - [UseColorNoise];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UseMonoNoise in FUseFilters then
          if CheckResolution(tmpBitmap) then
            MonoNoiseEffect(tmpBitmap, FFilterValues.FMonoNoise)
          else begin
            FUseFilters := FUseFilters - [UseMonoNoise];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UsePosterize in FUseFilters then
          if CheckResolution(tmpBitmap) then
            PosterizeEffect(tmpBitmap, FFilterValues.FPosterize)
          else begin
            FUseFilters := FUseFilters - [UsePosterize];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UseColorAdjust in FUseFilters then
          if CheckResolution(tmpBitmap) then
            ColorAdjustEffect(tmpBitmap,
                              FFilterValues.FRedColor,
                              FFilterValues.FGreenColor,
                              FFilterValues.FBlueColor)
          else begin
            FUseFilters := FUseFilters - [UseColorAdjust];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UseGrayScale in FUseFilters then
          if CheckResolution(tmpBitmap) then
            GrayScaleEffect(tmpBitmap)
          else begin
            FUseFilters := FUseFilters - [UseGrayScale];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        if UseSepia in FUseFilters then
          if CheckResolution(tmpBitmap) then
            SepiaEffect(tmpBitmap)
          else begin
            FUseFilters := FUseFilters - [UseSepia];
            MessageBox(Application.MainForm.Handle, ErrorMsg50, 'Notice',
                       MB_OK or MB_ICONERROR);
            end;
        BitBlt(hMemDC,
               0,
               0,
               Width,
               Height,
               tmpBitmap.Canvas.Handle,
               0,
               0,
               SRCCOPY);
        if UseRotateImage in FUseFilters then begin
          TmBitmap := TBitmap.Create;
          try
            BitBlt(tmpBitmap.Canvas.Handle,
                   0,
                   0,
                   Width,
                   Height,
                   hMemDC,
                   0,
                   0,
                   SRCCOPY);
            TmBitmap.Width  := tmpBitmap.Width;
            TmBitmap.Height := tmpBitmap.Height;
            if TmBitmap.Canvas.TryLock then begin
              try
                TmBitmap.Assign(tmpBitmap);
                TmBitmap.PixelFormat := nColors;
                if FFilterValues.FScreenRotate = RLeft then
                  //Rotate Image to 90 Degree
                  RotateEffect(TmBitmap, tmpBitmap, 90, clBlack);
                if FFilterValues.FScreenRotate = RRight then
                  //Rotate Image to 270 Degree
                  RotateEffect(TmBitmap, tmpBitmap, 270, clBlack);
                if FFilterValues.FScreenRotate = RReverse then
                  //Rotate Image to 180 Degree
                  FlipEffect(tmpBitmap, MT_Reverse);
                if FFilterValues.FScreenRotate = RHorizontal then
                  //Flip Image to Horizontal
                  FlipEffect(tmpBitmap, MT_Horizontal);
                if FFilterValues.FScreenRotate = RVertical then
                  //Flip Image to Vertical
                  FlipEffect(tmpBitmap, MT_Vertical);
                BitBlt(hMemDC,
                       0,
                       0,
                       Width,
                       Height,
                       tmpBitmap.Canvas.Handle,
                       0,
                       0,
                       SRCCOPY);
              finally
                TmBitmap.Canvas.Unlock;
              end;
              end;
          finally
            TmBitmap.Free;
          end;
          end;
      finally
        tmpBitmap.Canvas.Unlock;
      end;
      end;
  finally
    tmpBitmap.Free;
  end;

  if not FEffectToOvelayDraw then
    if Assigned(FOnOverlay) and FOvelayDrawing then
      FOnOverlay(Self, hMemDC, Width, Height);

  case Mode of
    0: begin
         TempImage.Width  := Width;
         TempImage.Height := Height;
         if TempImage.Canvas.TryLock then
           try
             TempImage.PixelFormat := nColors;
             BitBlt(TempImage.Canvas.Handle,
                    0,
                    0,
                    Width,
                    Height,
                    hMemDC,
                    0,
                    0,
                    SRCCOPY);
           finally
             TempImage.Canvas.UnLock;
           end;
         pBM_HEADER := nil;
       end;
    1: begin
         TempImage := nil;
	       pBM_HEADER := GlobalLock(HBitmap2DDB(hbm, Bits));
       end;
    2: begin
         TempImage.Width  := Width;
         TempImage.Height := Height;
         if TempImage.Canvas.TryLock then
           try
             TempImage.PixelFormat := nColors;
             BitBlt(TempImage.Canvas.Handle,
                    0,
                    0,
                    Width,
                    Height,
                    hMemDC,
                    0,
                    0,
                    SRCCOPY);
           finally
             TempImage.Canvas.UnLock;
           end;
	       pBM_HEADER := GlobalLock(HBitmap2DDB(hbm, Bits));
       end;
  end;
  ReleaseDC(hDesktop, hScreenDC);
  DeleteDC(hMemDC);
	DeleteObject(hbm);
  Result := pBM_HEADER;
end;

function TScreenCamera.GetAudioInputsNames: TStringList;
var
  I, J, Index : Integer;
  AudioMixer  : TAudioMixer;
begin
  FAudioInputNames.Clear;
  AudioMixer := TAudioMixer.Create(Self);
  try
    for I := 0 to AudioMixer.MixerCount - 1 do begin
      AudioMixer.MixerID := I;
      if LowerCase(AudioMixer.DestinationName) = 'recording control' then
        Index := I;
      end;
    AudioMixer.MixerID := Index;

    SetLength(FAudioInfo, AudioMixer.Master.Mixer.LineCount + 1);

    for I := 0 to AudioMixer.Master.Mixer.LineCount - 1 do begin
       AudioMixer.DestinationID := I;
       FAudioInfo[I].AudioInputName := AudioMixer.Master.Mixer.Lines[I].Name;
       FAudioInfo[I].AudioInputVolume := AudioMixer.Master.Mixer.Lines[I].Volume;
       FAudioInfo[I].AudioInputEnabled := mcVolume in AudioMixer.Master.Mixer.Lines[I].AvailableControls;
       FAudioInputNames.Add(AudioMixer.Master.Mixer.Lines[I].Name);
       end;

    FAudioInputNames.Add(AudioMixer.Master.Name);
    FAudioInfo[High(FAudioInfo)].AudioInputName := AudioMixer.Master.Name;
    FAudioInfo[High(FAudioInfo)].AudioInputVolume := AudioMixer.Master.Volume;
    FAudioInfo[High(FAudioInfo)].AudioInputEnabled := mcVolume in AudioMixer.Master.AvailableControls;

    if (mcSelect in AudioMixer.Master.AvailableControls) then
      FAudioInputIndex := AudioMixer.Master.SelectedLine
    else
      FAudioInputIndex := High(FAudioInfo);

    finally
      AudioMixer.Free;
    end;
    Result := FAudioInputNames;
end;

procedure TScreenCamera.SetAudioInput(InputName: string);
var
  I,
  _Index     : Integer;
  AudioMixer : TAudioMixer;
begin
  AudioMixer := TAudioMixer.Create(Self);
  try
    for I := 0 to AudioMixer.MixerCount - 1 do begin
      AudioMixer.MixerID := I;
      if LowerCase(AudioMixer.DestinationName) = 'recording control' then
        _Index := I;
      end;
    AudioMixer.MixerID := _Index;
    for I := 0 to AudioMixer.Master.Mixer.LineCount - 1 do begin
      AudioMixer.DestinationID := I;
      if AudioMixer.Master.Mixer.Lines[I].Name = InputName then begin
        AudioMixer.Master.SelectedLine := I;
        FAudioInputIndex := I;
        end
      else
        if AudioMixer.Master.Name = InputName then begin
          AudioMixer.Master.SelectedLine := High(FAudioInfo);
          FAudioInputIndex := High(FAudioInfo);
          end;
      end;
   finally
     AudioMixer.Free;
   end;
end;

procedure TScreenCamera.SetAudioInputVolume(InputName: string; Volume: Integer);
var
  I,
  _Index     : Integer;
  AudioMixer : TAudioMixer;
begin
  AudioMixer := TAudioMixer.Create(Self);
  try
    for I := 0 to AudioMixer.MixerCount - 1 do begin
      AudioMixer.MixerID := I;
      if LowerCase(AudioMixer.DestinationName) = 'recording control' then
        _Index := I;
      end;
    AudioMixer.MixerID := _Index;
    for I := 0 to AudioMixer.Master.Mixer.LineCount - 1 do begin
      AudioMixer.DestinationID := I;
      if AudioMixer.Master.Mixer.Lines[I].Name = InputName then begin
        AudioMixer.Master.Mixer.Lines[I].Volume := Volume;
        FAudioInfo[I].AudioInputVolume := Volume;
        end
      else
        if AudioMixer.Master.Name = InputName then begin
          AudioMixer.Master.Volume := Volume;
          FAudioInfo[High(FAudioInfo)].AudioInputVolume := Volume;
          end;
      end;
  finally
    AudioMixer.Free;
  end;
end;

function TScreenCamera.GetAudioFormatsInfo: TStringList;
var
  pcm                : TPCMFormat;
  WaveFormatEx       : TWaveFormatEx;
  StockAudioRecorder : TStockAudioRecorder;
begin
  StockAudioRecorder := TStockAudioRecorder.Create(Self);
  try
    FAudioFormatList.Clear;
    for pcm := Succ(Low(TPCMFormat)) to High(TPCMFormat) do begin
      SetPCMAudioFormatS(@WaveFormatEx, pcm);
      FAudioFormatList.Add(GetWaveAudioFormat(@WaveFormatEx));
      end;
    if FAudioFormatsIndex = -1 then
      FAudioFormatsIndex := Ord(StockAudioRecorder.PCMFormat) - 1;
  finally
    StockAudioRecorder.Free;
  end;
  Result := FAudioFormatList;
end;

function TScreenCamera.GetVideoCompressorsInfo: TStringList;
var
  ICV    : HIC;
 	Source : PBitmapInfoHeader;
  I      : Integer;
  mImage : TBitmap;
begin
  mImage := TBitmap.Create;
  try
    Source := CaptureScreenFrame(1,
                                 mImage,
                                 FScreenArea.FScreenLeft,
                                 FScreenArea.FScreenTop,
                                 FScreenArea.FScreenWidth,
                                 FScreenArea.FScreenHeight,
                                 UseReverseColor in FUseFilters);
    FVideoCompressorCount := 0;
    FVideoCodecList.Clear;
    for I := 0 to 50 do begin
     	ICInfo(ICTYPE_VIDEO,
             I,
             @FVideoCompressorInfo[FVideoCompressorCount]);
   		ICV := ICOpen(FVideoCompressorInfo[FVideoCompressorCount].fccType,
                    FVideoCompressorInfo[FVideoCompressorCount].fccHandler,
                    ICMODE_QUERY);
  		if (ICV <> 0) then begin
	  		if (ICCompressQuery(ICV, Source, nil) = ICERR_OK) then begin
		  		ICGetInfo(ICV,
                    @FVideoCompressorInfo[FVideoCompressorCount],
                    SizeOf(TICINFO));
      		Inc(FVideoCompressorCount);
          end;
		  	ICClose(ICV);
        end;
      end;
    for I := 0 to FVideoCompressorCount - 1 do
      FVideoCodecList.Add(FVideoCompressorInfo[I].szDescription);
  finally
    mImage.Free;
  end;
	FreeFrame(Source);
  Result := FVideoCodecList;
end;

function TScreenCamera.RecordVideo(szFileName: WideString): Integer;
var
	alpbi          : PBitmapInfoHeader;
	strhdr         : TAVISTREAMINFO;
	pfile          : PAVIFile;
	ps,
  psCompressed   : PAVIStream;
  opts           : TAVICOMPRESSOPTIONS;
	Option         : PAVICOMPRESSOPTIONS;
	hr             : HRESULT;
  wVer           : WORD;
	szTitle        : String;
  ic             : HIC;
  fTime,
  fTimeBeginPause,
  fTimePause,
  fTotalTimePauses,
  pTime,
  FrameRate,
  InitialTime,
 	TimeExpended,
  OldFrameTime,
  OldTime,
  OldUpdateTime  : Extended;
  InfoImageSize,
  N,
  align,
  I,
  hm,
  wm,
  OldComputedFrameNo,
  newleft,
  newtop,
  newwidth,
  newheight      : Integer;
  CapturedFrame  : Boolean;
  mImage         : TBitmap;
  RemindTime     : THMSM;
  StockAudioRecorder : TStockAudioRecorder;

label Error;

begin
  mImage := TBitmap.Create;
	wVer := HIWORD(VideoForWindowsVersion);
	if (wVer < $010a) then begin
    if Assigned(FOnError) then FOnError(Self, ErrorMsg4);
    RecordState := False;
    FSuccess    := Fail;
    if Assigned(FOnStop) then FOnStop(Self);
    if not FShowPreview then begin
      if Assigned(FFrame) then
        ShowWindow(FFrame.Handle, SW_HIDE);
      if Assigned(FPreviewTimer) then begin
        FPreviewTimer.Enabled := False;
        end;
      end;
		Result := 0;
    if FRestore then
      Application.Restore;
    mImage.Free;
    Exit;
    end;

	alpbi := CaptureScreenFrame(1,
                              mImage,
                              FScreenArea.FScreenLeft,
                              FScreenArea.FScreenTop,
                              FScreenArea.FScreenWidth,
                              FScreenArea.FScreenHeight,
                              UseReverseColor in FUseFilters);

  if alpbi = nil then begin
    mImage.Free;
    FreeFrame(alpbi);
    if Assigned(FOnError) then FOnError(Self, ErrorMsg5);
    Result := 0;
    FSuccess := Fail;
    RecordState := False;
    if Assigned(FOnStop) then FOnStop(Self);
    if FRestore then
      Application.Restore;
    Exit;
    end;

  StrCodec := 'No Compressor';
  if ((FRecordType = CompressOnFly) or (FRecordType = CompressAfterRecord)) and
     (FSelectedCompressor <> -1) and (not FSelCodecRepeat) then begin
		ic := ICOpen(FVideoCompressorInfo[FSelectedCompressor].fccType,
                 FVideoCompressorInfo[FSelectedCompressor].fccHandler,
                 ICMODE_QUERY);
		if (ic <> 0) then begin
      align := 1;
			while (ICCompressQuery(ic, alpbi, nil) <> ICERR_OK) do begin
				align := align * 2;
				if (align > 8) then Break;

				newleft := FScreenArea.FScreenLeft;
				newtop  := FScreenArea.FScreenTop;
				wm      := (FScreenArea.FScreenWidth mod align);
				if (wm > 0) then begin
					newwidth := FScreenArea.FScreenWidth + (align - wm);
          FScreenArea.SetScreenWidth(newwidth);
					if (newwidth > MaxXScreen) then
						newwidth := FScreenArea.FScreenWidth - wm;
				  end;

				hm := (FScreenArea.FScreenHeight mod align);
				if (hm > 0) then begin
					newheight := FScreenArea.FScreenHeight + (align - hm);
          FScreenArea.SetScreenHeight(newheight);
					if (newheight > MaxYScreen) then
						newwidth := FScreenArea.FScreenHeight - hm;
  				end;

        FreeFrame(alpbi);
 				alpbi := CaptureScreenFrame(1,
                                    mImage,
                                    newleft,
                                    newtop,
                                    newwidth,
                                    newheight,
                                    UseReverseColor in FUseFilters);

        if alpbi = nil then begin
          mImage.Free;
          FreeFrame(alpbi);
          if Assigned(FOnError) then FOnError(Self, ErrorMsg5);
          Result := 0;
          FSuccess := Fail;
          RecordState := False;
          if Assigned(FOnStop) then FOnStop(Self);
          if FRestore then
            Application.Restore;
          Exit;
          end;
        end;


		  if (align = 1) then begin

        CompfccHandler := FVideoCompressorInfo[FSelectedCompressor].fccHandler;
        StrCodec       := FVideoCompressorInfo[FSelectedCompressor].szName;
	  		ICClose(ic);
		  	end
      else if (align <= 8) then begin
		  	FScreenArea.FScreenLeft := newleft;
  			FScreenArea.FScreenTop  := newtop;
	  		FScreenArea.SetScreenWidth(newwidth);
		  	FScreenArea.SetScreenHeight(newheight);
        CompfccHandler := FVideoCompressorInfo[FSelectedCompressor].fccHandler;
        StrCodec       := FVideoCompressorInfo[FSelectedCompressor].szName;
	  		ICClose(ic);
		    end
      else begin
      	if (MessageBox(Application.MainForm.Handle, ErrorMsg7, 'Notice',
                       MB_YESNO or MB_ICONEXCLAMATION) = IDYES) then begin
  		    CompfccHandler  := FourCC;
          StrCodec        := 'MS Video Codec';
   	  		ICClose(ic);
          FSelCodecRepeat := True;
          end
        else begin
          mImage.Free;
          FreeFrame(alpbi);
          if Assigned(FOnError) then FOnError(Self, ErrorMsg8);
          RecordState := False;
          FSuccess    := Fail;
          if Assigned(FOnStop) then FOnStop(Self);
          if not FShowPreview then begin
            if Assigned(FOnPreview) then
              FOnPreview(Self, nil, False, False);
            if Assigned(FFrame) then
              ShowWindow(FFrame.Handle, SW_HIDE);
            if Assigned(FPreviewTimer) then begin
              FPreviewTimer.Enabled := False;
              end;
            end;
          ICClose(ic);
     	    Result := 0;
          if FRestore then
            Application.Restore;
          Exit;
          end;
  			end;
		  end
    else begin
      if (MessageBox(Application.MainForm.Handle, ErrorMsg9, 'Notice',
                     MB_YESNO or MB_ICONEXCLAMATION) = IDYES) then begin
        CompfccHandler  := FourCC;
        StrCodec        := 'MS Video Codec';
 	  		ICClose(ic);
        FSelCodecRepeat := True;
        end
      else begin
        mImage.Free;
        FreeFrame(alpbi);
        if Assigned(FOnError) then FOnError(Self, ErrorMsg8);
        RecordState := False;
        FSuccess    := Fail;
        if Assigned(FOnStop) then FOnStop(Self);
        if not FShowPreview then begin
          if Assigned(FOnPreview) then
            FOnPreview(Self, nil, False, False);
          if Assigned(FPreviewTimer) then begin
            FPreviewTimer.Enabled := False;
            end;
          if Assigned(FFrame) then
            ShowWindow(FFrame.Handle, SW_HIDE);
          end;
	  		ICClose(ic);
 	      Result := 0;
        if FRestore then
          Application.Restore;
        Exit;
        end;
	  	end;
	  end
  else begin
    if ((FRecordType = CompressOnFly) or
        (FRecordType = CompressAfterRecord)) and
       (not FSelCodecRepeat) then begin
      if (MessageBox(Application.MainForm.Handle, ErrorMsg10,
                     'Open Audio/Video Settings !', MB_YESNO or MB_ICONEXCLAMATION) = IDYES) then begin
 	      CompfccHandler  := FourCC;
        StrCodec        := 'MS Video Codec';
        FSelCodecRepeat := True;
        end
      else begin
        mImage.Free;
        FreeFrame(alpbi);
        if Assigned(FOnError) then FOnError(Self, ErrorMsg8);
        RecordState := False;
        FSuccess    := Fail;
        if Assigned(FOnStop) then FOnStop(Self);
        if not FShowPreview then begin
          if Assigned(FOnPreview) then
            FOnPreview(Self, nil, False, False);
          if Assigned(FPreviewTimer) then begin
            FPreviewTimer.Enabled := False;
            end;
          if Assigned(FFrame) then
            ShowWindow(FFrame.Handle, SW_HIDE);
          end;
     	  Result := 0;
        if FRestore then
          Application.Restore;
        Exit;
        end;
      end;
    end;
	AVIFileInit;

  if not PowerDeleteFile(TempVideoFile) then begin
    mImage.Free;
    // Free memory
    FreeFrame(alpbi);
    if Assigned(FOnError) then FOnError(Self, ErrorMsg11);
    hr := 1;
    goto Error;
    end;

	// Open the movie file for writing....
	hr := AVIFileOpenW(pfile,
                     {$IFDEF VERSION14}TempVideoFile,
                     {$ELSE}PWideChar(TempVideoFile),
                     {$ENDIF}
                     OF_WRITE or OF_CREATE, nil);
	if (hr <> AVIERR_OK) then begin
    mImage.Free;
    // Free memory
    FreeFrame(alpbi);
    if Assigned(FOnError) then FOnError(Self, ErrorMsg12);
    goto Error;
    end;

  FillChar(strhdr, SizeOf(strhdr), 0);
	strhdr.fccType   := streamtypeVIDEO;        // stream type
  if FRecordType = CompressOnFly then
   	strhdr.fccHandler := CompfccHandler       // selected video codec
  else
   	strhdr.fccHandler := 0;                   // non selected video codec
	strhdr.dwScale   := 1;                      // no time scaling
  strhdr.dwQuality := FCompressionQuality;    // Compress quality 0-10,000
	strhdr.dwRate    := FPlaybackFPS;           // set playback rate in fps
	strhdr.dwFlags   := AVICOMPRESSF_VALID or
                      AVICOMPRESSF_KEYFRAMES; // flags
  for I := 0 to High(strhdr.szName) do
    strhdr.szName[I] := WideChar(FVideoCompressorInfo[FSelectedCompressor].szName[I]);
	strhdr.dwSuggestedBufferSize := alpbi^.biSizeImage;
	SetRect(strhdr.rcFrame,                       // rectangle for stream
          0,
          0,
	        alpbi^.biWidth,
	        alpbi^.biHeight);

	// INIT AVI STREAM
  AVIStreamInit;

	// And create the stream;
	hr := AVIFileCreateStream(pfile,	ps, @strhdr); // returns ps as uncompressed stream pointer
	if (hr <> AVIERR_OK) then	begin
    mImage.Free;
    FreeFrame(alpbi);
    if Assigned(FOnError) then FOnError(Self, ErrorMsg13);
    goto Error;
    end;

  FillChar(opts, SizeOf(opts), 0);
  LongWord(Option)          := LongWord(@opts);
	Option^.fccType	          := streamtypeVIDEO;        // Stream type
  if FRecordType = CompressOnFly then
    Option^.fccHandler      := CompfccHandler          // Selected video codec
  else
    Option^.fccHandler      := 0;                      // Selected video codec
	Option^.dwKeyFrameEvery	  := FKeyFramesEvery;        // Keyframe rate
	Option^.dwQuality         := FCompressionQuality;    // Compress quality 0-10,000
	Option^.dwBytesPerSecond  := 0; 	                   // Bytes per second
	Option^.dwFlags	          := AVICOMPRESSF_VALID or
                               AVICOMPRESSF_KEYFRAMES; // Flags
	Option^.lpFormat          := $00;                    // Save format
	Option^.cbFormat          := 0;
	Option^.dwInterleaveEvery := 0;	                     // For non-video streams only

	hr := AVIMakeCompressedStream(psCompressed,
                                ps,
                                @opts,
                                nil);

	if (hr <> AVIERR_OK) then	begin
    mImage.Free;
    FreeFrame(alpbi);
    if Assigned(FOnError) then FOnError(Self, ErrorMsg14);
    goto Error;
    end;

  if alpbi^.biBitCount <= 8 then
    InfoImageSize := alpbi^.biSize + alpbi^.biClrUsed * SizeOf(RGBQUAD)
  else
    InfoImageSize := alpbi^.biSize;
	hr := AVIStreamSetFormat(psCompressed,
                           0,
    	                     alpbi,
			                     InfoImageSize);
 	FreeFrame(alpbi);

	if (hr <> AVIERR_OK) then begin
    mImage.Free;
    if Assigned(FOnError) then FOnError(Self, ErrorMsg16);
    goto Error;
    end;

  if Assigned(FOnStart) then FOnStart(Self);

  StockAudioRecorder := TStockAudioRecorder.Create(Self);
  if FAudioRecord then begin
    StockAudioRecorder.PCMFormat := TPCMFormat(FAudioFormatsIndex + 1);
    StockAudioRecorder.Async     := True;
    if not PowerDeleteFile(TempAudioFile) then begin
      mImage.Free;
      if Assigned(FOnError) then FOnError(Self, ErrorMsg17);
      hr := 1;
      goto Error;
      end;
    StockAudioRecorder.RecordToFile(TempAudioFile);
    end;

  mImage.Free;
  FreeFrame(alpbi);

  Hur                 := 0;
  Min                 := 0;
  Sec                 := 0;
  Mil                 := 0;
  OldUpdateTime       := 0;
	OldComputedFrameNo  := -1;
  FActualFrameNo      := 0;
  FRealCapturingFPS   := 0;
  FSkippedFrames      := 0;
  pTime               := 10;
  fTimeBeginPause     := 0;
  fTimePause          := 0;
  fTotalTimePauses    := 0;
  OldFrameTime        := TimeGetTime {GetTickCount};
  OldTime             := TimeGetTime {GetTickCount};
	InitialTime         := TimeGetTime {GetTickCount};


 	while (RecordState) do begin // Repeatedly loop
    // Pause recording
    if FPauseRecording then
      begin
        if Assigned(FOnPause) then FOnPause(Self);
        fTimeBeginPause := TimeGetTime;
        while RecordState and FPauseRecording do begin
          fTimePause := TimeGetTime - fTimeBeginPause {GetTickCount};
          end;
        fTotalTimePauses := fTotalTimePauses + fTimePause;
        if Assigned(FOnResume) then FOnResume(Self);
      end;

    CapturedFrame := False;
    // TimeExpended = time of spend for geting a frame of screen in ms
    TimeExpended  := TimeGetTime {GetTickCount} - (InitialTime + fTotalTimePauses);

    mImage := TBitmap.Create;
    alpbi  := CaptureScreenFrame(2,
                                 mImage,
                                 FScreenArea.FScreenLeft,
                                 FScreenArea.FScreenTop,
                                 FScreenArea.FScreenWidth,
                                 FScreenArea.FScreenHeight,
                                 UseReverseColor in FUseFilters);

    if alpbi = nil then begin
      if Assigned(mImage) then
        mImage.Free;
      // Free memory
     	FreeFrame(alpbi);
      if Assigned(FOnError) then FOnError(Self, ErrorMsg5);
      Break;
      end;

    FComputedFrameNo := Round(TimeExpended / FMSPFRecord); // loop duty - time syncronous

    if (FComputedFrameNo - OldComputedFrameNo) > 1 then
      Inc(FSkippedFrames, ((FComputedFrameNo - OldComputedFrameNo) - 1));

    // (video start) or (new loop=(keyframe) necessary) ?
    if FComputedFrameNo > OldComputedFrameNo then begin
      pTime := TimeGetTime {GetTickCount};

      if alpbi^.biBitCount <= 8 then
        InfoImageSize := alpbi^.biSize + alpbi^.biClrUsed * SizeOf(RGBQUAD)
      else
        InfoImageSize := alpbi^.biSize;

	    // if frameno repeats...the avistreamwrite will cause an error
      hr := AVIStreamWrite(psCompressed,           // stream pointer
        	                 FComputedFrameNo,	     // number this frame
                           1,			         	       // number to write
                           PByte(LongWord(alpbi) + // pointer to data
                           InfoImageSize),
                           alpbi^.biSizeImage,	   // size of this frame
                           AVIIF_KEYFRAME,		  	 // flags....
                           nil,
                           nil);

      if (hr <> AVIERR_OK) then begin
        if Assigned(mImage) then
          mImage.Free;
        // Free memory
        FreeFrame(alpbi);
        if Assigned(FOnError) then FOnError(Self, ErrorMsg19);
        Break;
        end;

      Inc(FActualFrameNo); // just a counter
      OldComputedFrameNo := FComputedFrameNo;

      CapturedFrame := True;

      // Current captured frames at one second...
      fTime := TimeGetTime - fTotalTimePauses {GetTickCount};
      if (fTime - OldFrameTime) > 0 then
        FrameRate := (1000 / (fTime - OldFrameTime));
      if FrameRate <= FPlaybackFPS then
        FCurrentCapturedFPS := FrameRate
      else
        FCurrentCapturedFPS := FPlaybackFPS;
      // Initialize old frame time status
      OldFrameTime := fTime;

      pTime := TimeGetTime {GetTickCount} - pTime;
      end;

    if mImage.Canvas.TryLock then
      begin
        try
          if FOnRecordPreview then
            if Assigned(FOnPreview) then
              FOnPreview(Self, mImage, True, True);
        finally
          mImage.Canvas.UnLock;
        end;
      end;

    if Assigned(mImage) then
      mImage.Free;
    // Free memory
    FreeFrame(alpbi);

    RemindTime := MilliSecond2Time(TimeExpended);
    Hur := RemindTime.Hour;
    Min := RemindTime.Minute;
    Sec := RemindTime.Second;
    Mil := RemindTime.MilliSecond;

    FElapsedTime := IntToStr(Hur) + ' : ' +
                    IntToStr(Min) + ' : ' +
                    IntToStr(Sec) + ' : ' +
                    IntToStr(Mil);

    if FTimerRecord.TimerON then
      if ((FTimerRecord.Hour > 0)   or
          (FTimerRecord.Min  > 0)   or
          (FTimerRecord.Sec  > 0))  and
         ((Hur = FTimerRecord.Hour) and
          (Min = FTimerRecord.Min)  and
          (Sec = FTimerRecord.Sec)) then
         StopRecording;

    // Real capturing frames at one second...
    fTime := TimeGetTime - fTotalTimePauses {GetTickCount};
    if (fTime - OldTime) > 0 then begin
      if CapturedFrame then
        FRealCapturingFPS := (1000 / (fTime - OldTime))
      else
        FRealCapturingFPS := (1000 / ((fTime - OldTime) + pTime));
      end;
    // Initialize old time status
    OldTime := fTime;

    // Update record stats
    if (TimeExpended > OldUpdateTime + FUpdateRate) then begin
      OldUpdateTime := TimeExpended;
      if Assigned(FOnUpdate) then FOnUpdate(Self); // user event for current status
      end;
	  end;

  // ========================= recording loop ends =============================

Error:

  if Assigned(FOnStop) then FOnStop(Self);

  if Assigned(Option) then
    AVISaveOptionsFree(1, Option);

	if Assigned(ps) then
    AVIStreamRelease(ps);

  if Assigned(psCompressed) then
    AVIStreamRelease(psCompressed);

	if Assigned(pfile) then
    AVIFileRelease(pfile);

  if FAudioRecord and StockAudioRecorder.Active then begin
    // Stop audio recording
    StockAudioRecorder.Active := False;
    StockAudioRecorder.Stop;
    end;
  StockAudioRecorder.Free;

  if FRestore then
    Application.Restore;

  if (hr = AVIERR_OK) and (FSuccess = Success) then begin
    TempCompressed[0] := nil; // Video temp stream
    TempCompressed[1] := nil; // Audio temp stream

    // Extract video temp stream to TempCompressed[0]
    LoadAVIFileToStream(TempVideoFile, TempCompressed[0]);

    if FAudioRecord then
      // Extract audio temp stream to TempCompressed[1]
      LoadAVIFileToStream(TempAudioFile, TempCompressed[1]);

    // N = Number of streams { Video(0)-Audio(1) }
    if Assigned(TempCompressed[1]) then N := 2 else N := 1;

    // Save all streams to final file
    if Assigned(TempCompressed[0]) or Assigned(TempCompressed[1]) then
      SavingSuccess := FinalSaveAvi(szFileName, N, TempCompressed);

    // Release all streams
    if Assigned(TempCompressed[0]) then
      AVIStreamRelease(TempCompressed[0]);
    if Assigned(TempCompressed[1]) then
      AVIStreamRelease(TempCompressed[1]);
    end;

  AVIStreamExit;
 	AVIFileExit;

	if (hr <> AVIERR_OK) then begin
 		if (FRecordType = CompressOnFly) and (CompfccHandler <> FourCC)	then begin
			if (IDYES = MessageBox(Application.MainForm.Handle, PChar(ErrorMsg9), 'Notice',
                                MB_YESNO or MB_ICONEXCLAMATION)) then begin
				CompfccHandler  := FourCC;
        StrCodec        := 'MS Video Codec';
        // indicate to restart recording...
        FSuccess        := Fail;
        Result          := -1;
        FSelCodecRepeat := True;
			  end
      else begin
        if Assigned(FOnError) then FOnError(Self, ErrorMsg8);
        if not FShowPreview then begin
          if Assigned(FOnPreview) then
            FOnPreview(Self, nil, False, False);
          if Assigned(FPreviewTimer) then begin
            FPreviewTimer.Enabled := False;
            end;
          if Assigned(FFrame) then
            ShowWindow(FFrame.Handle, SW_HIDE);
          end;
        // indicate to cancel recording...
        FSuccess := Fail;
        RecordState := False;
        if Assigned(FOnStop) then FOnStop(Self);
        Result   := 0;
        FSelCodecRepeat := False;
        if FRestore then
          Application.Restore;
        end;
		  end
    else begin
      if Assigned(FOnError) then FOnError(Self, ErrorMsg20);
      if not FShowPreview then begin
        if Assigned(FOnPreview) then
          FOnPreview(Self, nil, False, False);
        if Assigned(FPreviewTimer) then begin
          FPreviewTimer.Enabled := False;
          end;
        if Assigned(FFrame) then
          ShowWindow(FFrame.Handle, SW_HIDE);
        end;
      // indicate to cancel recording...
      FSuccess := Fail;
      RecordState := False;
      if Assigned(FOnStop) then FOnStop(Self);
      Result := 0;
      FSelCodecRepeat := False;
      if FRestore then
        Application.Restore;
      end;
    Exit;
    end;

  FSelCodecRepeat := False;
	//Save the file on success
  Result := 1;
end;

procedure TScreenCamera.StopRecording;
begin
  FSuccess := Success;
  RecordState := False;
  FPauseRecording := False;
  if not FShowPreview then
    SetShowPreview(False)
  else
    SetShowPreview(True);
end;

procedure TScreenCamera.PauseRecording;
begin
  FPauseRecording := True;
end;

procedure TScreenCamera.ResumeRecording;
begin
  if FPauseRecording then
    FPauseRecording := False;
end;

function TScreenCamera.StartRecording(szFileName: String): Boolean;
begin
  if RecordState then begin
    Result := False;
    Exit; // exit if still recording
    end;
  FFileName := szFileName;
  if FMinimize then
    Application.Minimize;
  case FScreenArea.FScreenRegion of
    SelObject  : begin
                   FSelectObject := True;
                   FFreeHandMode := False;
                   FAutoPan      := False;
                   FFullScreen   := False;
                 end;
    FreeHand   : begin
                   FSelectObject := False;
                   FFreeHandMode := True;
                   FAutoPan      := False;
                   FFullScreen   := False;
                 end;
    FixedMoving: begin
                   FSelectObject := False;
                   FFreeHandMode := False;
                   FAutoPan      := True;
                   FFullScreen   := False;
                 end;
    FixedStable: begin
                   FSelectObject := False;
                   FFreeHandMode := False;
                   FAutoPan      := False;
                   FFullScreen   := False;
                 end;
    FullScreen : begin
                   FSelectObject := False;
                   FFreeHandMode := False;
                   FAutoPan      := False;
                   FFullScreen   := True;
                 end;
    end;
  if not Assigned(FPreviewTimer) then begin
    FPreviewTimer := THighTimer.Create(Self);
    FPreviewTimer.OnTimer := FShowPreviewTimer;
    FPreviewTimer.ThreadPriority := FPriority;
    FPreviewTimer.Synchronize := True;
    FPreviewTimer.UseThread := True;
    end;
  FPreviewTimer.Interval := 1000 div FPlaybackFPS;
  FPreviewTimer.Enabled := True;
  if FFreeHandMode or FSelectObject then begin
    StartRegionSel := True;
    Result         := False;
    Exit; // exit if region selecting
    end;
  StartRegionSel := False;
  if FFullScreen then
    SetSizeFullScreen;
  FRecordAVIThread := TRecordAVIThread.Create(Self);
  FRecordAVIThread.OnTerminate := ThreadDone;
  SetPriority(FPriority);
  RecordState := True;
  Result      := True;
end;

// message from thread informing that it is done
procedure TScreenCamera.ThreadDone(Sender: TObject);
begin
  RecordState      := False;
  FRecordAVIThread := nil;
end;

function SaveCallBack(nPercent: Integer): LONG; stdcall;
var
  C : Boolean;
begin
  Result := 0;
  if Assigned(SC) then begin
    if Assigned(SC.OnSaving) then begin
      C := True;
      SC.OnSaving(SC, nPercent, SavingMsg, C);
      if not C then
        Result := -1;
      end;
    end;  
end;

function TScreenCamera.FinalSaveAvi(const FileName: WideString;
         nStreams: Integer; Streams: APAVISTREAM): Boolean;
var
  AVIERR    : Cardinal;
  ErrMess   : string;
  ComOpt    : APAVICOMPRESSOPTIONS;
  Opts      : TAVICOMPRESSOPTIONS;
  OldCursor : TCursor;
begin
  case FRecordType of
    CompressOnFly,
    NoCompress : ComOpt[0] := nil;
    CompressAfterRecord :
      begin
        FillChar(Opts, SizeOf(Opts), 0);
        LongWord(ComOpt[0])          := LongWord(@Opts);
        ComOpt[0]^.fccType           := streamtypeVIDEO;        // Stream type
        ComOpt[0]^.fccHandler        := CompfccHandler;         // Selected video codec;
        ComOpt[0]^.dwKeyFrameEvery   := FKeyFramesEvery;        // Keyframe rate
        ComOpt[0]^.dwQuality         := FCompressionQuality;    // Compress quality 0-10,000
        ComOpt[0]^.dwBytesPerSecond  := 0; 	                    // Bytes per second
        ComOpt[0]^.dwFlags           := AVICOMPRESSF_VALID or
                                        AVICOMPRESSF_KEYFRAMES; // Flags
        ComOpt[0]^.lpFormat          := $00;                    // Save format
        ComOpt[0]^.cbFormat          := 0;
        ComOpt[0]^.dwInterleaveEvery := 0;	                    // For non-video streams only
      end;
  end;
  ComOpt[1] := nil;

  // If already exist video file try to delete it
  if not PowerDeleteFile(FileName) then begin
    if Assigned(FOnError) then FOnError(Self, ErrorMsg21);
    Result := False;
    Exit;
    end;

  OldCursor := Screen.Cursor;
  Screen.Cursor := crAppStart;
  AVIERR := AVISaveVW({$IFDEF VERSION14}FileName,
                      {$ELSE}PWideChar(FileName),
                      {$ENDIF}      // File name
                      nil,          // File handler
                      SaveCallBack, // Callback
                      nStreams,     // Number of streams
                      Streams,      // Audio/Video streams
                      ComOpt);      // Compress options for Streams
  Screen.Cursor := OldCursor;

  ErrMess := '';
  case AVIERR of
      AVIERR_OK:
            begin
              Result := True;
              Exit;
            end;
      AVIERR_UNSUPPORTED:
          ErrMess := ErrorMsg22;
      AVIERR_BADFORMAT:
          ErrMess := ErrorMsg23;
      AVIERR_FILEREAD:
          ErrMess := ErrorMsg24;
      AVIERR_FILEWRITE:
          ErrMess := ErrorMsg25;
      AVIERR_MEMORY:
          ErrMess := ErrorMsg26;
      AVIERR_INTERNAL:
          ErrMess := ErrorMsg27;
      AVIERR_BADFLAGS:
          ErrMess := ErrorMsg28;
      AVIERR_BADPARAM:
          ErrMess := ErrorMsg29;
      AVIERR_BADSIZE:
          ErrMess := ErrorMsg30;
      AVIERR_BADHANDLE:
          ErrMess := ErrorMsg31;
      AVIERR_FILEOPEN:
          ErrMess := ErrorMsg32;
      AVIERR_COMPRESSOR:
          ErrMess := ErrorMsg33;
      AVIERR_NOCOMPRESSOR:
          ErrMess := ErrorMsg34;
      AVIERR_READONLY:
          ErrMess := ErrorMsg35;
      AVIERR_NODATA:
          ErrMess := ErrorMsg36;
      AVIERR_BUFFERTOOSMALL:
          ErrMess := ErrorMsg37;
      AVIERR_CANTCOMPRESS:
          ErrMess := ErrorMsg38;
      AVIERR_USERABORT:
          ErrMess := ErrorMsg39;
      AVIERR_ERROR:
          ErrMess := ErrorMsg40;
      else
        ErrMess   := ErrorMsg41 + IntToStr(AVIERR);
      end;
  if ErrMess <> '' then begin
    if Assigned(FOnError) then FOnError(Self, ErrMess);
    if Assigned(FOnStop) then FOnStop(Self);
    Result := False;
    end;
end;

procedure TScreenCamera.LoadAVIFileToStream(const FileName: WideString;
          var TempAVIStream: PAVIStream);
var
   InputFile : PAVIFILE;
   hr        : Integer;
   Msg       : String;
begin
   // Open the video or audio file.
   if FileExists(FileName) then begin
     hr := AVIFileOpenW(InputFile,
                        {$IFDEF VERSION14}FileName,
                        {$ELSE}PWideChar(FileName),
                        {$ENDIF}
                        OF_READ,
                        nil);
     case hr of
        AVIERR_OK           : Msg := '';
        AVIERR_BADFORMAT    : Msg := ErrorMsg42;
        AVIERR_MEMORY       : Msg := ErrorMsg43;
        AVIERR_FILEREAD     : Msg := ErrorMsg44;
        AVIERR_FILEOPEN     : Msg := ErrorMsg45;
        REGDB_E_CLASSNOTREG : Msg := ErrorMsg46;
        else                  Msg := ErrorMsg47;
     end;
     if Msg <> '' then
       if Assigned(FOnError) then FOnError(Self, Msg);
     // Open the stream.
     try
       if (AVIFileGetStream(InputFile, TempAVIStream, 0, 0) <> AVIERR_OK) then
         if Assigned(FOnError) then FOnError(Self, ErrorMsg48);
     finally
         AviFileRelease(InputFile);
       end;
     end;
end;

constructor TRecordAVIThread.Create(ScrCam: TScreenCamera);
begin
  inherited Create(False);
  FScrCam := ScrCam;
  FreeOnTerminate := True;
end;

procedure TRecordAVIThread.Execute;
var
  Res      : Integer;
  Variable : Boolean;
  function IsDirectory(const DirName: string): Boolean;
  var
    Attr: Integer;
  begin
    Attr := SysUtils.FileGetAttr(DirName);
    Result := (Attr <> -1) and (Attr and SysUtils.faDirectory = SysUtils.faDirectory);
  end;
begin
  if IsDirectory(ExtractFilePath(FFileName)) then begin
    repeat
      Res := FScrCam.RecordVideo(FFileName);
    until not (Res = -1);
    Variable := True;
    if SavingSuccess then
      if Assigned(SC) then
        if Assigned(SC.OnSaving) then
          SC.OnSaving(SC, 100, SavingSuccessMsg, Variable);
    end
  else begin
    if Assigned(SC) then
      if Assigned(SC.OnError) then
        SC.OnError(SC, ErrorMsg49);
    end;

  PowerDeleteFile(TempVideoFile);
  PowerDeleteFile(TempAudioFile);
end;

end.

