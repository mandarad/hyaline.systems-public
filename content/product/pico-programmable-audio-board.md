---
title: "Pico Programmable Audio Board"
date: 2025-03-23
draft: false
price: 0.00
images:
- picoprogrammableaudioboard.jpg
repo: https://codeberg.org/hyaline-systems/Pico-Programmable-Audio-Board
#currency: €
#stock: 0
#shipping: "Free shipping worldwide."
tags: ['electronics', 'art', 'sound', 'arduino', 'dsp', 'pico']
description: "Audio development board for the Raspberry Pi PIco"
---

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X8X6RXV10)

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

A development board for working with audio, SD cards, hardware midi and sensors on the Raspberry Pi Pico. 

Use this board to create interactive art projects, synthesizers, audio file players, props, USB audio interfaces, you name it.

Designed by [Mads Kjeldgaard](https://madskjeldgaard.dk) for [hyaline.systems](https://hyaline.systems).

## Features

- High quality i2s stereo output DAC with 3.5mm line out jack: [PCM5102A DAC](https://www.ti.com/product/PCM5102A) – this DAC is widely compatible with all platforms and SDK's, including Arduino and C.
- SD card reader
- NeoPixel
- Hardware MIDI in and out.
- Compatible with all Pico-compatible boards, including Pico 1, PicoW and Pico 2.
- StemmaQT connector for easy i2c expansion.
- Power: Use external power (5V) or power from USB on Pico. Circuit will automatically switch between these two sources, depending on what's available. Includes reverse polarity protection on power input.
- Optional: Hardware mute button may be connected directly to DAC.
- All remaining pins broken out with lots of ground and power pins to make external connections easy
- Reset button connected to RUN on the Pico to make it easy to restart the Pico.
- Self-documenting board: All pins and connections are written on the board itself.
- 4 x M3 mounting holes


