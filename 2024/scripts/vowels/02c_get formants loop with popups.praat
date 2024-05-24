
# The same as 02b_get formants loop, but with added popups to guide folder selection and allow window size selection

# make a popup that tells you what you are about to do
pauseScript: "Choose a directory for the input folder"

# choose the input directory and store the path in a variable
inDir$ = chooseDirectory$: "Choose the folder containing your wav files"
inDir$ = inDir$ + "/"
inDirWav$ = inDir$ + "*.wav"

# make a popup that tells you what you are about to do
pauseScript: "Choose the folder to save the extracted data in"

# choose the output directory and store the path in a variable
outDir$ = chooseDirectory$: "Choose the folder to save the data in"
outDir$ = outDir$ + "/"

# make a variable containing all the file names for the wav files
wavList = Create Strings as file list: "wavList", inDirWav$

# add the file name "formants.csv" to the output path
outFile$ = outDir$ + "formants.csv"

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


# create a popup that lets you set the desired window size
beginPause: "Adust window or ceiling?"
	comment: "Set window ofset (sec)"
	real: "window", 0.025
clicked = endPause: "Continue", 1




##############


clearinfo


# make a path for the output file with formant values in the same folder as the wav files
outFile$ = outDir$ + "formants.csv"

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

	# extrat formants from the first file
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
	#window = 0.025
	windstart = midpoint - window
	windend = midpoint + window

	f1 = Get mean: 1, windstart, windend, "hertz"
	f2 = Get mean: 2, windstart, windend, "hertz"
	f3 = Get mean: 3, windstart, windend, "hertz"

	fileappend "'outFile$'" 'wavFile$', 'f1', 'f2', 'f3' ,'newline$'

endfor
