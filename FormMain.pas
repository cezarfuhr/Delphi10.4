unit FormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,

  FModule, FBaseLista;

type
  TFoMain = class(TForm)
    Panel1: TPanel;
    btnLFornecedore: TBitBtn;
    btnClientes: TBitBtn;
    panMain: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    procedure btnClientesClick(Sender: TObject);
    procedure btnLFornecedoreClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    Cliente: TFrameLista;
    Fornecedor: TFrameLista;

    procedure LoadDatasets;
  public
    { Public declarations }
  end;

var
  FoMain: TFoMain;

implementation

{$R *.dfm}

uses classPedido, classProduto, classCliente;

procedure TFoMain.LoadDatasets;
begin
  Module.loadClientes;
  Module.loadFornecedores;
end;

procedure TFoMain.FormCreate(Sender: TObject);
begin
  if not Assigned(Cliente) then
  begin
    Cliente := TFrameLista.Create(Application);
    Cliente.Dataset := Module.tmClientes;
    Cliente.Name := 'frmClientes';
  end;

  if not Assigned(Fornecedor) then
  begin
    Fornecedor := TFrameLista.Create(Application);
    Fornecedor.Dataset := Module.tmFornecedores;
    Fornecedor.Name := 'frmFornecedores';
  end;

  LoadDatasets;
end;

procedure TFoMain.btnClientesClick(Sender: TObject);
begin
  Fornecedor.Parent := nil;

  Cliente.Parent := Nil;
  try
    Cliente.CreateDs;
    Cliente.Width := panMain.Width;
    Cliente.Height := panMain.Height;
  finally
    Cliente.Parent := panMain;
  end;
end;

procedure TFoMain.btnLFornecedoreClick(Sender: TObject);
begin
  Cliente.Parent := nil;

  Fornecedor.Parent := nil;
  try
    Fornecedor.CreateDs;
    Fornecedor.Width := panMain.Width;
    Fornecedor.Height := panMain.Height;
  finally
    Fornecedor.Parent := panMain;
  end;
end;

procedure TFoMain.Button1Click(Sender: TObject);
var
  Pedido: TPedido;
  AItem: TPedProduto;
  AProduto: TCvfProduto;
  APagamento: TPedPagamento;
  I: Integer;
begin
  Pedido := TPedido.Create;

  //Cliente
  Pedido.Cliente := TPedCliente.Create;
  Pedido.Cliente.Id := 1;

  //Produto UM
  AProduto := TCvfProduto.Create;
  AProduto.Id := 10;
  AProduto.Descricao := 'Item do Pedito';
  AItem := TPedProduto.Create;
  AItem.Produto := AProduto;
  AItem.Quantidade := 10;
  AItem.Unitario := 2.5;
  AItem.Acrescimo := TCalcPorPerc.Create(3);
  AItem.Desconto := TCalcPorValor.Create(5);
  Pedido.Produtos.Add(AItem);

  //Produto Dois
  AProduto := TCvfProduto.Create;
  AProduto.Id := 10;
  AProduto.Descricao := 'Item do Pedito';
  AItem := TPedProduto.Create;
  AItem.Produto := AProduto;
  AItem.Quantidade := 20;
  AItem.Unitario := 3;
  AItem.Acrescimo:= TCalcPorValor.Create(10);
  AItem.Desconto := TCalcPorPerc.Create(1);
  Pedido.Produtos.Add(AItem);

  //Acrescimos por valor e por perc
  Pedido.AcrescimoARatear := TCalcPorPerc.Create(10);
  //Pedido.Acrescimo := TCalcPorValor.Create(5);

  //Desconto por valor e por perc
  //Pedido.Desconto := TCalcPorPerc.Create(10);
  Pedido.DescontoARatear := TCalcPorValor.Create(5);

  Pedido.Frete := TCalcPorContaDoEmitente.Create(0);

  //Pagamentos
  APagamento := TPedPagamento.Create;
  APagamento.Id := 1;
  APagamento.Descricao := 'Dinheiro';
  APagamento.Tipo := 1;
  APagamento.Valor := 50;
  Pedido.Pagamentos.Add(APagamento);

  APagamento := TPedPagamento.Create;
  APagamento.Id := 1;
  APagamento.Descricao := 'Dinheiro';
  APagamento.Tipo := 1;
  APagamento.Valor := 60;
  Pedido.Pagamentos.Add(APagamento);

  for I := 0 to Pedido.Produtos.Count - 1 do begin
    Memo1.Lines.Add('Qtde: ' + FormatFloat('0.,00', Pedido.Produtos.Items[i].Quantidade) );
    Memo1.Lines.Add('Unit: ' + FormatFloat('0.,00', Pedido.Produtos.Items[i].Preco) );
    Memo1.Lines.Add('Total: ' + FormatFloat('0.,00', Pedido.Produtos.Items[i].Total) );
    Memo1.Lines.Add('Total com Acresc: ' + FormatFloat('0.,00', Pedido.Produtos.Items[i].TotalComAcrescimo) );
    Memo1.Lines.Add('Total com Desc: ' + FormatFloat('0.,00', Pedido.Produtos.Items[i].TotalComDesconto) );
    Memo1.Lines.Add('-----------');
  end;

  Memo1.Lines.Add('Totais');
  Memo1.Lines.Add('-----------');
  Memo1.Lines.Add('Mercadorias: ' + FormatFloat('0.,00', Pedido.ValorMercadorias));

  if Assigned( Pedido.Acrescimo ) then begin
    if Pedido.Acrescimo is TCalcPorValor then
      Memo1.Lines.Add('Mercadorias + Valor Acres: ' + FormatFloat('0.,00', Pedido.ValorTotalComAcrescimo ) );
    if Pedido.Acrescimo is TCalcPorPerc then
      Memo1.Lines.Add('Mercadorias + Perce Acres: ' + FormatFloat('0.,00', Pedido.ValorTotalComAcrescimo ) );
  end;

  if Assigned( Pedido.Desconto ) then begin
    if Pedido.Desconto is TCalcPorValor then
      Memo1.Lines.Add('Mercadorias + Valor desc: ' + FormatFloat('0.,00', Pedido.ValorTotalComDesconto ) );
    if Pedido.Desconto is TCalcPorPerc then
      Memo1.Lines.Add('Mercadorias + Perce desc: ' + FormatFloat('0.,00', Pedido.ValorTotalComDesconto ) );
  end;

  Memo1.Lines.Add('-----------');
  Memo1.Lines.Add('+ Rateio');
  Memo1.Lines.Add('-----------');
  for I := 0 to Pedido.Produtos.Count - 1 do begin
    with Pedido.Produtos.Items[i] do begin
      if RateioAcrescimo is TCalcPorValor then
        Memo1.Lines.Add('Total com Acresc+rateio: ' + FormatFloat('0.,00', (RateioAcrescimo as TCalcPorValor).valor ) );
      if RateioAcrescimo is TCalcPorPerc then
        Memo1.Lines.Add('Total com Acresc+rateio: ' + FormatFloat('0.,00', (RateioAcrescimo as TCalcPorPerc).Percentual ) );
    end;

    with Pedido.Produtos.Items[i] do begin
      if RateioDesconto is TCalcPorValor then
        Memo1.Lines.Add('Total com Acresc+rateio: ' + FormatFloat('0.,00', (RateioDesconto as TCalcPorValor).valor ) );
      if RateioDesconto is TCalcPorPerc then
        Memo1.Lines.Add('Total com Acresc+rateio: ' + FormatFloat('0.,00', (RateioDesconto as TCalcPorPerc).Percentual ) );
    end;

    Memo1.Lines.Add('-----------');
  end;

end;

procedure TFoMain.FormShow(Sender: TObject);
begin
  Self.WindowState := wsMaximized;
end;

end.
