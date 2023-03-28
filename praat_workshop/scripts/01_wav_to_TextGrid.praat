# take a wav file and create a TextGrid with segments added around areas with sounding
# script ends be displaying the sound and TextGrid together, so you can adjust the segments, or add a tier for e.g. marking vowels

# 1. mark the vowel segements you want to extract
# 2. save your completed TextGrid

pauseScript: "Choose the file you want to segment"

inFile$ = chooseReadFile$: "pick a file"


sound = Read from file: inFile$

# get the intensity (for identifying areas with silence)To Intensity: 100, 0, "no"
To Intensity: 100, 0, "no"

# make a new TextGrid using labels from intensity to segment the sound file
tg = To TextGrid (silences): -25, 0.1, 0.05, "silent", "sounding"


Insert interval tier: 2, "vowels"

# select the sound and the TextGrid together
selectObject: sound
plusObject: tg

View & Edit