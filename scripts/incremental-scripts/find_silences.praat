# make a new folder to put the seperate files in
Read from file: "/Users/ethan/Documents/GitHub/praat-workshop/cardinal_vowels.wav"

# select the sound object
selectObject: "Sound cardinal_vowels"

# get the intensity (for identifying areas with silence)To Intensity: 100, 0, "no"
To Intensity: 100, 0, "no"

# make a new TextGrid using labels from intensity to segment the sound file
To TextGrid (silences): -25, 0.1, 0.05, "silent", "sounding"

# select the sound and the TextGrid together
selectObject: "Sound cardinal_vowels"
plusObject: "TextGrid cardinal_vowels"

# inspect where the segments have been placed
View & Edit
