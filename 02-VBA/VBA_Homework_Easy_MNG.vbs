Sub VBA_Easy()

'define last row and last column
LastColumn = Cells(1, Columns.Count).End(xlToLeft).Column
LastRow = Cells(Rows.Count, 1).End(xlUp).Row

'loop through all worksheets
For Each ws In Worksheets

    'add headers for summary categories
    ws.Range("I1").Value = "Ticker"
    ws.Range("J1").Value = "Total Stock Volume"

    'set up ticker name and volume total buckets to recall later
    Dim ticker As String
    Dim vol_total As String

    'set vol_total count to zero
    vol_total = 0

    'set up summary table row counter
    Dim summary_table_row As Integer
    summary_table_row = 2

    'loop through each row
    For i = 2 To LastRow

        'if the next cell doesn't match
        If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then

            'retain the ticker name
            ticker = ws.Cells(i, 1).Value

            'add to the current volume total
            vol_total = vol_total + ws.Cells(i, 7).Value

            'record ticket and volume total in summary area
            ws.Range("I" & summary_table_row).Value = ticker
            ws.Range("J" & summary_table_row).Value = vol_total

            'move on to the next row in the summary area
            summary_table_row = summary_table_row + 1

            'reset the volume total
            vol_total = 0

            'if the area next ticket is the same that volume total to the current counter
            Else: vol_total = vol_total + ws.Cells(i, 7).Value

        End If

    Next i

'format cells
ws.Columns("A:J").AutoFit


Next ws


End Sub

