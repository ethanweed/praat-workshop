# Script to split sound file into separate wav files based on text grid

# requires a sound file and TextGrid to be selected
# the TextGrid should contain a tier with a label showing which sections to extract

# Script to split sound file into separate wav files based on text grid

# requires a sound file and TextGrid to be selected
# the TextGrid should contain a tier with a label showing which sections to extract
# Script to split sound file into separate wav files based on text grid

# requires a sound file and TextGrid to be selected
# the TextGrid should contain a tier with a label showing which sections to extract


beginPause: "Split into separate wav files based on TextGrid"
	comment: "Which tier is the label on?"
	real: "tierNumber", 2
	comment: "Enter the TextGrid label to split on"
	text: "label", "V"
	comment: "Name for the new folder with output files?"
	text: "folder", "Danish_vowels"
clicked = endPause: "Continue", 1



pauseScript: "Choose a directory for the output folder"

outDir$ = chooseDirectory$: "Select a folder to store the output files" 

saveDir$ = outDir$ + "/" + folder$ + "/"


# make a new folder to put the seperate files in
createFolder: saveDir$

# make new sound objects from the part of the sound file with sounding
Extract intervals where: tierNumber, "no", "is equal to", label$


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
