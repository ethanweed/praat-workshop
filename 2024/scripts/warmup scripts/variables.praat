# This is my very first Praat script!
# It teaches me about different kinds of variables

# make a string variable with a name. You can put on your own name, or whatever name you like.
name$ = "Ethan"

# make a integer variable with a number. In case you aren't the same age as me, you might need to adjust this number.
age = 50

# make a string variable with my cat's name. Or your cat's name. Or your dog. Or your goldfish. It's your script!
nameCat$ = "D2"

# make a string variable with the same value as the integer variable
age$ = string$: age

# print the output to the Praat Info window

clearinfo # does what it says on the tin

# make a string variable with the information we want to display in the info window
output$ = name$ + " is " + age$ + " years old."

# display the new variable in the info window
appendInfoLine: output$

# add additional, critical information.
output$ = name$ + " has a cat named " + nameCat$
appendInfoLine: output$

# do some important calculations
ageDiff$ = string$: age-7

# add the results of our calculations to the info window
appendInfoLine: name$ + " is " + ageDiff$ + " years older than " + nameCat$
