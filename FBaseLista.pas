unit FBaseLista;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FBase, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TBotao = class
    Caption: String;
    AbreCadastro: String;
    OnClick: procedure(Sender: TObject) of object;
  end;

  TBotoes = class(TList)

  end;

  TFrameLista = class(TFrameBase)
    AListaGrid: TDBGrid;
    Panel1: TPanel;

    procedure BotaoClicado(Sender: TObject);
  private
    dsLista: TDataSource;

    FBotoes: TBotoes;
    FADataset: TDataSet;

    procedure LoadBotoes;
    procedure LoadPreferences;

  public
    procedure CreateDs;

    property Dataset: TDataSet read FADataset write FADataset;
    property Botoes: TBotoes read FBotoes write FBotoes;
  end;

var
  FrameLista: TFrameLista;

implementation

{$R *.dfm}

procedure TFrameLista.LoadPreferences;
begin
  AListaGrid.Font.Size := 11;
  AListaGrid.DataSource := dsLista;
end;

procedure TFrameLista.LoadBotoes;

  function Botao1: TBotao;
  begin
    Result := TBotao.Create;
    Result.Caption := 'Teste 1';
    Result.AbreCadastro := 'cadCliente';
    Result.OnClick := BotaoClicado;
  end;

  function Botao2: TBotao;
  begin
    Result := TBotao.Create;
    Result.Caption := 'Teste 2';
    Result.AbreCadastro := 'cadFornecedor';
    Result.OnClick := BotaoClicado;
  end;

var
  I: Integer;
  Btn: TBotao;
begin
  FBotoes := TBotoes.Create;
  FBotoes.Add(Botao1);
  FBotoes.Add(Botao2);

  for I := 0 to FBotoes.Count - 1 do
  begin
    Btn := TBotao(FBotoes.Items[I]);

    with TBitBtn.Create(nil) do
    begin
      Align := alLeft;
      Parent := Panel1;
      Caption := Btn.Caption;
      OnClick := Btn.OnClick;
    end;
  end;
end;

procedure TFrameLista.CreateDs;
begin
  if not Assigned(dsLista) then
  begin
    dsLista := TDataSource.Create(nil);
    dsLista.Dataset := FADataset;
  end;

  LoadPreferences;
  LoadBotoes;
end;

procedure TFrameLista.BotaoClicado(Sender: TObject);
begin
  ShowMessage((Sender as TBitBtn).Caption);
end;

end.
