+++
title = 'SoX guide: Convert, manipulate and generate audio on the command line'
date = 2025-02-13
draft = false
author = "Mads Kjeldgaard"
authorlink = "https://madskjeldgaard.dk"
tags = ['sox', 'guide', 'audioprocessing', 'bash', 'cli']
toc = true
description = "SoX is a free command line audio processing tool with a text-based interface that let's you perform powerful audio operations by typing just a few words in your computer's terminal. It is a popular tool for managing large collections of audio files, splitting audio files by silence and batch processing (eg. normalizing an entire folder of drum sounds in a matter of seconds), but really it is much more than that. If you learn to use SoX you are guaranteed to save enormous amounts of time working with audio files. This guide will help you get started."
images = ["/tapemachine.jpg"]
+++

## Part 0: About this guide

This guide was originally published on my website [madskjeldgaard.dk](https://madskjeldgaard.dk) – due to popular demand, I decided to brush it off, update it, and move it to this website.

### Contributing to the guide

This guide is open source, and you can contribute changes, modifications and questions by visiting [the site's repository on Github](https://github.com/madskjeldgaard/hyaline.systems-public). 

### Support

Writing this guide took a long time. If you found it useful, [please consider making a donation to show your support and/or say thanks :)](https://ko-fi.com/madskjeldgaard). All contributions are greatly appreciated and help motivate me to make more stuff like this.

{{< kofi >}}

{{< lftri >}}

## Part 1: Getting started

### Installing SoX

#### MacOS
Using the [Homebrew package manager](https://brew.sh/):

```sh
brew install sox
```
#### Windows

Using the Chocolatey package manager

```sh
choco install sox.portable
```

#### Ubuntu / Debian

```sh
sudo apt install sox
```

#### Arch / Manjaro

```sh
sudo pacman -S sox
```

### What's included

#### The manual
<!-- ![sox manual](/sox-man.png) -->

To read the manual, open up a terminal and type: 

```sh
man sox
```

The manual is the best place to find information and example usages for SoX.

To search the manual press `/` followed by your search query. By pressing `n` while searching, the cursor will jump to the next instance of the query you searched for. By pressing `N` the cursor will jump to the previous instance.

Scroll forward one page by pressing `ctrl-f`

And backwards one page by pressing `ctrl-b`

Exit the manual by pressing `q`

#### Supported file types and formats

By default, SoX supports pretty much every file type you can imagine. There may be variations, depending on what operating system you are on (some might not support mp3 for example). 

See the audio formats manual for more information:

```sh
man soxformats
```

#### Audio recorder

SoX includes a very handy way of recording audio using the `rec` command.

The simplest use is to type `rec filename` which will start recording from the default input until you stop it by pressing `ctrl-c` in the terminal window.

Example use:

```sh
rec hello.wav
```

You can specify a predefined length of the recording like this: `rec hello.wav trim 0 30:00` which will record for 30 minutes and then automatically stop

#### Audio player

Similarly, playing audio is also possible using the command `play`

Example use:
```sh
play hello.wav
```
Note that both play and rec can be used with SoX's many included effects.

Playing the above example at half speed with a flanger at the end is as simple as

```sh
play hello.wav speed 0.5 flanger
```

#### Audio file information

Another helpful command bundled with sox is

```sh
soxi <path-to-audiofile>
```
This will display information about an audio file.

### Command line basics

You do not have to have a lot of command line experience to use SoX but there is a few basic commands that will make it easier for you to navigate your computer in the command line.

- **pwd** - see path to directory you are currently in
- **ls** - see files in current directory
- **cd /some/path** - move to _/some/path_
- **cd ..** - move up one folder
- **cd ~** - move to home folder

As well as commands, here are some essential keyboard shortcuts:

- up/down - scroll through previous commands (easy way to see / reuse previous work)
- ctrl-c - cancel/abort the program (a sort of panic button)

Sometimes, a simple way of using `cd` is to drag and drop a folder from your computer onto your terminal, this will in most cases paste the full path.

#### The sox command

Our main interface for sox in this tutorial will be the `sox` command. The basic usage of this includes specifying an input file path, an output file path and then optionally some effects followed by an optional series of parameters.

The basic command we will use will thus look like this:

```sh
sox inputfile outputfile effect parameters
```

If your input or output file contains spaces in the file name, you should wrap the path to it in quotation marks like this:

```sh
sox "/in/sound.wav" "out/newsound.wav" effect param1
```

Like other command line tools, sox executes from the context of the folder that you are currently in (which can be found by typing `pwd`) and as such you do not need to type out the entire path to a file if it is in the same folder as the one you are executing sox from.

{{< lfsine animationSpeed=44s >}}

## Part 2: Command line tape music

Tape music artists of the 60's and 70's had very rudimentary tools at their disposal - mostly they did their work using reel-to-reel tape recorders and simple effects. But you would be surprised by the incredible sonic possibilities available in a tool as simple as this, using basic techniques of recording, reversing, adding effects, changing playback speed, etc. you can get a long way towards making interesting music.

Let us explore some of SoX' basic commands a bit by doing some command line audio manipulations reminiscent of classic tape music techniques.

### Recording and playing audio

First of all, we need some audio to operate on. I would recommend recording a quick bit from your computer's microphone. If you have an instrument around, maybe use that for this exercise or simply (like me) whistle like an idiot in front of your computer.

Record to the file idiot.wav for 10 seconds:

```sh
rec idiot.wav trim 0:0 0:10
```

Once SoX is done recording, it will post a "done" message.

Moving on, let us test the file we just recorded

```sh
play idiot.wav
```

### Adding effects to your audio recording

You should now hear yourself doing something silly in front of your computer a few seconds ago.

To convert this to something else, we need to invoke the `sox` command now, providing it with an input file name, an output file name and a chain of effects. In this example, I will add a silly effects chain consisting of reversing the audio -> flanger (2ms delay) -> playback speed 50% (0.5) -> reverb. The output of this operation will be saved in the file `art.wav`

```sh
sox idiot.wav art.wav reverse flanger 2 speed 0.5 reverb
```

If you execute the command `ls` now, you should in your directory see both the files idiot.wav (the original) and the manipulated file art.wav.

Just to be sure, we can test our output file.

```sh
play art.wav
```

Now, we would not be proper command line tape musicians if we felt satisfied after 1 manipulation to the original recording, so let us continue our sonic journey by transforming the `art.wav` file further, this time we will time stretch to twice the length (factor 2), reverse the audio again and add some reverb. Just to make sure we do not lose too much of our audio level, we will normalize the output to -0.1db as well finally saving the result in the file `art2.wav`

```sh
sox art.wav art2.wav stretch 2 reverse reverb norm -0.1
```

{{< lfsine animationSpeed=33s >}}

## Part 3: Split a file by silence
SoX has a very effective and rather precise way of semi-automatically chopping a sound file into smaller sound files.

Let us say you have a sound file containing many different sounds seperated by a bit of silence in between. It could be a series of drum hits that you have recorded off of a drum machine. To make these sounds easy to use, you most probably need them as seperate sound files so you can load them into a sampler or other software as a sample bank of sorts.

In SoX we can approach this problem quite simply: Split the input file (the long file containing many different sounds in sequence) by detecting the silence in between the sounds.

To do this we need to use the `silence` effect in SoX, which I will explain in a bit more detail since it is an important one and it's syntax is a bit esoteric to say the least.

### What is silence

In the manual, `silence` is defined like this:

"Removes silence from the beginning, middle, or end of the audio. 'Silence' is determined by a specified threshold."

`silence` takes a range of optional arguments but we will only use the first three of them:

- above-periods - indicate if audio should be trimmed at the begnning of the audio. 0 = no silence trimmed from beginning, 1 = trim silence from beginning
- duration - amount of time in seconds that non-silence must be detected before it stops trimming audio
- threshold - audio threshold, we will indicate this in percentages

The parameters are stringed together after the `silence` keyword in the sox command like this:
```bash
sox infile.wav outfile.wav silence <above-periods> <duration> <threshold>
```

### Trimming silence from beginning and end of one file
To trim the beginning of a file until the audio is above 1% in volume for more than 0.1 seconds, you would write a command like this:
```bash
sox infile.wav outfile.wav silence 1 0.1 1%
```

To trim the ending as well, we basically repeat the parameters like this:
```bash
sox infile.wav outfile.wav silence 1 0.1 1% 1 0.1 1%
```

### Chaining (pseudo) effects

This is all good and well, but we want to produce a sample bank from one input audio file. To do this we need to make use of SoX' ability to chain effects chains after eachother and enter into "multiple output file mode".

From the manual: "In multiple output mode, a new file is created when the effects prior to the 'newfile' indicate they are done. The effects chain listed after 'newfile' is then started up and its output is saved to the new file."

An effects chain can thus be chained after another using a colon `:`. Now instead of manually writing out the silence effect and it's parameters for each bit we want to extract from the sound file, we can make the process automatically restart each time it has detected a bit of sound by silence

To do this we need to chain the `restart` pseudoeffect at the end of our command. This will make the process create a new file from the bit it detected by silence, then restart the process from where it left off and repeat until it reaches the end of the file. Kind of like slicing off bits of a (sound) sausage from left to right.

Our final command for chopping files by silence will then end up looking like this:
```bash
sox infile.wav outfile.wav silence 1 0.1 1% 1 0.1 1% : newfile : restart
```
### Chopping three bursts

<!-- ![alt](/img/small/threebursts.png) -->

As an example of the above, let us have a look at a sound file containing three short noise bursts.

The sound file is called threebursts.wav and can be [downloaded here](/audio/threebursts.wav).

To split the soundfile into three seperate files containing the bursts (without the silence in between), we simply execute the command

```bash
sox threebursts.wav burst_num.wav silence 1 0.1 1% 1 0.1 1% : newfile : restart
```

which will produce sound files called "burst_num001.wav", "burst_num002.wav" etc.

Now this works very well for our very unnatural example here, but I encourage you to mess around with the parameters when you do this on your own with your own files. Change the threshold to 5% for example if it's noisy or set the duration to something higher if it results in too many small files.

Note: Sometimes on some systems this command will produce an extra audio file containing nothing. I honestly have no idea why. Just delete the file (or send me an email if you have a solution to this problem)

{{<  lfsquare animationSpeed=45s >}}

## Part 4: Batch processing audio files – a cookbook

To make full use of SoX' potential for batch processing we will be using a bit of command line wizardry.

The idea is to put our sox command inside of a for-loop which iterates over all audio files in the folder you are currently in. If you are unsure of what folder your terminal is executing from, you can write `pwd` to see it's full path and `ls` to see the folder's contents.

### For-loop

The structure of our for-loop-command will look something like this:
```bash
for file in *.wav; do command $file; done
```
This needs a bit of explanation. What we see here is shell scripting where commands (or lines of code you could say) are seperated by semi colons.

The first bit of this command (`for file in *.wav`) will find all files in the current directory containing the suffix `.wav`. Note that this is case-sensitive, so if you want WAV files to be converted change it to `*.WAV`, and so on. The smart thing about this is that each file inside of the for-loop will accessible as the variable `$file`.

The second bit of the command is the meat of it. Here we execute our sox command like we have done previously in this tutorial, with the main difference being we put `do` in front of it - this is a way to tell our for loop that this is supposed to happen on each file we find.

The third bit is self-explanatory: `done`.

We will be operating on .wav-files here, but you can easily change the commands to target .aiff files or some other supported file format.

### Normalize
To normalize a file in SoX we need to apply the `norm` effect which only takes one parameter which is the sound level to normalize to. A reasonable normalization level is -0.1 dB so let us use that in our conversion process.

```bash
for file in *.wav; do sox "$file" "n_$file" norm -0.1; done
```

Notice that what we do here is non-destructive. The normalized files produced by this process have the same file names as the input files but with a "n_" at the beginning to signify that it has been normalized.

### Channel conversion

Another useful effect included with SoX is `channels`, this makes it possible for us to specify the number of channels in the output file. This is useful if for example you need to convert a folder of files to mono, this can be done in a manner similar to the above:

```bash
for file in *.wav; do sox "$file" "mono_$file" channels 1; done
```

### Convert to 48khz sample rate

```bash
for file in *.wav; do sox "$file" "48khz_$file" rate 48k; done
```

### Convert to 16bit

Now, this is slightly different because when converting bit-depth we need to use a command line flag instead of an effect. Normally, SoX will use the detected bit-depth of the input file as the bit-depth of the output file, but you can force SoX to change it to something else (like 16 bit) by adding a `-b 16` in between the file names (or `-b 24` for 24 bit).

```bash
for file in *.wav; do sox "$file" -b 16 "16bit_$file"; done
```

### Trim silence from all files

```bash
for file in *.wav; do sox "$file" "nosilence_$file" silence 1 0.1 1% 1 0.1 1%; done
```
### Making a bash script

If you find yourself repeating a command or for-loop a lot, it can be benefitial to put it in a bash script. 
This will make it easy to reuse, and we can even add nice extra features like file type detection etc.

The script below is an example of a bash script that runs sox over all files of type mp3, wav, flac and aiff, and on each one runs the sox command to normalize each one of them.

To use it, save it to a file. For example: *batchnormalize.sh*.

Then, to allow your user to run the script, run:

```sh
chmod +x batchnormalize.sh
```

After this, you can run it using

```bash
./batchnormalize.sh <path-to-folder>
```
Here are the contents of the script:

```bash 
#!/bin/bash

# This script runs sox on all file types mentioned below, and normalizes each file to the level -0.1 dB

# Check if a folder path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <folder_path>"
  exit 1
fi

# Define the prefix for output files
prefix="normalized_"

# Navigate to the specified folder
cd "$1" || { echo "Folder not found: $1"; exit 1; }

# Define the file suffixes to search for (both lowercase and uppercase)
suffixes=("mp3" "wav" "flac" "aiff" "MP3" "WAV" "FLAC" "AIFF")

# Loop through each suffix and process the files
for suffix in "${suffixes[@]}"; do
  for file in *."$suffix"; do
    # Check if the file exists (to avoid processing non-matching patterns)
    if [ -f "$file" ]; then
      OUTFILE="${prefix}${file}"
      echo "[sox] Processing file ${file}. Output: ${OUTFILE}"
      # Run the sox command and add the prefix to the output file
      sox "$file" "$OUTFILE" norm -0.1
    fi
  done
done

echo "Processing complete."
```

{{< lftri animationSpeed=100s >}}

## Part 5: Using SoX in SuperCollider

If you are a user of [SuperCollider](https://supercollider.github.io/), I have made a convenience package to make it easy to run SoX programmatically from SuperCollider. It is available [here](https://github.com/madskjeldgaard/sox.quark).


### Convert single files from sclang

Here are some examples of simple commands you can run

```javascript
// Normalize
Sox.normalize("in.wav", "out.wav", (-0.1))

// Split by silence (using default values)
Sox.splitBySilence("in.wav", "out.wav")

// Run arbitrary sox command
Sox.run("inFile.wav", "outFile.wav", "gain", "-3", "pad", "0", "3", "reverb");
```

### Batch process files from sclang

And here an example of batch-processing a folder of files from within SuperCollider:

```javascript
(
var folder = "~/tmp/sounds";
var folderPath = PathName(folder);

folderPath.filesDo{|file|
    var inFile = file;

    var file=inFile.fileNameWithoutExtension ++ "_n" ++ "." ++ inFile.extension;
    var outFile = inFile.pathOnly +/+ PathName(file);
    Sox.normalize(inFile.fullPath, outFile.fullPath);
};

)
```

{{< lfsine animationSpeed=100s >}}

## Where to go from here?
I would highly encourage you to go back and read the SoX manual (`man sox`, remember?) because there really is a plethora of fun and useful things you can do with SoX in a for-loop.

If you want to mess with video on the commandline, we have a [guide for that as well](/blog/ffmpeg-for-artists).


{{< kofi >}}
