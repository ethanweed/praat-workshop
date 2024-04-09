# These examples are taken from the excellent praatscriptingtutorial.com
# http://praatscriptingtutorial.com/popupWindows

clearinfo

# This is an example of a form
form This is on the top of the Window
	comment This is a form
	comment I am uneditable text used for messages to the user.
	real Real_number_form 5
	text Enter_text_form You can enter text here
endform

appendInfoLine: "Form values: ", real_number_form, " ", enter_text_form$


# This is an example of a pause
beginPause: "This is on the top of the Window"
	comment: "This is a beginPause window"
	comment: "I am uneditable text used for messages to the user."
	real: "Real number", 5
	text: "Enter Text", "You can enter text here"
clicked = endPause: "First button", "Second button", 2


appendInfoLine: "Begin pause values: ", real_number, " ", enter_Text$
appendInfoLine: clicked, " was clicked"