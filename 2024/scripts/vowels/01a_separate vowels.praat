# make a popup that tells you what you are about to do
pauseScript: "Choose the folder to read the wav file from"

inFile$ = chooseReadFile$: "Open a .wav file"

#appendInfoLine: inFile$

label$ = replace$ (inFile$, ".wav", "", 0)
#appendInfoLine: language$

label$ = right$ (label$, 6)
#appendInfoLine: language$

pauseScript: "Choose the folder to save the wav file to"

# choose the output directory and store the path in a variable
outDir$ = chooseDirectory$: "Choose the folder to save the extracted files"
outDir$ = outDir$ + "/"

# read in the sound file
Read from file: inFile$


# select the new sound object
#selectObject: "Sound cardinal_vowels"

# name the sound object
originalSounds = selected: "Sound"

# get the intensity (for identifying areas with silence)
To Intensity: 100, 0, "no"

# make a new TextGrid using labels from intensity to segment the sound file
To TextGrid (silences): -25, 0.1, 0.05, "silent", "sounding"

# name the new TextGrid
newText = selected: "TextGrid"

# select the sound and the TextGrid together
selectObject: originalSounds
plusObject: newText

# make new sound objects from the part of the sound file with sounding
Extract intervals where: 1, "no", "contains", "sounding"


# make an array of sound id numbers
n = numberOfSelected ("Sound")
for i to n
    sound_id [i] = selected ("Sound", i)
endfor


# loop through the new sound objects and save them as wav files
n = numberOfSelected ("Sound")
for i to n
	selectObject: sound_id [i]
	Save as WAV file: outDir$ + label$ + string$ (i) + ".wav"
endfor