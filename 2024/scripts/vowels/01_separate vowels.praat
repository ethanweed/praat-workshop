# Script to split the sound file with isolated vowels into separate wav files

# make a new folder to put the seperate files in
createFolder: "/Users/ethan/Desktop/cardinal_vowels"

# read in the sound file
Read from file: "/Users/ethan/Desktop/Praat_Workshop_2024/data/cardinal_vowels/cardinal_vowels.wav"

# select the new sound object
selectObject: "Sound cardinal_vowels"

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


# just to check, we can inspect what it is in the array
#clearinfo
#n = numberOfSelected ("Sound")
#for i from 1 to n
#   appendInfoLine: sound_id [i]
#endfor

# loop through the new sound objects and save them as wav files
n = numberOfSelected ("Sound")
for i to n
	selectObject: sound_id [i]
	Save as WAV file: "/Users/ethan/Desktop/cardinal_vowels/vowel" + string$ (i) + ".wav"
endfor