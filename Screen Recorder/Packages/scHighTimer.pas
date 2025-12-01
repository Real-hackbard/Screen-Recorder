unit scHighTimer;

interface

uses
  Windows,
  Classes,
  Messages,
  Dialogs,
  MMSystem;

type
  THighTimer = class;
  TSCTimerInterval = 1..High(Word);
  {------------------------------- TSCThreadedTimer ---------------------------}
  TSCThreadedTimer = class(TThread)
  private
    FTimer: THighTimer;
    FInterval: TSCTimerInterval;
  protected
    procedure Execute; override;
  public
    property Interval: TSCTimerInterval read FInterval write FInterval;
    constructor Create(aOwner: THighTimer);
  end;

  THighTimer = class(TComponent)
  private
    FSynchronize,
    FUseThread,
    FEnabled,
    FInternalFlag   : Boolean;
    FInterval,
    FTimerID        : UINT;
    FTimerCaps      : TTimeCaps;
    FOnTimer        : TNotifyEvent;
    FWindowHandle   : HWND;
    FThread         : TSCThreadedTimer;
    FThreadPriority : TThreadPriority;
    procedure SetThreadPriority(aValue: TThreadPriority);
    procedure SetUseThread(aValue: Boolean);
    procedure SetEnabled(aValue: Boolean);
    procedure SetInterval(aValue: UINT);
    procedure SetOnTimer(aValue: TNotifyEvent);
    procedure WndProc(var Msg: TMessage);
    procedure UpdateTimer;
    function GetCaps: TTimeCaps;
    function GetInteger(index: Integer):Integer;
  protected
    procedure Timer; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateExt(aOwner: TComponent; Interval: TSCTimerInterval);
    destructor Destroy; override;
    property MaxInterval    : Integer index 0 read GetInteger;
    property MinInterval    : Integer index 1 read GetInteger;
  published
    property Enabled        : Boolean         read FEnabled        write SetEnabled default False;
    property Interval       : UINT            read FInterval       write SetInterval default 1000;
    property OnTimer        : TNotifyEvent    read FOnTimer        write SetOnTimer;
    property Synchronize    : Boolean         read FSynchronize    write FSynchronize default True;
    property UseThread      : Boolean         read FUseThread      write SetUseThread default True;
    property ThreadPriority : TThreadPriority read FThreadPriority write SetThreadPriority default tpNormal;
  end;


implementation

uses
  Forms,
  SysUtils,
  Consts;

{------------------------------------------------------------------------------}
procedure TimeCallBack(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD); stdcall;
begin
  PostMessage(HWND(dwUser), WM_TIMER, uTimerID, 0);
end;

{------------------------------------------------------------------------------}
procedure TSCThreadedTimer.Execute;

  function ThreadClosed: Boolean;
  begin
    Result := Terminated or Application.Terminated or (FTimer = nil);
  end;

begin
  repeat
    if not ThreadClosed then
      if SleepEx(FInterval, False) = 0 then
        begin
          if not ThreadClosed and FTimer.FEnabled then
            with FTimer do
              if FSynchronize then
                Self.Synchronize(Timer)
              else
                Timer;
      end;
  until Terminated;
end;

{------------------------------------------------------------------------------}
constructor TSCThreadedTimer.Create(aOwner: THighTimer);
begin
  inherited Create(True);
  FTimer    := aOwner;
  FInterval := 1000;
  // free Thread after Termination
  FreeOnTerminate := True;
end;

{*************************** Class THighTimer**********************************}
{----------------------------  Private ----------------------------------------}
procedure THighTimer.SetEnabled(aValue: Boolean);
begin
 if aValue <> FEnabled then
   begin
     FEnabled := aValue;
     UpdateTimer;
   end;
end;

{------------------------------------------------------------------------------}
procedure THighTimer.SetInterval(aValue: UINT);
begin
 if aValue <> FInterval then
   begin
     if (aValue < FTimerCaps.wPeriodMin) then
       FInterval := FTimerCaps.wPeriodMin
     else
       if (aValue > FTimerCaps.wPeriodMax) then
         FInterval := FTimerCaps.wPeriodMax
       else
         FInterval := aValue;
     UpdateTimer;
   end;
end;

{------------------------------------------------------------------------------}
procedure THighTimer.SetOnTimer(aValue: TNotifyEvent);
begin
  FOnTimer := aValue;
  UpdateTimer;
end;

{------------------------------------------------------------------------------}
procedure THighTimer.SetUseThread(aValue: Boolean);
begin
  if aValue <> FUseThread then
    begin
      FUseThread := aValue;
      UpdateTimer;
    end;
end;

{------------------------------------------------------------------------------}
procedure THighTimer.SetThreadPriority(aValue: TThreadPriority);
begin
  if aValue <> FThreadPriority then
    begin
      FThreadPriority := aValue;
      if FUseThread then UpdateTimer;
    end;
end;

{------------------------------------------------------------------------------}
function THighTimer.GetCaps: TTimeCaps;
var
  Temp: TTimeCaps;
begin
  TimeGetDevCaps(@Temp, 2 * SizeOf(UINT));
  Result := Temp;
end;

{------------------------------------------------------------------------------}
function THighTimer.GetInteger(index: Integer): Integer;
begin
  Result := 0;
  case Index of
    0: Result := FTimerCaps.wPeriodMax;
    1: Result := FTimerCaps.wPeriodMin;
  end;
end;

{------------------------------------------------------------------------------}
procedure THighTimer.UpdateTimer;
begin
  if csDesigning in ComponentState then Exit;
  if Assigned(FThread) then
    try
      FThread.Terminate;
    except
      on E: Exception do ShowMessage(E.Message);
    end;
  {if one is active - delete it!}
  if FTimerID <> 0 then TimeKillEvent(FTimerID);
  if FUseThread then
    begin
      if FWindowHandle <> 0 then
        begin
          DeallocateHWnd(FWindowHandle);
          FWindowHandle := 0;
        end;
      if FEnabled and Assigned(FOnTimer) then
        begin
          FThread := TSCThreadedTimer.Create(Self);
          FThread.FInterval := FInterval;
          FThread.Priority  := FThreadPriority;
          while FThread.Suspended do
            FThread.Resume;
        end;
    end
  else
    begin
      if FWindowHandle = 0 then
        FWindowHandle := AllocateHWnd(WndProc);
      if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
        begin
          FTimerID := TimeSetEvent(FInterval,
                                   FInterval,
                                   TimeCallBack,
                                   FWindowHandle,
                                   TIME_PERIODIC);
          FInternalFlag := False;
          If FTimerId = 0 then
            raise EOutOfResources.Create(SNoTimers);
        end;
    end;
end;

{------------------------------------------------------------------------------}
procedure THighTimer.WndProc(var Msg: TMessage);
begin
  with Msg do
    if (Msg = WM_TIMER) and (DWORD(WPARAM) = FTimerID) then
      try
        if FInternalFlag then exit;
        FInternalFlag := True;
        Timer;
        FInternalFlag := False;
        Result := 0;
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

{--------------------- Protected ----------------------------------------------}
procedure THighTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;

{---------------------Public---------------------------------------------------}
constructor THighTimer.Create(aOwner: TComponent);
begin
  CreateExt(aOwner, 1000);
end;

{------------------------------------------------------------------------------}
constructor THighTimer.CreateExt(aOwner: TComponent; Interval: TSCTimerInterval);
begin
  inherited Create(aOwner);
  FEnabled        := False;
  FInternalFlag   := False;
  FTimerCaps      := GetCaps;
  TimeBeginPeriod(FTimerCaps.wPeriodMin);
  FInterval       := Interval;
  FWindowHandle   := 0;
  FSynchronize    := True;
  FUseThread      := True;
  FThreadPriority := tpNormal;
  FThread         := nil;
end;

{------------------------------------------------------------------------------}
Destructor THighTimer.Destroy;
begin
  FOnTimer := nil;
  if FThread <> nil then
    UpdateTimer;
  TimeEndPeriod(FTimerCaps.wPeriodMin);
  FEnabled := False;
  if FWindowHandle <> 0 then
    DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

end.
