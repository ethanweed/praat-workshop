# Formant Extraction and Analysis Script

form Formant Extractinator TM
  comment Select audio processing parameters:
  integer Silence_threshold_(dB) -25
  positive Minimum_silent_interval_(s) 0.1
  positive Minimum_sounding_interval_(s) 0.05
  positive Number_of_formants 5
  positive Maximum_formant_(Hz) 5500
  boolean Save_individual_segments 0
  boolean Use_original_filename_for_output 1
endform

writeInfoLine: "This script will segment a sound file and extract formant measurements"


# Select input file
inFile$ = chooseReadFile$: "Open a .wav file"

# Check file type
if !endsWith(inFile$, ".wav")
  exitScript: "Only WAV files are supported. Please select a WAV file."
endif

# Get base filename without the path and extension
baseName$ = replace$(inFile$, ".wav", "", 0)
baseName$ = replace_regex$(baseName$, ".*[/\\]", "", 0)

# Choose the output directory
outDir$ = chooseDirectory$: "Choose the folder to save the extracted files"
outDir$ = outDir$ + "/"

# Create output file name
infoFileName$ = outDir$ + baseName$ + "_formants.txt"

# Check if file exists before overwriting
if fileReadable(infoFileName$)
  pauseScript: "Warning: Output file already exists and will be overwritten. Click OK to continue or Cancel to abort."
endif

# Read in the sound file
writeInfoLine: "Processing file: ", inFile$
Read from file: inFile$

# Name the sound object
originalSounds = selected: "Sound"

# Get the intensity (for identifying areas with silence)
To Intensity: 100, 0, "no"

# Make a new TextGrid using labels from intensity to segment the sound file
To TextGrid (silences): silence_threshold, minimum_silent_interval, minimum_sounding_interval, "silent", "sounding"

# Name the new TextGrid
newText = selected: "TextGrid"

# Create a Formant object from the sound
selectObject: originalSounds
formant = To Formant (burg): 0.01, number_of_formants, maximum_formant, 0.025, 50

# Get the number of intervals in the TextGrid
selectObject: newText
numberOfIntervals = Get number of intervals: 1
appendInfoLine: "Number of intervals found: ", numberOfIntervals
appendInfoLine: "Analyzing formants..."

# Clear the info window for results
clearinfo

# Print header for results
writeInfoLine: "Interval", tab$, "Label", tab$, "Start", tab$, "End", tab$, "Duration", tab$, "F1", tab$, "F2", tab$, "F3"

# Initialize counter for sounding segments
soundingCount = 0

# Loop through all intervals
for interval from 1 to numberOfIntervals
    selectObject: newText
    label$ = Get label of interval: 1, interval

    # Check if the interval is labeled "sounding"
    if label$ = "sounding"
        soundingCount += 1
        segment_label$ = "Segment_" + string$(soundingCount)

        # Get the start and end time of the interval
        start = Get start time of interval: 1, interval
        end = Get end time of interval: 1, interval
        duration = end - start

        # Get the mean formant values for this interval
        selectObject: formant
        f1 = Get mean: 1, start, end, "Hertz"
        f2 = Get mean: 2, start, end, "Hertz"
        f3 = Get mean: 3, start, end, "Hertz"

        # Print the results
        appendInfoLine: interval, tab$, segment_label$, tab$, fixed$(start, 3), tab$, fixed$(end, 3), tab$, fixed$(duration, 3), tab$, fixed$(f1, 1), tab$, fixed$(f2, 1), tab$, fixed$(f3, 1)

        # Save individual sound segments if option selected
        if save_individual_segments
            selectObject: originalSounds
            Extract part: start, end, "rectangular", 1, 0
            Save as WAV file: outDir$ + baseName$ + "_" + segment_label$ + ".wav"
            Remove
        endif
    endif
endfor

# Save the info window contents to a file
infoContent$ = info$()
writeFile: infoFileName$, infoContent$

# Provide feedback about completion
appendInfoLine: ""
appendInfoLine: "Analysis complete!"
appendInfoLine: "Found ", soundingCount, " sound segments."
appendInfoLine: "Results saved to ", infoFileName$



# Clean up
selectObject: originalSounds
plusObject: newText
plusObject: formant
Remove
