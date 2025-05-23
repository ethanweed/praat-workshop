---
customTheme : "ethan-slides"
---



# Goal 1
## Understanding Spectrograms

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/understanding_spectrograms.png?raw=true" width="600"/>

---

# Basic Acoustics

--

Speech is sound. 

But what is sound?

--

Pitch carries meaning. 

But what is pitch?

--

## Point processes

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/understanding_spectrograms_point-process.png?raw=true" width="600"/>

--

Let's make ambulance sounds

<img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fclipartix.com%2Fwp-content%2Fuploads%2F2016%2F11%2FImages-ambulance-clipart-yellow-clip-art.png&f=1&nofb=1&ipt=feaf2ee180b7b785b0c79f6855fa13704b5f4e02e0ff12531682c38da5e27fd2&ipo=images" width=""/>

--

<img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fclipartix.com%2Fwp-content%2Fuploads%2F2016%2F11%2FImages-ambulance-clipart-yellow-clip-art.png&f=1&nofb=1&ipt=feaf2ee180b7b785b0c79f6855fa13704b5f4e02e0ff12531682c38da5e27fd2&ipo=images" width="200"/>

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/baa-boo_pp.png?raw=true" width="600"/>

--

1. _frequency_ is a physical property

1. _pitch_ is a psychological experience

--

## Cochlea

<div id = "left">
Mouse cochlea  

Green: hair cells

Red: auditory nerves

</div>

<div id = "right">
<img src="https://www.betterhearingus.com/wp-content/uploads/img_0239.jpg" width="400"/>

</div>

--

## Exercise
What is your perceptual range?

--

<div id = "left">

1. find the lowest tone you can hear
1. find the highest tone you can hear
1. enter your results in the google doc: kortlink.dk/2kb5m


</div>

<div id = "right">

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/make-sine.gif?raw=true" width="400"/>
</div>


--

## Hearing

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Tidens_naturlære_fig40.png/1280px-Tidens_naturlære_fig40.png" width="500"/>


--

## From moving air to neurotransmission

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/NIH-Hearing.gif?raw=true" width=""/>

--

## Oscillations



<div id = "left">

1. Waveform
    1. time on x-axis
    1. pressure (intensity) on y axis

1. Spectrogram 
    1. two y-axes
    1. f0 on the right
    1. "actual" frequency on the left


</div>



<div id = "right">

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/Sine-100-Hz.png?raw=true" width="500"/>

</div>

--

## Spectral slice

<div id = "left">

1. The y-axis on the slice is still pressure (intensity)

2. The x-axis is _frequency_, not time! We froze time when we selected a window of the sound.

</div>



<div id = "right">

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/Sine-100-Hz_spectral-slice.png?raw=true" width="500"/>

</div>


--

## Let's build sounds
100 Hz sine wave

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/make-sine-with-formula.gif?raw=true" width=""/>

--
## Let's build sounds
Select 100 ms

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/select-100%20ms.gif?raw=true" width=""/>

--

## Let's build sounds
100 Hz sine with 200 Hz overtone

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/make-sine-with-overtone.gif?raw=true" width=""/>

--

## Comapre the two sounds

<div id = "left">

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/100-Hz.png?raw=true" width=""/>

</div>

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/100+200%20Hz.png?raw=true" width=""/>

<div id = "right">


</div>

--

## Formants

(sort of)

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/Sine-100-200-Hz_spectral-slice.png?raw=true" width=""/>



---

# Speech Acoustics

--

## Vowel Editor

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/vowel_editor.gif?raw=true" width=""/>


--

## Vowel Editor Quiz!

<div id = "left">

1. What are the axes of this figure?
1. Why are they arranged in this strange way?
1. What is a formant?

</div>



<div id = "right">

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/vowel-editor.png?raw=true" width=""/>

</div>



--


[Download an ``[i]``](https://github.com/ethanweed/praat-workshop/blob/main/2023/raw/main/data/cardinal_vowels/cardinal_vowel_wavs/vowels1.wav)

--

## Exercise


<div id = "left">

1. Use the VowelEditor to make a synthetic ``[i]`` with the same duration and same fundamental frequency as the human ``[i]`` 
1. Listen to both.
1. Make spectrograms of both
1. What differences do you observe?

</div>



<div id = "right">

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/vowel-editor.png?raw=true" width=""/>

</div>

--

<div id = "left">
[i], human
<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/i_human.png?raw=true" width="400"/>

</div>



<div id = "right">
[i], robot
<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/i_robot.png?raw=true" width="400"/>

</div>

--

## I-human vs. I-Robot

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/i-human%20v%20i-robot%20slices.png?raw=true" width=""/>

1. What differences do you observe?
1. Where are the first and second formants?

---


# Spectrogram settings and TextGrids


--


## Spectrograms are slices

"see"

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/see_spectrogram.png?raw=true" width="450"/>


<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/see-spectral-slices.png?raw=true" width="450"/>


--

<div id = "left">

Download this recording of the [cardinal vowels](https://github.com/ethanweed/praat-workshop/blob/main/2023/raw/main/data/cardinal_vowels.wav) (the picture is of Daniel Jones, but the voice on the recordings is not!)

- Click the link and save the file to  your ``data`` folder
- Open the file in Praat

</div>



<div id = "right">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Daniel_Jones_%28phonetician%29.jpg/220px-Daniel_Jones_%28phonetician%29.jpg" width=""/>

</div>

--

## Spectrogram settings

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/cardinal_vowels_spectrogram_settings.png?raw=true" width="550"/>


--

[The North Wind and the Sun](https://github.com/ethanweed/praat-workshop/blob/main/2023/raw/main/data/the_north_wind_and_the_sun.wav) 


<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/The_North_Wind_and_the_Sun_-_Wind_-_Project_Gutenberg_etext_19994.jpg/220px-The_North_Wind_and_the_Sun_-_Wind_-_Project_Gutenberg_etext_19994.jpg" width=""/>

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/The_North_Wind_and_the_Sun_-_Sun_-_Project_Gutenberg_etext_19994.jpg/220px-The_North_Wind_and_the_Sun_-_Sun_-_Project_Gutenberg_etext_19994.jpg" width=""/>

Download the file and save in ``data`` folder

--

## Annotation

<img src="https://github.com/ethanweed/praat-workshop/blob/main/2023/images/north-wind-pitch.png?raw=true" width="550"/>


---

# References


<div id = "refs">

Image credit:

Ambulance: clipartix.com

Mouse cochlea: Doetzlhofer lab; https://www.betterhearingus.com/researchers-discover-proteins-that-could-soon-cure-hearing-loss/

Ear animation: National Institue of Health; https://www.youtube.com/watch?v=eQEaiZ2j9oc


Daniel Jones: https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Daniel_Jones_%28phonetician%29.jpg/220px-Daniel_Jones_%28phonetician%29.jpg

Wind: https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/The_North_Wind_and_the_Sun_-_Wind_-_Project_Gutenberg_etext_19994.jpg/220px-The_North_Wind_and_the_Sun_-_Wind_-_Project_Gutenberg_etext_19994.jpg

Sun: https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/The_North_Wind_and_the_Sun_-_Sun_-_Project_Gutenberg_etext_19994.jpg/220px-The_North_Wind_and_the_Sun_-_Sun_-_Project_Gutenberg_etext_19994.jpg


</div>