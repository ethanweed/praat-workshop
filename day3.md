---
title: "Praat Workshop — Day 3"
theme: white
highlightTheme: github
---

# Praat Workshop
## Day 3: Extracting and Plotting Vowels


---

## Day 3 Overview

| Time | Activity |
|------|----------|
| 9:15–10:00 | Review + script demos |
| 10:00–10:15 | *Break* |
| 10:15–11:00 | Creating vowels in Praat; vowel space graphs |
| 11:00–11:15 | *Break* |
| 11:15–12:00 | Extracting formants; arranging data |
| 12:00–13:00 | *Lunch* |
| 13:00–14:00 | Plotting in Python; what's your dialect? |


---

# Morning
## 9:15–12:00

---

## Review + Script Demos
### 9:15–10:00


--

### Quick recap of Days 1 & 2

- **Day 1:** Praat's interface, sound acoustics, first scripts, the input → extract → output cycle
- **Day 2:** TextGrids, automatic vowel detection, variables, loops, conditionals


--

### Anyone have a script to demo?


---

## Creating Vowels in Praat
### 10:15–11:00 (approx.)



--

### Synthesising vowels in Praat

Praat can synthesise vowels by specifying formant frequencies:

1. **New** menu → **Sound** → **Create Sound from VowelEditor…**
2. Click in the vowel space to set F1 and F2
3. Listen to your synthesised vowel


---

## Vowel Space Graphs
### 11:15–12:00 (approx.)


--

### The vowel space

```
     High F2 ←————————————→ Low F2
          (front)           (back)
Low F1 ●[i]              [u]●   ← High vowel
  ↑    ●[e]              [o]●
  |    ●[ɛ]           [ʌ]●
  ↓
High F1 ●[a]              [ɑ]●  ← Low vowel
```

- Axes are *inverted* compared to the physical vocal tract
- High F1 = low in the mouth; low F2 = back in the mouth


--

### Workflow overview

```
Recording (.wav)
      ↓
Segment into vowels (Praat script)
      ↓
Extract F1, F2, F3 for each segment (Praat script)
      ↓
Save measurements to a text file (.txt)
      ↓
Combine multiple speakers (Praat script)
      ↓
Plot in Python (Google Colab / Jupyter)
```


--

### Step 1: Extract formants from a single file

Open `scripts/Day 3/extract_formants_from_vowel_list.praat`

What it does:
1. You pick a `.wav` file
2. Praat finds sounding/silent intervals automatically
3. For each "sounding" interval it measures F1, F2, F3
4. Results are saved to a `.txt` file (tab-separated)


--

### The formant extraction loop

```praat
for interval from 1 to numberOfIntervals
    label$ = Get label of interval: 1, interval

    if label$ = "sounding"
        start = Get start time of interval: 1, interval
        end   = Get end time of interval: 1, interval

        selectObject: formant
        f1 = Get mean: 1, start, end, "Hertz"
        f2 = Get mean: 2, start, end, "Hertz"
        f3 = Get mean: 3, start, end, "Hertz"

        appendInfoLine: interval, tab$, fixed$(f1, 1), tab$,
            ...fixed$(f2, 1), tab$, fixed$(f3, 1)
    endif
endfor
```


--

### Try it on your recording!

1. Open `extract_formants_from_vowel_list.praat`
2. Run it and select your homework recording (`yourname_vowels.wav`)
3. Choose your `output/` folder when asked
4. Open the resulting `_formants.txt` file in a text editor

Does the number of segments look right? (You said 8 words — you might get slightly more or fewer depending on pauses.)


--

### Step 2: Batch processing multiple speakers

Open `scripts/Day 3/extract_formants_from_vowel_list_batch.praat`

Same idea — but processes a **whole folder** of `.wav` files automatically:

```praat
for fileIndex from 1 to numberOfFiles
    ...
    Read from file: inputDir$ + fileName$
    # extract formants, save to file
    ...
endfor
```


--

### Step 3: Combine results from multiple speakers

Open `scripts/Day 3/concatenate_formant_data.praat`

- Reads all `*_formants.txt` files from a folder
- Adds a **source column** (the filename = the speaker)
- Combines everything into one `combined_formants.txt` file

This is the file we'll feed into Python for plotting.


--

### Parameter tuning: maximum formant frequency

The `Maximum_formant_(Hz)` setting matters a lot:

| Speaker type | Recommended maximum formant |
|---|---|
| Adult male | ~5000 Hz |
| Adult female | ~5500 Hz |
| Child | ~8000 Hz |

Setting it too low → formants are squashed together and inaccurate
Setting it too high → formants estimated from noise


---

## Lunch
### 12:00–13:00

---

# Afternoon
## Plotting Vowels & Finding Your Dialect
## 13:00–14:00

---

## Plotting Vowels with Python


--

### Why Python for plotting?

- Python's `matplotlib` and `plotnine` (ggplot) libraries are far more flexible than Praat's Picture window
- You can customise colours, labels, point shapes, ellipses, etc.
- The same plotting code works on any computer
- Google Colab runs it in the browser — no installation needed


--

### Google Colab notebook

Open the notebook:

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1m1csZRgnuHlyYr_sSl3xaROuinvyM0bG?usp=sharing)

Or open `scripts/Day 3/advanced_vowelspace_plot.ipynb` locally in VS Code / Jupyter.


--

### Arranging the data

The combined formant file looks like this:

| Interval | Label | Start | End | F1 | F2 | F3 | Source_File |
|---|---|---|---|---|---|---|---|
| 3 | Segment_1 | 0.412 | 0.681 | 487.2 | 1823.6 | 2741.1 | speaker1 |
| … | … | … | … | … | … | … | … |


--

### Adding vowel labels

Since you recorded the vowels in a fixed order:

```
Segment 1 = heed → /iː/
Segment 2 = hid  → /ɪ/
Segment 3 = head → /ɛ/
Segment 4 = had  → /æ/
Segment 5 = hod  → /ɒ/
Segment 6 = hawed → /ɔː/
Segment 7 = hood → /ʊ/
Segment 8 = who'd → /uː/
```

The notebook adds these labels automatically.


--

### The vowel space plot

```python
import pandas as pd
import plotnine as p9

df = pd.read_csv("combined_formants.txt", sep="\t")

(p9.ggplot(df, p9.aes(x="F2", y="F1", colour="vowel", label="vowel"))
  + p9.geom_text()
  + p9.scale_x_reverse()
  + p9.scale_y_reverse()
  + p9.labs(title="Vowel Space", x="F2 (Hz)", y="F1 (Hz)")
  + p9.theme_bw()
)
```


---

## What's Your Dialect?


--

### Comparing the `h_d_raw` speakers

The `data/h_d_raw/` folder has recordings from:

- American English (2 speakers)
- Australian English (2 speakers)
- British English
- New Zealand English (2 speakers)
- South African English
- Scottish English


--

### Interpreting your vowel space

Things to look for:
- How spread out are your vowels? (Some dialects have more merged vowels)
- Is your /æ/ (had) high or low?
- How close are your /ɒ/ (hod) and /ɔː/ (hawed)?
- Where does your /uː/ (who'd) sit — are your back vowels fronted?


--

### Add yourself to the comparison!

1. Run the formant extraction script on your own recording
2. Concatenate your results with the `h_d_raw` results
3. Plot everyone on the same graph, coloured by speaker

> **Which variety of English does your vowel space most resemble?**


---

## Afternoon: Open Exploration


---

## Workshop Wrap-up


--

### What we covered over three days

**Day 1:** Praat's interface · Sound acoustics · First scripts · history-paste · input → extract → output

**Day 2:** TextGrids · Automatic vowel detection · Variables · Loops · Conditionals · Pseudocode + LLMs

**Day 3:** Formant extraction · Batch processing · Vowel space visualisation · Cross-dialect comparison

--

### Where to go from here

- **Praat documentation:** [praat.org](https://www.praat.org) — the manual is comprehensive (if dense)
- **Phonetics on the web:** Peter Ladefoged's resources, UCLA Phonetics Lab
- **Python for linguists:** NLTK, spaCy, Parselmouth (a Python interface to Praat!)
- **R for phonetics:** `phonR`, `ggplot2`
- **Ask an LLM:** for pseudocode → code, but always check the output!


--

### Key takeaways

- Praat is a powerful tool, but its real power comes from **scripting**
- The concepts you learned — **variables, loops, conditionals** — are universal
- Computational approaches to linguistics are about **reproducible, scalable measurement**
- Every algorithm has parameters you need to **tune and validate**
- Start simple, build up — and don't be afraid to read error messages


--

### Thank you!

Questions? Comments? Bugs in the scripts?
