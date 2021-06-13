unit classCliente;

interface

uses System.Classes;

type
  TClassCliente = class
  private
    FId: Integer;
    FNome: String;
  public
    property Id: Integer read FId write FId;
    property Nome: String read FNome write FNome;
  end;

  TClassClientes = class(TList)
  private
    FCliente: TClassCliente;

    function GetItems(Index: Integer): TClassCliente;
    procedure SetItems(Index: Integer; ACliente: TClassCliente);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(ACliente: TClassCliente): Integer;

    property Items[Index: Integer]: TClassCliente read GetItems
      write SetItems; default;
  end;

implementation

{ TClassClientes }

constructor TClassClientes.Create;
begin
  inherited Create;
end;

destructor TClassClientes.Destroy;
begin
  inherited;
end;

function TClassClientes.Add(ACliente: TClassCliente): Integer;
begin
  Result := inherited Add(ACliente);
end;

function TClassClientes.GetItems(Index: Integer): TClassCliente;
begin
  Result := TClassCliente(inherited Items[Index]);
end;

procedure TClassClientes.SetItems(Index: Integer; ACliente: TClassCliente);
begin
  inherited Items[Index] := ACliente;
end;

end.
