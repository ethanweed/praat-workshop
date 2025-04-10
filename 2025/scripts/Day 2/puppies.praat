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