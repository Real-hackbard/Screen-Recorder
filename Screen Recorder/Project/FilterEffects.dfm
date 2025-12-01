object frmFilterEffects: TfrmFilterEffects
  Left = 347
  Top = 213
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Effects'
  ClientHeight = 364
  ClientWidth = 647
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BrightnessBox: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 49
    TabOrder = 0
    object BrightnessLabel: TLabel
      Left = 276
      Top = 29
      Width = 6
      Height = 13
      Caption = '0'
    end
    object BrightnessTrackBar: TTrackBar
      Left = 8
      Top = 22
      Width = 265
      Height = 22
      Max = 255
      Min = -2550
      TabOrder = 1
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = BrightnessTrackBarChange
    end
    object UseBrightnessEffect: TCheckBox
      Left = 8
      Top = 0
      Width = 123
      Height = 17
      Caption = 'Use Brightness Effect'
      TabOrder = 0
      OnClick = UseBrightnessEffectClick
    end
  end
  object ContrastBox: TGroupBox
    Left = 8
    Top = 64
    Width = 313
    Height = 49
    TabOrder = 1
    object ContrastLabel: TLabel
      Left = 276
      Top = 27
      Width = 6
      Height = 13
      Caption = '0'
    end
    object ContrastTrackBar: TTrackBar
      Left = 8
      Top = 22
      Width = 265
      Height = 24
      Max = 2550
      Min = -255
      TabOrder = 1
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = ContrastTrackBarChange
    end
    object UseContrastEffect: TCheckBox
      Left = 8
      Top = 0
      Width = 113
      Height = 17
      Caption = 'Use Contrast Effect'
      TabOrder = 0
      OnClick = UseContrastEffectClick
    end
  end
  object ColorAdjustingBox: TGroupBox
    Left = 8
    Top = 120
    Width = 313
    Height = 49
    TabOrder = 2
    object DarknessLabel: TLabel
      Left = 276
      Top = 26
      Width = 6
      Height = 13
      Caption = '0'
    end
    object DarknessTrackBar: TTrackBar
      Left = 8
      Top = 22
      Width = 265
      Height = 24
      Max = 255
      TabOrder = 1
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = DarknessTrackBarChange
    end
    object UseDarknessEffect: TCheckBox
      Left = 8
      Top = 0
      Width = 118
      Height = 17
      Caption = 'Use Darkness Effect'
      TabOrder = 0
      OnClick = UseDarknessEffectClick
    end
  end
  object SaturationBox: TGroupBox
    Left = 8
    Top = 175
    Width = 313
    Height = 50
    TabOrder = 3
    object SaturationLabel: TLabel
      Left = 275
      Top = 27
      Width = 18
      Height = 13
      Caption = '255'
    end
    object SaturationTrackBar: TTrackBar
      Left = 8
      Top = 22
      Width = 265
      Height = 24
      Max = 2550
      Position = 255
      TabOrder = 1
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = SaturationTrackBarChange
    end
    object UseSaturationEffect: TCheckBox
      Left = 8
      Top = 0
      Width = 121
      Height = 17
      Caption = 'Use Saturation Effect'
      TabOrder = 0
      OnClick = UseSaturationEffectClick
    end
  end
  object SolarizeBox: TGroupBox
    Left = 8
    Top = 230
    Width = 313
    Height = 51
    TabOrder = 4
    object NoiseLabel: TLabel
      Left = 276
      Top = 27
      Width = 6
      Height = 13
      Caption = '0'
    end
    object NoiseTrackBar: TTrackBar
      Left = 8
      Top = 22
      Width = 265
      Height = 24
      Max = 255
      TabOrder = 2
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = NoiseTrackBarChange
    end
    object UseColorNoiseEffect: TCheckBox
      Left = 8
      Top = 0
      Width = 127
      Height = 17
      Caption = 'Use Color noise Effect'
      TabOrder = 0
      OnClick = UseColorNoiseEffectClick
    end
    object UseMonoNoiseEffect: TCheckBox
      Left = 152
      Top = 0
      Width = 130
      Height = 17
      Caption = 'Use Mono noise Effect'
      TabOrder = 1
      OnClick = UseMonoNoiseEffectClick
    end
  end
  object ScreenRotation: TRadioGroup
    Left = 327
    Top = 120
    Width = 313
    Height = 105
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Rotate to left'
      'Rotate to right'
      'Reverse'
      'Flip Horizontal'
      'Flip Vertical')
    TabOrder = 8
    OnClick = ScreenRotationClick
  end
  object OkBtn: TButton
    Left = 529
    Top = 309
    Width = 89
    Height = 25
    Caption = 'Ok'
    TabOrder = 10
    OnClick = OkBtnClick
  end
  object UseScreenRotation: TCheckBox
    Left = 335
    Top = 120
    Width = 121
    Height = 14
    Caption = 'Use Screen Rotation'
    TabOrder = 7
    OnClick = UseScreenRotationClick
  end
  object DefaultValueBtn: TButton
    Left = 529
    Top = 278
    Width = 89
    Height = 25
    Caption = 'Default Values'
    TabOrder = 9
    OnClick = DefaultValueBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 285
    Width = 313
    Height = 52
    TabOrder = 5
    object PosterizeLabel: TLabel
      Left = 275
      Top = 27
      Width = 6
      Height = 13
      Caption = '1'
    end
    object PosterizeTrackBar: TTrackBar
      Left = 8
      Top = 22
      Width = 265
      Height = 24
      Max = 500
      Min = 1
      Position = 1
      TabOrder = 1
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = PosterizeTrackBarChange
    end
    object UsePosterizeEffect: TCheckBox
      Left = 8
      Top = 0
      Width = 121
      Height = 17
      Caption = 'Use Posterize Effect'
      TabOrder = 0
      OnClick = UsePosterizeEffectClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 327
    Top = 8
    Width = 313
    Height = 105
    TabOrder = 6
    object RedLabel: TLabel
      Left = 282
      Top = 29
      Width = 6
      Height = 13
      Caption = '0'
    end
    object GreenLabel: TLabel
      Left = 282
      Top = 51
      Width = 6
      Height = 13
      Caption = '0'
    end
    object BlueLabel: TLabel
      Left = 282
      Top = 75
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label1: TLabel
      Left = 13
      Top = 26
      Width = 26
      Height = 13
      Caption = 'Red :'
    end
    object Label2: TLabel
      Left = 13
      Top = 48
      Width = 35
      Height = 13
      Caption = 'Green :'
    end
    object Label3: TLabel
      Left = 13
      Top = 72
      Width = 27
      Height = 13
      Caption = 'Blue :'
    end
    object RedValueTrackBar: TTrackBar
      Left = 48
      Top = 24
      Width = 232
      Height = 23
      Max = 255
      Min = -255
      Position = 1
      TabOrder = 1
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = RedValueTrackBarChange
    end
    object UseColorAdjustEffect: TCheckBox
      Left = 8
      Top = 0
      Width = 129
      Height = 17
      Caption = 'Use color adjust Effect'
      TabOrder = 0
      OnClick = UseColorAdjustEffectClick
    end
    object GreenValueTrackBar: TTrackBar
      Left = 48
      Top = 47
      Width = 233
      Height = 23
      Max = 255
      Min = -255
      Position = 1
      TabOrder = 2
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = GreenValueTrackBarChange
    end
    object BlueValueTrackBar: TTrackBar
      Left = 48
      Top = 70
      Width = 233
      Height = 23
      Max = 255
      Min = -255
      Position = 1
      TabOrder = 3
      ThumbLength = 15
      TickStyle = tsManual
      OnChange = BlueValueTrackBarChange
    end
  end
  object Button1: TButton
    Left = 528
    Top = 246
    Width = 89
    Height = 25
    Caption = 'Save Settings'
    TabOrder = 11
    OnClick = Button1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 345
    Width = 647
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object GroupBox3: TGroupBox
    Left = 328
    Top = 230
    Width = 185
    Height = 107
    Caption = ' Draw Options '
    TabOrder = 13
    object CheckGrayScale: TCheckBox
      Left = 15
      Top = 32
      Width = 110
      Height = 17
      Caption = 'Grayscale drawing'
      TabOrder = 0
      OnClick = CheckGrayScaleClick
    end
    object CheckSepia: TCheckBox
      Left = 15
      Top = 80
      Width = 90
      Height = 17
      Caption = 'Sepia drawing'
      TabOrder = 1
      OnClick = CheckSepiaClick
    end
    object CheckReverseColor: TCheckBox
      Left = 15
      Top = 56
      Width = 90
      Height = 17
      Caption = 'Reverse Colors'
      TabOrder = 2
      OnClick = CheckReverseColorClick
    end
  end
end
