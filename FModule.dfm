object Module: TModule
  OldCreateOrder = False
  Height = 255
  Width = 388
  object tmClientes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 40
    Top = 32
    object tmClientesid: TIntegerField
      FieldName = 'id'
    end
    object tmClientesnome: TStringField
      FieldName = 'nome'
      Size = 50
    end
  end
  object tmFornecedores: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 40
    Top = 88
    object tmFornecedoresid: TIntegerField
      FieldName = 'id'
    end
    object tmFornecedoresnome: TStringField
      FieldName = 'nome'
      Size = 50
    end
  end
end
