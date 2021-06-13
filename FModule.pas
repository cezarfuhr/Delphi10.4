unit FModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  IBX.IBDatabase, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.DApt, Data.FMTBcd, Data.SqlExpr,

  classCliente;

type
  TModule = class(TDataModule)
    tmClientes: TFDMemTable;
    tmClientesid: TIntegerField;
    tmClientesnome: TStringField;
    tmFornecedores: TFDMemTable;
    tmFornecedoresid: TIntegerField;
    tmFornecedoresnome: TStringField;
  private
    function Database: TFDConnection;
    function Transacao: TFDTransaction;
    function ResultaClientes: TFDQuery;

    function ListaClientes: TClassClientes;
  public
    procedure loadClientes;
    procedure loadFornecedores;
  end;

var
  Module: TModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TModule.Database: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.Params.Add('Database=C:\Fontes\Delphi10.4\Win32\Debug\BASE.FDB');
  Result.Params.Add('User_Name=SYSDBA');
  Result.Params.Add('Password=masterkey');
  Result.Params.Add('DriverID=FB');
  Result.Connected := True;
end;

function TModule.Transacao: TFDTransaction;
begin
  Result := TFDTransaction.Create(nil);
  Result.Connection := Database;
  Result.StartTransaction;
end;

function TModule.ResultaClientes: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := Database;
  Result.SQL.Add('Select * from CLIENTES');
  Result.Open;
end;

function TModule.ListaClientes: TClassClientes;
var
  Tabela: TFDQuery;
  Cli: TClassCliente;
begin
  Result := TClassClientes.Create;

  Tabela := ResultaClientes;

  Tabela.First;
  while not Tabela.Eof do
  begin
    Cli := TClassCliente.Create;
    Cli.Id := Tabela.FieldByName('id').AsInteger;
    Cli.Nome := Tabela.FieldByName('nome').AsString;
    Result.Add(Cli);

    Tabela.Next;
  end;
end;

procedure TModule.loadClientes;
var
  Lista: TClassClientes;
  I: Integer;
begin
  if tmClientes.Active = False then
    tmClientes.Active := True;

  tmClientes.EmptyDataSet;
  Lista := ListaClientes;

  for I := 0 to Lista.Count - 1 do
  begin
    with TClassCliente(Lista.Items[I]) do
    begin
      tmClientes.Append;
      tmClientes.FieldByName('id').AsInteger := Id;
      tmClientes.FieldByName('nome').AsString := Nome;
      tmClientes.Post;
    end;
  end;
end;

procedure TModule.loadFornecedores;
begin
  if tmFornecedores.Active = False then
    tmFornecedores.Active := True;

  tmFornecedores.Append;
  tmFornecedores.FieldByName('id').AsInteger := 1;
  tmFornecedores.FieldByName('nome').AsString := 'Fornecedor A';
  tmFornecedores.Post;

  tmFornecedores.Append;
  tmFornecedores.FieldByName('id').AsInteger := 2;
  tmFornecedores.FieldByName('nome').AsString := 'Fornecedor B';
  tmFornecedores.Post;
end;

end.
