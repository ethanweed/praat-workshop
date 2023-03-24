---
customTheme : "ethan-slides"
---



# Automating Praat

---


# Programming

--

Make the computer do your work for you!

<img src="https://imgs.xkcd.com/comics/automation.png" width=""/>

--

## Basic Concepts

1. variables
1. loops
1. conditionals

--

## Basic strategy

1. Identify your goal
1. Break into small tasks
1. Prototype
1. Loop
1. Generalize

--

different language, same strategy

--

## Variables


<div id = "left">

``numeric variables``

age = 49  

yearsInDenmark = 25  

numKids = 4  

numCats = 1

</div>



<div id = "right">

``string variables``

name$ = "Ethan"  

nameCat$ = "D2"  

favDrink$ = "Espresso"  

favSnack$ = "PB & J"

</div>


--

## Loops


```praat
    n = some number

    for i to n  

        do something

    endfor
```

--

## Loops

```praat
clearinfo

days = 7

for day from 1 to days

	appendInfoLine: "Day ", day, ": take the bus"

endfor

```

--

## Conditionals

```praat

clearinfo

days = 7
for day from 1 to days
	if day == 3
		appendInfoLine: "Day ", day, ": ride bike"
	else
		appendInfoLine: "Day ", day, ": take the bus"
	endif
endfor

```

--

variables + loops + conditionals = power

---

# Project

Make a vowel space plot

<img src="https://github.com/ethanweed/praat-workshop/blob/main/images/vowel-editor.png?raw=true" width="400"/>

--

## strategy

<div id = "left">

1. Identify your goal
1. Break into small tasks
1. Prototype
1. Loop
1. Generalize

</div>



<div id = "right">

<img src="https://github.com/ethanweed/praat-workshop/blob/main/images/vowel-editor.png?raw=true" width="400"/>

</div>



---


# References


<div id = "refs">

Loop examples: https://praatscriptingtutorial.com/loops


</div>