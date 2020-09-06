program Minesweeper;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uOptions in 'uOptions.pas' {frmOptions},
  Vcl.Themes,
  Vcl.Styles,
  Common in 'Common.pas',
  MsgList in 'MsgList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'JD Minesweeper';
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
