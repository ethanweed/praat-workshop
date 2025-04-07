# Read the sound file
Read from file: "/Users/ethan/Documents/GitHub/praat-workshop/2025/data/cats_dogs.wav"

# Get the pitch contour
selectObject: "Sound cats_dogs"
To Pitch: 0, 75, 600

# Prepare the drawing window
Erase all
Lime
18
Palatino
Line width: 5

# Define the area to draw in
Select outer viewport: 0, 6, 0, 4

# Draw the figure
Draw: 0, 0, 0, 500, "yes"

# Create a pdf of the final image
Save as PDF file: "/Users/ethan/Documents/GitHub/praat-workshop/2025/output/cats_dogs.pdf"

