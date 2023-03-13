# Script to split sound file into separate wav files based on text grid

# requires a sound file and TextGrid to be selected
# the TextGrid should contain a tier with a label showing which sections to extract

# Script to split sound file into separate wav files based on text grid

# requires a sound file and TextGrid to be selected
# the TextGrid should contain a tier with a label showing which sections to extract

form Split into separate wav files based on TextGrid
    comment Which tier is the label on?
    positive tierNumber
    comment Enter the TextGrid text to split on
    sentence lab e.g. V, vowels, voicing
	comment Name for output folder
	sentence savedir e.g. Danish vowels
    comment Give an optional prefix for all filenames:
    sentence prefix
endform

pauseScript: "Choose a directory for the output folder"

outDir$ = chooseDirectory$: "Select a folder to store the output files" 

saveDir$ = outDir$ + "/" + savedir$ + "/"


# make a new folder to put the seperate files in
createFolder: saveDir$

# make new sound objects from the part of the sound file with sounding
Extract intervals where: tierNumber, "no", "is equal to", lab$


# make an array of sound id numbers
n = numberOfSelected ("Sound")
for i to n
    sound_id [i] = selected ("Sound", i)
endfor

# loop through the new sound objects and save them as wav files
n = numberOfSelected ("Sound")
for i to n
	selectObject: sound_id [i]
	Save as WAV file: saveDir$ + string$ (i) + ".wav"
endfor

select all
Remove