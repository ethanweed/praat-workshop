clearinfo
appendInfoLine: "Hello World!"

#######################
# string variables

clearinfo
msg$ = "Hello World!"
appendInfoLine: msg$

#######################
# re-assigning string variables

clearinfo
msg$ = "Hello World!"
appendInfoLine: msg$
msg$ = "How are you?"
appendInfoLine: msg$

#######################
# numeric variables

totalHours = 5
lunch = 1
actualHours = totalHours-lunch
appendInfoLine: actualHours

#######################
# combining strings and numbers

totalHours = 5
lunch = 1
actualHours = totalHours-lunch
appendInfoLine: "Actual Hours of Praat workshop today:" + string$: actualHours


#######################
# Forms

clearinfo
form Chomsky age comparinator
	comment Compare your age to Noam Chomsky's age
	comment You can also enter a message for Noam
	real your_age 20
	text message_to_Noam You can enter text here
endform

noamsAge = 96
ageDiff = noamsAge - your_age
ageDiff$ = string$: ageDiff

appendInfoLine: "Chomsky is " + ageDiff$ + " years older than you."
appendInfoLine: "Hey Noam, " + message_to_Noam$

