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

writeInfoLine: "This script will segment sound files and extract formant measurements"
appendInfoLine: "Select directory containing WAV files"


# Select directory containing WAV files
inputDir$ = chooseDirectory$: "Select directory containing WAV files"
inputDir$ = inputDir$ + "/"

appendInfoLine: "Choose the folder to save the extracted files"
# Choose the output directory
outDir$ = chooseDirectory$: "Choose the folder to save the extracted files"
outDir$ = outDir$ + "/"

# Create a list of all WAV files in the directory
Create Strings as file list: "fileList", inputDir$ + "*.wav"
numberOfFiles = Get number of strings

if numberOfFiles == 0
  exitScript: "No WAV files found in the selected directory."
endif

# Process each file
for fileIndex from 1 to numberOfFiles
  selectObject: "Strings fileList"
  fileName$ = Get string: fileIndex

  # Check file type
  if !endsWith(fileName$, ".wav")
    appendInfoLine: "Skipping non-WAV file: ", fileName$
    continue
  endif

  inFile$ = inputDir$ + fileName$

  # Get base filename without the path and extension
  baseName$ = replace$(fileName$, ".wav", "", 0)

  # Create output file name
  infoFileName$ = outDir$ + baseName$ + "_formants.txt"

  # Check if file exists before overwriting
  if fileReadable(infoFileName$)
    appendInfoLine: "Warning: Output file already exists and will be overwritten: ", infoFileName$
  endif

  # Read in the sound file
  appendInfoLine: "Processing file ", fileIndex, " of ", numberOfFiles, ": ", fileName$
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

  # Create a new file for results
  writeFile: infoFileName$, "Interval" + tab$ + "Label" + tab$ + "Start" + tab$ + "End" + tab$ + "Duration" + tab$ + "F1" + tab$ + "F2" + tab$ + "F3" + newline$

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

          # Write the results to file
          resultLine$ = string$(interval) + tab$ + segment_label$ + tab$ + fixed$(start, 3) + tab$ + fixed$(end, 3) + tab$ + fixed$(duration, 3) + tab$ + fixed$(f1, 1) + tab$ + fixed$(f2, 1) + tab$ + fixed$(f3, 1) + newline$
          appendFile: infoFileName$, resultLine$

          # Save individual sound segments if option selected
          if save_individual_segments
              selectObject: originalSounds
              Extract part: start, end, "rectangular", 1, 0
              Save as WAV file: outDir$ + baseName$ + "_" + segment_label$ + ".wav"
              Remove
          endif
      endif
  endfor

  # Provide feedback about completion
  appendInfoLine: "  Found ", soundingCount, " sound segments."
  appendInfoLine: "  Results saved to ", infoFileName$

  # Clean up
  selectObject: originalSounds
  plusObject: newText
  plusObject: formant
  Remove
endfor

# Clean up file list
selectObject: "Strings fileList"
Remove

appendInfoLine: ""
appendInfoLine: "All files processed successfully!"
