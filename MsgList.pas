unit MsgList;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils;

type
  TMsgItem = class;
  TMsgList = class;

  TStringArray = array of String;

  TMsgItem = class(TPersistent)
  private
    FOwner: TMsgList;
    FMsg: String;
    procedure SetMsg(const Value: String);
  public
    constructor Create(AOwner: TMsgList);
    destructor Destroy; override;
  published
    property Msg: String read FMsg write SetMsg;
  end;

  TMsgList = class(TPersistent)
  private
    FItems: TList;
    function GetItem(Index: Integer): TMsgItem;
    procedure SetItem(Index: Integer; const Value: TMsgItem);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const Msg: String = ''): TMsgItem;
    function Count: Integer;
    procedure Clear;
    procedure Delete(const Index: Integer);
    function RandomMsg(const Params: TStringArray = nil): String;
    property Items[Index: Integer]: TMsgItem read GetItem write SetItem; default;
  end;

implementation

{ TMsgItem }

constructor TMsgItem.Create(AOwner: TMsgList);
begin
  FOwner:= AOwner;

end;

destructor TMsgItem.Destroy;
begin

  inherited;
end;

procedure TMsgItem.SetMsg(const Value: String);
begin
  FMsg := Value;
end;

{ TMsgList }

constructor TMsgList.Create;
begin
  FItems:= TList.Create;
end;

destructor TMsgList.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

function TMsgList.GetItem(Index: Integer): TMsgItem;
begin
  Result:= TMsgItem(FItems[Index]);
end;

function TMsgList.RandomMsg(const Params: TStringArray = nil): String;
var
  T: TMsgItem;
  C, X: Integer;
  S, N, V: String;
begin
  Randomize;
  C:= Count;
  X:= Random(C);
  T:= Items[X];
  Result:= T.Msg;
  for X:= 0 to Length(Params)-1 do begin
    S:= Params[X];
    N:= Copy(S, 1, Pos(':', S)-1);
    System.Delete(S, 1, Pos(':', S));
    V:= S;
    Result:= StringReplace(Result, '['+N+']', V, [rfReplaceAll]);
  end;
end;

procedure TMsgList.SetItem(Index: Integer; const Value: TMsgItem);
begin
  TMsgItem(FItems[Index]).Assign(Value);
end;

function TMsgList.Add(const Msg: String = ''): TMsgItem;
begin
  Result:= TMsgItem.Create(Self);
  FItems.Add(Result);
  Result.Msg:= Msg;
end;

procedure TMsgList.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

function TMsgList.Count: Integer;
begin
  Result:= FItems.Count;
end;

procedure TMsgList.Delete(const Index: Integer);
begin
  TMsgItem(FItems[Index]).Free;
  FItems.Delete(Index);
end;

end.
