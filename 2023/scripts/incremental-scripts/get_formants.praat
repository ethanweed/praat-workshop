####################
# Give the students this first part. 
# Go through it, to show what it does, but it is more valuable
# for them to build the loop themselves

clearinfo

# read files
inDir$ = chooseDirectory$: "Select folder with your .wav files"

# check what the contents of inDir$ looks like
#appendInfoLine: inDir$

inDir$ = inDir$ + "/"

files$ = inDir$ + "*.wav"

# Get list of files
wavList = Create Strings as file list: "wavList", files$

# See how many files there are for the loop
numFiles = Get number of strings

#appendInfoLine: numFiles

outDir$ = chooseDirectory$: "Select a folder to store the output files" 

#appendInfoLine: outDir$

# Create the output file and write the first line.
outPath$ = outDir$ + "/" + "formants.csv"
writeFileLine: "'outPath$'", "Vowel,F1,F2,F3"


# 1. Break into small pieces
# 2. Prototype
# 3. Loop
# 4. Generalize


for i from 1 to numFiles
	
	selectObject: wavList
	wavFile$ = Get string: i
	wav = Read from file: inDir$ + wavFile$
	selectObject: wav
	To Formant (burg): 0, 5, 5500, 0.025, 50
	
	#duration = Get total duration
	#midpoint = duration / 2
	#appendInfoLine: midpoint
	
	f1 = Get mean: 1, 0, 0, "hertz"
	f2 = Get mean: 2, 0, 0, "hertz"
	f3 = Get mean: 3, 0, 0, "hertz"

	appendFileLine: "'outPath$'", 
                    ...wavFile$, ",",
                    ...f1, ",", 
                    ...f2, ",", 
                    ...f3

endfor