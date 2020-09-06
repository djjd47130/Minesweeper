unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnList, Vcl.ActnMan,
  Vcl.StdCtrls, Vcl.Buttons,
  Common, MsgList, Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    MM: TMainMenu;
    File1: TMenuItem;
    NewGame1: TMenuItem;
    HighScores1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    Options2: TMenuItem;
    Difficulty1: TMenuItem;
    Easy1: TMenuItem;
    Medium1: TMenuItem;
    Hard1: TMenuItem;
    Custom1: TMenuItem;
    Actions: TActionManager;
    actNewGame: TAction;
    actExit: TAction;
    actOptions: TAction;
    actSetEasy: TAction;
    actSetMedium: TAction;
    actSetHard: TAction;
    actSetCustom: TAction;
    actResetGame: TAction;
    Shape1: TShape;
    tmrTime: TTimer;
    Pages: TPageControl;
    tabField: TTabSheet;
    pTop: TPanel;
    lblMines: TLabel;
    lblTime: TLabel;
    cmdMain: TBitBtn;
    Field: TStringGrid;
    tabOptions: TTabSheet;
    tabHighScores: TTabSheet;
    tabEnterHighScore: TTabSheet;
    View1: TMenuItem;
    MineField1: TMenuItem;
    Options3: TMenuItem;
    HighScores2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FieldDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure actOptionsExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actResetGameExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FieldMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FieldMouseLeave(Sender: TObject);
    procedure FieldMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure actNewGameExecute(Sender: TObject);
    procedure tmrTimeTimer(Sender: TObject);
    procedure pTopResize(Sender: TObject);
    procedure actSetEasyExecute(Sender: TObject);
    procedure actSetMediumExecute(Sender: TObject);
    procedure actSetHardExecute(Sender: TObject);
  private
    FLoaded: Boolean;
    FOptions: TOptions;
    FCurBox: TBox;
    FMines: TIntArray;
    FStarted: TDateTime;
    FEnded: TDateTime;
    FWon: Boolean;
    FWinMsg: TMsgList;
    FLoseMsg: TMsgList;
    FNewMsg: TMsgList;
    procedure ResetGame;
    procedure ResizeGrid;
    function TouchCount(ACol, ARow: Integer): Integer;
    function GetCell(ACol, ARow: Integer): TBox;
    procedure FloodOpen(ACol, ARow: Integer);
    procedure UpdateCount;
    procedure CheckEnded;
    procedure EndGame(Won: Boolean);
    function FlaggedCount: Integer;
    function CalculateScore: Integer;
    procedure CreateMessages;
    function PromptNewGame: Boolean;
  public
    property Options: TOptions read FOptions write FOptions;
    property Cells[ACol, ARow: Integer]: TBox read GetCell;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uOptions, DateUtils, Math;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
var
  X: Integer;
begin
  ReportMemoryLeaksOnShutdown:= True;
  FLoaded:= False;
  Pages.Align:= alClient;
  for X := 0 to Pages.PageCount-1 do begin
    Pages.Pages[X].TabVisible:= False;
  end;
  tabField.Show;
  Field.Align:= alClient;
  FWinMsg:= TMsgList.Create;
  FLoseMsg:= TMsgList.Create;
  FNewMsg:= TMsgList.Create;
  CreateMessages;
  FOptions.Difficulty:= dfEasy;
  FOptions.Width:= EASY_WIDTH;
  FOptions.Height:= EASY_HEIGHT;
  FOptions.Count:= EASY_COUNT;
  FOptions.BoxSize:= BOX_SIZE;
  FOptions.GameChanged:= False;
  FOptions.SizeChanged:= False;
  ResetGame;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  X, Y: Integer;
  B: TBox;
begin
  for X := 0 to Field.RowCount - 1 do begin
    for Y := 0 to Field.ColCount - 1 do begin
      B:= TBox(Field.Objects[Y, X]);
      B.Free;
    end;
  end;
  FWinMsg.Free;
  FLoseMsg.Free;
  FNewMsg.Free;
end;

procedure TfrmMain.ResetGame;
var
  X, Y, Z, I: Integer;
  B: TBox;
begin
  tmrTime.Enabled:= False;
  Randomize;
  //First, clear data
  if FLoaded then begin
    for X := 0 to Field.RowCount - 1 do begin
      for Y := 0 to Field.ColCount - 1 do begin
        B:= Cells[Y, X];
        B.Free;
      end;
    end;
  end;

  //Next, set counts and resize
  Field.ColCount:= FOptions.Width;
  Field.RowCount:= FOptions.Height;
  ResizeGrid;
  FLoaded:= True;

  //Then, populate data
  for X := 0 to Field.RowCount - 1 do begin
    for Y := 0 to Field.ColCount - 1 do begin
      B:= TBox.Create(X, Y);
      Field.Objects[Y, X]:= B;
    end;
  end;

  //Now, set mines in random places
  FMines:= Common.RandomRange(FOptions.Width * FOptions.Height, FOptions.Count);
  I:= 0;
  for X := 0 to Field.RowCount - 1 do begin
    for Y := 0 to Field.ColCount - 1 do begin
      B:= Cells[Y, X];
      B.HasMine:= False;
      for Z := 0 to Length(FMines)-1 do begin
        if FMines[Z] = I then begin
          B.HasMine:= True;
          Break;
        end;
      end;
      Inc(I);
    end;
  end;

  //Finally, calculate mines touching each box
  for X := 0 to Field.RowCount - 1 do begin
    for Y := 0 to Field.ColCount - 1 do begin
      B:= Cells[Y, X];
      B.Touching:= TouchCount(Y, X);
    end;
  end;

  UpdateCount;
  FStarted:= 0;
  FEnded:= 0;
  tmrTime.Enabled:= True;
end;

function TfrmMain.TouchCount(ACol, ARow: Integer): Integer;
var
  B, T: TBox;
begin
  Result:= 0;
  B:= Cells[ACol, ARow];
  if ACol > 0 then begin
    if Cells[ACol-1, ARow].HasMine then Inc(Result);
    if ARow > 0 then
      if Cells[ACol-1, ARow-1].HasMine then Inc(Result);
    if ARow < Field.RowCount-1 then
      if Cells[ACol-1, ARow+1].HasMine then Inc(Result);
  end;
  if ACol < Field.ColCount-1 then begin
    if Cells[ACol+1, ARow].HasMine then Inc(Result);
    if ARow > 0 then
      if Cells[ACol+1, ARow-1].HasMine then Inc(Result);
    if ARow < Field.RowCount-1 then
      if Cells[ACol+1, ARow+1].HasMine then Inc(Result);
  end;
  if ARow > 0 then
    if Cells[ACol, ARow-1].HasMine then Inc(Result);
  if ARow < Field.RowCount-1 then
    if Cells[ACol, ARow+1].HasMine then Inc(Result);
end;

procedure TfrmMain.ResizeGrid;
var
  X, DW, DH: Integer;
begin
  for X := 0 to Field.ColCount-1 do
    Field.ColWidths[X]:= FOptions.BoxSize;
  for X := 0 to Field.RowCount-1 do
    Field.RowHeights[X]:= FOptions.BoxSize;
  ClientWidth:= (FOptions.Width * FOptions.BoxSize) + 8;
  ClientHeight:= (FOptions.Height * FOptions.BoxSize) + pTop.Height + 10;
  //Center form with screen
  //  This should be re-done to only move form onto screen if it's outside
  Left:= (Screen.Width div 2) - (Width div 2);
  Top:= (Screen.Height div 2) - (Height div 2);
end;

procedure TfrmMain.tmrTimeTimer(Sender: TObject);
var
  T: Integer;
begin
  //Calculate time elapsed
  if (FStarted <> 0) and (FEnded = 0) then begin
    T:= SecondsBetween(FStarted, Now);
    lblTime.Caption:= IntToStr(T)+' secs';
  end;
end;

function TfrmMain.PromptNewGame: Boolean;
begin
  Result:= MessageDlg(FNewMsg.RandomMsg, mtWarning, [mbYes,mbNo], 0) = mrYes;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  ResetGame;
end;

function TfrmMain.GetCell(ACol, ARow: Integer): TBox;
begin
  Result:= TBox(Field.Objects[ACol, ARow]);
end;

procedure TfrmMain.pTopResize(Sender: TObject);
begin
  cmdMain.Left:= (pTop.ClientWidth div 2) - (cmdMain.Width div 2);
end;

procedure TfrmMain.actNewGameExecute(Sender: TObject);
begin
  case MessageDlg(FNewMsg.RandomMsg,
    mtWarning, [mbYes,mbNo], 0) of
    mrYes: begin
      ResetGame;
    end;
  end;
end;

procedure TfrmMain.actOptionsExecute(Sender: TObject);
var
  Opt: TfrmOptions;
begin
  Opt:= TfrmOptions.Create(FOptions);
  try
    Opt.ShowModal;
    FOptions:= Opt.Options;
    if FOptions.SizeChanged then begin
      ResizeGrid;
    end;
    if FOptions.GameChanged then begin
      ResetGame;
    end;
  finally
    Opt.Free;
  end;
end;

procedure TfrmMain.actResetGameExecute(Sender: TObject);
begin
  ResetGame;
end;

procedure TfrmMain.actSetEasyExecute(Sender: TObject);
begin
  //Set Easy

end;

procedure TfrmMain.actSetHardExecute(Sender: TObject);
begin
  //Set Hard

end;

procedure TfrmMain.actSetMediumExecute(Sender: TObject);
begin
  //Set Mediu

end;

procedure TfrmMain.FloodOpen(ACol, ARow: Integer);
var
  B: TBox;
  procedure Chk(const C, R: Integer);
  var
    T: TBox;
  begin
    T:= Cells[C, R];
    if (T.Status = bsNone) and (not T.HasMine) then begin
      T.Status:= bsEmpty;
      if T.Touching = 0 then
        FloodOpen(C, R);
    end;
  end;
begin
  //Open all empty cells surrounding current
  B:= Cells[ACol, ARow];
  if ACol > 0 then begin
    Chk(ACol-1, ARow);
    if ARow > 0 then
      Chk(ACol-1, ARow-1);
    if ARow < Field.RowCount-1 then
      Chk(ACol-1, ARow+1);
  end;
  if ACol < Field.ColCount-1 then begin
    Chk(ACol+1, ARow);
    if ARow > 0 then
      Chk(ACol+1, ARow-1);
    if ARow < Field.RowCount-1 then
      Chk(ACol+1, ARow+1);
  end;
  if ARow > 0 then
    Chk(ACol, ARow-1);
  if ARow < Field.RowCount-1 then
    Chk(ACol, ARow+1);
end;

function TfrmMain.CalculateScore: Integer;
var
  MC, CC, TM, TN, EM: Integer;
begin
  MC:= FOptions.Count;                        //Total Mine Count
  CC:= (FOptions.Width * FOptions.Height);    //Total Cell Count
  TM:= SecondsBetween(FStarted, FEnded);      //Seconds taken to complete
  EM:= CC - MC;                               //Total empty cell count
  //TN:= EM * 5;                                //Time needed
  TN:= MC * 10;
  Result:= TN - TM;
end;

procedure TfrmMain.EndGame(Won: Boolean);
begin
  FEnded:= Now;
  FWon:= Won;
  if FWon then begin
    //Calculate score
    if MessageDlg(FWinMsg.RandomMsg + sLineBreak +
      'Score: '+IntToStr(CalculateScore) + sLineBreak +
      'Would you like to start a new game?',
      mtInformation, [mbYes,mbNo], 0) = mrYes then
    begin
      ResetGame;
    end;
  end else begin
    if MessageDlg(FLoseMsg.RandomMsg + sLineBreak +
      'Would you like to start a new game?',
      mtInformation, [mbYes,mbNo], 0) = mrYes then
    begin
      ResetGame;
    end;
  end;
end;

function TfrmMain.FlaggedCount: Integer;
var
  X, Y: Integer;
  B: TBox;
begin
  Result:= 0;
  for X := 0 to Field.RowCount-1 do begin
    for Y := 0 to Field.ColCount-1 do begin
      B:= Cells[Y, X];
      if B.Status = bsFlagged then Inc(Result);
    end;
  end;
end;

procedure TfrmMain.CheckEnded;
var
  X, Y, F, N: Integer;
  B: TBox;
begin
  //Check if all empty cells are opened and mines are flagged
  F:= 0; //Flagged
  N:= 0; //Not Opened
  for X := 0 to Field.RowCount-1 do begin
    for Y := 0 to Field.ColCount-1 do begin
      B:= Cells[Y, X];
      case B.Status of
        bsNone, bsUnknown:  Inc(N);
        bsFlagged:          Inc(F);
      end;
    end;
  end;
  if (F = FOptions.Count) and (N = 0) then begin
    EndGame(True);
  end;
end;

procedure TfrmMain.CreateMessages;
begin
  //Win Messages
  FWinMsg.Clear;
  FWinMsg.Add('You''ve cleared all the mines!');
  FWinMsg.Add('Way to go!');
  FWinMsg.Add('That''s what I''m talkin'' bout, baby!');
  FWinMsg.Add('That was fucking awesome.');
  FWinMsg.Add('You fucking rawk!');
  FWinMsg.Add('You saved the day!');
  FWinMsg.Add('Keep that shit up pal!');
  //FWinMsg.Add('');

  //Lose Messages
  FLoseMsg.Clear;
  FLoseMsg.Add('What the fuck was that?');
  FLoseMsg.Add('You fucking suck.');
  FLoseMsg.Add('BOOM! You just killed everyone.');
  FLoseMsg.Add('You''re fucking dead.');
  FLoseMsg.Add('Your body has been blown to bits.');
  FLoseMsg.Add('Killed In Action.');
  FLoseMsg.Add('You''ve been fragged!');
  FLoseMsg.Add('You''ve been pwned!');
  //FLoseMsg.Add('');
  //FLoseMsg.Add('');
  //FLoseMsg.Add('');

  //New Messages
  FNewMsg.Clear;
  FNewMsg.Add('Are you sure you want to start a new game?');
  FNewMsg.Add('What? New game? Are you sure?');
  FNewMsg.Add('Good luck in the field. Continue?');
  FNewMsg.Add('Why so serious? New game?');
  FNewMsg.Add('Do you absolutely positively want to start a new game?');
  //FNewMsg.Add('');
  //FNewMsg.Add('');
  //FNewMsg.Add('');
  //FNewMsg.Add('');
  //FNewMsg.Add('');

end;

procedure TfrmMain.FieldMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  B, T: TBox;
  C, R: Integer;
  XT, YT: Integer;
begin
  if FEnded = 0 then begin
    Field.MouseToCell(X, Y, C, R);
    B:= TBox(Field.Objects[C, R]);
    case Button of
      TMouseButton.mbLeft: begin
        case B.Status of
          bsNone: begin
            if B.HasMine then begin
              B.Status:= bsHit;
              //Trigger hit and lose
              for XT := 0 to Field.RowCount-1 do begin
                for YT := 0 to Field.ColCount-1 do begin
                  T:= Cells[YT, XT];
                  if T <> B then
                    if T.HasMine then
                      if B.Status = bsFlagged then
                        T.Status:= bsShowMine
                      else
                        T.Status:= bsHit;
                end;
              end;
              EndGame(False);
            end else begin
              B.Status:= bsEmpty;
              if B.Touching = 0 then begin
                FloodOpen(C, R);
              end;
            end;
          end;
        end;
      end;
      TMouseButton.mbRight: begin
        case B.Status of
          bsNone: B.Status:= bsFlagged;
          bsFlagged: B.Status:= bsUnknown;
          bsUnknown: B.Status:= bsNone;
        end;
      end;
    end;
    UpdateCount;
    Field.Invalidate;
    if FStarted = 0 then
      FStarted:= Now;
    if FEnded = 0 then
      CheckEnded;
  end;
end;

procedure TfrmMain.UpdateCount;
var
  X, Y, C: Integer;
  B: TBox;
begin
  C:= FOptions.Count;
  for X := 0 to Field.RowCount-1 do begin
    for Y := 0 to Field.ColCount-1 do begin
      B:= Cells[Y, X];
      if B.Status = bsFlagged then
        Dec(C);
    end;
  end;
  lblMines.Caption:= IntToStr(C)+' left';
end;

procedure TfrmMain.FieldMouseLeave(Sender: TObject);
begin
  if Assigned(FCurBox) then begin
    FCurBox.Hover:= False;
    Field.Invalidate;
  end;
end;

procedure TfrmMain.FieldMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  B: TBox;
  C, R: Integer;
  XT: Integer;
  YT: Integer;
begin
  Field.MouseToCell(X, Y, C, R);
  B:= TBox(Field.Objects[C, R]);
  if B <> FCurBox then begin
    if Assigned(FCurBox) then
      FCurBox.Hover:= False;
    FCurBox:= B;
    B.Hover:= True;
    Field.Invalidate;
  end;
end;

procedure TfrmMain.FieldDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  C: TCanvas;
  Br: TBrush;
  Pn: TPen;
  B: TBox;
  R: TRect;
  procedure DrawNone;
  begin
    //Draw nothing
  end;
  procedure DrawEmpty;
  begin
    //Draw touch count, if > 0
    if B.Touching > 0 then begin
      C.Font.Color:= clBlack;
      C.Font.Style:= [fsBold];
      C.Font.Size:= 12;
      C.TextOut(R.Left, R.Top, ' '+IntToStr(B.Touching));
    end;
  end;
  procedure DrawFlagged;
  begin
    //Draw flag
    InflateRect(R, -2, -2);
    C.Ellipse(R);
  end;
  procedure DrawUnknown;
  begin
    //Draw a question mark
    Pn.Style:= psSolid;
    Br.Style:= bsClear;
    C.Font.Color:= Pn.Color;
    C.Font.Style:= [fsBold];
    C.Font.Size:= 12;
    C.TextOut(R.Left, R.Top, ' ?');
  end;
  procedure DrawHit;
  begin
    //Draw a hit mine
    InflateRect(R, -2, -2);
    Pn.Color:= clRed;
    C.MoveTo(R.Left, R.Top);
    C.LineTo(R.Right, R.Bottom);
    C.MoveTo(R.Right, R.Top);
    C.LineTo(R.Left, R.Bottom);
  end;
  procedure DrawShowMine;
  begin
    //Draw an uncovered mine
    InflateRect(R, -2, -2);
    Br.Style:= bsSolid;
    Br.Color:= clGray;
    Pn.Color:= clGray;
    C.Ellipse(R);
  end;
begin
  C:= Field.Canvas;
  Br:= C.Brush;
  Pn:= C.Pen;
  B:= TBox(Field.Objects[ACol, ARow]);
  if Assigned(B) then begin
    Br.Style:= bsSolid;

    case B.Status of
      bsNone, bsFlagged, bsUnknown: begin
        if B.Hover then
          Br.Color:= CLR_HOVER
        else
          Br.Color:= CLR_NONE;
      end;
      bsEmpty: begin
        Br.Color:= CLR_DOWN;
      end;
      bsHit: begin
        Br.Color:= clBlack;
      end;
      bsShowMine: begin
        Br.Color:= clNavy;
      end;
    end;

    Pn.Style:= psClear;
    C.FillRect(Rect);

    Pn.Style:= psSolid;
    Br.Style:= bsClear;
    Pn.Color:= CLR_LINE;
    Pn.Width:= 1;
    C.MoveTo(Rect.Right-1, Rect.Top);
    C.LineTo(Rect.Right-1, Rect.Bottom-1);
    C.MoveTo(Rect.Left, Rect.Bottom-1);
    C.LineTo(Rect.Right-1, Rect.Bottom-1);

    Pn.Color:= clWhite;
    Pn.Width:= 2;
    R:= Rect;
    case B.Status of
      bsNone: begin
        DrawNone;
      end;
      bsEmpty: begin
        DrawEmpty;
      end;
      bsFlagged: begin
        DrawFlagged;
      end;
      bsUnknown: begin
        DrawUnknown;
      end;
      bsHit: begin
        DrawHit;
      end;
      bsShowMine: begin
        DrawShowMine;
      end;
    end;
  end;
end;

end.
