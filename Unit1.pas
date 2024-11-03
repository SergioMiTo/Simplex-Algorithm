unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Unit_Simplex, Math,
  Vcl.NumberBox, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Jpeg;

type
  TForm1 = class(TForm)
    bCalculate: TButton;
    Edit_a: TEdit;
    Edit_b: TEdit;
    nbConstant_a: TNumberBox;
    nbConstant_b: TNumberBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    nbAlfa: TNumberBox;
    nbBeta: TNumberBox;
    nbGamma: TNumberBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image1: TImage;
    nbError: TNumberBox;
    LabelError: TLabel;
    LabelMaxIterations: TLabel;
    nbStep: TNumberBox;
    LabelStep: TLabel;
    nbMaxIterations: TNumberBox;
    bGenerate: TButton;
    nbNumber_Data: TNumberBox;
    lDataNumber: TLabel;
    Label8: TLabel;
    nbErrorFunction: TNumberBox;
    Memo: TMemo;
    Label9: TLabel;
    pGenerateData: TPanel;
    lTitle: TLabel;
    Label10: TLabel;
    procedure bCalculateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bGenerateClick(Sender: TObject);

  private
    { Private declarations }

    n : integer;
    m : integer;  // number of parameters to fit
    nvpp :integer;   // number of vars per data point
    np :integer; //  number of data points

    data :tdata;

    function generar_y (x,a,b: extended):extended;

  public
    { Public declarations }
  end;




var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.bCalculateClick(Sender: TObject);
var resultado: toutput;


begin




  resultado:=   simplex (data, nbMaxIterations.valueInt, m, nvpp, nbAlfa.value,nbBeta.value,nbGamma.value, nbStep.Value, nbError.Value);
  edit_a.Text := resultado.values[1].ToString;
  edit_b.Text := resultado.values[2].ToString;

  memo.Text :=  memo.Text + sLineBreak +  resultado.report;

end;

function  TForm1.generar_y (x,a,b: extended):extended;
begin

result := (a *x)/ (x+b)
end;



procedure TForm1.bGenerateClick(Sender: TObject);
var i :integer;
    x:extended;
    y:extended;
    r:extended;
begin
bCalculate.Enabled := true;
  m:=2;  // number of parameters to fit
  nvpp :=2;   // number of vars per data point
  // n := m+1;
  np := nbNumber_Data.ValueInt; // maximum number of data points

  Setlength (data, np,nvpp );

 Randomize;
 x:= 0;
 for i := 0 to np-1 do
  begin

  x:= x+ random;
  y:= (random * nbErrorFunction.ValueFloat )   + generar_y(x, nbConstant_a.Value, nbConstant_b.Value  );
  data[I][0] := x;
  data[I][1] := y;
  end;
 memo.Text := memo.Text + sLineBreak +   ' New Data Generated ' ;
 end;

procedure TForm1.FormCreate(Sender: TObject);
var
  jp: TJPEGImage;  //Requires the jpeg unit added to the uses clause.
begin
  jp := TJPEGImage.Create;
    with jp do
    begin
      Assign(Image1.Picture.Bitmap);
      //SaveToFile('function.jpg');
      Image1.Stretch := True;
      Image1.Picture.LoadFromFile('funcion.jpg');
    end;

end;

end.
