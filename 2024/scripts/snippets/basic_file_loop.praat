


# make a variable containing all the file names for the wav files
wavList = Create Strings as file list: "wavList", inDirWav$

# Find the number of files in the folder to loop through
numFiles = Get number of strings

#loop through the files
for i from 1 to numFiles

	# read in the next file
	selectObject: wavList
	wavFile$ = Get string: i
	wav = Read from file: inDir$ + wavFile$

    # do stuff

endfor