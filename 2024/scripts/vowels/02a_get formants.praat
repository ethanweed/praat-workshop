
inDir$ = "/Users/ethan/Desktop/"
outFile$ = inDir$ + "formants.csv"
out$ = "Vowel,F1,F2,F3" + newline$
writeFile: outFile$, out$


Read from file: inDir$ + "cardinal_vowels/vowel1.wav"
soundname$ = selected$ ("Sound")
To Formant (burg): 0, 5, 5500, 0.025, 50

duration = Get total duration
midpoint = duration / 2
appendInfoLine: midpoint
	

window = 0.025

windstart = midpoint - window
windend = midpoint + window

clearinfo
#appendInfoLine: soundname$
#appendInfoLine: "start time:", start
#appendInfoLine: "end time:", end
#appendInfoLine: "window start time:", windstart
#appendInfoLine: "window end time:", windend
#appendInfoLine: " "

f1 = Get mean: 1, windstart, windend, "hertz"
f2 = Get mean: 2, windstart, windend, "hertz"
f3 = Get mean: 3, windstart, windend, "hertz"

#appendInfoLine: f1, ", ", f2, ", ",  f3
fileappend "'outFile$'" 'soundname$', 'f1', 'f2', 'f3' ,'newline$'

