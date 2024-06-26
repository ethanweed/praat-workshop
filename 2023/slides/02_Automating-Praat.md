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

## Fun with variables

```praat
name$ = "Ethan"
age = 49
nameCat$ = "D2"

age$ = string$: age

clearinfo
output$ = name$ + " is " + age$ + " years old."
appendInfoLine: output$

output$ = name$ + " has a cat named " + nameCat$
appendInfoLine: output$

```

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

--

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

--

```praat
1. read the wav file in as a sound object
2. select the sound object
3. get the intensityx (for identifying areas with silence
4. make a new TextGrid using labels from intensity to segment the sound file
5. select the sound and the TextGrid together
6. inspect where the segments have been placed
```


---


# References


<div id = "refs">

Loop examples: https://praatscriptingtutorial.com/loops


</div>