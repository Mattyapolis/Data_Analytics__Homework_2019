import os
import csv

#Create file path variable
budget_csv = os.path.join("Resources", "budget_data.csv")

#Create empty lists to store data as we iterate through the CSV file.
date = []
profitLoss = []
monthlyChange = []

#Open CSV file and create reader.
with open(budget_csv, encoding='utf8', newline='') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',')
     
    #Skip the header row.     
    csv_header = next(csvreader)
   
    #Iterate through CSV file and record Date and Profit/Loss data in 
    #each appropriate list        
    for row in csvreader:
        date.append(row[0])
        profitLoss.append(row[1])
        
#cast list as integer using list comprehension. 
ProfitLossInt = [int(i) for i in profitLoss]

#sum of profit and loss.
Total = sum(ProfitLossInt)

#Iterate through Profit/Loss rows tofind monthly change and put it in a list.
#It needs to  be off set by 1 because
#otherwise it will iterate beyond the last row since using i+1 in conditional statement.
for i in range(len(ProfitLossInt)-1):
    if i+1 <= len(ProfitLossInt):
        monthlyChange.append(ProfitLossInt[i+1] - ProfitLossInt[i])  


#Create an function to calculate average.
def average(mylist):
    return sum(mylist)/len(mylist)

monthlyChangeAvg = round(average(monthlyChange),2)

#Find the maximum and minimum monthly change.
monthlyChangeMax = max(monthlyChange)
monthlyChangeMin = min(monthlyChange)

#find the date that corresponds to the maxium and minimum monthly change
MaxDate = date[monthlyChange.index(max(monthlyChange))+1]
MinDate = date[monthlyChange.index(min(monthlyChange))+1]

#Print output to console and create text file summary
print("Financial Analysis")
print("-------------------------------")
print("Total Months: " + str(len(date)))
print(f"Total: ${Total}")
print(f"Average Change: ${monthlyChangeAvg}")
print(f"Greatest Increase in Profits: {MaxDate} (${monthlyChangeMax})")
print(f"Greatest Decrease in Profits: {MinDate} (${monthlyChangeMin})")

output = open("Financial_Analysis.txt", "w")
output.write("Financial Analysis\n")
output.write("-------------------------------\n")
output.write("Total Months: " + str(len(date))+"\n")
output.write(f"Total: ${Total}\n")
output.write(f"Average Change: ${monthlyChangeAvg}\n")
output.write(f"Greatest Increase in Profits: {MaxDate} (${monthlyChangeMax})\n")
output.write(f"Greatest Decrease in Profits: {MinDate} (${monthlyChangeMin})\n")
output.close()

os.startfile("Financial_Analysis.txt")
