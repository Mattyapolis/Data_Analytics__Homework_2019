
Sub VBA_Moderate()

'define last row and last column
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
            
             'calculate percentage change accounting for years that started with zero price
            If yrOpn = 0 Then
                yrPercentChg = 0
            Else
                yrPercentChg = yrChg / yrOpn
            End If
            
            'record ticket and volume total in summary area
            ws.Range("I" & summary_table_row).Value = ticker
            ws.Range("L" & summary_table_row).Value = vol_total
            ws.Range("J" & summary_table_row).Value = yrChg
            
            If ws.Range("J" & summary_table_row).Value >= 0 Then
                ws.Range("J" & summary_table_row).Interior.ColorIndex = 4
            Else
                ws.Range("J" & summary_table_row).Interior.ColorIndex = 3
            End If
            
            ws.Range("K" & summary_table_row).Value = yrPercentChg

            'move on to the next row in the summary area
            summary_table_row = summary_table_row + 1

            'reset the volume total
            vol_total = 0

            'if the area next ticket is the same that volume total to the current counter
        Else: vol_total = vol_total + ws.Cells(i, 7).Value
        
        End If
        
      
    Next i

    'format cells
    ws.Columns("A:L").AutoFit
    ws.Columns("K").NumberFormat = "0.00%"

        
Next ws


End Sub

