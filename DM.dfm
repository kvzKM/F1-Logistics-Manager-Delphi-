object FDM: TFDM
  Height = 357
  Width = 780
  PixelsPerInch = 120
  object F1Connect: TADOConnection
    LoginPrompt = False
    Left = 56
    Top = 33
  end
  object tblTeams: TADOTable
    Connection = F1Connect
    Left = 56
    Top = 120
  end
  object tblVehicles: TADOTable
    Left = 136
    Top = 120
  end
  object tblMaintenance: TADOTable
    Left = 233
    Top = 120
  end
  object DSTeams: TDataSource
    DataSet = tblTeams
    Left = 56
    Top = 208
  end
  object DSVehicles: TDataSource
    DataSet = tblVehicles
    Left = 144
    Top = 208
  end
  object DSMaintenance: TDataSource
    DataSet = tblMaintenance
    Left = 240
    Top = 208
  end
  object tblExpenses: TADOTable
    Left = 448
    Top = 120
  end
  object tblInventory: TADOTable
    Left = 553
    Top = 120
  end
  object tblStaff: TADOTable
    Left = 648
    Top = 120
  end
  object DSExpenses: TDataSource
    DataSet = tblExpenses
    Left = 448
    Top = 208
  end
  object DSInventory: TDataSource
    DataSet = tblInventory
    Left = 553
    Top = 208
  end
  object DSStaff: TDataSource
    DataSet = tblStaff
    Left = 648
    Top = 208
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 240
    Top = 30
  end
  object SQLall: TADOQuery
    Connection = F1Connect
    Parameters = <>
    Left = 176
    Top = 30
  end
end
