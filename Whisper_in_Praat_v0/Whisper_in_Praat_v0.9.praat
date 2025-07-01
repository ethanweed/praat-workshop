###   ___________________________________________________________________________________
###
### 	Objects Script
###   ___________________________________________________________________________________
###
### 	Program info
###	
###	Whisper_in_Praat is a convenient way for Praat users to automatically generate 
###	transcriptions using whisper-faster. 
###	
###	The script provides a simple graphical user interface to whisper
###	and convert the transcription to a Praat TextGrid.
###	
###	Processing of media files happens locally on the computer where the script runs.
###
###	This script comes in a zip-file that contains all that is needed to run whisper,  
###	except for the language models that will be downloaded automatically by whisper 
###	the first time they are needed. Zip files containing the windows or macOs versions
###	can be found at
###		http://dx.doi.org/10.13140/RG.2.2.24093.93925
###
###	The script assumes that the whisper-faster executable and it's subfolders
###	are located in the same folder as this script.
###
###	NB! The script does not work if files or paths contain special characters 
###	like blank space.
###
###	The Whisper-faster executables are faster, compiled & ready to use programs
###	derived from open AI's whisper. See further
###		https://openai.com/research/whisper	
###	faster-whisper is available for download from
###		https://github.com/SYSTRAN/faster-whisper
###	The standalone whisper-faster executables are available from 
###		https://github.com/Purfview
###   ___________________________________________________________________________________
###
###	Revisions
###
###	v 0.1 20240223 	Functional, reads .srt + .json.
### 	v 0.2 20240226 	Reads only .json.
###			+ Relative path to whisper-faster.
###	v 0.3 20240227 	Support combination of output formats.
###	v 0.4 20240227 	Use input and output folder.
###			+ write probabilities.
###			+ check output folder for previous files.
###			& select new output folder.
###	v 0.5 20240301	Sticky settings using Table containing settings.
###			Keep TextGrid and LongSound in Objects window or not.
###			Program info added.
###	v 0.6 20240305	Clean-up of debugging lines and variable names.
###			Suppress punctuation and utterance initial upper case letters.
###			Improved logic around combination of choices.
###			Probability tiers now depend on word or utterance tiers.
###	v 0.7 20240313	Changed message regading missing settings file.
###	v 0.8 20240522	Check for blankspace in media file name or path.
###			Dual channel processing added.
###			The feature uses intensity differences between two audio
###			channels to direct transcription to two separate tiers.
###	v 0.8.1 240814	Added option: Attempt to use GPU or not.
###			Added option: Beep when finished or not.
###	v 0.8.2 240912	Added startup message.
###			Added simple/advanced mode.
###			Added Standards button.
###			Using system neutral / in paths.
###			Combined Windows/macOS version.
###			Added check that whisper-faster executable is readable.
###			NB! The Whisper-faster executable that is called is matched to
###			the operating-system!
###	v 0.8.3 240925	Check that the script is running on the expected OS.
###			Ensure that entered output folder uses / and ends in /
###			Fixed bug related to the standards button.
###			Added .processed.tsv which converts TextGrid to .tsv.
###			In case of two channel processing this output format reflects
###			the distribution of utterances between the two channels as seen 
###			in the TextGrid.
###	v 0.8.4 241016	Added option to use previously generated .json Whisper output file.
###	v 0.9	241017	Beginning a complete recoding of main loop to make processing more flexible.
###			Most processing moved to procedures.
###			Added option to split utterances at pauses, at punctuation marks . : ! ?
###			and when channel balance shifts from one word to the next
###		250404	Recoding of main loop completed
###			Settings file changed to v0.9
###			Relic code lines removed
###			Info section updated
###			
###
###   ___________________________________________________________________________________
###
###	Script was developed and tested using Praat 6.4.12
###	in combination with whisper-faster.exe 0.9.0
###	running on Windows 10 Enterprise
###
###	macOS version developed and tested using Praat 6.4.01
###	in combination with whisper-faster 0.9.0
###	running on macOS Catalina 10.15.7
###
###	Praat script CC BY-NC-SA Gert Foget Hansen 20240223-20250404
###	Faster-whisper made avaiable under a MIT license:
###		https://github.com/openai/whisper?tab=MIT-1-ov-file#readme
###
###	This script with accompanying executables can be found at:
###	 	http://dx.doi.org/10.13140/RG.2.2.24093.93925
###
###   ___________________________________________________________________________________


clearinfo

version$ = "v0.9"
version_object_name$ = "v0_9"

####system$ = "Windows"
system$ = "macOS"

if system$ = "Windows"
	extension$ = ".psc"
elsif system$ = "macOS"
	extension$ = ".praat"
endif

### Check if the script is running on the right OS
if system$ = "Windows"
	slash = rindex (defaultDirectory$, "\")
	if slash <> 0
		appendInfoLine: "Script appears to be running in a Windows environment"
	elsif slash = 0 
		appendInfoLine: "It seem like you are trying to run the Windows version of Whisper_in_Praat on a mac"
		appendInfoLine: "Please download the macOS version from this link:"
		appendInfoLine: "http://dx.doi.org/10.13140/RG.2.2.24093.93925"
		exitScript: "It seem like you are trying to run the Windows version of Whisper_in_Praat on a mac. Please download the macOS version from this link: http://dx.doi.org/10.13140/RG.2.2.24093.93925"
	endif
elsif system$ = "macOS"
	slash = rindex (defaultDirectory$, "/")
	if slash <> 0
		appendInfoLine: "Script appears to be running in a macOS environment"
	elsif slash = 0 
		appendInfoLine: "It seem like you are trying to run the mac version of Whisper_in_Praat on a Windows computer"
		appendInfoLine: "Please download the Windows version from this link:"
		appendInfoLine: "http://dx.doi.org/10.13140/RG.2.2.24093.93925"
		exitScript: "It seem like you are trying to run the mac version of Whisper_in_Praat on a Windows computer. Please download the Windows version from this link: http://dx.doi.org/10.13140/RG.2.2.24093.93925"
	endif
endif

###   ___________________________________________________________________________________
###
###	Present startup message or not
###   ___________________________________________________________________________________
###

if fileReadable: defaultDirectory$ + "/Run_whisper_settings_" + version$ + ".Table"
	Read Table from tab-separated file: defaultDirectory$ + "/Run_whisper_settings_" + version$ + ".Table"
	show_startup_message$ = Get value: 1, "show_startup_message"
	show_startup_message = number (show_startup_message$)
	Remove
else
	show_startup_message = 1
endif

if show_startup_message = 1
	beginPause: "Startup message for Whisper in Praat"
		comment: "There are four steps to the Whisper in Praat script: "
		comment: "    1 This startup message (can be disabled)"
		comment: "    2 Select media file"
		comment: "    3 Set parameters"
		comment: "    4 Process and wait for the result"
		comment: "Expect 1-2 minutes of processing time per minute of recording."
		comment: "The first time the chosen language model is needed (small, medium or large)"
		comment: "it will be downloaded. This takes additional time."
		comment: "4.75 GB of space is required in total for all three models."
		comment: ""
		comment: "By default output is saved to a folder named whisper-output"
		comment: "located in the same folder as the media file."
		comment: "If it doesn't exist the script will create it."
		comment: "You can specify a different output folder if you want to."

	clicked = endPause: "Continue", 1
endif

###   ___________________________________________________________________________________
###
###	Select media file and parse filename and folder
###   ___________________________________________________________________________________
###

repeat
	go = 1
	media_file_with_path$ = chooseReadFile$: "Select media file for transcription"

	### separate folder path, filename and extension
	if system$ = "Windows"
		media_file_with_path$ = replace$ (media_file_with_path$, "\", "/", 0)
	endif
	slash = rindex (media_file_with_path$, "/")
	dot = rindex (media_file_with_path$, ".")
	length = length (media_file_with_path$)
	namelength = dot - slash - 1
	path$ = left$ (media_file_with_path$, (slash))
	file_name$ = right$ (media_file_with_path$, (length - slash))
	naked_file_name$ = mid$ (media_file_with_path$, (slash + 1), namelength)

	### check for blankspace in file name or path
	if index (media_file_with_path$, " ") > 0
		go = 0
		beginPause: "Error"
			comment: "The name or the path of the selected file contains blankspace:"
			comment: media_file_with_path$
			comment: "Rename or move media file and reselect."
		clicked = endPause: "Reselect", 1
	endif
until go = 1
appendInfoLine: "Selected media file: " + media_file_with_path$ + newline$


###   ___________________________________________________________________________________
###
###	Set parameters
###   ___________________________________________________________________________________
###

### read settings file if it exits
if fileReadable: defaultDirectory$ + "/Run_whisper_settings_" + version$ + ".Table"
	Read Table from tab-separated file: defaultDirectory$ + "/Run_whisper_settings_" + version$ + ".Table"
else
	### create new table and set default values
	appendInfoLine: "No previous settings file found. New settings file will be created."
	@create_new_table_and_set_default_values
endif

### read settings into variables
@read_settings_into_variables

# output_folder$ is a short hand for output_folder_with_path$
output_folder$ = path$ + output_folder_name$

### Pauseform placed in loop to give the option to toggle between simple and advanced modes

repeat
	beginPause: "Select options"
		sentence: "Selected media file", file_name$
		sentence: "Output folder", output_folder$
		optionMenu: "Language", language
			option: "Auto"
			option: "Danish"
			option: "English"
			option: "Estonian"
			option: "Finnish"
			option: "French"
			option: "German"
			option: "Norwegian"
			option: "Nynorsk"
			option: "Portuguese"
			option: "Spanish"
			option: "Swedish"
			if advanced_mode = 1
				option: "Other"
			endif
		if advanced_mode = 1
			word: "Other language", other_language$
		endif
		optionMenu: "Model", model
			option: "small"
			option: "medium"
			option: "large"
		if advanced_mode = 1
			boolean: "Attempt to use GPU", attempt_to_use_GPU
		endif
		optionMenu: "Processing method", processing_method
			option: "Single channel"
			option: "Dual channel, one pass"
####			option: "Dual channel, two pass"
		if advanced_mode = 1
			boolean: "Use existing .json file", use_existing_.json_file
		endif
	
		comment: "_______________________________________________________________________________"
		comment: "Output files:"
		if advanced_mode = 1
			boolean: "json", json
		endif
		boolean: "lrc", lrc
		boolean: "srt", srt
		boolean: "text", text
		boolean: "tsv", tsv
		boolean: "txt", txt
		boolean: "vtt", vtt

		comment: "Post processing:"
		boolean: "Suppress punctuation and utterance initial uppercase", suppress_punctuation_and_utterance_initial_uppercase
		boolean: "Reanalyze utterance boundaries", reanalyze_utterance_boundaries
		comment: "Processed output to TextGrid tiers and files:"
		boolean: "utterances", textGrid_utterances
		boolean: "words", textGrid_words
		if advanced_mode = 1
			boolean: "probabilities", textGrid_probabilities
		endif
		boolean: "processed.tsv", processed_tsv
		comment: "_______________________________________________________________________________"
		boolean: "Keep TextGrid and LongSound in Objects window", keep_TextGrid_and_LongSound_in_Objects_window
		boolean: "Beep when finished", beep_when_finished
		boolean: "Debug mode", debug_mode
		boolean: "Show startup message", show_startup_message
	clicked = endPause: "Standards", "Simple", "Advanced", "Process", 4
	
	# Check that the output folder end in a "/"
	if right$(output_folder$) = "\"
		output_folder$ = replace$(output_folder$, "\", "/", 0)
	elsif right$(output_folder$) <> "/"
		output_folder$ = output_folder$ + "/"
	endif

	# Transfer values from variable names created in form to variables used in the rest of the script
	output_folder_with_path$ = output_folder$
	processed_tsv = processed.tsv
	textGrid_utterances = utterances
	textGrid_words = words
	textGrid_probabilities = probabilities
	
	if clicked = 1
		# Remove open table
		# create new table and set default values
		# read settings into variables
		Remove
		@create_new_table_and_set_default_values
		@read_settings_into_variables
		# output_folder$ needs to be recreated
		output_folder$ = path$ + output_folder_name$
	elsif clicked = 2
		advanced_mode = 0
	elsif clicked = 3
		advanced_mode = 1
	endif
until clicked = 4

if textGrid_utterances = 0 and textGrid_words = 0 and textGrid_probabilities = 1
	beginPause: "Warning"
		comment: "The tiers with probabilities are linked to the utterance and word tiers."
		comment: "Neither 'Utterances' nor 'Words' was chosen, so no TextGrid will be generated."
	clicked = endPause: "OK", 1
endif

if textGrid_utterances = 0 and textGrid_words = 0
	textGrid = 0
else
	textGrid = 1
endif

### deconstruct output folder path
slash = rindex_regex (output_folder_with_path$, "/\w+")
length = length (output_folder_with_path$)
output_folder_path$ = left$ (output_folder_with_path$, slash)
output_folder_name$ = right$ (output_folder_with_path$, length - slash)
appendInfoLine: "Output folder: " + output_folder_with_path$ + newline$

###   ___________________________________________________________________________________
###
###	Check if previous output files exist
###   ___________________________________________________________________________________
###


repeat
	go = 1
	existing_output_files$ = ""

	file_json = fileReadable: output_folder_with_path$ + naked_file_name$ + ".json"
	existing_json = file_json
	if (file_json = 1) and (use_existing_.json_file = 1)
		file_json = 0
	endif
	if file_json = 1 
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".json" + ", "
	endif

	file_lrc = fileReadable: output_folder_with_path$ + naked_file_name$ + ".lrc"
	if file_lrc = 1
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".lrc" + ", "
	endif

	file_srt = fileReadable: output_folder_with_path$ + naked_file_name$ + ".srt"
	if file_srt = 1
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".srt" + ", "
	endif

	file_text = fileReadable: output_folder_with_path$ + naked_file_name$ + ".text"
	if file_text = 1
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".text" + ", "
	endif

	file_tsv = fileReadable: output_folder_with_path$ + naked_file_name$ + ".tsv"
	if file_tsv = 1
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".tsv" + ", "
	endif

	file_processed_tsv = fileReadable: output_folder_with_path$ + naked_file_name$ + ".processed.tsv"
	if file_processed_tsv = 1
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".processed.tsv" + ", "
	endif

	file_txt = fileReadable: output_folder_with_path$ + naked_file_name$ + ".txt"
	if file_txt = 1
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".txt" + ", "
	endif

	file_vtt = fileReadable: output_folder_with_path$ + naked_file_name$ + ".vtt"
	if file_vtt = 1
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".vtt" + ", "
	endif

	file_TextGrid = fileReadable: output_folder_with_path$ + naked_file_name$ + ".TextGrid"
	if file_TextGrid = 1
		existing_output_files$ = existing_output_files$ + naked_file_name$ + ".TextGrid"
	endif

	if file_json = 1 or file_lrc = 1 or file_srt = 1 or file_text = 1 or file_tsv = 1 or file_processed_tsv = 1 or file_txt = 1 or file_vtt = 1 or file_TextGrid = 1
		go = 0
	endif

	if (use_existing_.json_file = 1) and (existing_json = 0)
		beginPause: "Warning"
			comment: "No existing .json file found in the output folder."
			comment: "Reverting to run Whisper"
		clicked = endPause: "OK", 1
		use_existing_.json_file = 0
	endif

	if go = 0
		beginPause: "Warning"
			comment: "The following files in the output folder will be deleted or overwritten:"
			comment: existing_output_files$
		clicked = endPause: "Choose new output folder", "OK", 2
		if clicked = 1
			beginPause: "Change the name of the output folder"
				sentence: "New output folder", output_folder_name$
			clicked = endPause: "Continue", 1
			if right$ (new_output_folder$, 1) <> "/"
				new_output_folder$ = new_output_folder$ + "/"
			endif
			output_folder_with_path$ = output_folder_path$ + new_output_folder$
			output_folder_name$ = new_output_folder$
			appendInfoLine: output_folder_with_path$
		elsif clicked = 2
			go = 1
		endif
	endif	
until go = 1

###   ___________________________________________________________________________________
###
###	Save parameters to settings file
###   ___________________________________________________________________________________
###

### save variables to settings Table
selectObject: "Table Run_whisper_settings_" + version_object_name$

Set numeric value: 1, "show_startup_message", show_startup_message
Set string value: 1, "output_folder_name", output_folder_name$
Set numeric value: 1, "language", language
Set string value: 1, "other_language", other_language$
Set numeric value: 1, "model", model
Set numeric value: 1, "attempt_to_use_GPU", attempt_to_use_GPU
Set numeric value: 1, "processing_method", processing_method
Set numeric value: 1, "use_existing_.json_file", use_existing_.json_file
Set numeric value: 1, "json", json
Set numeric value: 1, "lrc", lrc
Set numeric value: 1, "srt", srt
Set numeric value: 1, "text", text
Set numeric value: 1, "tsv", tsv
Set numeric value: 1, "txt", txt
Set numeric value: 1, "vtt", vtt
Set numeric value: 1, "processed_tsv", processed_tsv
Set numeric value: 1, "TextGrid_utterances", textGrid_utterances
Set numeric value: 1, "TextGrid_words", textGrid_words
Set numeric value: 1, "TextGrid_probabilities", textGrid_probabilities
Set numeric value: 1, "suppress_punctuation_and_utterance_initial_uppercase", suppress_punctuation_and_utterance_initial_uppercase
Set numeric value: 1, "reanalyze_utterance_boundaries", reanalyze_utterance_boundaries
Set numeric value: 1, "keep_TextGrid_and_LongSound_in_Objects_window", keep_TextGrid_and_LongSound_in_Objects_window
Set numeric value: 1, "beep_when_finished", beep_when_finished
Set numeric value: 1, "debug_mode", debug_mode
Set numeric value: 1, "advanced_mode", advanced_mode

### save settings Table to settings file in defaultDirectory$
Save as tab-separated file: defaultDirectory$ + "/Run_whisper_settings_" + version$ + ".Table"
Remove

createDirectory: output_folder_with_path$


###   ___________________________________________________________________________________
###
###	Preprocessing of audio and setting up TextGrids
###   ___________________________________________________________________________________
###

Open long sound file: media_file_with_path$
if processing_method > 1	
	Extract part: 0, 1, "no"
	number_of_channels = Get number of channels
	Remove
	if number_of_channels = 2
		Read separate channels from sound file: media_file_with_path$
		for channel from 1 to number_of_channels
			naked_file_name$ [channel] = naked_file_name$ + "_ch" + string$(channel)
			selectObject: "Sound " + naked_file_name$ [channel]
			Filter (pass Hann band): 150, 4500, 100
			To Intensity: 100, 0.002, "no"
			Rename: naked_file_name$ [channel]

			if processing_method = 3
				#### Not implemented yet
			endif

			# select and remove sound _ch + sound _ch_band
			selectObject: "Sound " + naked_file_name$ [channel]
			Remove
			selectObject: "Sound " + naked_file_name$ [channel] + "_band"
			Remove
		endfor
	else
		beginPause: "Warning"
			comment: "Dual channel processing is only possible for two channel audio files"
			comment: "Reverting to single channel processing"
		clicked = endPause: "OK", 1
		processing_method = 1
	endif

	if processing_method = 3
		#### Not implemented yet
	endif
endif

if processing_method = 1
	number_of_channels = 1
	number_of_passes = 1
	naked_file_name$ [1] = naked_file_name$
elsif processing_method = 2
	number_of_channels = 2
	number_of_passes = 1
elsif processing_method = 3
	number_of_channels = 2
	number_of_passes = 2
	#### Run whisper on two separate channnels and combine the output afterwards <<<<
endif


###   ___________________________________________________________________________________
###
###	Call Whisper-faster
###   ___________________________________________________________________________________
###

if use_existing_.json_file = 0

	if language$ = "Other"
		language$ = other_language$
		appendInfoLine: language$
	endif

	if beep_when_finished = 1
		beep_off$ = ""
	else
		beep_off$ = " --beep_off"
	endif
	
	if attempt_to_use_GPU = 1
		force_CPU$ = ""
	else
		force_CPU$ = " --device CPU"
	endif
	
	appendInfoLine: "Starting whisper-faster in a separate terminal window..." + newline$


	### Windows specific code ###############################################################

	if system$ = "Windows"
		if fileReadable: "whisper-faster.exe"

			if debug_mode = 0
				close_or_not$ = "/C"
			else
				close_or_not$ = "/K"
			endif
		
			if language$ = "Auto"
				runSystem: "START ""WhisperFaster"" /D " + defaultDirectory$ + " /W CMD " + close_or_not$ + " ""whisper-faster.exe"" --model " + model$ + force_CPU$ + " --output_dir " + output_folder_with_path$ + " --output_format all " + media_file_with_path$ + beep_off$
			else
				runSystem: "START ""WhisperFaster"" /D " + defaultDirectory$ + " /W CMD " + close_or_not$ + " ""whisper-faster.exe"" --model " + model$ + force_CPU$ + " --language " + language$ + " --output_dir " + output_folder_with_path$ + " --output_format all " + media_file_with_path$ + beep_off$
			endif
		else
			exitScript: "The whisper executable ""whisper-faster.exe"" was not found in " + defaultDirectory$
		endif
	endif

	### End of Windows specific code ########################################################


	### macOS specific code #################################################################

	if system$ = "macOS"
		if fileReadable: "whisper-faster"

			#looking for finished.flag
			if fileReadable: defaultDirectory$ + "/finished.flag"
				appendInfoLine: "Found finished.flag"
				deleteFile: defaultDirectory$ + "/finished.flag"
			endif
	
			if language$ = "Auto"
				runSystem: "osascript -e 'tell app ""Terminal"" to do script ""cd " + defaultDirectory$ + " && " + defaultDirectory$ + "/whisper-faster --model " + model$ + force_CPU$ + " --output_dir " + output_folder_with_path$ + " --output_format all " + media_file_with_path$ + beep_off$ + " && touch finished.flag""'"
			else
				runSystem: "osascript -e 'tell app ""Terminal"" to do script ""cd " + defaultDirectory$ + " && " + defaultDirectory$ + "/whisper-faster --model " + model$ + force_CPU$ + " --language " + language$ + " --output_dir " + output_folder_with_path$ + " --output_format all " + media_file_with_path$ + beep_off$ + " && touch finished.flag""'"
			endif
		
			# Wait in loop until finished.flag appears to signal that the whisper process has finished
			finished = 0
			repeat
				if debug_mode = 1
					pauseScript: "Press continue when Whisper-faster has finished"
				endif
				finished = fileReadable: defaultDirectory$ + "/finished.flag"
				sleep: 1
			until finished = 1
		else
			exitScript: "The whisper executable ""whisper-faster"" was not found in " + defaultDirectory$
		endif
	endif
	
	### End of macOS specific code ##########################################################
else
	appendInfoLine: "Using existing .json file..." + newline$
endif


###   ___________________________________________________________________________________
###
###	Read .json file, 
###	Store sentence intervals in Table_of_utterances
###	Store word intervals in Table_of_words
###   ___________________________________________________________________________________
###

if processing_method = 3
	#### read two json files
	#### when we get to processing ch1 and ch2 separately then this means naked filename must include the channel designation
else
	@read_json_file_and_parse_to_tables: path$, naked_file_name$, output_folder_with_path$, use_existing_.json_file
endif


###   ___________________________________________________________________________________
###
###	Process content from .json file:
###	
###	Combine word intervals from table of word intervals to new utterances using selected criteria
###	
###	Step 1: detect boundaries
###	•	Find first word
###	•	Punctuation
###	•	Empty word intervals -Not currently in table of words. Fix?				####
###	•	Gaps in time between intervals (= original utterance boundries? I think not) 		####
###	•	Channel balance at word level < only makes sense for pocessing_method = 2 = one pass
###	•	Find last word
###
###	Step 2: form new utterances, start time, end time
###
###	Step 3: Probe channel balance for table of utterances and table of new utterances
###
###	Step 4: Remove punctuation and upper case letters from utterances, words and new utterances
###   ___________________________________________________________________________________
###

### Step 1

@set_utterance_boundry_at_first_word: "Table_of_words_" + naked_file_name$
@detect_utterance_boundries_by_punctuation: "Table_of_words_" + naked_file_name$
####@detect_utterance_boundries_by_empty_intevals: "Table_of_words_" + naked_file_name$
@detect_utterance_boundries_by_time_gaps_between_intervals: "Table_of_words_" + naked_file_name$
if processing_method = 2
	### consider if this has any utility with processing_method = 3
	@probe_channel_balance: "Table_of_words_" + naked_file_name$, naked_file_name$ [1], naked_file_name$ [2]
	@detect_utterance_boundries_by_channel_balance: "Table_of_words_" + naked_file_name$
elsif processing_method = 1
	## This is only needed until probe_channel_balance is updated to handle arbitrary number of channels
	@set_fixed_channel_balance: "Table_of_words_" + naked_file_name$
endif
@set_utterance_boundry_at_last_word: "Table_of_words_" + naked_file_name$

### Step 2

@create_new_utterances_from_Table_of_words: "Table_of_words_" + naked_file_name$, "Table_of_new_utterances_" + naked_file_name$

### Step 3
if processing_method = 2
	@probe_channel_balance: "Table_of_utterances_" + naked_file_name$, naked_file_name$ [1], naked_file_name$ [2]
	@probe_channel_balance: "Table_of_new_utterances_" + naked_file_name$, naked_file_name$ [1], naked_file_name$ [2]
elsif processing_method = 1
	## This is only needed until probe_channel_balance is updated to handle arbitrary number of channels
	@set_fixed_channel_balance: "Table_of_utterances_" + naked_file_name$
	@set_fixed_channel_balance: "Table_of_new_utterances_" + naked_file_name$
endif

### Step 4

if suppress_punctuation_and_utterance_initial_uppercase = 1
	@remove_punctuation_and_change_initial_upper_case: "Table_of_utterances_" + naked_file_name$, "text"
	@remove_punctuation_and_change_initial_upper_case: "Table_of_words_" + naked_file_name$, "word"
	@remove_punctuation_and_change_initial_upper_case: "Table_of_new_utterances_" + naked_file_name$, "text"
endif


###   ___________________________________________________________________________________
###
###	Write content of tables to TextGrid
###   ___________________________________________________________________________________
###

###	Create TextGrid and write data to TextGrid if selected by user

selectObject: "LongSound " + naked_file_name$
if textGrid_utterances = 1 or textGrid_words = 1
	To TextGrid: "Dummy", ""
	
	current_channel = number_of_channels
	while current_channel > 0
		if textGrid_words = 1 and textGrid_probabilities = 1
			selectObject: "TextGrid " + naked_file_name$
			if number_of_channels > 1
				Insert interval tier: 1, "CH" + string$(current_channel) + "-Word probability"
			else
				Insert interval tier: 1, "Word probability"
			endif
			@move_data_from_table_to_TextGrid_tiers: "Table_of_words_" + naked_file_name$, "probability", current_channel , naked_file_name$, 1
		endif

		if textGrid_words = 1
			selectObject: "TextGrid " + naked_file_name$
			if number_of_channels > 1
				Insert interval tier: 1, "CH" + string$(current_channel) + "-Word"
			else
				Insert interval tier: 1, "Word"
			endif
			@move_data_from_table_to_TextGrid_tiers: "Table_of_words_" + naked_file_name$, "word", current_channel, naked_file_name$, 1
		endif

		textGrid_new_utterances = reanalyze_utterance_boundaries
		#### currently bound together

		textGrid_average_probability = 0

		if textGrid_new_utterances = 1 and textGrid_average_probability = 1
			selectObject: "TextGrid " + naked_file_name$
			if number_of_channels > 1
				Insert interval tier: 1, "CH" + string$(current_channel) + "-New utterances avr probability"
			else
				Insert interval tier: 1, "New utterances avr probability"
			endif
			@move_data_from_table_to_TextGrid_tiers: "Table_of_new_utterances_" + naked_file_name$, "probability", current_channel, naked_file_name$, 1
		endif
			
		if textGrid_new_utterances = 1
			selectObject: "TextGrid " + naked_file_name$
			if number_of_channels > 1
				Insert interval tier: 1, "CH" + string$(current_channel) + "-New utterances"
			else
				Insert interval tier: 1, "New utterances"
			endif
			@move_data_from_table_to_TextGrid_tiers: "Table_of_new_utterances_" + naked_file_name$, "text", current_channel, naked_file_name$, 1
		endif

		if textGrid_utterances = 1 and textGrid_probabilities = 1
			selectObject: "TextGrid " + naked_file_name$
			if number_of_channels > 1
				Insert interval tier: 1, "CH" + string$(current_channel) + "-Whisper utterances probability"
			else
				Insert interval tier: 1, "Whisper utterances probability"
			endif
			@move_data_from_table_to_TextGrid_tiers: "Table_of_utterances_" + naked_file_name$, "probability", current_channel , naked_file_name$, 1
		endif

		if textGrid_utterances = 1
			selectObject: "TextGrid " + naked_file_name$
			if number_of_channels > 1
				Insert interval tier: 1, "CH" + string$(current_channel) + "-Whisper utterances"
			else
				Insert interval tier: 1, "Whisper utterances"
			endif
			@move_data_from_table_to_TextGrid_tiers: "Table_of_utterances_" + naked_file_name$, "text", current_channel, naked_file_name$, 1
		endif

		current_channel = current_channel - 1
		endwhile

	selectObject: "TextGrid " + naked_file_name$
	last_tier = Get number of tiers
	Remove tier: last_tier

	Save as text file: output_folder_with_path$ + naked_file_name$ + ".TextGrid"
endif

###   ___________________________________________________________________________________
###
###	sort Table_of_utterances and save as .processed.tsv
###   ___________________________________________________________________________________
###

if processed_tsv = 1
	if reanalyze_utterance_boundaries = 1
		selectObject: "Table Table_of_new_utterances_" + naked_file_name$
	else
		selectObject: "Table Table_of_utterances_" + naked_file_name$
	endif
	Copy: "Copy_of_table"
	# Change channel number to letter followed by ":"
	rows_in_table = Get number of rows
	for row from 1 to rows_in_table	
		channel$ = Get value: row, "channel"
		channel$ = replace$ (channel$, "20", "T:", 1)
		channel$ = replace$ (channel$, "19", "S:", 1)
		channel$ = replace$ (channel$, "18", "R:", 1)
		channel$ = replace$ (channel$, "17", "Q:", 1)
		channel$ = replace$ (channel$, "16", "P:", 1)
		channel$ = replace$ (channel$, "15", "O:", 1)
		channel$ = replace$ (channel$, "14", "N:", 1)
		channel$ = replace$ (channel$, "13", "M:", 1)
		channel$ = replace$ (channel$, "12", "L:", 1)
		channel$ = replace$ (channel$, "11", "K:", 1)
		channel$ = replace$ (channel$, "10", "J:", 1)
		channel$ = replace$ (channel$, "9", "I:", 1)
		channel$ = replace$ (channel$, "8", "H:", 1)
		channel$ = replace$ (channel$, "7", "G:", 1)
		channel$ = replace$ (channel$, "6", "F:", 1)
		channel$ = replace$ (channel$, "5", "E:", 1)
		channel$ = replace$ (channel$, "4", "D:", 1)
		channel$ = replace$ (channel$, "3", "C:", 1)
		channel$ = replace$ (channel$, "2", "B:", 1)
		channel$ = replace$ (channel$, "1", "A:", 1)
		Set string value: row, "channel", channel$
	endfor
	Remove column: "probability"
	Sort rows: { "start" }
	Save as tab-separated file: output_folder_with_path$ + naked_file_name$ + ".processed.tsv"
	Remove
endif


###   ___________________________________________________________________________________
###
###	Cleanup
###   ___________________________________________________________________________________
###

### Delete unwanted output files from whisper-faster
if json = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".json"
endif
if lrc = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".lrc"
endif
if srt = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".srt"
endif
if text = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".text"
endif
if tsv = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".tsv"
endif
if txt = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".txt"
endif
if vtt = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".vtt"
endif

if processed_tsv = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".processed.tsv"
endif

if textGrid = 0
	deleteFile: output_folder_with_path$ + naked_file_name$ + ".TextGrid"
endif

if keep_TextGrid_and_LongSound_in_Objects_window = 0
	if textGrid = 1
		selectObject: "TextGrid " + naked_file_name$
		Remove
	endif
	selectObject: "LongSound " + naked_file_name$
	Remove
endif

selectObject: "Strings " + naked_file_name$
plusObject: "Table Table_of_utterances_" + naked_file_name$
plusObject: "Table Table_of_words_" + naked_file_name$
plusObject: "Table Table_of_new_utterances_" + naked_file_name$
Remove

if processing_method > 1
	selectObject: "Intensity " + naked_file_name$ [1]
	Remove
	selectObject: "Intensity " + naked_file_name$ [2]
	Remove
endif

appendInfoLine: ""
appendInfoLine: "Processing done"


###   ___________________________________________________________________________________
###
###	Pocedures...
###   ___________________________________________________________________________________
###


###   ___________________________________________________________________________________
###
###	Procedure searches for the next string containing .match$
###	Return values 
###		.found
###			.found = -1 means end of strings was reached without match
### 			.found > 0 indicates position of first character in case of match
###		.string_number
###			last examined string
###			Use it to locate match when .found > 0
###   ___________________________________________________________________________________
###

procedure findNextString: .name_of_strings_object$, .start, .match$

	selectObject: "Strings " + .name_of_strings_object$
	.number_of_strings = Get number of strings
	.string_number = .start
	.found = 0
	.found_string_number = 0

	repeat	
		.string$ = Get string: .string_number
		.found = index(.string$, .match$)
		if .found > 0
			.found_string_number = .string_number
		endif
		.string_number = .string_number + 1
		if .string_number > .number_of_strings
			.found = -1
		endif
	until .found <> 0
endproc


###   ___________________________________________________________________________________
###
###	Procedure parses string of the format "variable": " abc def",
###   ___________________________________________________________________________________
###

procedure read_text: .string$

	.marker = index(.string$, ": ")
	.length = length(.string$)
	.text$ = mid$(.string$, .marker + 4, .length - .marker - 5)
endproc


###   ___________________________________________________________________________________
###
###	Procedure create new table and set default values - uses global variable space
###   ___________________________________________________________________________________
###

procedure create_new_table_and_set_default_values
	Create Table with column names: "Run_whisper_settings_" + version_object_name$, 1, "show_startup_message output_folder_name language other_language model attempt_to_use_GPU processing_method use_existing_.json_file json lrc srt text tsv txt vtt processed_tsv TextGrid_utterances TextGrid_words TextGrid_probabilities suppress_punctuation_and_utterance_initial_uppercase reanalyze_utterance_boundaries keep_TextGrid_and_LongSound_in_Objects_window beep_when_finished debug_mode advanced_mode"
	Set string value: 1, "show_startup_message", "1"
	Set string value: 1, "output_folder_name", "whisper-output/"
	Set string value: 1, "language", "1"
	Set string value: 1, "other_language", "Yoruba"
	Set string value: 1, "model", "2"
	Set string value: 1, "attempt_to_use_GPU", "1"
	Set string value: 1, "processing_method", "1"
	Set string value: 1, "use_existing_.json_file", "0"
	Set string value: 1, "json", "0"
	Set string value: 1, "lrc", "0"
	Set string value: 1, "srt", "1"
	Set string value: 1, "text", "1"
	Set string value: 1, "tsv", "0"
	Set string value: 1, "txt", "0"
	Set string value: 1, "vtt", "0"
	Set string value: 1, "processed_tsv", "0"
	Set string value: 1, "TextGrid_utterances", "1"
	Set string value: 1, "TextGrid_words", "1"
	Set string value: 1, "TextGrid_probabilities", "0"
	Set string value: 1, "suppress_punctuation_and_utterance_initial_uppercase", "1"
	Set string value: 1, "reanalyze_utterance_boundaries", "1"
	Set string value: 1, "keep_TextGrid_and_LongSound_in_Objects_window", "1"
	Set string value: 1, "beep_when_finished", "1"
	Set string value: 1, "debug_mode", "0"
	Set string value: 1, "advanced_mode", "0"
endproc


###   ___________________________________________________________________________________
###
###	Procedure read settings into variables - uses global variable space
###   ___________________________________________________________________________________
###

procedure read_settings_into_variables
	show_startup_message$ =  Get value: 1, "show_startup_message"
	show_startup_message = number (show_startup_message$)
	output_folder_name$ = Get value: 1, "output_folder_name"
	language$ = Get value: 1, "language"
	language = number (language$)
	other_language$ = Get value: 1, "other_language"
	model$ = Get value: 1, "model"
	model = number (model$)
	attempt_to_use_GPU$ = Get value: 1, "attempt_to_use_GPU"
	attempt_to_use_GPU = number (attempt_to_use_GPU$)
	processing_method$ = Get value: 1, "processing_method"
	processing_method = number (processing_method$)
	use_existing_.json_file$ = Get value: 1, "use_existing_.json_file"
	use_existing_.json_file = number (use_existing_.json_file$)
	json$ = Get value: 1, "json"
	json = number (json$)
	lrc$ = Get value: 1, "lrc"
	lrc = number (lrc$)
	srt$ = Get value: 1, "srt"
	srt = number (srt$)
	text$ = Get value: 1, "text"
	text = number (text$)
	tsv$ = Get value: 1, "tsv"
	tsv = number (tsv$)
	txt$ = Get value: 1, "txt"
	txt = number (txt$)
	vtt$ = Get value: 1, "vtt"
	vtt = number (vtt$)
	processed_tsv$ = Get value: 1, "processed_tsv"
	processed_tsv = number (processed_tsv$)
	textGrid_utterances$ = Get value: 1, "TextGrid_utterances"
	textGrid_utterances = number (textGrid_utterances$)
	textGrid_words$ = Get value: 1, "TextGrid_words"
	textGrid_words = number (textGrid_words$)
	textGrid_probabilities$ = Get value: 1, "TextGrid_probabilities"
	textGrid_probabilities = number (textGrid_probabilities$)
	probabilities = textGrid_probabilities
	suppress_punctuation_and_utterance_initial_uppercase$ = Get value: 1, "suppress_punctuation_and_utterance_initial_uppercase"
	suppress_punctuation_and_utterance_initial_uppercase = number (suppress_punctuation_and_utterance_initial_uppercase$)
	reanalyze_utterance_boundaries$ = Get value: 1, "reanalyze_utterance_boundaries"
	reanalyze_utterance_boundaries = number (reanalyze_utterance_boundaries$)
	keep_TextGrid_and_LongSound_in_Objects_window$ = Get value: 1, "keep_TextGrid_and_LongSound_in_Objects_window"
	keep_TextGrid_and_LongSound_in_Objects_window = number (keep_TextGrid_and_LongSound_in_Objects_window$)
	beep_when_finished$ = Get value: 1, "beep_when_finished"
	beep_when_finished = number (beep_when_finished$)
	debug_mode$ = Get value: 1, "debug_mode"
	debug_mode = number (debug_mode$)
	advanced_mode$ = Get value: 1, "advanced_mode"
	advanced_mode = number (advanced_mode$)
endproc



###   ___________________________________________________________________________________
###
###	Procedure seconds_to_hh:mm:ss.sss
###   ___________________________________________________________________________________
###

procedure seconds_to_hms: .time_in_seconds
	.hours = .time_in_seconds / 3600
	.hours = floor (.hours)
	.remaining_seconds = .time_in_seconds - (.hours * 3600)
	.minutes = .remaining_seconds / 60
	.minutes = floor (.minutes)
	.seconds = .remaining_seconds - (.minutes * 60)

	.hours$ = string$(.hours)
	.minutes$ = string$(.minutes)
	if .minutes < 10
		.minutes$ = "0" + .minutes$
	endif
	.seconds$ = fixed$(.remaining_seconds, 3)
	if .seconds < 10
		.seconds$ = "0" + .seconds$
	endif

	.time_in_hms$ = .hours$ + ":" + .minutes$ + ":" + .seconds$
	#appendInfoLine: .time_in_hms$
endproc

###   ___________________________________________________________________________________
###
###	Procedure
###	Read .json file, 
###	Store sentence intervals in Table_of_utterances
###	Store word intervals in Table_of_words
###   ___________________________________________________________________________________
###

procedure read_json_file_and_parse_to_tables: .path$, .naked_file_name$, .output_folder_with_path$, .use_existing_.json_file

	if .use_existing_.json_file = 1
		if fileReadable: .path$ + .naked_file_name$ + ".json"
			Read Strings from raw text file: .path$ + .naked_file_name$ + ".json"
			appendInfoLine: "Reading " + .path$ + .naked_file_name$ + ".json" + newline$
		elsif fileReadable: .output_folder_with_path$ + .naked_file_name$ + ".json"
			Read Strings from raw text file: .output_folder_with_path$ + .naked_file_name$ + ".json"
			appendInfoLine: "Reading " + .output_folder_with_path$ + .naked_file_name$ + ".json"
		endif
	else
		Read Strings from raw text file: .output_folder_with_path$ + .naked_file_name$ + ".json"
		appendInfoLine: "Reading " + .output_folder_with_path$ + .naked_file_name$ + ".json"
	endif

	selectObject: "Strings " + .naked_file_name$

	.number_of_strings = Get number of strings
	.string_number = 1
	.sentence_number = 1

	#Create Table with column names: "Table_of_utterances", 0, { "start", "end", "channel_name", "text" }
	Create Table with column names: "Table_of_utterances_" + .naked_file_name$, 0, { "start", "end", "channel", "probability", "text"}
	Create Table with column names: "Table_of_words_" + .naked_file_name$, 0, { "start", "end", "probability", "word", "channel", "beginning", "ending"}
	Create Table with column names: "Table_of_new_utterances_" + .naked_file_name$, 0, { "start", "end", "channel", "probability", "text"}

	repeat
		### find next instance of "id":
		### i.e. find next utterance
		@findNextString: .naked_file_name$, .string_number, """id"":"
		if findNextString.found > 0
			.string_number = findNextString.found_string_number
			.sentence_number$ = Get string: .string_number
			.sentence_number = extractNumber: .sentence_number$, """id"":"

			#### write error message if it does not match expected number

			.start_time$ = Get string: .string_number + 2
			.start_time = extractNumber: .start_time$, """start"":"

			.end_time$ = Get string: .string_number + 3
			.end_time = extractNumber: .end_time$, """end"":"

			.text$ = Get string: .string_number + 4
			@read_text: .text$
			.text$ = read_text.text$

			### find next instance of "avg_logprob":
			@findNextString: .naked_file_name$, .string_number, """avg_logprob"":"
			.string_number = findNextString.found_string_number
			.avg_logprob$ = Get string: .string_number
			.avg_logprob = extractNumber: .avg_logprob$, """avg_logprob"":"

			### add utterance to Table of utterances
			selectObject: "Table Table_of_utterances_" + .naked_file_name$
			Insert row: 1

			Set string value: 1, "start", string$(.start_time)
			Set string value: 1, "end", string$(.end_time)
			Set string value: 1, "text", .text$
			Set string value: 1, "probability", string$(.avg_logprob)

			### find next instance of "words":
			@findNextString: .naked_file_name$, .string_number, """words"":"
			.string_number = findNextString.found_string_number

			.word_counter = 0
			repeat
				.word_counter = .word_counter + 1
				@findNextString: .naked_file_name$, .string_number, """start"":"
				.string_number = findNextString.found_string_number

				### read word_start_time
				.word_start_time$ = Get string: .string_number
				.word_start_time = extractNumber: .word_start_time$, """start"":"

				### read word_end_time
				.word_end_time$ = Get string: .string_number + 1 
				.word_end_time = extractNumber: .word_end_time$, """end"":"

				### read word$
				.word$ = Get string: .string_number + 2
				@read_text: .word$
				.word$ = read_text.text$

				### read word_probability
				.word_probability$ = Get string: .string_number + 3
				.word_probability = extractNumber: .word_probability$, """probability"":"

				### add word to Table of words
				selectObject: "Table Table_of_words_" + .naked_file_name$
				Insert row: 1

				Set string value: 1, "start", string$(.word_start_time)
				Set string value: 1, "end", string$(.word_end_time)
				Set string value: 1, "word", .word$
				Set string value: 1, "probability", string$(.word_probability)

				selectObject: "Strings " + .naked_file_name$

				### read word_final_bracket$
				.word_final_bracket$ = Get string: .string_number + 4
				.word_final_bracket$ = replace_regex$(.word_final_bracket$, "\s+", "", 1)

				.string_number = .string_number + 4

			# "}" as opposed to "}," signals last word in id-segment
			until .word_final_bracket$ = "}"

			### read id-segment_final_bracket$
			.id_segment_final_bracket$ = Get string: .string_number + 2
			.id_segment_final_bracket$ = replace_regex$(.id_segment_final_bracket$, "\s+", "", 1)
		endif

	# "}" as opposed to "}," signals last id-segment
	until ((.id_segment_final_bracket$ = "}") or (.string_number > .number_of_strings))

	#### sort Table_of_utterances - Sorting causes problems with words that have 0 duration; using reflect rows

	selectObject: "Table Table_of_utterances_" + .naked_file_name$
	# Sort the table
	##Sort rows: { "start" }
	Reflect rows

	selectObject: "Table Table_of_words_" + .naked_file_name$
	# Sort the table
	##Sort rows: { "start" }
	Reflect rows

	#Remove ??

endproc


###   ___________________________________________________________________________________
###
###	Procedure set_utterance_boundry_at_first_word
###   ___________________________________________________________________________________
###

procedure set_utterance_boundry_at_first_word: .table_name$

	selectObject: "Table " + .table_name$
	.first_word_found = 0
	.rows_in_table = Get number of rows
	for .row from 1 to .rows_in_table
		.word$ = Get value: .row, "word"
		if ((.word$ <> "") and (.first_word_found = 0))
			Set numeric value: .row, "beginning", 1
			.first_word_found = 1
		endif
	endfor

endproc


###   ___________________________________________________________________________________
###
###	Procedure detect_utterance_boundries_by_punctuation
###   ___________________________________________________________________________________
###

procedure detect_utterance_boundries_by_punctuation: .table_name$

	selectObject: "Table " + .table_name$

	# loop thorough all rows
	# look for puunctuation signs and mark as 'ending' if found
	.rows_in_table = Get number of rows
	for .row from 1 to .rows_in_table
		.word$ = Get value: .row, "word"
		if index_regex(.word$, "[.:!?]")
			Set numeric value: .row, "ending", 1
			if .row + 1 < .rows_in_table
				Set numeric value: .row+1, "beginning", 1
			endif
		endif
	endfor
endproc


###   ___________________________________________________________________________________
###
###	Procedure detect_utterance_boundries_by_time_gaps_between_intervals
###   ___________________________________________________________________________________
###

procedure detect_utterance_boundries_by_time_gaps_between_intervals: .table_name$

	selectObject: "Table " + .table_name$

	# loop thorough all rows
	# look for mismatch between ending time and starting time of next interval
	# mark current row as 'endning' and next row as 'beginning'
	# unless current row is final row
 
	.rows_in_table = Get number of rows
	for .row from 1 to .rows_in_table
		.start = Get value: .row, "start"
		.end = Get value: .row, "end"
		if .row < .rows_in_table
			.next_start = Get value: .row + 1, "start"
			if .end < .next_start
				Set numeric value: .row, "ending", 1
				Set numeric value: .row + 1, "beginning", 1
			endif
		endif
	endfor
endproc


###   ___________________________________________________________________________________
###
###	Procedure probe_channel_balance
###   ___________________________________________________________________________________
###

procedure probe_channel_balance: .table_name$, .channel_1$, .channel_2$
## currently only designed to work with 2 channel audio

	selectObject: "Table " + .table_name$

	# loop thorough all rows
	# compare intensity between channels and mark loudest channel
 
	.rows_in_table = Get number of rows
	for .row from 1 to .rows_in_table
		.start = Get value: .row, "start"
		.end = Get value: .row, "end"

		# get intensity from ch_1
		selectObject: "Intensity " + .channel_1$
		.channel_1_intensity = Get quantile: .start, .end, 0.5

		# get intensity from ch_2
		selectObject: "Intensity " + .channel_2$
		.channel_2_intensity = Get quantile:  .start, .end, 0.5

		selectObject: "Table " + .table_name$
		# which is stronger
		if .channel_1_intensity > .channel_2_intensity
			Set numeric value: .row, "channel", 1
		else
			Set numeric value: .row, "channel", 2
		endif
	endfor
endproc



###   ___________________________________________________________________________________
###
###	Procedure set_fixed_channel_balance
###   ___________________________________________________________________________________
###

procedure set_fixed_channel_balance: .table_name$
## Hack to handle one channel files until Procedure probe_channel_balance is updated to handle arbitrary number of channels

	selectObject: "Table " + .table_name$

	# loop thorough all rows
	# set channel to 1
 
	.rows_in_table = Get number of rows
	for .row from 1 to .rows_in_table
		Set numeric value: .row, "channel", 1
		endif
	endfor
endproc




###   ___________________________________________________________________________________
###
###	Procedure detect_utterance_boundries_by_channel_balance
###   ___________________________________________________________________________________
###

procedure detect_utterance_boundries_by_channel_balance: .table_name$
## currently only designed to work with 2 channel audio

	selectObject: "Table " + .table_name$

	# loop thorough all rows
	# look for changes in channel balance. When changes occur
	# mark current row as 'endning' and next row as 'beginning'
	# unless current row is final row
 
	.rows_in_table = Get number of rows
	for .row from 1 to .rows_in_table
		.loudest_channel = Get value: .row, "channel"

		if .row < .rows_in_table
			.next_row_loudest_channel = Get value: .row + 1, "channel"
			if .loudest_channel <> .next_row_loudest_channel
				Set numeric value: .row, "ending", 1
				Set numeric value: .row + 1, "beginning", 1
			endif
		endif
	endfor
endproc



###   ___________________________________________________________________________________
###
###	Procedure set_utterance_boundry_at_last_word
###   ___________________________________________________________________________________
###

procedure set_utterance_boundry_at_last_word: .table_name$

	selectObject: "Table " + .table_name$
	.last_word_found = 0
	.rows_in_table = Get number of rows

	.row = .rows_in_table 
	while ((.row > 0) and (.last_word_found = 0))
		.word$ = Get value: .row, "word"
		if ((.word$ <> "") and (.last_word_found = 0))
			Set numeric value: .row, "ending", 1
			.last_word_found = 1
		endif
		.row = .row - 1 
	endwhile
endproc


###   ___________________________________________________________________________________
###
###	Procedure create_new_utterances_from_Table_of_words
###   ___________________________________________________________________________________
###

procedure create_new_utterances_from_Table_of_words: .table_of_words$, .table_of_new_utterances$

	selectObject: "Table " + .table_of_words$

	# loop thorough all rows
	# look for words marked as beginning or ending an utterance
	.rows_in_table = Get number of rows

	.new_utterance$ = ""
	.new_utterance = 0
	for .row from 1 to .rows_in_table
		
		.word$ = Get value: .row, "word"
		.beginning = Get value: .row, "beginning"
		.ending = Get value: .row, "ending"

		if .beginning = 1
			.start_time = Get value: .row, "start"
			.new_utterance = 1
			selectObject: "Table " + .table_of_new_utterances$
			Insert row: 1
			Set numeric value: 1, "start", .start_time
			selectObject: "Table " + .table_of_words$
			.new_utterance$ = .word$
		elsif .beginning <> 1
			if .new_utterance = 1
				.new_utterance$ = .new_utterance$ + " " + .word$
			endif
		endif
		if .ending = 1
			.end_time = Get value: .row, "end"
			selectObject: "Table " + .table_of_new_utterances$
			Set numeric value: 1, "end", .end_time
			Set string value: 1, "text", .new_utterance$
			selectObject: "Table " + .table_of_words$
			.new_utterance = 0
		endif
	endfor
	selectObject: "Table " + .table_of_new_utterances$
	Reflect rows
endproc


###   ___________________________________________________________________________________
###
###	Procedure remove_punctuation_and_change_initial_upper_case
###   ___________________________________________________________________________________
###

procedure remove_punctuation_and_change_initial_upper_case: .name_of_table$, .column_name$

	selectObject: "Table " + .name_of_table$

	# loop thorough all rows
	.rows_in_table = Get number of rows

	for .row from 1 to .rows_in_table
		.text$ = Get value: .row, .column_name$

		# Change initial letter in first word to lower case, unless pocessing single words that are not utterance initial
		if .column_name$ = "text"
			.text$ = replace_regex$ (.text$, "^.", "\l&", 1)
		elsif .column_name$ = "word"
			.beginning = Get value: .row, "beginning"
			if .beginning = 1
				.text$ = replace_regex$ (.text$, "^.", "\l&", 1)
			endif
		endif

		# Remove punctuation etc
		.text$ = replace_regex$ (.text$, "[\[\](){}.,:;!?+-]", "", 0)
		Set string value: .row, .column_name$, .text$
	endfor
endproc


###   ___________________________________________________________________________________
###
###	Procedure move_data_from_table_to_TextGrid_tiers
###   ___________________________________________________________________________________
###


procedure move_data_from_table_to_TextGrid_tiers: .name_of_table$, .column_name$, .channel_filter, .name_of_TextGrid$, .tier_number

	selectObject: "Table " + .name_of_table$

	# loop thorough all rows
	.rows_in_table = Get number of rows

	for .row from 1 to .rows_in_table
		selectObject: "Table " + .name_of_table$
		if .channel_filter > 0
			.channel = Get value: .row, "channel"
		else
			.channel = 0
		endif

		if .channel = .channel_filter
			.start_time = Get value: .row, "start"
			.end_time = Get value: .row, "end"
			.text$ = Get value: .row, .column_name$

			### add intervals and write text to TextGrid
			selectObject: "TextGrid " + .name_of_TextGrid$

			.check_boundary = Get interval boundary from time: .tier_number, .start_time
			if .check_boundary = 0 and .start_time > 0
				Insert boundary: .tier_number, .start_time
			endif

			.check_boundary = Get interval boundary from time: .tier_number, .end_time
			if .check_boundary = 0 and .end_time > 0
				# the second condition is just in the unlikely event that the first interval has duration 0
				Insert boundary: .tier_number, .end_time
				.interval = Get low interval at time: .tier_number, .end_time
				Set interval text: .tier_number, .interval, .text$
			else
				.interval = Get low interval at time: .tier_number, .end_time
				.existing_label$ = Get label of interval: .tier_number, .interval
				if .existing_label$ <> ""
					.text$ = .existing_label$ + " " + .text$
				endif
				Set interval text: .tier_number, .interval, .text$
			endif
		endif
	endfor
endproc


###   ___________________________________________________________________________________
###
###	Procedure scrap_code
###   ___________________________________________________________________________________
###

procedure scrap_code
	# NOP
endproc