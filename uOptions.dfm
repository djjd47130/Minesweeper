object frmOptions: TfrmOptions
  Left = 333
  Top = 599
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Minesweeper Options'
  ClientHeight = 187
  ClientWidth = 293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    293
    187)
  PixelsPerInch = 96
  TextHeight = 13
  object radDifficulty: TRadioGroup
    Left = 8
    Top = 8
    Width = 89
    Height = 138
    Caption = 'Difficulty'
    ItemIndex = 0
    Items.Strings = (
      'Easy'
      'Medium'
      'Hard'
      'Custom')
    TabOrder = 0
    OnClick = radDifficultyClick
  end
  object BitBtn1: TBitBtn
    Left = 219
    Top = 155
    Width = 66
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    Default = True
    TabOrder = 1
    OnClick = BitBtn1Click
    ExplicitLeft = 152
    ExplicitTop = 167
  end
  object BitBtn2: TBitBtn
    Left = 147
    Top = 155
    Width = 66
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    ExplicitLeft = 80
    ExplicitTop = 167
  end
  object GroupBox1: TGroupBox
    Left = 103
    Top = 8
    Width = 137
    Height = 66
    Caption = 'Field Size'
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 21
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object Label1: TLabel
      Left = 48
      Top = 36
      Width = 25
      Height = 16
      Caption = '  X  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 72
      Top = 22
      Width = 31
      Height = 13
      Caption = 'Height'
    end
    object txtWidth: TEdit
      Left = 8
      Top = 35
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '15'
      OnChange = GameChanger
    end
    object txtHeight: TEdit
      Left = 72
      Top = 35
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '15'
      OnChange = GameChanger
    end
  end
  object GroupBox3: TGroupBox
    Left = 103
    Top = 80
    Width = 137
    Height = 66
    Caption = 'Other'
    TabOrder = 4
    object Label4: TLabel
      Left = 8
      Top = 22
      Width = 54
      Height = 13
      Caption = 'Mine Count'
    end
    object Label5: TLabel
      Left = 72
      Top = 22
      Width = 40
      Height = 13
      Caption = 'Box Size'
    end
    object txtCount: TEdit
      Left = 8
      Top = 35
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '5'
      OnChange = GameChanger
    end
    object txtBoxSize: TEdit
      Left = 72
      Top = 35
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '15'
      OnChange = txtBoxSizeChange
    end
  end
end
