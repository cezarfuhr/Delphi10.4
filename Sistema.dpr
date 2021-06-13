program Sistema;

uses
  Vcl.Forms,
  FormMain in 'FormMain.pas' {FoMain},
  FBase in 'FBase.pas' {FrameBase: TFrame},
  FModule in 'FModule.pas' {Module: TDataModule},
  FBaseLista in 'FBaseLista.pas' {FrameLista: TFrame},
  classCliente in 'classes\classCliente.pas',
  classPedido in 'classes\classPedido.pas',
  classProduto in 'classes\produto\classProduto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TModule, Module);
  Application.CreateForm(TFoMain, FoMain);
  Application.Run;
end.
