---
title: "Praat Workshop — Day 2"
theme: white
highlightTheme: github
---

# Praat Workshop
## Day 2: Scripting Praat



---

## Day 2 Overview

| Time | Activity |
|------|----------|
| 9:15–9:30 | Review of Day 1 |
| 9:30–10:00 | Working with TextGrids |
| 10:00–10:15 | *Break* |
| 10:15–11:00 | Automatically finding vowels |
| 11:00–11:15 | *Break* |
| 11:15–12:00 | Introduction to programming |
| 12:00–13:00 | *Lunch* |
| 13:00–14:00 | Afternoon: code, debug, code… |


---

# Morning
## 9:15–12:00

---

## Review: What Did We Learn Yesterday?
### 9:15–9:30



--

### Quick recap

- Praat's windows: **Objects**, **View & Edit**, **Scripts**, **Picture**, **Info**
- Sound is a physical phenomenon; what we hear is psychological
- **Sine waves** → building blocks of all sound
- The **history-paste** method: click → paste history → edit
- The **input → extract → output** cycle
- Extracting and drawing a pitch contour from a script


---

## Working with TextGrids
### 9:30–10:00



--

### What is a TextGrid?

- A **TextGrid** is a set of labelled time intervals or points overlaid on a sound
- **Interval tiers** — spans of time with labels (e.g., words, phones)
- **Point tiers** — single time points with labels (e.g., stress marks)
- TextGrids are saved as `.TextGrid` files alongside the `.wav` file



--

### Pitch contour with annotation

Let's draw a pitch contour *with* a TextGrid annotation below it:

```praat
# Read sound and TextGrid
Read from file: "/path/to/north_wind_sun.wav"
Read from file: "/path/to/north_wind_sun.TextGrid"

# Create Pitch object
selectObject: "Sound north_wind_sun"
To Pitch: 0, 75, 600

# Select TextGrid + Pitch together
selectObject: "TextGrid north_wind_sun"
plusObject: "Pitch north_wind_sun"

# Draw both together
Draw: 0, 0, 0, 500, "yes", "no", "centre", "no"
```


--

### Try it!

1. Load `data/north_wind_sun.wav` and `data/north_wind_sun.TextGrid`
2. Explore the annotation in View & Edit
3. Try modifying a label or adding a boundary
4. Write a short script using the history-paste method that draws the pitch contour + annotation


---

## Automatically Finding Vowels
### 10:15–11:00


--

### Why automate?



--

### Script 1: Formant-based vowel detection

Looks for sections with a clear **first formant (F1)** in the right frequency range:

- F1 present and between 300–1000 Hz
- F1 bandwidth narrow (strong formant)
- Intensity above threshold

→ Marks those regions as "vowel" in a TextGrid


--

### Script 2: Energy-based vowel detection

A different approach — looks for **peaks in a filtered energy envelope**:

- Band-pass filter around the formant frequency range (900–2000 Hz)
- Rectify and smooth to get a "beat wave"
- Find where the energy rises above a threshold


--

### Which settings work best?

Try both scripts on the same file. Compare:

- How many vowels did each script find?
- Are there false positives (non-vowels labelled as vowels)?
- Are there false negatives (vowels that were missed)?
- What happens when you change the threshold?

---

## Introduction to Programming
### 11:15–12:00


--

### Hello, World!

Every programmer's first program:

```praat
writeInfoLine: "Hello world!"
```

- `writeInfoLine` sends text to the **Info window**
- `appendInfoLine` adds a new line without clearing first


--

### What is programming?

- Programming = giving a computer **precise, step-by-step instructions**
- Computers are very fast but very literal — they do *exactly* what you say
- The hard part is figuring out *what to say*

> A program is a recipe. The computer is a very fast, very obedient, but completely clueless cook.


---

## Variables
### The boxes that hold values


--

### String variables

A **string** is a piece of text. In Praat, string variable names end with `$`:

```praat
clearinfo
msg$ = "Hello World!"
appendInfoLine: msg$
```

You can reassign a variable:

```praat
msg$ = "Hello World!"
appendInfoLine: msg$

msg$ = "How are you?"
appendInfoLine: msg$
```


--

### Numeric variables

No `$` suffix for numbers:

```praat
totalHours = 5
lunch = 1
actualHours = totalHours - lunch

appendInfoLine: "Hours of Praat today: " + string$(actualHours)
```


--

### Forms — getting input from the user

```praat
form Chomsky age comparinator
    comment Compare your age to Noam Chomsky's age
    real your_age 20
    text message_to_Noam You can enter text here
endform

noamsAge = 96
ageDiff = noamsAge - your_age

appendInfoLine: "Chomsky is " + string$(ageDiff) + " years older than you."
appendInfoLine: "Hey Noam, " + message_to_Noam$
```


---

## Loops
### Doing things many times


--

### The `for` loop

```praat
for number from 1 to 3
    appendInfoLine: number
endfor
```

Output:
```
1
2
3
```

The **loop variable** (`number`) counts up automatically.


--

### Using a variable to control the loop

```praat
max_number = 10

for number from 1 to max_number
    appendInfoLine: number
endfor
```

Now you can change `max_number` and the loop adapts.

--

### Loops with text output

```praat
puppies = 15

for number from 1 to puppies
    appendInfoLine: "There are ", number, " puppies"
endfor
```


---

## Conditionals
### Making decisions



--

### The `if` statement

```praat
puppies = 15

for number from 1 to puppies
    if number == 1
        appendInfoLine: "There is ", number, " puppy"
    else
        appendInfoLine: "There are ", number, " puppies"
    endif
endfor
```

--

### `elif` — more than two options

```praat
for number from 1 to puppies
    if number == 1
        appendInfoLine: "There is ", number, " puppy"
    elif number == 7
        appendInfoLine: number, "? That's the bestest number of puppies!"
    else
        appendInfoLine: "There are ", number, " puppies"
    endif
endfor
```

--

### The puppies exercise

Open `scripts/Day 2/puppies.praat` and:

1. Change the number of puppies
2. Add a new special case for your favourite number
3. Compare with the Python version in `puppies.py`
4. Compare with the R version in `puppies.R`



---

## Beyond Praat
### Programming is programming

--

### The same logic in Python

```python
puppies = 15

for number in range(puppies):
    if number == 1:
        print("There is", number, "puppy")
    elif number == 7:
        print("There are", number, "puppies! That's my favourite!")
    else:
        print("There are", number, "puppies")
```



--

### Code editors (IDEs)

- A good editor makes coding much easier
- **VS Code** — free, widely used, works for Praat, Python, R, and more
- Features: syntax highlighting, auto-complete, error highlighting, integrated terminal
- Praat has its own built-in editor, but it's quite basic


--

### Pseudocode and LLMs

**Pseudocode** = describing what you want in plain English before writing actual code

```
for each sound file in my folder:
    load the file
    extract the pitch
    save a plot to my output folder
```

→ LLMs (ChatGPT, Claude, Copilot) can help turn pseudocode into working code


---

## Lunch
### 12:00–13:00

---

# Afternoon
## Code, Debug, Code…
## 13:00–14:00

---

## Afternoon Challenge



--

### Your mission

Using what you have learned, together with tools like Copilot, ChatGPT, etc.:

> **Create a SIMPLE script that automates some aspect of acoustic analysis.**

Suggestions:
- Start with a single file; then try a folder of files
- Extract pitch or formants from all files in `data/cardinal_vowels/`
- Plot a spectrogram for every file in a folder automatically


--

### Tips for the afternoon

- **LLMs are not great at Praat yet** — use them for ideas and starting points, but expect to debug
- Test your script on *one* file before trying a whole folder
- Use `appendInfoLine` to print progress as your script runs — it tells you what's happening
- The history-paste method is always there if you get lost


---

## Homework: Record Your Own Vowels


--

### What to record

In a **quiet location**, record yourself saying:

> **"heed, hid, head, had, hod, hawed, hood, who'd"**

- These are the eight English vowels in an /h\_d/ frame
- ["hod"](https://en.wikipedia.org/wiki/Brick_hod) — rhymes with "bod", "cod", or "sod"
- Leave a **little space** between each word (makes it easier for scripts to find them)
- Any device works — phone, laptop mic, etc. — quiet room matters more than equipment



---

## Day 2 Wrap-up

**Today we learned:**
- TextGrids — Praat's annotation system
- Two different approaches to automatic vowel detection
- Core programming concepts: **variables**, **loops**, **conditionals**
- How these concepts look in Praat, Python, and R
- How to use pseudocode + LLMs as a starting point

**Homework:** record "heed, hid, head, had, hod, hawed, hood, who'd" as a .wav file

**Friday:** extracting formants, plotting vowel spaces, and also... which dialect of English do you speak?

