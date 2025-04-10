# Vowel Detection Script
# This script identifies vowel segments in a sound file using formant analysis
# Attempts to only labels sections with a clear first formant

form Vowel Detection
    comment Parameters for vowel detection:
    positive Time_step 0.01
    positive Window_length 0.025
    positive Maximum_formant 5500
    integer Number_of_formants 5
    positive Minimum_vowel_duration 0.05
    positive F1_minimum 300
    positive F1_maximum 1000
    positive F1_strength_threshold 0.7
    positive Intensity_threshold 55
endform

# Get the selected sound object
sound = selected("Sound")
soundname$ = selected$("Sound")

# Create necessary analysis objects
selectObject: sound
To Formant (burg)... time_step number_of_formants maximum_formant window_length 50
formant = selected("Formant")

selectObject: sound
To Intensity... 100 0 yes
intensity = selected("Intensity")

# Create a TextGrid to mark vowel segments
selectObject: sound
To TextGrid... "vowels" ""
textgrid = selected("TextGrid")

# Get sound duration
selectObject: sound
duration = Get end time

# Initialize variables
start_vowel = 0
in_vowel = 0
vowel_count = 0

# Analyze each time point
time = 0
while time < duration
    # Get formant and intensity values
    selectObject: formant
    f1_exists = Get value at time... 1 time Hertz Linear
    f1_bw_exists = Get bandwidth at time... 1 time Hertz Linear

    selectObject: intensity
    int_exists = Get value at time... time Cubic

    # Check if this point has a clear first formant (vowel)
    is_vowel = 0

    # First check if we have valid values before doing any comparisons
    if f1_exists <> undefined
        if f1_bw_exists <> undefined
            if int_exists <> undefined
                # Store the actual values
                f1 = f1_exists
                f1_bandwidth = f1_bw_exists
                int_value = int_exists

                # Now check if F1 is in typical vowel range
                if f1 >= f1_minimum
                    if f1 <= f1_maximum
                        # Calculate formant strength (lower bandwidth = stronger formant)
                        f1_strength = 1 - (f1_bandwidth / f1)

                        # Check if F1 is strong enough and intensity is sufficient
                        if f1_strength >= f1_strength_threshold
                            if int_value > intensity_threshold
                                is_vowel = 1
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif

    # Handle transitions between vowel and non-vowel segments
    if is_vowel and not in_vowel
        # Start of a potential vowel
        start_vowel = time
        in_vowel = 1
    elsif not is_vowel and in_vowel
        # End of a vowel segment
        end_vowel = time

        # Only mark if longer than minimum duration
        if end_vowel - start_vowel >= minimum_vowel_duration
            vowel_count = vowel_count + 1
            selectObject: textgrid
            Insert boundary... 1 start_vowel
            Insert boundary... 1 end_vowel
            mid_point = (start_vowel + end_vowel) / 2
            interval = Get interval at time... 1 mid_point
            vowel_label$ = "vowel_" + string$(vowel_count)
            Set interval text... 1 interval vowel_label$
        endif

        in_vowel = 0
    endif

    # Increment time
    time = time + time_step
endwhile

# Handle case where sound ends during a vowel
if in_vowel
    end_vowel = duration
    if end_vowel - start_vowel >= minimum_vowel_duration
        vowel_count = vowel_count + 1
        selectObject: textgrid
        Insert boundary... 1 start_vowel
        Insert boundary... 1 end_vowel
        mid_point = (start_vowel + end_vowel) / 2
        interval = Get interval at time... 1 mid_point
        vowel_label$ = "vowel_" + string$(vowel_count)
        Set interval text... 1 interval vowel_label$
    endif
endif

# Clean up temporary objects
selectObject: formant
Remove
selectObject: intensity
Remove

# Select the results
selectObject: sound, textgrid

# Report results
writeInfoLine: "Vowel detection completed."
appendInfoLine: "Found ", vowel_count, " vowel segments in ", soundname$
appendInfoLine: "Results are marked in the TextGrid."
