# this very nice example is stolen from: https://praatscriptingtutorial.com/loops
# praatscriptingtutorial is an excellent intro to scripting with Praat, which I highly reccomend


clearinfo

days = 7

for day from 1 to days
	if day == 3
		appendInfoLine: "Day", day, ": ride bike"
	else
		appendInfoLine: "Day", day, ": take the bus"
	endif
endfor