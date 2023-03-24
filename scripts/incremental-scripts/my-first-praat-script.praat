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


