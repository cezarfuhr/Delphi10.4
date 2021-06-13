object FoMain: TFoMain
  Left = 0
  Top = 0
  Caption = 'FoMain'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 299
    Align = alLeft
    TabOrder = 0
    object btnLFornecedore: TBitBtn
      Left = 1
      Top = 35
      Width = 183
      Height = 34
      Align = alTop
      Caption = 'Cadastro Dois'
      TabOrder = 0
      OnClick = btnLFornecedoreClick
    end
    object btnClientes: TBitBtn
      Left = 1
      Top = 1
      Width = 183
      Height = 34
      Align = alTop
      Caption = 'Cadastro UM'
      TabOrder = 1
      OnClick = btnClientesClick
    end
    object Button1: TButton
      Left = 1
      Top = 69
      Width = 183
      Height = 44
      Align = alTop
      Caption = 'Pedido'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object panMain: TPanel
    Left = 185
    Top = 0
    Width = 450
    Height = 299
    Align = alClient
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 448
      Height = 297
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 32
      ExplicitTop = 144
      ExplicitWidth = 185
      ExplicitHeight = 89
    end
  end
end
