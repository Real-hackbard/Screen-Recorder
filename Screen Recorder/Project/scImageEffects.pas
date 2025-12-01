

unit scImageEffects;

{$B-}
{$WARNINGS OFF}
{$HINTS OFF}
{$RANGECHECKS OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Graphics, Math;

const
  MaxPixelCount = 32768;

type
  TRGBAArray = array[0..0] of TRGBQuad;
  pRGBAArray = ^TRGBAArray;

  TRGBArray = array[0..MaxPixelCount-1] of TRGBTriple;
  pRGBArray = ^TRGBArray;

  TMirror = (MT_Horizontal, MT_Vertical, MT_Reverse);

function CheckResolution(Bitmap: TBitmap): Boolean; stdcall;
procedure BrightnessEffect(Bitmap: TBitmap; Increment: Integer); stdcall;
procedure DarknessEffect(Bitmap: TBitmap; Increment: Integer); stdcall;
procedure ContrastEffect(Bitmap: TBitmap; Increment: Integer); stdcall;
procedure SaturationEffect(Bitmap: TBitmap; Increment: Integer); stdcall;
procedure ColorNoiseEffect(Bitmap: TBitmap; Increment: Integer); stdcall;
procedure MonoNoiseEffect(Bitmap: TBitmap; Increment: Integer); stdcall;
procedure GrayScaleEffect(Bitmap: TBitmap); stdcall;
procedure SepiaEffect(Bitmap: TBitmap); stdcall;
procedure PosterizeEffect(Bitmap: TBitmap; Increment: Integer); stdcall;
procedure ColorAdjustEffect(Bitmap: TBitmap;
          RValue, GValue, BValue: Integer); stdcall;
procedure RotateEffect(SourceBitmap: TBitmap; TargetBitmap: TBitmap;
          const Angle: Extended; bgColor: TColor); stdcall;
procedure FlipEffect(Bitmap: TBitmap; MirrorType: TMirror); stdcall;

implementation

function CheckResolution(Bitmap: TBitmap): Boolean;
begin
  Result := True;
  if not Assigned(Bitmap) then
    Result := False
  else if (Bitmap.Width = 1280) and
    ((Bitmap.PixelFormat = pf8bit) or
    (Bitmap.PixelFormat = pf16bit)) then
    Result := False;
end;

function IntToByte(I: Integer): Byte;
begin
  if I > 255 then Result := 255
  else if I < 0 then Result := 0
  else Result := I;
end;

function Min(A, B: Integer): Integer;
begin
  if A < B then Result := A
  else Result := B;
end;

function Max(A, B: Integer): Integer;
begin
  if A > B then Result := A
  else Result := B;
end;

procedure BrightnessEffect(Bitmap: TBitmap; Increment: Integer);
var
  OrigRow,
  DistRow  : pRGBArray;
  RO, GO, BO,
  I, J, Wn : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := Bitmap.Width div 3;
  end;
  // for each row of pixels
  for I := 0 to Bitmap.Height - 1 do begin
    OrigRow := Bitmap.ScanLine[I];
    DistRow := Bitmap.ScanLine[I];
    // for each pixel in row
    for J := 0 to (Bitmap.Width + Wn) - 1 do begin
      // get source RGB values
      RO := OrigRow[J].rgbtRed;
      GO := OrigRow[J].rgbtGreen;
      BO := OrigRow[J].rgbtBlue;
      // set destination RGB values
      // add brightness value to pixel's RGB values
      // RGB values must be between -2550 ~ 255
      DistRow[J].rgbtRed := IntToByte(RO + ((255 - RO) * Increment) div 255);
      DistRow[J].rgbtGreen := IntToByte(GO + ((255 - GO) * Increment) div 255);
      DistRow[J].rgbtBlue := IntToByte(BO + ((255 - BO) * Increment) div 255);
      end;
    end;
end;

procedure DarknessEffect(Bitmap: TBitmap; Increment: Integer);
var
  OrigRow,
  DistRow  : pRGBArray;
  RO, GO, BO,
  I, J, Wn : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := Bitmap.Width div 3;
  end;
  // for each row of pixels
  for I := 0 to Bitmap.Height - 1 do begin
    OrigRow := Bitmap.ScanLine[I];
    DistRow := Bitmap.ScanLine[I];
    // for each pixel in row
    for J := 0 to (Bitmap.Width + Wn) - 1 do begin
      // get source RGB values
      RO := OrigRow[J].rgbtRed;
      GO := OrigRow[J].rgbtGreen;
      BO := OrigRow[J].rgbtBlue;
      // set destination RGB values
      // add darkness value to pixel's RGB values
      // RGB values must be between 0 ~ 255
      DistRow[J].rgbtRed := IntToByte(RO - (RO * Increment) div 255);
      DistRow[J].rgbtGreen := IntToByte(GO - (GO * Increment) div 255);
      DistRow[J].rgbtBlue := IntToByte(BO - (BO * Increment) div 255);
      end;
    end;
end;

procedure ContrastEffect(Bitmap: TBitmap; Increment: Integer);
var
  OrigRow,
  DistRow  : pRGBArray;
  RO, GO, BO,
  R, G, B,
  I, J, Wn : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := Bitmap.Width div 3;
  end;
  // for each row of pixels
  for I := 0 to Bitmap.Height - 1 do begin
    OrigRow := Bitmap.ScanLine[I];
    DistRow := Bitmap.ScanLine[I];
    // for each pixel in row
    for J := 0 to (Bitmap.Width + Wn) - 1 do begin
      // get source RGB values
      RO := OrigRow[J].rgbtRed;
      GO := OrigRow[J].rgbtGreen;
      BO := OrigRow[J].rgbtBlue;

      R := (Abs(127 - RO) * Increment) div 255;
      G := (Abs(127 - GO) * Increment) div 255;
      B := (Abs(127 - BO) * Increment) div 255;
      if RO > 127 then RO := RO + R else RO := RO - R;
      if GO > 127 then GO := GO + G else GO := GO - G;
      if BO > 127 then BO := BO + B else BO := BO - B;
      // set destination RGB values
      // add contrast value to pixel's RGB values
      // RGB values must be between -255 ~ 2550
      DistRow[J].rgbtRed := IntToByte(RO);
      DistRow[J].rgbtGreen := IntToByte(GO);
      DistRow[J].rgbtBlue := IntToByte(BO);
      end;
    end;
end;

procedure SaturationEffect(Bitmap: TBitmap; Increment: Integer); 
var
  OrigRow24,
  DistRow24  : pRGBArray;

  OrigRow32,
  DistRow32  : pRGBAArray;

  RO, GO, BO,
  Gray,
  I, J, Wn   : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := 0;
  end;
  if Bitmap.PixelFormat = pf32Bit then begin
    // for each row of pixels
    for I := 0 to Bitmap.Height - 1 do begin
      OrigRow32 := Bitmap.ScanLine[I];
      DistRow32 := Bitmap.ScanLine[I];
      // for each pixel in row
      for J := 0 to (Bitmap.Width + Wn) - 1 do begin
        // get source RGB values
        RO := OrigRow32[J].rgbRed;
        GO := OrigRow32[J].rgbGreen;
        BO := OrigRow32[J].rgbBlue;
        // gray scale value
        Gray := Round((RO * 0.3) + (GO * 0.59) + (BO * 0.11));
        // set destination RGB values
        // RGB values must be between 0 ~ 2550
        DistRow32[J].rgbRed := IntToByte(Gray + (((RO - Gray) * Increment) div 255));
        DistRow32[J].rgbGreen := IntToByte(Gray + (((GO - Gray) * Increment) div 255));
        DistRow32[J].rgbBlue := IntToByte(Gray + (((BO - Gray) * Increment) div 255));
        end;
      end;
    end
  else begin
    // for each row of pixels
    for I := 0 to Bitmap.Height - 1 do begin
      OrigRow24 := Bitmap.ScanLine[I];
      DistRow24 := Bitmap.ScanLine[I];
      // for each pixel in row
      for J := 0 to (Bitmap.Width + Wn) - 1 do begin
        // get source RGB values
        RO := OrigRow24[J].rgbtRed;
        GO := OrigRow24[J].rgbtGreen;
        BO := OrigRow24[J].rgbtBlue;
        // gray scale value
        Gray := Round((RO * 0.3) + (GO * 0.59) + (BO * 0.11));
        // set destination RGB values
        // RGB values must be between 0 ~ 2550
        DistRow24[J].rgbtRed := IntToByte(Gray + (((RO - Gray) * Increment) div 255));
        DistRow24[J].rgbtGreen := IntToByte(Gray + (((GO - Gray) * Increment) div 255));
        DistRow24[J].rgbtBlue := IntToByte(Gray + (((BO - Gray) * Increment) div 255));
        end;
      end;
    end;
end;

procedure ColorNoiseEffect(Bitmap: TBitmap; Increment: Integer);
var
  OrigRow,
  DistRow  : pRGBArray;
  RO, GO, BO,
  I, J, Wn : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := Bitmap.Width div 3;
  end;
  // for each row of pixels
  for I := 0 to Bitmap.Height - 1 do begin
    OrigRow := Bitmap.ScanLine[I];
    DistRow := Bitmap.ScanLine[I];
    // for each pixel in row
    for J := 0 to (Bitmap.Width + Wn) - 1 do begin
      // get source RGB values
      RO := OrigRow[J].rgbtRed + (Random(Increment) - (Increment shr 1));
      GO := OrigRow[J].rgbtGreen + (Random(Increment) - (Increment shr 1));
      BO := OrigRow[J].rgbtBlue + (Random(Increment) - (Increment shr 1));
      // set destination RGB values
      // add colornoise value to pixel's RGB values
      // RGB values must be between 0 ~ 255
      DistRow[J].rgbtRed := IntToByte(RO);
      DistRow[J].rgbtGreen := IntToByte(GO);
      DistRow[J].rgbtBlue := IntToByte(BO);
      end;
    end;
end;

procedure MonoNoiseEffect(Bitmap: TBitmap; Increment: Integer);
var
  OrigRow,
  DistRow     : pRGBArray;
  RO, GO, BO,
  I, J, Wn, A : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := Bitmap.Width div 3;
  end;
  // for each row of pixels
  for I := 0 to Bitmap.Height - 1 do begin
    OrigRow := Bitmap.ScanLine[I];
    DistRow := Bitmap.ScanLine[I];
    // for each pixel in row
    for J := 0 to (Bitmap.Width + Wn) - 1 do begin
      A := (Random(Increment) - (Increment shr 1));
      // get source RGB values
      RO := OrigRow[J].rgbtRed + A;
      GO := OrigRow[J].rgbtGreen + A;
      BO := OrigRow[J].rgbtBlue + A;
      // set destination RGB values
      // add mononoise value to pixel's RGB values
      // RGB values must be between 0 ~ 255
      DistRow[J].rgbtRed := IntToByte(RO);
      DistRow[J].rgbtGreen := IntToByte(GO);
      DistRow[J].rgbtBlue := IntToByte(BO);
      end;
    end;
end;

procedure GrayScaleEffect(Bitmap: TBitmap);
var
  OrigRow24,
  DistRow24  : pRGBArray;
  OrigRow32,
  DistRow32  : pRGBAArray;
  RO, GO, BO,
  Gray ,
  I, J, Wn   : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := 0;//Bitmap.Width div 3;
  end;
  if Bitmap.PixelFormat = pf32bit then begin
    // for each row of pixels
    for I := 0 to Bitmap.Height - 1 do begin
      OrigRow32 := Bitmap.ScanLine[I];
      DistRow32 := Bitmap.ScanLine[I];
      // for each pixel in row
      for J := 0 to (Bitmap.Width + Wn) - 1 do begin
        // get source RGB values
        RO := OrigRow32[J].rgbRed;
        GO := OrigRow32[J].rgbGreen;
        BO := OrigRow32[J].rgbBlue;
        // gray scale value
        Gray := Round((RO * 0.3) + (GO * 0.59) + (BO * 0.11));
        // set destination RGB values
        DistRow32[J].rgbRed := IntToByte(Gray);
        DistRow32[J].rgbGreen := IntToByte(Gray);
        DistRow32[J].rgbBlue := IntToByte(Gray);
        end;
      end;
    end
  else begin
    // for each row of pixels
    for I := 0 to Bitmap.Height - 1 do begin
      OrigRow24 := Bitmap.ScanLine[I];
      DistRow24 := Bitmap.ScanLine[I];
      // for each pixel in row
      for J := 0 to (Bitmap.Width + Wn) - 1 do begin
        // get source RGB values
        RO := OrigRow24[J].rgbtRed;
        GO := OrigRow24[J].rgbtGreen;
        BO := OrigRow24[J].rgbtBlue;
        // gray scale value
        Gray := Round((RO * 0.3) + (GO * 0.59) + (BO * 0.11));
        // set destination RGB values
        DistRow24[J].rgbtRed := IntToByte(Gray);
        DistRow24[J].rgbtGreen := IntToByte(Gray);
        DistRow24[J].rgbtBlue := IntToByte(Gray);
        end;
      end;
    end;
end;

procedure SepiaEffect(Bitmap: TBitmap);
var
  OrigRow24,
  DistRow24  : pRGBArray;
  OrigRow32,
  DistRow32  : pRGBAArray;
  RO, GO, BO,
  Gray ,
  I, J, Wn   : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := 0;//Bitmap.Width div 3;
  end;
  if Bitmap.PixelFormat = pf32bit then begin
    // for each row of pixels
    for I := 0 to Bitmap.Height - 1 do begin
      OrigRow32 := Bitmap.ScanLine[I];
      DistRow32 := Bitmap.ScanLine[I];
      // for each pixel in row
      for J := 0 to (Bitmap.Width + Wn) - 1 do begin
        // get source RGB values
        RO := OrigRow32[J].rgbRed;
        GO := OrigRow32[J].rgbGreen;
        BO := OrigRow32[J].rgbBlue;
        // gray scale value
        Gray := Round((RO * 0.3) + (GO * 0.59) + (BO * 0.11));
        // set destination RGB values
        RO := Gray + 68;
        GO := Gray + 34;
        BO := Gray;
        if RO <= 67 then
          RO := 255;
        if GO <= 33 then
          GO := 255;
        DistRow32[J].rgbRed := IntToByte(RO);
        DistRow32[J].rgbGreen := IntToByte(GO);
        DistRow32[J].rgbBlue := IntToByte(BO);
        end;
      end;
    end
  else begin
    // for each row of pixels
    for I := 0 to Bitmap.Height - 1 do begin
      OrigRow24 := Bitmap.ScanLine[I];
      DistRow24 := Bitmap.ScanLine[I];
      // for each pixel in row
      for J := 0 to (Bitmap.Width + Wn) - 1 do begin
        // get source RGB values
        RO := OrigRow24[J].rgbtRed;
        GO := OrigRow24[J].rgbtGreen;
        BO := OrigRow24[J].rgbtBlue;
        // gray scale value
        Gray := Round((RO * 0.3) + (GO * 0.59) + (BO * 0.11));
        RO := Gray + 68;
        GO := Gray + 34;
        BO := Gray;
        if RO <= 67 then
          RO := 255;
        if GO <= 33 then
          GO := 255;
        // set destination RGB values
        DistRow24[J].rgbtRed := IntToByte(RO);
        DistRow24[J].rgbtGreen := IntToByte(GO);
        DistRow24[J].rgbtBlue := IntToByte(BO);
        end;
      end;
    end;
end;

procedure PosterizeEffect(Bitmap: TBitmap; Increment: Integer);
var
  OrigRow,
  DistRow  : pRGBArray;
  RO, GO, BO,
  I, J, Wn : Integer;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := Bitmap.Width div 3;
  end;
  // for each row of pixels
  for I := 0 to Bitmap.Height - 1 do begin
    OrigRow := Bitmap.ScanLine[I];
    DistRow := Bitmap.ScanLine[I];
    // for each pixel in row
    for J := 0 to (Bitmap.Width + Wn) - 1 do begin
      RO := Round(OrigRow[J].rgbtRed / Increment) * Increment;
      GO := Round(OrigRow[J].rgbtGreen / Increment) * Increment;
      BO := Round(OrigRow[J].rgbtBlue / Increment) * Increment;
      // set destination RGB values
      // add posterize value to pixel's RGB values
      // RGB values must be between 1 ~ 500
      DistRow[J].rgbtRed := IntToByte(RO);
      DistRow[J].rgbtGreen := IntToByte(GO);
      DistRow[J].rgbtBlue := IntToByte(BO);
      end;
    end;
end;

procedure ColorAdjustEffect(Bitmap: TBitmap; RValue, GValue, BValue: Integer);
var
  OrigRow24,
  DistRow24  : pRGBArray;
  OrigRow32,
  DistRow32  : pRGBAArray;
  RO, GO, BO,
  I, J, Wn   : Integer;
  function CheckRGBValue(OldValue, NewValue: Integer): Integer;
  var
    a: Integer;
  begin
    a := OldValue;
    if NewValue > 0 then begin
      a := OldValue + NewValue;
      if a > 255 then
        a := 255
      end
    else if NewValue < 0 then
      if OldValue > 0 then begin
        a := OldValue - Abs(NewValue);
        if a < 0 then
          a := 0
        end;
    Result := a;
  end;
begin
  case Bitmap.PixelFormat of
    pf8Bit  : Wn := -((Bitmap.Width div 3) * 2);
    pf16Bit : Wn := -(Bitmap.Width div 3);
    pf24Bit : Wn := 0;
    pf32Bit : Wn := 0;
  end;
  if Bitmap.PixelFormat = pf32Bit then begin
    // for each row of pixels
    for I := 0 to Bitmap.Height - 1 do begin
      OrigRow32 := Bitmap.ScanLine[I];
      DistRow32 := Bitmap.ScanLine[I];
      // for each pixel in row
      for J := 0 to (Bitmap.Width + Wn) - 1 do begin
        // get source RGB values
        RO := OrigRow32[J].rgbRed;
        GO := OrigRow32[J].rgbGreen;
        BO := OrigRow32[J].rgbBlue;
        // set destination RGB values
        // RGB values must be between -255 ~ 255
        DistRow32[J].rgbRed := CheckRGBValue(RO, RValue);
        DistRow32[J].rgbGreen := CheckRGBValue(GO, GValue);
        DistRow32[J].rgbBlue := CheckRGBValue(BO, BValue);
        end;
      end;
    end
  else begin
    // for each row of pixels
    for I := 0 to Bitmap.Height - 1 do begin
      OrigRow24 := Bitmap.ScanLine[I];
      DistRow24 := Bitmap.ScanLine[I];
      // for each pixel in row
      for J := 0 to (Bitmap.Width + Wn) - 1 do begin
        // get source RGB values
        RO := OrigRow24[J].rgbtRed;
        GO := OrigRow24[J].rgbtGreen;
        BO := OrigRow24[J].rgbtBlue;
        // set destination RGB values
        // RGB values must be between -255 ~ 255
        DistRow24[J].rgbtRed := CheckRGBValue(RO, RValue);
        DistRow24[J].rgbtGreen := CheckRGBValue(GO, GValue);
        DistRow24[J].rgbtBlue := CheckRGBValue(BO, BValue);
        end;
      end;
    end;
end;

procedure RotateEffect(SourceBitmap: TBitmap; TargetBitmap: TBitmap;
          const Angle: Extended; bgColor: TColor);
var
    srcbmp     : Bitmap;
    srcdib     : array of TRGBQUAD;
    srcdibbmap : TBITMAPINFO;
    ldc        : HDC;

    dstbmp     : HBITMAP;
    dstdib     : array of TRGBQUAD;
    dstdibmap  : TBITMAPINFO;

    cosTheta       :  DOUBLE;
    i              :  Integer;
    iRotationAxis  :  Integer;
    iOriginal      :  Integer;
    iPrime         :  Integer;
    iPrimeRotated  :  Integer;
    j              :  Integer;
    jRotationAxis  :  Integer;
    jOriginal      :  Integer;
    jPrime         :  Integer;
    jPrimeRotated  :  Integer;
    sinTheta       :  DOUBLE;
    Theta          :  DOUBLE;       // radians

    OldHeight      : Integer;
    OldWidth       : Integer;
    NewWidth       : Integer;
    NewHeight      : Integer;
    bgRGB          : TRGBTriple;
    SrcIndex       : Integer;
    DstIndex       : Integer;
    screenmode     : DEVMODE;

begin
   if SourceBitmap.Empty then
    begin
       TargetBitmap := nil;
       exit;
    end;

    bgColor := ColorToRGB(bgColor);
    with bgRGB do
    begin
      rgbtRed := Byte(bgColor);
      rgbtGreen := Byte(bgColor shr 8);
      rgbtBlue := Byte(bgColor shr 16);
    end;

  //Load the source bitmaps information
   if (GetObject(SourceBitmap.Handle, sizeof(srcbmp), @srcbmp) = 0) then
   begin
      TargetBitmap := nil;
      exit;
   end;

  //Create the source dib array and the destdib array
   SetLength(srcdib, srcbmp.bmWidth * srcbmp.bmHeight);
  //Load source bits into srcdib
   srcdibbmap.bmiHeader.biSize := sizeof(srcdibbmap.bmiHeader);
   srcdibbmap.bmiHeader.biWidth := srcbmp.bmWidth;
   srcdibbmap.bmiHeader.biHeight := -srcbmp.bmHeight;
   srcdibbmap.bmiHeader.biPlanes := 1;
   srcdibbmap.bmiHeader.biBitCount := 32;
   srcdibbmap.bmiHeader.biCompression := BI_RGB;

   ldc := CreateCompatibleDC(0);
   GetDIBits(ldc, SourceBitmap.Handle, 0, srcbmp.bmHeight, srcdib, srcdibbmap, DIB_RGB_COLORS);
   DeleteDC(ldc);

  // Axis of rotation is normally center of image
  // Convert degrees to radians.
  Theta := Angle * PI / 180;
  sinTheta := SIN(Theta);
  cosTheta := COS(Theta);

 // if SourceBitmap.PixelFormat <> pf24bit then
 //    SourceBitmap.PixelFormat := pf24bit; // force to 24 bits
  OldWidth := SourceBitmap.Width;
  OldHeight := SourceBitmap.Height;

  //An easy way to calculate the non-clipping rectangle
  NewWidth := abs(round(OldHeight * sinTheta)) + abs(round(OldWidth * cosTheta));
  NewHeight := abs(round(OldWidth * sinTheta)) + abs(round(OldHeight * cosTheta));
  SetLength(dstdib, NewWidth * NewHeight);

  iRotationAxis := OldWidth div 2;
  jRotationAxis := OldHeight div 2;

  // Step through each row of rotated image.
  for j := (NewHeight - 1) downto 0 do
  begin

    // offset origin by the growth factor (NewHeight - OldHeight) div 2
    jPrime := 2*(j - (NewHeight - OldHeight) div 2 - jRotationAxis) + 1 ;

    for i := (NewWidth - 1) downto 0 do
    begin
      // offset origin by the growth factor (NewWidth - OldWidth) div 2
      iPrime := 2*(i - (NewWidth - OldWidth) div 2 - iRotationAxis) + 1;

      // Rotate (iPrime, jPrime) to location of desired pixel
      // Note:  There is negligible difference between floating point and
      // scaled Integer arithmetic here, so keep the math simple (and readable).
      iPrimeRotated := ROUND(iPrime * CosTheta - jPrime * sinTheta);
      jPrimeRotated := ROUND(iPrime * sinTheta + jPrime * cosTheta);

      // Transform back to pixel coordinates of image, including translation
      // of origin from axis of rotation to origin of image.
      iOriginal := (iPrimeRotated - 1) div 2 + iRotationAxis;
      jOriginal := (jPrimeRotated - 1) div 2 + jRotationAxis;
      SrcIndex := iOriginal + jOriginal * srcbmp.bmWidth;
      DstIndex := i + j * NewWidth;

      // Make sure (iOriginal, jOriginal) is in SourceBitmap.  If not,
      // assign blue color to corner points.
      if   (iOriginal >= 0) and (iOriginal <= SourceBitmap.Width-1) and
           (jOriginal >= 0) and (jOriginal <= SourceBitmap.Height-1)
      then begin
        // Assign pixel from rotated space to current pixel in srcdib
        dstdib[DstIndex].rgbRed := srcdib[SrcIndex].rgbRed;
        dstdib[DstIndex].rgbBlue := srcdib[SrcIndex].rgbBlue;
        dstdib[DstIndex].rgbGreen := srcdib[SrcIndex].rgbGreen;
      end
      else begin
        dstdib[DstIndex].rgbRed := bgRGB.rgbtBlue;
        dstdib[DstIndex].rgbBlue := bgRGB.rgbtGreen;
        dstdib[DstIndex].rgbGreen := bgRGB.rgbtRed;
      end

    end; // for i
  end;  // for j

  //Get Current Display Settings
   screenmode.dmSize := sizeof(DEVMODE);
   EnumDisplaySettings(nil, $FFFFFFFF{ENUM_CURRENT_SETTINGS}, screenmode);

  //Create the final bitmap object
   dstbmp := CreateBitmap(NewWidth, NewHeight, 1, screenmode.dmBitsPerPel, nil);

  //Write the bits into the bitmap and return it
   dstdibmap.bmiHeader.biSize := sizeof(dstdibmap.bmiHeader);
   dstdibmap.bmiHeader.biWidth := NewWidth;
   dstdibmap.bmiHeader.biHeight := -NewHeight;
   dstdibmap.bmiHeader.biPlanes := 1;
   dstdibmap.bmiHeader.biBitCount := 32;
   dstdibmap.bmiHeader.biCompression := BI_RGB;
   SetDIBits(0, dstbmp, 0, NewHeight, dstdib, dstdibmap, DIB_RGB_COLORS);

  try
    if TargetBitmap = nil then
      TargetBitmap := TBitmap.Create;
    TargetBitmap.Handle := dstbmp;
  finally
     SetLength(srcdib, 0);
     SetLength(dstdib, 0);
  end;

end;

procedure FlipEffect(Bitmap: TBitmap; MirrorType: TMirror);
var
  Dest: TRect;
begin
  if Assigned(Bitmap) then begin
    case MirrorType of
      MT_Horizontal   : begin
                          Dest.Left := Bitmap.Width - 1;
                          Dest.Top := 0;
                          Dest.Right := -Bitmap.Width;
                          Dest.Bottom := Bitmap.Height;
                        end;
      MT_Vertical     : begin
                          Dest.Top := Bitmap.Height - 1;
                          Dest.Left := 0;
                          Dest.Bottom := -Bitmap.Height;
                          Dest.Right := Bitmap.Width;
                        end;
      MT_Reverse     : begin
                          Dest.Top := Bitmap.Height - 1;
                          Dest.Left := Bitmap.Width - 1;
                          Dest.Bottom := -Bitmap.Height;
                          Dest.Right := -Bitmap.Width;
                        end;
    end;
    StretchBlt(Bitmap.Canvas.Handle,
               Dest.Left,
               Dest.Top,
               Dest.Right,
               Dest.Bottom,
               Bitmap.Canvas.Handle,
               0,
               0,
               Bitmap.Width,
               Bitmap.Height,
               SRCCOPY);
  end;
end;

end.
