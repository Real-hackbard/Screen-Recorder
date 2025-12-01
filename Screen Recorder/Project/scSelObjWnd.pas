unit scSelObjWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

{$WARNINGS OFF}
{$RANGECHECKS OFF}

const
  PW = 1;
  SL = 20;

type
  TSelObjWindow = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    cRect     : TRect;
    OldRegion : HRGN;
    procedure SetUpRegion(X, Y, Width, Height: Integer;
                          ClearLine: Boolean; Text: string);
    procedure PaintBorder(ColorVal: COLORREF; Text: string);
  public
    { Public declarations }
    PRegion   : TRect;
  end;

var
  SelObjWindow: TSelObjWindow;

implementation

{$R *.dfm}

// Set the Window Region for transparancy outside the mask region
procedure TSelObjWindow.SetUpRegion(X, Y, Width, Height: Integer;
                                    ClearLine: Boolean; Text: string);
var
	WndRgn, RgnTemp0, RgnTemp1, RgnTemp2, RgnTemp3: HRgn;
  PenWidth, SideLen, TextWidth, TextHeight: Integer;
begin
  // Create transparent window around selected object
  
  PenWidth     := PW;
  SideLen      := SL;
  TextWidth    := Canvas.TextWidth(Text);
  TextHeight   := Canvas.TextHeight(Text);;

  Self.Left    := X - (PenWidth * 2);
  Self.Top     := Y - ((PenWidth * 2) + TextHeight);
  Self.Width   := Width + (PenWidth * 3);
  Self.Height  := Height + (PenWidth * 3) + TextHeight;

	cRect.Left   := 0;
	cRect.Top    := TextHeight;
	cRect.Right  := Self.Width;
	cRect.Bottom := Self.Height;

  WndRgn       := CreateRectRgn(0,
                                0,
                                Self.Width,
                                Self.Height);

  RgnTemp0     := CreateRectRgn(TextWidth,
                                0,
                                Self.Width,
                                TextHeight);

	RgnTemp1     := CreateRectRgn(PenWidth,
                                PenWidth + TextHeight,
                                Width + (PenWidth * 2),
                                Height + (PenWidth * 2) + TextHeight);

  CombineRgn(WndRgn,
             WndRgn,
             RgnTemp0,
             RGN_DIFF);

	CombineRgn(WndRgn,
             WndRgn,
             RgnTemp1,
             RGN_DIFF);

  if ClearLine then begin
  	RgnTemp2 := CreateRectRgn(0,
                              SideLen + TextHeight,
                              Self.Width,
                              Self.Height - SideLen);
  	RgnTemp3 := CreateRectRgn(SideLen,
                              TextHeight,
                              Self.Width - SideLen,
                              Self.Height);
	  CombineRgn(WndRgn,
               WndRgn,
               RgnTemp2,
               RGN_DIFF);

  	CombineRgn(WndRgn,
               WndRgn,
               RgnTemp3,
               RGN_DIFF);
    end;

	SetWindowRgn(Handle,
               WndRgn,
               True);

  DeleteObject(RgnTemp0);
  DeleteObject(RgnTemp1);

  if ClearLine then begin
    DeleteObject(RgnTemp2);
    DeleteObject(RgnTemp3);
    end;

	if (OldRegion <> 0) then
    DeleteObject(OldRegion);
  OldRegion := WndRgn;
end;

procedure TSelObjWindow.PaintBorder(ColorVal: COLORREF; Text: string);
begin
	if ((cRect.Right > cRect.Left) and
     (cRect.Bottom > cRect.Top)) then begin
    Canvas.Font.Color  := clWhite;
    Canvas.Brush.Color := clRed;
    Canvas.TextOut(0, 0, PChar(Text));

    Canvas.Pen.Color   := clRed;
    Canvas.Brush.Color := clRed;
    Canvas.Rectangle(cRect.Left,
                     cRect.Top,
                     cRect.Right,
                     cRect.Bottom);
    end;
end;

procedure TSelObjWindow.FormCreate(Sender: TObject);
begin
  OldRegion      := 0;
  Timer1.Enabled := True;
end;

procedure TSelObjWindow.FormDestroy(Sender: TObject);
begin
  if OldRegion <> 0 then
    DeleteObject(OldRegion);
  Timer1.Enabled := False;
end;

procedure TSelObjWindow.Timer1Timer(Sender: TObject);
var
  Rect         : TRect;
  ParentHandle : HWnd;
  MousePos     : TMouse;
begin
  // Get object handle under mouse pointer
  ParentHandle   := WindowFromPoint(MousePos.CursorPos);
  // Get region from current object
  GetWindowRect(ParentHandle, Rect);
  PRegion.Left   := Rect.Left;
  PRegion.Top    := Rect.Top;
  PRegion.Right  := Rect.Right - Rect.Left;
  PRegion.Bottom := Rect.Bottom - Rect.Top;

  // Draw line around current object
  SetUpRegion(PRegion.Left,
              PRegion.Top,
              PRegion.Right,
              PRegion.Bottom,
              False,
              'Cancel: Esc -- Select: Ctrl+Enter');

  PaintBorder(clRed,
              'Cancel: Esc -- Select: Ctrl+Enter');

  SetWindowPos(Handle,
               HWND_TOPMOST,
               0,
               0,
               0,
               0,
               SWP_NOREPOSITION or
               SWP_NOMOVE or
               SWP_NOSIZE or
               SWP_NOACTIVATE);
end;

end.
