
clearinfo

# choose the folder with the .wav files
inDir$ = chooseDirectory$: "Select folder with your .wav files"

# we need to add the final "/" or "\" to the file path. Thanks, Praat!
inDir$ = inDir$ + "/"

# make a path for the output file with formant values in the same folder as the wav files
outFile$ = inDir$ + "formants.csv"

# make an output file with column headers, and put it in the vowel folder
out$ = "Vowel,F1,F2,F3" + newline$
writeFile: outFile$, out$

# make a string variable with the file names of every file in the folder that ends in ".wav"
files$ = inDir$ + "*.wav"

# Make a list object out of all the file names, so we can loop through them
wavList = Create Strings as file list: "wavList", files$

# Loop through all .wav files, get mean values for F1, F2, and F3, and put them all in a .csv file

# Find the number of files we want to loop through
numFiles = Get number of strings

for i from 1 to numFiles

	# extrace formants from the first file
	selectObject: wavList
	wavFile$ = Get string: i
	wav = Read from file: inDir$ + wavFile$
	selectObject: wav
	To Formant (burg): 0, 5, 5500, 0.025, 50

	# find the middle point of the vowel
	duration = Get total duration
	midpoint = duration / 2
	appendInfoLine: midpoint

	# make a window around the middle point of the vowel
	window = 0.025
	windstart = midpoint - window
	windend = midpoint + window

	f1 = Get mean: 1, windstart, windend, "hertz"
	f2 = Get mean: 2, windstart, windend, "hertz"
	f3 = Get mean: 3, windstart, windend, "hertz"

	fileappend "'outFile$'" 'wavFile$', 'f1', 'f2', 'f3' ,'newline$'

endfor
