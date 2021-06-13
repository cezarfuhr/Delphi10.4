unit classEspecie;

interface

uses System.Classes,

  types;

type
  TCvfEspecie = class
  private
    FId: Integer;
    FDescricao: String;
    FTipo: TCvfEspecieTypes;
  public
    property Id: Integer read FId write FId;
    property Descricao: String read FDescricao write FDescricao;
    property Tipo: TCvfEspecieTypes read FTipo write FTipo;
  end;

  TCvfEspecies = class(TList)
  private
    function GetItems(Index: Integer): TCvfEspecie;
    procedure SetItems(Index: Integer; AEspecie: TCvfEspecie);
  public
    function Add(AEspecie: TCvfEspecie): Integer; overload;
    function LocateByID(FId: Integer): TCvfEspecie;

    property Items[Index: Integer]: TCvfEspecie read GetItems
      write SetItems; default;
  end;

  TCvfEspeciesLoad = class
  private
    FEspecies: TCvfEspecies;

    function Dinheiro: TCvfEspecie;
    function CartaoCredito: TCvfEspecie;
    function CartaoDebito: TCvfEspecie;
    function Cheque: TCvfEspecie;
  public
    procedure loadEspecies;

    constructor Create(AEspecies: TCvfEspecies); overload;
  end;

implementation

{ TCvfEspecies }

function TCvfEspecies.Add(AEspecie: TCvfEspecie): Integer;
begin
  Result := inherited Add(AEspecie);
end;

function TCvfEspecies.GetItems(Index: Integer): TCvfEspecie;
begin
  Result := TCvfEspecie(inherited Items[Index]);
end;

function TCvfEspecies.LocateByID(FId: Integer): TCvfEspecie;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Id = FId then
    begin
      Result := Items[I];
      Break;
    end;
end;

procedure TCvfEspecies.SetItems(Index: Integer; AEspecie: TCvfEspecie);
begin
  inherited Items[Index] := AEspecie;
end;

{ TCvfEspeciesLoad }

constructor TCvfEspeciesLoad.Create(AEspecies: TCvfEspecies);
begin
  inherited Create;
  FEspecies := AEspecies;
  loadEspecies;
end;

function TCvfEspeciesLoad.Dinheiro: TCvfEspecie;
begin
  Result := TCvfEspecie.Create;
  Result.Id := 1;
  Result.Descricao := 'Dinheiro';
  Result.Tipo := foDinheiro;
end;

function TCvfEspeciesLoad.CartaoCredito: TCvfEspecie;
begin
  Result := TCvfEspecie.Create;
  Result.Id := 2;
  Result.Descricao := 'Cartão de Crédito';
  Result.Tipo := foCartaoCredito;
end;

function TCvfEspeciesLoad.CartaoDebito: TCvfEspecie;
begin
  Result := TCvfEspecie.Create;
  Result.Id := 3;
  Result.Descricao := 'Cartão de Débito';
  Result.Tipo := foCartaoDebido;
end;

function TCvfEspeciesLoad.Cheque: TCvfEspecie;
begin
  Result := TCvfEspecie.Create;
  Result.Id := 4;
  Result.Descricao := 'Cheque';
  Result.Tipo := foCheque;
end;

procedure TCvfEspeciesLoad.loadEspecies;
begin
  FEspecies.Add(Dinheiro);
  FEspecies.Add(CartaoCredito);
  FEspecies.Add(CartaoDebito);
  FEspecies.Add(Cheque);
end;

end.
