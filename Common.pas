unit Common;

interface

uses
  Graphics, MsgList, IniFiles;

const
  EASY_WIDTH = 15;
  EASY_HEIGHT = 15;
  EASY_COUNT = 20;
  MEDIUM_WIDTH = 30;
  MEDIUM_HEIGHT = 30;
  MEDIUM_COUNT = 75;
  HARD_WIDTH = 40;
  HARD_HEIGHT = 40;
  HARD_COUNT = 100;
  CLR_NONE = clBlack;
  CLR_HOVER = clDkGray;
  CLR_LINE = $00252525;
  CLR_DOWN = clLtGray;
  BOX_SIZE = 22;

type
  TBox = class;

  TDifficulty = (dfEasy, dfMedium, dfHard, dfCustom);

  TBoxStatus = (bsNone, bsEmpty, bsFlagged, bsUnknown, bsHit, bsShowMine);

  TIntArray = array of Integer;

  TOptions = record
    Difficulty: TDifficulty;
    Width: Integer;
    Height: Integer;
    Count: Integer;
    BoxSize: Integer;
    GameChanged: Boolean;
    SizeChanged: Boolean;
  end;

  TBox = class(TObject)
  private
    FCol: Integer;
    FRow: Integer;
    FHasMine: Boolean;
    FStatus: TBoxStatus;
    FHover: Boolean;
    FTouching: Integer;
  public
    constructor Create(const Row, Col: Integer);
    destructor Destroy; override;
    property Hover: Boolean read FHover write FHover;
    property Status: TBoxStatus read FStatus write FStatus;
    property HasMine: Boolean read FHasMine write FHasMine;
    property Touching: Integer read FTouching write FTouching;
  end;

  TScore = record
    Name: String;
    DT: TDateTime;
    Mines: Integer;
    Width: Integer;
    Length: Integer;
    Seconds: Integer;
    Score: Integer;
  end;
  TScores = array of TScore;

  TScoreFile = class(TObject)
  private
    FScores: TScores;
  public

  end;

function RandomRange(const Range, Count: Integer): TIntArray;

implementation

function RandomRange(const Range, Count: Integer): TIntArray;
var
  X: Integer;
  R: TIntArray;
  function Exists(const I: Integer): Boolean;
  var
    Y: Integer;
  begin
    Result:= False;
    for Y := 0 to X do begin
      if R[Y] = I then begin
        Result:= True;
        Break;
      end;
    end;
  end;
  function RndInt: Integer;
  begin
    repeat
      Result:= Random(Range);
    until not Exists(Result);
  end;
begin
  SetLength(R, Count);
  for X := 0 to Count-1 do begin
    R[X]:= RndInt;
  end;
  Result:= R;
end;

{ TBox }

constructor TBox.Create(const Row, Col: Integer);
begin
  FHover:= False;
end;

destructor TBox.Destroy;
begin

  inherited;
end;

end.
