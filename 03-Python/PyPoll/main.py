import csv, os

#Create file path variable
poll_csv_path = os.path.join("Resources","election_data.csv")

#Create empty list to store candidate names data.
names = []

#Open file and create CSV reader
with open(poll_csv_path,"r", encoding="utf8", newline='' ) as pollcsv:
    pollreader = csv.reader(pollcsv, delimiter=",")
    
    #Skip header row.
    header = next(pollreader)
    
    #iterate through the data and add candidate names to names list.
    for row in pollreader:
        names.append(row[2])

#Gather unique names in a different list.
list_set = set(names)
unique_names = list(list_set)

#Calculate total number of votes
total_votes = len(names)

#iterate through the unique_names list to assign each unique name to the count of occurances
# of that name in the "names" list. This will create a dictionary key value pairs representing
#candidate names and their total number of votes.
vote_tally={}

for i in range(len(unique_names)):
    vote_tally[unique_names[i]] = names.count(unique_names[i])
    
#Iterate through the vote_tally dictionary to isolate vote count for each candidate,
#calculate candidates' percentage of votes received
# and collect the data into a list of summary strings for each
#candidate. This will also assess who had the most votes and record their name in the
#variable called "winner" to be recalled later.
summary = []
winner = ""
most_votes = 0
candidate_stats = ""

for name in vote_tally:
    votes = vote_tally[name]
    vote_pct = round(((float(votes) / float(total_votes))* 100),2)
    candidate_stats = (f"{name}: {vote_pct}% ({votes})")
    summary.append(candidate_stats)
    if votes > most_votes:
        most_votes = votes
        winner = name

#Format the summary list so it prints with line breaks.        
clean_summary = "\n".join(summary)

#Print the results.
print("Election Results")
print("------------------------------")
print(f"Total Votes: {total_votes}")
print("------------------------------")
print(f"{clean_summary}")
print("------------------------------")
print(f"Winner: {winner}" )
print("------------------------------")

output = open("Election_Results.txt", "w")
output.write("Election Results\n")
output.write("------------------------------\n")
output.write(f"Total Votes: {total_votes}\n")
output.write("------------------------------\n")
output.write(f"{clean_summary}\n")
output.write("------------------------------\n")
output.write(f"Winner: {winner}\n" )
output.write("------------------------------\n")
output.close()

os.startfile("Election_Results.txt")

