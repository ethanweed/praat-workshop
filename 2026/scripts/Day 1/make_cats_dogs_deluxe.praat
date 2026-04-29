# Read in sound file and TextGrid file
Read from file: "/Users/ethan/Documents/GitHub/praat-workshop/2025/data/cats_dogs.wav"
Read from file: "/Users/ethan/Documents/GitHub/praat-workshop/2025/data/cats_dogs.TextGrid"

# Create a pitch object (extract F0)
selectObject: "Sound cats_dogs"
To Pitch: 0, 75, 600

# Select the Pitch object and the TextGrid object together
selectObject: "TextGrid cats_dogs"
plusObject: "Pitch cats_dogs"

# Prepare the drawing window
Erase all
Lime
18
Palatino
Line width: 5

# Define the area to draw in
Select outer viewport: 0, 6, 0, 4

# Add the image file
Insert picture from file: "/Users/ethan/Documents/praat_tutorial_tempfiles/D2_and_me_20.png", 2.1, 2.1, 347, 347

# Draw the pitch contour and annotation
Draw: 1, 0, 0, 0, 500, 18, "no", "centre", "no"

Black
Text: 1, "centre", 350, "half", "Everybody knows it..."

# Create a pdf of the final image
Save as PDF file: "/Users/ethan/Documents/GitHub/praat-workshop/2025/output/cats_dogs_deluxe.pdf"

# Clean up
select all
Remove




