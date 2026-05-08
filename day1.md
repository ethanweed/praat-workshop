---
title: "Praat Workshop — Day 1"
theme: white
highlightTheme: github
---

# Praat Workshop
## Day 1: Introduction to Praat



---

## Day 1 Overview

| Time | Activity |
|------|----------|
| 9:15–10:00 | Introduction & orienting in Praat |
| 10:00–10:15 | *Break* |
| 10:15–11:00 | Using Praat to learn about sound |
| 11:00–11:15 | *Break* |
| 11:15–12:00 | Writing our first Praat scripts |
| 12:00–13:00 | *Lunch* |
| 13:00–14:00 | Afternoon challenges |


---

# Morning
## 9:15–12:00

---

## Introduction
### 9:15–10:00



--

### Goals for today

**Become *more familiar* with Praat**

- What are all these windows?
- Why is Praat so weird!


--

### Goals for today

**Become *more aware* of computational approaches to linguistics**

- What does it mean to be "computational"?
- What are the benefits and drawbacks of computational approaches?


--

### Orienting yourselves in Praat

- **Objects window** — your workspace; everything you load or create lives here
- **View & Edit window** — visualise and interact with sounds and annotations
- **Scripts window** — write and run code
- **Info window** — text output from scripts and measurements
- **Picture window** — create publication-quality figures
- And more…



---

## Using Praat to Learn About Sound
### 10:15–11:00


--

### Sound as a physical phenomenon

- Sound is pressure variation travelling through a medium
- We can represent it as a **waveform** — amplitude over time
- Or as a **spectrogram** — frequency over time, with intensity as darkness

--

### Sound as a psychological phenomenon

- The experience of sound is constructed by our auditory system
- Physical pitch (frequency in Hz) ≠ perceived pitch (low/high)
- Physical loudness (amplitude) ≠ perceived loudness (quiet/loud)


--

### Sine waves in Praat

Creating a pure tone from a formula:

```praat
Create Sound from formula: "sine_100", 1, 0, 1, 44100,
    "1/2 * sin(2*pi*100*x)"
```

- One frequency → one "pure" tone (like a tuning fork)
- Real speech = many frequencies added together


--

### Adding sine waves

```praat
Create Sound from formula: "sine_100plus200", 1, 0, 0.1, 44100,
    "1/2 * sin(2*pi*100*x) + 1/2 * sin(2*pi*200*x)"
```

- Adding sine waves creates a **complex wave**
- The spectrogram reveals the individual components


--

### Measuring (and checking) pitch

- Select a region of a sound → **Periodicity** menu → **To Pitch…**
- Praat estimates the fundamental frequency (F0) over time
- The **pitch range** matters — set it to match your speaker


--

### Adjusting spectrogram settings

- **View & Edit** → **Spectrogram settings…**
- Key parameters: window length, frequency range, dynamic range
- Different settings reveal different features of the signal


---

## Writing Our First Praat Scripts
### 11:15–12:00



--

### What is a script?

- A **script** is a text file containing instructions for Praat
- Instead of clicking menus, you write commands
- Praat runs the commands in order, top to bottom
- Scripts are **reproducible** — run the same script → get the same result


--

### The history-paste method

The easiest way to start scripting:

1. Do things in Praat normally (clicking menus)
2. Open a script window
3. **Edit** → **Paste history**
4. Praat writes the commands for you!
5. Edit → **Clear history**, then start fresh

--

### Objects in Praat

- Everything in Praat is an **object** (Sound, Pitch, Spectrogram, TextGrid…)
- Objects live in the Objects window
- Scripts create, select, and manipulate objects

```praat
# Select an object by name
selectObject: "Sound cats_dogs"

# Or select by its ID number
selectObject: 1
```


--

### The input → extract → output cycle

```
Sound file  →  Load into Praat  →  Extract features  →  Save / Draw
```

Almost every script follows this pattern:
1. **Read** a file from disk
2. **Create** an analysis object (Pitch, Formant, Spectrogram…)
3. **Draw** or **Save** the result


--

### File path tips

**Windows**
- Shift + right-click a file in Explorer → **"Copy as path"**
- Use forward slashes `/` in Praat scripts, or double backslashes `\\`

**macOS**
- Option + right-click → **"Copy as Pathname"**

**File formats**
- Praat reads WAV, AIFF, and its own formats
- Use WAV for compatibility


--

### Extracting pitch from a file

```praat
# Read the sound file
Read from file: "/path/to/cats_dogs.wav"

# Make a Pitch object
selectObject: "Sound cats_dogs"
To Pitch: 0, 75, 600

# Draw it in the Picture window
Erase all
Select outer viewport: 0, 6, 0, 4
Draw: 0, 0, 0, 500, "yes"

# Save the image
Save as PDF file: "/path/to/output/cats_dogs.pdf"
```


--

### Let's try it!

1. Open `scripts/Day 1/make_cats_dogs_plot.praat`
2. Update the file paths for your computer
3. Run the script (**Run** → **Run**, or Ctrl/Cmd+R)
4. Check the Picture window — did it work?



---

## Lunch
### 12:00–13:00

---

# Afternoon
## 13:00–14:00

---

## Afternoon Challenges

Pick one — or try both!


--

### Challenge 1: Advanced

Using what we learned today — Praat scripts, clear history, paste history — plus exploring the Praat menus:

> **Create a script that makes a spectrogram of a Praat-synthesised voice saying a phrase of your choice.**

**Hint:** look for the feature called **"Text-to-speech synthesis"**

Save your script in your `scripts/` folder.



--

### Challenge 2: Extra Advanced!

Record yourself saying something. Then write a script that:

1. Reads in your recording and creates a spectrogram
2. Makes a spectrogram of the text-to-speech synthesizer saying the same thing
3. Plots **your** spectrogram at the **top**, and the TTS spectrogram **below** it
4. Adds **titles** above each spectrogram
5. Exports to a PDF or PNG in your `output/` folder
6. Saves your script to your `scripts/` folder


---

## Day 1 Wrap-up

--

**Today we learned:**
- How Praat is organised (Objects, View & Edit, Scripts, Picture windows)
- How sound can be represented and measured (waveforms, spectrograms, pitch)
- How to write and run basic Praat scripts
- The history-paste method for turning clicks into code
- The input → extract → output cycle

--

**Tomorrow:** TextGrids, automatic vowel detection, and proper programming concepts

