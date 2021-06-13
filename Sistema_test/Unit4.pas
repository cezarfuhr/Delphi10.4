unit Unit4;

interface

uses
  DUnitX.TestFramework,

  classPedido, classProdutos;

type

  [TestFixture]
  TMyTestPedido = class(TObject)
  public
    [Test]
    procedure AdicionarUmProduto;
  end;

implementation

function GeraPedido: TPedido;
begin
  Result := TPedido.Create;
end;

procedure TMyTestPedido.AdicionarUmProduto;
begin
  with GeraPedido do
  begin
    with AddProduto do
    begin
      Preco := 2.5;
      Quantidade := 10;
    end;
    Assert.IsTrue(ValorMercadorias = 25.0, 'Valor Mercadorias');
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TMyTestObject);

end.
