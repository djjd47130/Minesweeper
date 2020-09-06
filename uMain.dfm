object frmMain: TfrmMain
  Left = 323
  Top = 140
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Minesweeper'
  ClientHeight = 225
  ClientWidth = 316
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MM
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 200
    Top = 8
    Width = 73
    Height = 41
    Brush.Color = 14217205
    Visible = False
  end
  object Pages: TPageControl
    Left = 0
    Top = 55
    Width = 316
    Height = 170
    ActivePage = tabField
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    ExplicitWidth = 379
    ExplicitHeight = 328
    object tabField: TTabSheet
      Caption = 'Mine Field'
      ExplicitWidth = 177
      ExplicitHeight = 157
      object pTop: TPanel
        Left = 0
        Top = 0
        Width = 308
        Height = 42
        Align = alTop
        TabOrder = 0
        OnResize = pTopResize
        ExplicitWidth = 336
        DesignSize = (
          308
          42)
        object lblMines: TLabel
          Left = 8
          Top = 10
          Width = 24
          Height = 23
          Caption = '00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblTime: TLabel
          Left = 272
          Top = 10
          Width = 24
          Height = 23
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitLeft = 376
        end
        object cmdMain: TBitBtn
          Left = 128
          Top = 9
          Width = 25
          Height = 25
          TabOrder = 0
          TabStop = False
        end
      end
      object Field: TStringGrid
        Left = 0
        Top = 80
        Width = 308
        Height = 62
        Cursor = crHandPoint
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        ColCount = 15
        DefaultColWidth = 20
        DefaultRowHeight = 20
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 15
        FixedRows = 0
        GridLineWidth = 0
        ScrollBars = ssNone
        TabOrder = 1
        OnDrawCell = FieldDrawCell
        OnMouseDown = FieldMouseDown
        OnMouseLeave = FieldMouseLeave
        OnMouseMove = FieldMouseMove
        ExplicitWidth = 310
        ExplicitHeight = 89
      end
    end
    object tabOptions: TTabSheet
      Caption = 'tabOptions'
      ImageIndex = 1
      ExplicitWidth = 419
      ExplicitHeight = 241
    end
    object tabHighScores: TTabSheet
      Caption = 'High Scores'
      ImageIndex = 2
      ExplicitWidth = 419
      ExplicitHeight = 241
    end
    object tabEnterHighScore: TTabSheet
      Caption = 'Enter High Score'
      ImageIndex = 3
      ExplicitWidth = 419
      ExplicitHeight = 241
    end
  end
  object MM: TMainMenu
    Left = 16
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object NewGame1: TMenuItem
        Action = actNewGame
      end
      object HighScores1: TMenuItem
        Caption = 'High Scores'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = actExit
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object MineField1: TMenuItem
        Caption = 'Mine Field'
      end
      object Options3: TMenuItem
        Caption = 'Options'
      end
      object HighScores2: TMenuItem
        Caption = 'High Scores'
      end
    end
    object Options1: TMenuItem
      Caption = 'Edit'
      object Options2: TMenuItem
        Action = actOptions
      end
      object Difficulty1: TMenuItem
        Caption = 'Difficulty'
        object Easy1: TMenuItem
          Action = actSetEasy
        end
        object Medium1: TMenuItem
          Action = actSetMedium
        end
        object Hard1: TMenuItem
          Action = actSetHard
        end
        object Custom1: TMenuItem
          Action = actSetCustom
        end
      end
    end
  end
  object Actions: TActionManager
    Left = 64
    Top = 8
    StyleName = 'Platform Default'
    object actNewGame: TAction
      Caption = 'New Game'
      OnExecute = actNewGameExecute
    end
    object actExit: TAction
      Caption = 'Exit'
    end
    object actOptions: TAction
      Caption = 'Options'
      OnExecute = actOptionsExecute
    end
    object actSetEasy: TAction
      Caption = 'Easy'
      OnExecute = actSetEasyExecute
    end
    object actSetMedium: TAction
      Caption = 'Medium'
      OnExecute = actSetMediumExecute
    end
    object actSetHard: TAction
      Caption = 'Hard'
      OnExecute = actSetHardExecute
    end
    object actSetCustom: TAction
      Caption = 'Custom...'
    end
    object actResetGame: TAction
      Caption = 'Reset'
      OnExecute = actResetGameExecute
    end
  end
  object tmrTime: TTimer
    Interval = 200
    OnTimer = tmrTimeTimer
    Left = 112
    Top = 8
  end
end
