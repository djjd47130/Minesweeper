unit uOptions;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons,
  Common;

type
  TfrmOptions = class(TForm)
    radDifficulty: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;
    txtWidth: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    txtHeight: TEdit;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    txtCount: TEdit;
    Label4: TLabel;
    txtBoxSize: TEdit;
    Label5: TLabel;
    procedure radDifficultyClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure GameChanger(Sender: TObject);
    procedure txtBoxSizeChange(Sender: TObject);
  private
    FOptions: TOptions;
  public
    constructor Create(AOptions: TOptions);
    property Options: TOptions read FOptions;
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

uses
  uMain;

constructor TfrmOptions.Create(AOptions: TOptions);
begin
  inherited Create(nil);
  FOptions:= AOptions;
  txtWidth.Text:= IntToStr(AOptions.Width);
  txtHeight.Text:= IntToStr(AOptions.Height);
  txtCount.Text:= IntToStr(AOptions.Count);
  radDifficulty.ItemIndex:= Integer(AOptions.Difficulty);
  txtBoxSize.Text:= IntToStr(AOptions.BoxSize);
  FOptions.GameChanged:= False;
  FOptions.SizeChanged:= False;
end;

procedure TfrmOptions.BitBtn1Click(Sender: TObject);
begin
  //Check if current game has any progress
  if MessageDlg('This will restart the game. Continue?', mtWarning, [mbYes,mbNo], 0) = mrYes then begin
    ModalResult:= mrOK;
    BitBtn1.ModalResult:= mrOK;
    FOptions.Difficulty:= TDifficulty(radDifficulty.ItemIndex);
    FOptions.Width:= StrToIntDef(txtWidth.Text, 15);
    FOptions.Height:= StrToIntDef(txtHeight.Text, 15);
    FOptions.Count:= StrToIntDef(txtCount.Text, 5);
    FOptions.BoxSize:= StrToIntDef(txtBoxSize.Text, 20);
    Close;
  end;
end;

procedure TfrmOptions.radDifficultyClick(Sender: TObject);
begin
  //Changed difficulty
  case radDifficulty.ItemIndex of
    0: begin
      txtWidth.Text:= IntToStr(EASY_WIDTH);
      txtHeight.Text:= IntToStr(EASY_HEIGHT);
      txtCount.Text:= IntToStr(EASY_COUNT);
    end;
    1: begin
      txtWidth.Text:= IntToStr(MEDIUM_WIDTH);
      txtHeight.Text:= IntToStr(MEDIUM_HEIGHT);
      txtCount.Text:= IntToStr(MEDIUM_COUNT);
    end;
    2: begin
      txtWidth.Text:= IntToStr(HARD_WIDTH);
      txtHeight.Text:= IntToStr(HARD_HEIGHT);
      txtCount.Text:= IntToStr(HARD_COUNT);
    end;
    3: begin

    end;
  end;
  FOptions.GameChanged:= True;
end;

procedure TfrmOptions.txtBoxSizeChange(Sender: TObject);
begin
  FOptions.SizeChanged:= True;
end;

procedure TfrmOptions.GameChanger(Sender: TObject);
begin
  radDifficulty.ItemIndex:= 3;
  FOptions.GameChanged:= True;
end;

end.
