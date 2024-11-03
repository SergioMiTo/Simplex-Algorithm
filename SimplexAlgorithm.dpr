program SimplexAlgorithm;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit_Simplex in 'Unit_Simplex.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
