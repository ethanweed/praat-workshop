# coding 101
    # automate the things we can (and should) automate
    # break tasks down into smaller pieces
    # what do we want to achieve?
    # make a vowel space plot

# how will we do that?

# extract values for F1 and F2

# if we can figure out how to do this for one vowel, then we can automate it for all vowels

# start with commands from point and click

# go back and forth between script and gui

# generalize


# read the sound file in as a sound object
Read from file: "/Users/ethan/Documents/GitHub/praat-workshop/data/cardinal_vowels.wav"

# GENERALIZE IT!
#inFile$ = chooseReadFile$: "pick a file"
#sound = Read from file: inFile$
#selectObject: sound

selectObject: "Sound cardinal_vowels"



To Intensity: 100, 0, "yes"
To TextGrid (silences): -25, 0.1, 0.05, "silent", "sounding"

selectObject: "Sound cardinal_vowels"
plusObject: "TextGrid cardinal_vowels"


Extract intervals where: 1, "no", "contains", "sounding"

appendInfoLine: "Segments extracted!"


##########################

# add a loop to save

# Exercise:
# use history to find out what the save syntax is

#Save as WAV file: "/Users/ethan/Desktop/cardinal_vowels_sounding_1.wav"


# build a loop:

# n = numberOfSelected ("Sound")
# for i to n
	# do something
# endfor


# for i to n
#    sound_id [i] = selected ("Sound", i)
#	appendInfoLine: sound_id [i]
# endfor


# make a new folder to put the seperate files in
createFolder: "/Users/ethan/Desktop/cardinal_vowels"

# make an array of sound id numbers
n = numberOfSelected ("Sound")

for i to n
    sound_id [i] = selected ("Sound", i)
	appendInfoLine: sound_id [i]
	Save as WAV file: "/Users/ethan/Desktop/cardinal_vowels/vowels" + string$ (i) + ".wav"
endfor


