unit classProduto;

interface

uses System.Classes;

type
  TCvfProduto = class
  private
    FId: integer;
    FDescricao: String;
  public
    property Id: integer read FId write FId;
    property Descricao: String read FDescricao write FDescricao;
  end;

  TCvfProdutos = class(TList)
  private
    FShow: String;
    FProduto: TCvfProduto;

    function GetItems(Index: integer): TCvfProduto;
    procedure SetItems(Index: integer; AProduto: TCvfProduto);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(AProduto: TCvfProduto): integer;
    function LocateByID(FId: integer): TCvfProduto;

    property Items[Index: integer]: TCvfProduto read GetItems
      write SetItems; default;
  end;

  TCvfProdutosLoad = class
  private
    FProdutos: TCvfProdutos;
  public
    procedure loadProdutos;

    constructor Create(AProdutos: TCvfProdutos); overload;
  end;

implementation

{ TCvfProdutos }

constructor TCvfProdutos.Create;
begin
  inherited Create;
end;

destructor TCvfProdutos.Destroy;
begin
  inherited;
end;

function TCvfProdutos.Add(AProduto: TCvfProduto): integer;
begin
  Result := inherited Add(AProduto);
end;

function TCvfProdutos.GetItems(Index: integer): TCvfProduto;
begin
  Result := TCvfProduto(inherited Items[Index]);
end;

function TCvfProdutos.LocateByID(FId: integer): TCvfProduto;
var
  I: integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Id = FId then
    begin
      Result := Items[I];
      Break;
    end;
end;

procedure TCvfProdutos.SetItems(Index: integer; AProduto: TCvfProduto);
begin
  inherited Items[Index] := AProduto;
end;

{ TCvfProdutosLoad }

constructor TCvfProdutosLoad.Create(AProdutos: TCvfProdutos);
begin
  inherited Create;
  FProdutos := AProdutos;
  loadProdutos;
end;

procedure TCvfProdutosLoad.loadProdutos;
var
  AProduto: TCvfProduto;
begin
  AProduto := TCvfProduto.Create;
  AProduto.Id := 1;
  AProduto.Descricao := 'Cerveja Heineken lata 350ml';
  FProdutos.Add(AProduto);

  AProduto := TCvfProduto.Create;
  AProduto.Id := 2;
  AProduto.Descricao := 'Cerveja Cacildes lata 350ml';
  FProdutos.Add(AProduto);
end;

end.
