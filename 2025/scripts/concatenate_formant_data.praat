# Script to concatenate multiple formant files and add a source column

form Concatenate Formant Files
    comment Select a directory containing your formant text files:
    sentence File_pattern *_formants.txt
    sentence Output_filename combined_formants.txt
    boolean Keep_header_row_from_first_file_only 1
endform

# First select the directory containing the files
directory$ = chooseDirectory$: "Select directory containing formant files"
if directory$ = ""
    exitScript: "Selection cancelled by user."
endif

# Create list of files matching the pattern
Create Strings as file list: "fileList", directory$ + "/" + file_pattern$
numberOfFiles = Get number of strings

if numberOfFiles = 0
    selectObject: "Strings fileList"
    Remove
    exitScript: "No files matching the pattern were found in the selected directory."
endif

# Display the available files
clearinfo
writeInfoLine: "Found ", numberOfFiles, " files. Processing all files automatically."

# Initialize variables
header$ = ""
combinedData$ = ""
isFirstFile = 1
filesProcessed = 0

# Process all files
for fileIndex to numberOfFiles
    # Get the file path
    selectObject: "Strings fileList"
    fileName$ = Get string: fileIndex
    fullPath$ = directory$ + "/" + fileName$

    # Extract base name without extension for identification
    baseName$ = replace$(fileName$, ".txt", "", 0)
    baseName$ = replace_regex$(baseName$, ".*[/\\]", "", 0)

    appendInfoLine: "Processing file ", fileIndex, "/", numberOfFiles, ": ", baseName$

    # Read the file content
    fileContent$ = readFile$(fullPath$)

    # Split into lines manually
    lines = 0
    startPos = 1

    repeat
        # Extract substring from current position to end
        subString$ = mid$(fileContent$, startPos, length(fileContent$) - startPos + 1)
        position = index(subString$, newline$)

        if position = 0
            lineEnd = length(fileContent$) + 1
        else
            lineEnd = startPos + position - 1
        endif

        currentLine$ = mid$(fileContent$, startPos, lineEnd - startPos)
        lines = lines + 1

        # Process header for first file only
        if lines = 1
            if isFirstFile
                header$ = currentLine$ + tab$ + "Source_File"
                combinedData$ = header$ + newline$
                isFirstFile = 0
            endif
        else
            # For data lines, always add them (with source column)
            if keep_header_row_from_first_file_only = 0 or lines > 1
                if length(currentLine$) > 0
                    processedLine$ = currentLine$ + tab$ + baseName$
                    combinedData$ = combinedData$ + processedLine$ + newline$
                endif
            endif
        endif

        startPos = lineEnd + 1
    until startPos > length(fileContent$)

    filesProcessed = filesProcessed + 1
endfor

# Clean up file list
selectObject: "Strings fileList"
Remove

# Create output directory and file
outputDir$ = chooseDirectory$: "Select directory to save the combined file"
outputPath$ = outputDir$ + "/" + output_filename$

# Check if file exists before overwriting
if fileReadable(outputPath$)
    pauseScript: "Warning: Output file already exists and will be overwritten. Click OK to continue or Cancel to abort."
endif

# Write combined data to file
writeFile: outputPath$, combinedData$

# Provide feedback
writeInfoLine: "Concatenation complete!"
appendInfoLine: "Processed ", filesProcessed, " files."
appendInfoLine: "Combined data saved to: ", outputPath$


