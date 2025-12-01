unit scFlashWnd;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls;

{$WARNINGS OFF}
{$HINTS OFF}
{$RANGECHECKS OFF}

const
  PW =  2; // Pen Width
  CL = 30; // Corners Length
  TW = 34; // Text Width
  TH = 16; // Text Height

type
  TFlashingWnd = class(TCustomForm)
    private
      { Private declarations }
    	cRect     : TRect;
     	OldRegion : HRGN;
    protected
      { Protected declarations }
    public
      { Public declarations }
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure SetUpRegion(X, Y, Width, Height: Integer; ClearLine:
        Boolean; Text: string);
      procedure PaintBorder(ColorValue: TColor; Text: string);
  end;

implementation

constructor TFlashingWnd.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  OldRegion   := 0;
  BorderStyle := bsNone;
  Ctl3D       := False;
  Brush.Style := bsClear;
  Self.Left   := 0;
  Self.Top    := TH;
  Self.Width  := 300;
  Self.Height := 300;
end;

destructor TFlashingWnd.Destroy;
begin
  if OldRegion <> 0 then
    DeleteObject(OldRegion);
  inherited Destroy;
end;

// Set the Window Region for transparancy outside the mask region
procedure TFlashingWnd.SetUpRegion(X, Y, Width, Height: Integer;
  ClearLine: Boolean; Text: string);
var
	WndRgn, RgnTemp0, RgnTemp1, RgnTemp2, RgnTemp3: HRgn;
  PenWidth, CornersLength, TextWidth, TextHeight: Integer;
begin
  PenWidth     := PW;
  CornersLength:= CL;
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

  WndRgn       := CreateRectRgn(0, 0, Self.Width, Self.Height);

  RgnTemp0     := CreateRectRgn(TextWidth, 0, Self.Width, TextHeight);

	RgnTemp1     := CreateRectRgn(PenWidth, PenWidth + TextHeight, Width + (PenWidth * 2),
                                Height + (PenWidth * 2) + TextHeight);

  CombineRgn(WndRgn, WndRgn, RgnTemp0, RGN_DIFF);
	CombineRgn(WndRgn, WndRgn, RgnTemp1, RGN_DIFF);

  if ClearLine then begin
  	RgnTemp2 := CreateRectRgn(0, CornersLength + TextHeight, Self.Width, Self.Height - CornersLength);
  	RgnTemp3 := CreateRectRgn(CornersLength, TextHeight, Self.Width - CornersLength, Self.Height);
	  CombineRgn(WndRgn, WndRgn, RgnTemp2, RGN_DIFF);
  	CombineRgn(WndRgn, WndRgn, RgnTemp3, RGN_DIFF);
    end;

	SetWindowRgn(Handle, WndRgn, True);

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

procedure TFlashingWnd.PaintBorder(ColorValue: TColor; Text: string);
begin
	if ((cRect.Right > cRect.Left) and (cRect.Bottom > cRect.Top)) then begin
    Canvas.Font.Color  := clBlack;
    Canvas.Brush.Color := clYellow;
    Canvas.TextOut(0, 0, PChar(Text));

    Canvas.Pen.Color   := ColorValue;
    Canvas.Brush.Color := ColorValue;
    Canvas.Rectangle(cRect.Left, cRect.Top, cRect.Right, cRect.Bottom);
    end;
end;

end.
