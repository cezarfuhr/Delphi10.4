unit testPedido;

interface

uses
  DUnitX.TestFramework,

  System.SysUtils,

  classPedido, classEspecie;

type

  [TestFixture]
  TMyTestPedido = class(TObject)
  public
    [Test]
    procedure PedidoAddUmProduto;
    [Test]
    procedure PedidoAddDoisProduto;
    [Test]
    procedure AddAcrescimosPorValor;
    [Test]
    procedure AddAcrescimosPorValorMenosDescontoPorValor;
    [Test]
    procedure AddAcrescimosPorValorMenosDescontoPorPerc;
    [Test]
    procedure AddProdutoEAcrescimoRateadoPorValor;
    [Test]
    procedure AddProdutoEAcrescimoRateadoPorPerc;
    [Test]
    procedure AddProdutoEDescontoRateadoPorValor;
    [Test]
    procedure Add_ValorTotalComDescontoRateadoPorPerc;
    [Test]
    procedure Add_ValorTotalComFretePorContaDoDestinatario;
    [Test]
    procedure Add_ValorTotalComFretePorContaDoEmitente;
    [Test]
    procedure Add_Pagamento;
    [Test]
    procedure Add_Troco;
    [Test]
    procedure LoadEspecie;
  end;

implementation

uses classProduto;

function GeraPedido: TPedido;
begin
  Result := TPedido.Create;
end;

function AddPag(AEspecie: TCvfEspecie; AValor: Double): TPedPagamento;
begin
  Result := TPedPagamento.Create;
  Result.Id := AEspecie.Id;
  Result.Tipo := AEspecie.Tipo;
  Result.Descricao := AEspecie.Descricao;
  Result.Valor := AValor;
end;

function AddProd(AProduto: TCvfProduto; AQuantidade, AUnitario: Double;
  AAcrescimo: TCalcBase; ADesconto: TCalcBase): TPedProduto;
begin
  Result := TPedProduto.Create;
  Result.Produto := AProduto;
  Result.Quantidade := AQuantidade;
  Result.Unitario := AUnitario;
  Result.Acrescimo := AAcrescimo;
  Result.Desconto := ADesconto;
end;

function LoadEspecies: TCvfEspecies;
begin
  Result := TCvfEspecies.Create;
  TCvfEspeciesLoad.Create(Result);
end;

function LoadProdutos: TCvfProdutos;
begin
  Result := TCvfProdutos.Create;
  TCvfProdutosLoad.Create(Result);
end;

procedure TMyTestPedido.LoadEspecie;
var
  especies: TCvfEspecies;
begin
  especies := TCvfEspecies.Create;
  TCvfEspeciesLoad.Create(especies);
  Assert.IsTrue(especies.Count = 4, 'cadastros');
end;

procedure TMyTestPedido.Add_Troco;
var
  AEspecies: TCvfEspecies;
  AProdutos: TCvfProdutos;
begin
  AEspecies := LoadEspecies;
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 3, nil, nil));
    NewProduto(AddProd(AProdutos.LocateByID(1), 3, 6, nil, nil));

    AcrescimoARatear := TCalcPorValor.Create(6);
    DescontoARatear := TCalcPorPerc.Create(3);
    Frete := TCalcPorContaDoEmitente.Create(20);

    NewPagamento(AddPag(AEspecies.LocateByID(1), 20));
    NewPagamento(AddPag(AEspecies.LocateByID(1), 20));
    NewPagamento(AddPag(AEspecies.LocateByID(1), 10));

    Assert.IsTrue(SaldoTroco = 0.9, 'SaldoAPagar: ' + FloatToStr(SaldoTroco));
  end;
end;

procedure TMyTestPedido.Add_Pagamento;
var
  AEspecies: TCvfEspecies;
  AProdutos: TCvfProdutos;
begin
  AEspecies := LoadEspecies;
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 3, nil, nil));
    NewProduto(AddProd(AProdutos.LocateByID(1), 3, 6, nil, nil));

    AcrescimoARatear := TCalcPorValor.Create(6);
    DescontoARatear := TCalcPorPerc.Create(3);
    Frete := TCalcPorContaDoEmitente.Create(20);

    NewPagamento(AddPag(AEspecies.LocateByID(1), 20));
    NewPagamento(AddPag(AEspecies.LocateByID(1), 20));
    NewPagamento(AddPag(AEspecies.LocateByID(1), 9.1));

    Assert.IsTrue(SaldoAPagar = 0, 'SaldoAPagar: ' + FloatToStr(SaldoAPagar));
  end;
end;

procedure TMyTestPedido.Add_ValorTotalComFretePorContaDoEmitente;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 3, nil, nil));
    NewProduto(AddProd(AProdutos.LocateByID(1), 3, 6, nil, nil));

    AcrescimoARatear := TCalcPorValor.Create(6);
    DescontoARatear := TCalcPorPerc.Create(3);
    Frete := TCalcPorContaDoEmitente.Create(20);

    Assert.IsTrue(VlrComFrete = 49.1, 'VlrComFrete');
  end;
end;

procedure TMyTestPedido.Add_ValorTotalComFretePorContaDoDestinatario;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 3, nil, nil));
    NewProduto(AddProd(AProdutos.LocateByID(1), 3, 6, nil, nil));

    AcrescimoARatear := TCalcPorValor.Create(6);
    DescontoARatear := TCalcPorPerc.Create(3);
    Frete := TCalcPorContaDoDestinatario.Create(20);

    Assert.IsTrue(VlrComFrete = 29.1, 'VlrComFrete');
  end;
end;

procedure TMyTestPedido.Add_ValorTotalComDescontoRateadoPorPerc;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 3, nil, nil));
    NewProduto(AddProd(AProdutos.LocateByID(1), 3, 6, nil, nil));

    AcrescimoARatear := TCalcPorValor.Create(6);
    DescontoARatear := TCalcPorPerc.Create(3);

    Assert.IsTrue(VlrComDescontoARatear = 29.1, 'VlrComDescontoARatear');
  end;
end;

procedure TMyTestPedido.AddProdutoEDescontoRateadoPorValor;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 5, nil, nil));
    NewProduto(AddProd(AProdutos.LocateByID(1), 4, 5, nil, nil));

    AcrescimoARatear := TCalcPorPerc.Create(10);
    DescontoARatear := TCalcPorValor.Create(3);

    Assert.IsTrue(VlrComDescontoARatear = 30, 'VlrComDescontoARatear');
  end;
end;

procedure TMyTestPedido.AddProdutoEAcrescimoRateadoPorPerc;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 1, 5, nil, nil));

    AcrescimoARatear := TCalcPorPerc.Create(10);

    Assert.IsTrue(VlrComAcrescimoARatear = 5.5, 'VlrComAcrescimoARatear');
  end;
end;

procedure TMyTestPedido.AddProdutoEAcrescimoRateadoPorValor;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    produtos.Add(AddProd(AProdutos.LocateByID(1), 10, 5, nil, nil));

    AcrescimoARatear := TCalcPorValor.Create(10);

    Assert.IsTrue(VlrComAcrescimoARatear = 60, 'VlrComAcrescimoARatear');
  end;
end;

procedure TMyTestPedido.AddAcrescimosPorValorMenosDescontoPorPerc;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 1, 1, TCalcPorValor.Create(3),
      TCalcPorPerc.Create(50)));
    NewProduto(AddProd(AProdutos.LocateByID(1), 1, 1, TCalcPorValor.Create(3),
      TCalcPorPerc.Create(50)));

    Assert.IsTrue(VlrMercadorias = 4, 'VlrMercadorias');
  end;
end;

procedure TMyTestPedido.AddAcrescimosPorValorMenosDescontoPorValor;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 1, 1, TCalcPorValor.Create(2),
      TCalcPorValor.Create(3)));

    Assert.IsTrue(VlrMercadorias = 0, 'VlrMercadorias');
  end;
end;

procedure TMyTestPedido.AddAcrescimosPorValor;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 1, 1,
      TCalcPorValor.Create(1), nil));
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 2,
      TCalcPorPerc.Create(10), nil));

    Assert.IsTrue(VlrMercadorias = 6.4, 'VlrMercadorias');
  end;
end;

procedure TMyTestPedido.PedidoAddDoisProduto;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 3.5, nil, nil));
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 3, nil, nil));

    Assert.IsTrue(VlrMercadorias = 13, 'VlrMercadorias');
  end;
end;

procedure TMyTestPedido.PedidoAddUmProduto;
var
  AProdutos: TCvfProdutos;
begin
  AProdutos := LoadProdutos;

  with GeraPedido do
  begin
    NewProduto(AddProd(AProdutos.LocateByID(1), 2, 2.5, nil, nil));

    Assert.IsTrue(VlrMercadorias = 5, 'VlrMercadorias');
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TMyTestPedido);

end.
