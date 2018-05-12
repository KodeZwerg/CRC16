object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CRC16 Sample'
  ClientHeight = 156
  ClientWidth = 444
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEdit1: TLabeledEdit
    Left = 16
    Top = 32
    Width = 185
    Height = 21
    EditLabel.Width = 102
    EditLabel.Height = 13
    EditLabel.Caption = 'Eingabe eines Strings'
    TabOrder = 0
  end
  object LabeledEdit2: TLabeledEdit
    Left = 320
    Top = 50
    Width = 97
    Height = 21
    EditLabel.Width = 78
    EditLabel.Height = 13
    EditLabel.Caption = 'CRC16 Ausgabe'
    ReadOnly = True
    TabOrder = 1
    Text = '0000'
  end
  object Button1: TButton
    Left = 223
    Top = 87
    Width = 194
    Height = 25
    Caption = 'CRC16 von Datei'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 223
    Top = 30
    Width = 75
    Height = 25
    Caption = 'Berechne'
    TabOrder = 3
    OnClick = Button2Click
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 59
    Width = 193
    Height = 70
    Caption = 'String-Eingabe Art'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'String'
      'Hex-String')
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Options = [ofReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofShareAware, ofNoNetworkButton, ofEnableIncludeNotify, ofEnableSizing, ofDontAddToRecent, ofForceShowHidden]
    Left = 232
    Top = 8
  end
end
