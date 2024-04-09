# make a popup that tells you what you are about to do
pauseScript: "Choose a directory for the input folder"

# choose the input directory and store the path in a variable
inDir$ = chooseDirectory$: "Choose the folder containing your wav files"
inDir$ = inDir$ + "/"
inDirWav$ = inDir$ + "*.wav"

# make a popup that tells you what you are about to do
pauseScript: "Choose the folder to save the extracted files in"

# choose the output directory and store the path in a variable
outDir$ = chooseDirectory$: "Choose the folder to save the extracted files"
outDir$ = outDir$ + "/"

# make a variable containing all the file names for the wav files
wavList = Create Strings as file list: "wavList", inDirWav$