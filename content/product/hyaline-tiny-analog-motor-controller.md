---
title: "Tiny Analog Motor Controller"
date: 2025-03-09T17:45:42+01:00
draft: false
#price: 10.00
images:
- tinymotor.jpg
repo: https://codeberg.org/hyaline-systems/Tiny-Analog-Motor-Controller
#currency: €
#stock: 10
#shipping: "Free shipping worldwide."
tags: ['electronics', 'art', 'kinetic', '555']
description: "Simple, small and powerful analog motor controller."
---

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X8X6RXV10)

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

Designed by [Mads Kjeldgaard](https://madskjeldgaard.dk) for [hyaline.systems](https://hyaline.systems).

## Features

- Easy to use: Just connect power at one end, a motor at the other end.
- Power: 5-12V DC  
- Control speed using a potentiometer.
- Hackable: Pins broken out to allow daisy chaining boards, or connecting circuitry in between the PWM signal and the motor gate (eg a button, an LDR or whatever).
- Based on a 555 timer chip in astable mode.
- 4 x M3 mounting holes
- Completely [open source](https://codeberg.org/hyaline-systems/Tiny-Analog-Motor-Controller).
- Tiny (about the size of a matchbox)

## Videos

{{< youtube 8T458q-4F3A >}}

{{< youtube vgZMr6bK9-s >}}

{{< masto link="https://social.ordinal.garden/@t36s/114431780934173209/embed" >}}

{{< youtube 2x3-BIKj-YE >}}

## Datasheets

- 555 chip: [LMC555](https://www.ti.com/lit/ds/symlink/lmc555.pdf)
- Motor mosfet: [Infineon IRFS3806TRLPBF](https://eu.mouser.com/datasheet/2/196/Infineon_IRFS3806_DataSheet_v01_01_EN-3363385.pdf) (but any similar mosfet will do the job).

## Credits

- Thanks [PCBWay](https://pcbway.com/) for sponsoring the PCB's for this project during prototyping.
- Thanks Thom, Niklas, Eirik, Fredrik and others for inspiration.

