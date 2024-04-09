# for loops


# for X from Y to Z
#	do something
# endfor


#############

clearinfo


for number from 1 to 3
	appendInfoLine: number
endfor



##############


max_number = 15

for number from 1 to 3
	appendInfoLine: number
endfor



##############

puppies = 15

for number from 1 to 3
	appendInfoLine: number
endfor


##############

clearinfo

puppies = 15

for number from 1 to puppies
	appendInfoLine: "There are ", number, " puppies"
endfor


##############

# for loops + conditionals
# if statements
# else statements

clearinfo
puppies = 15

for number from 1 to puppies
	if number == 1
		appendInfoLine: "There is ", number, " puppy"
	else
		appendInfoLine: "There are ", number, " puppies"
	endif
endfor

##############

# for loops + conditionals
# elif statements

clearinfo
puppies = 15

for number from 1 to puppies
	if number == 1
		appendInfoLine: "There is ", number, " puppy"
	elif number == 7
		appendInfoLine: "There are ", number, " puppies! That's my favourite number of puppies!"
	else
		appendInfoLine: "There are ", number, " puppies"
	endif
endfor

# Note! This is almost exactly the same as we would write in Python, R, or any number of other programming languages.
