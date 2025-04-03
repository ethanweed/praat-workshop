Create Sound as pure tone: "tone", 1, 0, 0.4, 44100, 100, 0.2, 0.01, 0.01
Create Sound as pure tone: "tone", 1, 0, 0.1, 44100, 100, 0.2, 1e-05, 1e-05
Create Sound as pure tone: "tone", 1, 0, 1, 44100, 100, 0.2, 1e-05, 1e-05
Create Sound from formula: "sineWithNoise", 1, 0, 1, 44100, "1/2 * sin(2*pi*100*x)"
Create Sound from formula: "sine_100", 1, 0, 1, 44100, "1/2 * sin(2*pi*100*x)"
Create Sound from formula: "sine_100", 1, 0, 0.1, 44100, "1/2 * sin(2*pi*100*x)"
Create Sound from formula: "sine_200", 1, 0, 0.1, 44100, "1/2 * sin(2*pi*200*x)"
Create Sound from formula: "sine_100plus200", 1, 0, 0.1, 44100, "1/2 * sin(2*pi*100*x) + 1/2 * sin(2*pi*200*x)"
Create Sound from formula: "sine_100plus200", 1, 0, 0.1, 44100, "1/2 * sin(2*pi*200*x) + 1/2 * sin(2*pi*100*x)"
Create Sound from formula: "sine_100plus200", 1, 0, 0.1, 44100, "1/2 * sin(2*pi*200*x) + 1/2 * sin(2*pi*80*x)"
Create Sound from formula: "sine_100plus200", 1, 0, 0.1, 44100, "1/2 * sin(2*pi*100*x) + 1/2 * sin(2*pi*200*x) + 1/2 * sin(2*pi*337*x)"
Create Sound from formula: "sineWithNoise", 1, 0, 1, 44100, "1/2 * sin(2*pi*100*x) + 1/2 * sin(2*pi*200*x) + 1/2 * sin(2*pi*337*x) + randomGauss(0,0.1)"
