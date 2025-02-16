+++
title = 'ffmpeg for Artists: A Cookbook for Audio and Video Processing on the Command Line ... with Examples!'
date = 2025-02-15
draft = false 
author = "Mads Kjeldgaard"
authorlink = "https://madskjeldgaard.dk"
tags = ['ffmpeg', 'guide', 'audioprocessing', 'bash', 'cli', 'video']
toc = true
description = "A guide to using ffmpeg for artists. ffmpeg is a free tool that allows you to create, convert and manipulate video, really quickly and without opening a heavy GUI-based program. You can script it to make full use of it's power and convert folders of files for example. The following is a cookbook of handy examples I myself use to easily create videos for social media, websites, etcetera – mostly from a source material of audio files and/or photos. I hope you find it useful."
images = ["/ffmpeg-spectrum.jpg"]
+++

## Part 0: About this guide

This cookbook is a continual work in progress. It will get updated as new ideas and needs emerge. If you have any ideas, please feel free to 
[open an issue here](https://github.com/madskjeldgaard/hyaline.systems-public/issues).

### Contributing to the guide

This guide is open source, and you can contribute changes, modifications and questions by visiting [the site's repository on Github](https://github.com/madskjeldgaard/hyaline.systems-public) or by clicking the edit button above.

### Support

Writing this guide took a long time. If you found it useful, [please consider making a donation to show your support and/or say thanks :)](https://ko-fi.com/madskjeldgaard). All contributions are greatly appreciated and help motivate me to make more stuff like this.

{{< kofi >}}

{{< lftri >}}

### Prerequisites

This post assumes you have a bit of experience using bash scripting. You can mostly get by by copy-pasting the examples below, but I'd recommend becoming a big more familiar with the basics of bash scripting if you want to have the full potential. Here is [one guide](https://mywiki.wooledge.org/BashGuide) you could check out, but there's a lot more out there. Find one that suits you.

## Part 1: Getting started

### Installing ffmpeg

#### MacOS
Using the [Homebrew package manager](https://brew.sh/):

```sh
brew install ffmpeg
```
#### Windows

Using the Chocolatey package manager

```sh
choco install ffmpeg
```

#### Ubuntu / Debian

```sh
sudo apt install ffmpeg
```

#### Arch / Manjaro

```sh
sudo pacman -S ffmpeg
```

### What's included

#### The manual
<!-- ![ffmpeg manual](/ffmpeg-man.png) -->

To read the manual, open up a terminal and type: 

```sh
man ffmpeg
```

The manual is the best place to find information and example usages for FFMPEG.

To search the manual press `/` followed by your search query. By pressing `n` while searching, the cursor will jump to the next instance of the query you searched for. By pressing `N` the cursor will jump to the previous instance.

Scroll forward one page by pressing `ctrl-f`

And backwards one page by pressing `ctrl-b`

Exit the manual by pressing `q`

{{< lfsine animationSpeed=100s >}}

## Part 2: The Cookbook

### Audio waveform video: Convert an audio file to a video with a waveform visualization

This Bash script converts an audio file into a video with a customizable audio waveform visualization using `ffmpeg`. It supports various options for resolution, frame rate, color schemes, and EBU R128 loudness normalization.

To read more about this filter, run 

```sh
man ffmpeg-filters
```

And search for `showwaves`.


#### Example

{{< video src="pumpwaveform" >}}

#### Usage
Save the following script in a file named `audio2videowaveform.sh` and make it executable using `chmod +x audio2videowaveform.sh`.

Then you can run the script with the following commands:

```bash
./audio2videowaveform.sh -i <input_file> [-o <output_file>] [-s <resolution>] [-r <frame_rate>] [-c <colors>] [-n]
```

You can also use it in a for-loop to iterate over all audio files in a folder and convert each to a waveform video:

```bash
for file in *.wav; do 
    ./audio2videowaveform.sh -i "$file" -o "${file%.wav}.mp4" -n
done
```

#### Script

```bash
#!/bin/bash

# Convert audio file to video waveform using FFmpeg
# Usage: audio2videowaveform.sh -i <input_file> [-o <output_file>] [-s <resolution>] [-r <frame_rate>] [-c <colors>] [-n]

# Function to display usage information
usage() {
    echo "Usage: $0 -i <input_file> [-o <output_file>] [-s <resolution>] [-r <frame_rate>] [-c <colors>] [-n]"
    echo "  -i  Input audio file (required)"
    echo "  -o  Output video file (optional, default: <input_file_base>.mp4)"
    echo "  -s  Video resolution (optional, default: 1920x1080)"
    echo "  -r  Frame rate (optional, default: 30)"
    echo "  -c  Waveform colors (optional, default: white)"
    echo "      Examples: 'white', 'red', 'blue', 'green', 'yellow', 'magenta', 'cyan'"
    echo "  -n  Normalize audio to EBU R128 using loudnorm (optional, default: false)"
    exit 1
}

# Default values
resolution="1920x1080"
frame_rate="30"
colors="white"
normalize_audio=false

# Parse command-line arguments
while getopts ":i:o:s:r:c:n" opt; do
    case "${opt}" in
        i)
            input_file="${OPTARG}"
            ;;
        o)
            output_file="${OPTARG}"
            ;;
        s)
            resolution="${OPTARG}"
            ;;
        r)
            frame_rate="${OPTARG}"
            ;;
        c)
            colors="${OPTARG}"
            ;;
        n)
            normalize_audio=true
            ;;
        *)
            echo "Error: Invalid option"
            echo "Invalid option: ${OPTARG}"
            usage
            ;;
    esac
done

# Check if input file is provided
if [ -z "${input_file}" ]; then
    echo "Error: Input file is required."
    usage
fi

# Extract base name of the input file without extension
input_base_name=$(basename "${input_file}" | sed 's/\.[^.]*$//')

# Set default output file if not provided
if [ -z "${output_file}" ]; then
    output_file="${input_base_name}.mp4"
fi

# Build the filter_complex string
filter_complex="[0:a]"

# Add loudnorm filter if normalization is enabled
if [ "${normalize_audio}" = true ]; then
    echo "Normalizing audio to EBU R128 using loudnorm..."
    filter_complex+="loudnorm,"
fi

# Add showwaves filter
filter_complex+="showwaves=s=${resolution}:colors=${colors}:mode=line:rate=${frame_rate}:scale=sqrt[v]"

echo "Filter complex: ${filter_complex}"

# Run ffmpeg command
ffmpeg -y -i "${input_file}" -filter_complex "${filter_complex}" -map '[v]' -map '0:a' -c:v libx264 -pix_fmt yuv420p -r "${frame_rate}" -c:a aac -movflags +faststart "${output_file}" && echo "Video created successfully: ${output_file}"
```


### Audio spectrum video: Convert an audio file to a video with a spectrum visualization

This Bash script converts an audio file into a video with a customizable audio spectrum visualization using `ffmpeg`. It supports various options for resolution, frame rate, color schemes, and EBU R128 loudness normalization.

To read more about this filter, run 
```sh
man ffmpeg-filters
```
And search for `showspectrum`.

#### Example

<!-- Input audio: -->

<!-- {{< simpleaudioplayer title="pump.mp3" url="/audio/pump.mp3">}} -->

{{< video src="pump" >}}

#### Usage

Save the following script in a file named `audio2videospectrum.sh` and make it executable using `chmod +x audio2videospectrum.sh`.

Then you can run the script with the following commands:

```bash
./audio2videospectrum.sh -i <input_file> [-o <output_file>] [-s <resolution>] [-r <frame_rate>] [-c <colors>] [-n]
```

You can also use it in a for-loop to iterate over all audio files in a folder and convert each to a spectrum video:

```bash
for file in *.wav; do 
    ./audio2videospectrum.sh -i "$file" -o "${file%.wav}.mp4" -n
done
```

#### Script

```bash
#!/bin/bash

# Convert audio file to video spectrum using FFmpeg
# Usage: audio2videospectrum.sh -i <input_file> [-o <output_file>] [-s <resolution>] [-r <frame_rate>] [-c <colors>] [-n]

# Function to display usage information
usage() {
    echo "Usage: $0 -i <input_file> [-o <output_file>] [-s <resolution>] [-r <frame_rate>] [-c <colors>] [-n]"
    echo "  -i  Input audio file (required)"
    echo "  -o  Output video file (optional, default: <input_file_base>.mp4)"
    echo "  -s  Video resolution (optional, default: 1920x1080)"
    echo "  -r  Frame rate (optional, default: 30)"
    echo "  -c  Spectrum colors (optional, default: rainbow)"
    echo "      Examples: 'channel', 'rainbow', 'intensity', 'blues', 'fire', 'cool', 'magma', 'viridis'"
    echo "  -n  Normalize audio to EBU R128 using loudnorm (optional, default: false)"
    exit 1
}

# Default values
resolution="1920x1080"
frame_rate="30"
colors="rainbow"
scaling="sqrt"
fscaling="lin"
data="magnitude"
normalize_audio=false
freqstart=0
freqstop=20000
gain=3

# Parse command-line arguments
while getopts ":i:o:s:r:c:n" opt; do
    case "${opt}" in
        i)
            input_file="${OPTARG}"
            ;;
        o)
            output_file="${OPTARG}"
            ;;
        s)
            resolution="${OPTARG}"
            ;;
        r)
            frame_rate="${OPTARG}"
            ;;
        c)
            colors="${OPTARG}"
            ;;
        n)
            normalize_audio=true
            ;;
        *)
            echo "Error: Invalid option"
            echo "Invalid option: ${OPTARG}"
            usage
            ;;
    esac
done

# Check if input file is provided
if [ -z "${input_file}" ]; then
    echo "Error: Input file is required."
    usage
fi

# Extract base name of the input file without extension
input_base_name=$(basename "${input_file}" | sed 's/\.[^.]*$//')

# Set default output file if not provided
if [ -z "${output_file}" ]; then
    output_file="${input_base_name}.mp4"
fi

# Build the filter_complex string
filter_complex="[0:a]"

# Add loudnorm filter if normalization is enabled
if [ "${normalize_audio}" = true ]; then
    echo "Normalizing audio to EBU R128 using loudnorm..."
    filter_complex+="loudnorm,"
fi

# Add showspectrum filter
filter_complex+="showspectrum=s=${resolution}:color=${colors}:mode=combined:scale=${scaling}:gain=${gain}:fscale=${fscaling}:data=${data}:slide=scroll:start=${freqstart}:stop=${freqstop}[v]"

echo "Filter complex: ${filter_complex}"

# Run ffmpeg command
ffmpeg -y -i "${input_file}" -filter_complex "${filter_complex}" -map '[v]' -map '0:a' -c:v libx264 -pix_fmt yuv420p -r "${frame_rate}" -c:a aac -movflags +faststart "${output_file}" && echo "Video created successfully: ${output_file}"
```

### Image + Audio to Video: Convert an image and audio file into a video
This Bash script combines an image and an audio file into a video using ffmpeg. It allows you to specify the image, audio, and output file paths, as well as an optional fixed length for the video. The script ensures that paths are properly quoted and constructs the appropriate ffmpeg command.

#### Example

{{< video src="fountain-image" >}}

#### Usage

Convert a single image and single audio file to a video:
```bash
./imageaudio2video.sh -i "image.jpg" -a "audio.mp3" -o "output.mp4" 
```

Do it for all wav files in current folder:

```bash
for file in *.wav; do 
    ./imageaudio2video.sh -i "image.jpg" -a "$file" -o "${file%.wav}.mp4" 
done
```

#### Script

```bash
#!/bin/bash

# Combine an image and an audio file into a video using ffmpeg
# Usage: imageaudio2video.sh [-i <image_file>] [-a <audio_file>] [-o <output_file>] [-l <length>]

# Function to display usage information
usage() {
    echo "Usage: $0 [-i <image_file>] [-a <audio_file>] [-o <output_file>] [-l <length>]"
    echo "  -i  Input image file (required)"
    echo "  -a  Input audio file (required)"
    echo "  -o  Output video file (optional, default: output.mp4)"
    echo "  -l  Fixed length in seconds (optional, default: full audio length)"
    exit 1
}

# Default values
output_file="output.mp4"
length=""

# Parse command-line arguments
while getopts ":i:a:o:l:" opt; do
    case "${opt}" in
        i)
            image_file="${OPTARG}"
            ;;
        a)
            audio_file="${OPTARG}"
            ;;
        o)
            output_file="${OPTARG}"
            ;;
        l)
            length="${OPTARG}"
            ;;
        *)
            echo "Error: Invalid option"
            echo "Invalid option: ${OPTARG}"
            usage
            ;;
    esac
done

# Check if image and audio files are provided
if [ -z "${image_file}" ] || [ -z "${audio_file}" ]; then
    echo "Error: Image and audio files are required."
    usage
fi

# Construct the ffmpeg command
ffmpeg_command="ffmpeg -loop 1 -i ${image_file} -i ${audio_file} -c:v libx264 -c:a aac -b:a 320k -shortest -preset faster -pix_fmt yuv420p -tune stillimage \"${output_file}\""

# Add length parameter if provided
if [[ -n "${length}" ]]; then
    ffmpeg_command="ffmpeg -loop 1 -i ${image_file} -i ${audio_file} -c:v libx264 -c:a aac -b:a 320k -shortest -preset faster -pix_fmt yuv420p -tune stillimage -t ${length} \"${output_file}\""
fi

# Execute the ffmpeg command
echo "Executing: ${ffmpeg_command}"
eval ${ffmpeg_command}
```

{{< lfsquare animationSpeed=37s >}}

## Where to go from here?

You might like to get into messing with audio on the command line as well ? If so, [check out our guide on SoX](/blog/sox-guide).

If you found this post useful, please share it. And consider making a donation:

{{< kofi >}}

