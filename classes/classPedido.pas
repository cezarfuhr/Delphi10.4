unit classPedido;

interface

uses System.Classes, ClassCliente, ClassProduto,
  types;

type
  TPedCliente = class(TClassCliente)
  private
  public
  end;

  TCalcFrete = class
  private
    FFrete: Currency;
  public
    property Frete: Currency read FFrete write FFrete;
  end;

  TCalcPorContaDoEmitente = class(TCalcFrete)
  private
    FValor: Currency;
  public
    function Valor: Currency;

    constructor Create(AValor: Currency); overload;
    destructor Destroy; override;
  end;

  TCalcPorContaDoDestinatario = class(TCalcFrete)
  private
    FValor: Currency;
  public
    function Valor: Currency;

    constructor Create(AValor: Currency); overload;
    destructor Destroy; override;
  end;

  TCalcBase = class
  private
    FMontante: Currency;
  public
    property Montante: Currency read FMontante write FMontante;
  end;

  TCalcPorValor = class(TCalcBase)
  private
    FValor: Currency;
  public
    function Valor: Currency;
    function Percentual: Double;

    constructor Create(AValor: Currency); overload;
    destructor Destroy; override;
  end;

  TCalcPorPerc = class(TCalcBase)
  private
    FPercentual: Double;
  public
    function Valor: Currency;
    function Percentual: Double;

    constructor Create(APercentual: Double); overload;
    destructor Destroy; override;
  end;

  TPedProduto = class
  private
    FProduto: TCvfProduto;
    FProdutoId: Integer;
    FProdutoDescricao: String;

    FAcrescimo: TCalcBase;
    FDesconto: TCalcBase;

    FRateioAcrescimo: TCalcBase;
    FRateioDesconto: TCalcBase;

    FUnitario: Currency;
    FQuantidade: Double;
  public
    function Total: Currency;

    function TotalComAcrescimo: Currency;
    function TotalComDesconto: Currency;

    property Acrescimo: TCalcBase read FAcrescimo write FAcrescimo;
    property Desconto: TCalcBase read FDesconto write FDesconto;

    property RateioAcrescimo: TCalcBase read FRateioAcrescimo
      write FRateioAcrescimo;
    property RateioDesconto: TCalcBase read FRateioDesconto
      write FRateioDesconto;

    property Produto: TCvfProduto read FProduto write FProduto;
    Property Quantidade: Double read FQuantidade write FQuantidade;
    property Unitario: Currency read FUnitario write FUnitario;
  end;

  TPedProdutos = class(TList)
  private
    function VlrMercadorias: Currency;

    function GetItems(Index: Integer): TPedProduto;

    procedure SetItems(Index: Integer; APedProduto: TPedProduto);
  public
    function Add(APedProduto: TPedProduto): Integer; overload;

    property Items[Index: Integer]: TPedProduto read GetItems
      write SetItems; default;
  end;

  TPedPagamento = class
  private
    FId: Integer;
    FDescricao: String;
    FValor: Currency;
    FTipo: TCvfEspecieTypes;
  public
    property Id: Integer read FId write FId;
    property Descricao: String read FDescricao write FDescricao;
    property Valor: Currency read FValor write FValor;
    property Tipo: TCvfEspecieTypes read FTipo write FTipo;
  end;

  TPedPagamentos = class(TList)
  private
    function VlrPago: Currency;

    function GetItems(Index: Integer): TPedPagamento;
    procedure SetItems(Index: Integer; APedPagamento: TPedPagamento);

  public
    function Add(APedPagamento: TPedPagamento): Integer; overload;

    property Items[Index: Integer]: TPedPagamento read GetItems
      write SetItems; default;
  end;

  TPedido = class
  private
    FCliente: TPedCliente;
    FProdutos: TPedProdutos;
    FPagamentos: TPedPagamentos;

    FFrete: TCalcFrete;
    FAcrescimoARatear: TCalcBase;
    FDescontoARatear: TCalcBase;

    FTroco: Currency;
  public
    constructor Create;
    destructor Destroy; override;

    function SaldoTroco: Currency;
    function SaldoAPagar: Currency;

    function VlrMercadorias: Currency;
    function VlrComAcrescimoARatear: Currency;
    function VlrComDescontoARatear: Currency;
    function VlrComFrete: Currency;
    function VlrTotal: Currency;

    procedure NewProduto(AProduto: TPedProduto);
    procedure NewPagamento(APagamento: TPedPagamento);

    property Troco: Currency read FTroco write FTroco;
    property Frete: TCalcFrete read FFrete write FFrete;
    property DescontoARatear: TCalcBase read FDescontoARatear
      write FDescontoARatear;
    property AcrescimoARatear: TCalcBase read FAcrescimoARatear
      write FAcrescimoARatear;

    property Cliente: TPedCliente read FCliente write FCliente;
    property Produtos: TPedProdutos read FProdutos write FProdutos;
    property Pagamentos: TPedPagamentos read FPagamentos write FPagamentos;
  end;

implementation

{ TPedProduto }

function TPedProduto.Total: Currency;
begin
  Result := FQuantidade * FUnitario;
end;

function TPedProduto.TotalComAcrescimo: Currency;
begin
  Result := Total;

  if Assigned(Acrescimo) then
  begin
    if Acrescimo is TCalcPorValor then
    begin
      Acrescimo.Montante := Result;
      Result := Result + (Acrescimo as TCalcPorValor).Valor;
    end;

    if Acrescimo is TCalcPorPerc then
    begin
      Acrescimo.Montante := Result;
      Result := Result + (Acrescimo as TCalcPorPerc).Valor;
    end;
  end;
end;

function TPedProduto.TotalComDesconto: Currency;
begin
  Result := TotalComAcrescimo;

  if Assigned(Desconto) then
  begin
    if Desconto is TCalcPorValor then
    begin
      Desconto.Montante := Result;
      Result := Result - (Desconto as TCalcPorValor).Valor;
    end;

    if Desconto is TCalcPorPerc then
    begin
      Desconto.Montante := Result;
      Result := Result - (Desconto as TCalcPorPerc).Valor;
    end;
  end;
end;

{ TPedProdutos }

function TPedProdutos.Add(APedProduto: TPedProduto): Integer;
begin
  Result := inherited Add(APedProduto);
end;

function TPedProdutos.GetItems(Index: Integer): TPedProduto;
begin
  Result := TPedProduto(inherited Items[Index]);
end;

procedure TPedProdutos.SetItems(Index: Integer; APedProduto: TPedProduto);
begin
  inherited Items[Index] := APedProduto;
end;

function TPedProdutos.VlrMercadorias: Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    Result := Result + Items[I].TotalComDesconto;
end;

{ TPedPagamentos }

function TPedPagamentos.Add(APedPagamento: TPedPagamento): Integer;
begin
  Result := inherited Add(APedPagamento);
end;

function TPedPagamentos.VlrPago: Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    Result := Result + Items[I].Valor;
end;

function TPedPagamentos.GetItems(Index: Integer): TPedPagamento;
begin
  Result := TPedPagamento(inherited Items[Index]);
end;

procedure TPedPagamentos.SetItems(Index: Integer; APedPagamento: TPedPagamento);
begin
  inherited Items[Index] := APedPagamento;
end;

{ TCalcPorContaDoDestinatario }

constructor TCalcPorContaDoDestinatario.Create(AValor: Currency);
begin
  inherited Create;
  FValor := AValor;
end;

destructor TCalcPorContaDoDestinatario.Destroy;
begin
  inherited;
end;

function TCalcPorContaDoDestinatario.Valor: Currency;
begin
  Result := 0;
end;

{ TCalcPorContaDoEmitente }

constructor TCalcPorContaDoEmitente.Create(AValor: Currency);
begin
  inherited Create;
  FValor := AValor;
end;

destructor TCalcPorContaDoEmitente.Destroy;
begin
  inherited;
end;

function TCalcPorContaDoEmitente.Valor: Currency;
begin
  Result := FValor;
end;

{ TCalcPorValor }

constructor TCalcPorValor.Create(AValor: Currency);
begin
  inherited Create;
  FValor := AValor;
end;

destructor TCalcPorValor.Destroy;
begin
  inherited;
end;

function TCalcPorValor.Percentual: Double;
begin
  Result := FValor * 100 / FMontante;
end;

function TCalcPorValor.Valor: Currency;
begin
  Result := FValor;
end;

{ TCalcPorPerc }

constructor TCalcPorPerc.Create(APercentual: Double);
begin
  inherited Create;
  FPercentual := APercentual;
end;

destructor TCalcPorPerc.Destroy;
begin
  inherited;
end;

function TCalcPorPerc.Percentual: Double;
begin
  Result := FPercentual;
end;

function TCalcPorPerc.Valor: Currency;
begin
  Result := FMontante * FPercentual / 100;
end;

{ TPed }

constructor TPedido.Create;
begin
  inherited Create;
  FCliente := TPedCliente.Create;
  FProdutos := TPedProdutos.Create;
  FPagamentos := TPedPagamentos.Create;
end;

destructor TPedido.Destroy;
begin
  inherited;
  FCliente.Free;
  FProdutos.Free;
  FPagamentos.Free;
end;

procedure TPedido.NewProduto(AProduto: TPedProduto);
begin
  Produtos.Add(AProduto);
end;

procedure TPedido.NewPagamento(APagamento: TPedPagamento);
begin
  Pagamentos.Add(APagamento);
end;

function TPedido.VlrComAcrescimoARatear: Currency;
var
  APerc: Double;
  ATotal, AValor: Currency;
  I: Integer;
begin
  Result := Produtos.VlrMercadorias;

  if Assigned(AcrescimoARatear) then
  begin
    if (AcrescimoARatear is TCalcPorValor) then
    begin
      TCalcPorValor(AcrescimoARatear).Montante := Result;

      ATotal := Result;
      AValor := TCalcPorValor(AcrescimoARatear).Valor;
      Result := ATotal + AValor;

      APerc := AValor * 100 / ATotal;
      for I := 0 to Produtos.Count - 1 do
      begin
        AValor := Produtos.Items[I].TotalComDesconto * APerc / 100;
        Produtos.Items[I].RateioAcrescimo := TCalcPorValor.Create(AValor);
      end;
    end;

    if (AcrescimoARatear is TCalcPorPerc) then
    begin
      TCalcPorPerc(AcrescimoARatear).Montante := Result;

      ATotal := Result;
      AValor := TCalcPorPerc(AcrescimoARatear).Valor;
      Result := ATotal + AValor;

      for I := 0 to Produtos.Count - 1 do
        Produtos.Items[I].RateioAcrescimo := TCalcPorPerc(AcrescimoARatear);
    end;
  end;
end;

function TPedido.VlrComDescontoARatear: Currency;
var
  APerc: Double;
  ATotal, AValor: Currency;
  I: Integer;
begin
  Result := VlrComAcrescimoARatear;

  if Assigned(FDescontoARatear) and (FDescontoARatear is TCalcPorValor) then
  begin
    TCalcPorValor(FDescontoARatear).Montante := Result;

    ATotal := Result;
    AValor := TCalcPorValor(FDescontoARatear).Valor;
    Result := ATotal - AValor;

    APerc := AValor * 100 / ATotal;
    for I := 0 to Produtos.Count - 1 do
    begin
      AValor := Produtos.Items[I].TotalComDesconto * APerc / 100;
      Produtos.Items[I].RateioDesconto := TCalcPorValor.Create(AValor);
    end;
  end;

  if Assigned(FDescontoARatear) and (FDescontoARatear is TCalcPorPerc) then
  begin
    TCalcPorPerc(FDescontoARatear).Montante := Result;

    ATotal := Result;
    AValor := TCalcPorPerc(FDescontoARatear).Valor;
    Result := ATotal - AValor;

    for I := 0 to Produtos.Count - 1 do
      Produtos.Items[I].RateioDesconto := TCalcPorPerc(FDescontoARatear);
  end;
end;

function TPedido.VlrMercadorias: Currency;
begin
  Result := Produtos.VlrMercadorias;
end;

function TPedido.VlrComFrete: Currency;
begin
  Result := VlrComDescontoARatear;

  if Assigned(FFrete) then
  begin
    if (FFrete is TCalcPorContaDoEmitente) then
      Result := Result + (FFrete as TCalcPorContaDoEmitente).Valor;

    if (FFrete is TCalcPorContaDoDestinatario) then
      Result := Result + (FFrete as TCalcPorContaDoDestinatario).Valor;
  end;
end;

function TPedido.VlrTotal: Currency;
begin
  Result := VlrComFrete;
end;

function TPedido.SaldoTroco: Currency;
var
  AValorTotal, AValorPago: Currency;
begin
  Result := 0;

  AValorTotal := VlrTotal;
  AValorPago := Pagamentos.VlrPago;
  if AValorPago <= AValorTotal then
    exit;

  Result := AValorPago - AValorTotal;
end;

function TPedido.SaldoAPagar: Currency;
var
  AValorTotal, AValorPago: Currency;
begin
  Result := 0;

  AValorTotal := VlrTotal;
  AValorPago := Pagamentos.VlrPago;
  if AValorPago > AValorTotal then
    exit;

  Result := AValorTotal - AValorPago;
end;

end.
