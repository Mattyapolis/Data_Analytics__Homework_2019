
Sub VBA_Hard()


'define last row
LastRow = Cells(Rows.Count, 1).End(xlUp).Row

'loop through all worksheets
For Each ws In Worksheets

    'add headers for summary categories
    ws.Range("I1").Value = "Ticker"
    ws.Range("J1").Value = "Yearly Change"
    ws.Range("K1").Value = "Percent Change"
    ws.Range("L1").Value = "Total Stock Volume"

    'set up ticker, volume total, year open and close buckets to recall later
    Dim ticker As String
    Dim vol_total As Double
    Dim yrOpn As Double
    Dim yrCls As Double
    Dim yrChg As Double
    Dim yrPercentChg As Double

    'set vol_total count to zero
    vol_total = 0

    'set up summary table row counter
    Dim summary_table_row As Integer
    summary_table_row = 2

    'loop through each row
    For i = 2 To LastRow
    
        'if the cell above doesn't match
        If ws.Cells(i - 1, 1).Value <> ws.Cells(i, 1).Value Then
            
            'record first opening price for each ticket
            yrOpn = ws.Cells(i, 3).Value
        
        'if the next cell doesn't match
        ElseIf ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then

            'retain the ticker name
            ticker = ws.Cells(i, 1).Value

            'add to the current volume total
            vol_total = vol_total + ws.Cells(i, 7).Value
            
            'record last closing  price for each ticket
            yrCls = ws.Cells(i, 6).Value
            
            'calculate the yearly change from first opening price to last closing price
            yrChg = yrCls - yrOpn
            
             'calculate percentage change from the start of the year
            If yrOpn = 0 Then
                yrPercentChg = 0
            Else
                yrPercentChg = yrChg / yrOpn
            End If
            
            'record ticket and volume total in summary area
            ws.Range("I" & summary_table_row).Value = ticker
            ws.Range("L" & summary_table_row).Value = vol_total
            ws.Range("J" & summary_table_row).Value = yrChg
            ws.Range("K" & summary_table_row).Value = yrPercentChg
            
            'conditionally format the year change column fill color
            If ws.Range("J" & summary_table_row).Value >= 0 Then
                ws.Range("J" & summary_table_row).Interior.ColorIndex = 4
            Else
                ws.Range("J" & summary_table_row).Interior.ColorIndex = 3
            End If

            'move on to the next row in the summary area
            summary_table_row = summary_table_row + 1

            'reset the volume total
            vol_total = 0

        'if the area next ticket name is the same, add that row's volume total to the current total volume counter
        Else: vol_total = vol_total + ws.Cells(i, 7).Value
        
        End If
           
    Next i
                
    'format cells
    ws.Columns("A:L").AutoFit
    ws.Columns("K").NumberFormat = "0.00%"
    
    '---------------------------
    '        MIN/MAX TABLE
    '---------------------------
    
    'add header for min max table
    ws.Range("N2").Value = "Greatest % Increase"
    ws.Range("N3").Value = "Greatest % Decrease"
    ws.Range("N4").Value = "Greatest Total Volume"
    ws.Range("O1").Value = "Ticker"
    ws.Range("P1").Value = "Value"
    
    'set cell ranges of % change and total volume and store as variables
    Dim volRange As Range
    Dim pctRange As Range
    
    Set pctRange = ws.Range("K:K")
    Set volRange = ws.Range("L:L")
    
    'find min and max % change and max total volume and store as variables
    Dim pctMax As Double
    Dim pctMin As Double
    Dim volMax As Double
    
    pctMin = Application.WorksheetFunction.Min(pctRange)
    pctMax = Application.WorksheetFunction.Max(pctRange)
    volMax = Application.WorksheetFunction.Max(volRange)
    
    'add min and max % change and max total volume value to min/max table
    
    ws.Range("P2").Value = pctMax
    ws.Range("P3").Value = pctMin
    ws.Range("P4").Value = volMax
    
    'declare variable to hold ticker name for min max table
    Dim pctMaxTkt As String
    Dim pctMinTkt As String
    Dim volMaxTkt As String
    
    'find row index number of the min and max % change and total volume values using match function
    'use row index number along with column index number of ticker column to find the ticker name
    'print ticker names to appropriate cells
    
    pctMaxTkt = Application.WorksheetFunction.Match(pctMax, pctRange, 0)
    ws.Range("O2").Value = ws.Cells(pctMaxTkt, 9)
    
    pctMinTkt = Application.WorksheetFunction.Match(pctMin, pctRange, 0)
    ws.Range("O3").Value = ws.Cells(pctMinTkt, 9)
    
    volMaxTkt = Application.WorksheetFunction.Match(volMax, volRange, 0)
    ws.Range("O4").Value = ws.Cells(volMaxTkt, 9)
    
    'format %change values as %
    ws.Range("P2:P3").NumberFormat = "0.00%"
    ws.Range("N1:P4").Columns.AutoFit
        
Next ws


End Sub

