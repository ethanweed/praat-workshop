# this very nice example is stolen from: https://praatscriptingtutorial.com/loops
# praatscriptingtutorial is an excellent intro to scripting with Praat, which I highly reccomend


clearinfo

days = 7

appendInfoLine: "Day,Transportation_Type"

for day from 1 to days
	if day == 3
		appendInfoLine: "Day", day, ",ride bike"
	elif day == 6
appendInfoLine: "Day", day, ",ride bike"
	else
		appendInfoLine: "Day", day, ",take the bus"
	endif
endfor

# save file as a .csv file
appendFile ("/Users/ethan/Desktop/Praat_Workshop_2024/output/transportation.csv", info$ ())
