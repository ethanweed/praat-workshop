# Script to split sound file into separate wav files based on text grid

# requires a sound file and TextGrid to be selected
# the TextGrid should contain a tier with a label showing which sections to extract

form Split into separate wav files based on TextGrid
    comment Which tier is the label on?
    positive tierNumber
    comment Enter the TextGrid text to split on
    sentence lab e.g. V, vowels, voicing
    comment Specify directory where you want to save the finished files (don't forget final slash)
    sentence saveDir /Users/myname/Desktop/newfiles/
    comment Give an optional prefix for all filenames:
    sentence prefix
endform


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
