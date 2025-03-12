---
title: "Hyaline Motor Controller XL"
date: 2025-03-09T17:45:42+01:00
draft: true
price: 0.00
images:
- /hyalinemotorcontrollerxl.jpg
repo: https://github.com/hyaline-systems/Hyaline-Motor-Controller-XL
#currency: €
#stock: 0
#shipping: "Free shipping worldwide."
tags: ['electronics', 'art', 'kinetic', 'raspberrypipico']
description: "Control motors using Raspberry Pi Pico (5v-15V, 4 DC motors or 2 stepper motors)."
---

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X8X6RXV10)

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)


A board for Raspberry Pi Pico compatible boards, designed for controlling motors.

It can be used with pretty much any Pico-like board. It uses an i2c-based interface for controlling the motors, which frees up a lot of gpio for other things – at the expense of a limited PWM frequency of 1.6khz maximum (which can cause audible high frequency noise in some motors). 

The board is completely decked out with a bunch of features to make it easy to hack and use it as the "brain" of a motorized project of any kind.

Designed by [Mads Kjeldgaard](https://madskjeldgaard.dk) for [hyaline.systems](https://hyaline.systems).

## Features

- Control 4 DC motors or 2 stepper motors
- Control the speed and direction of each motor
- Self-documenting: All pins and connections are written on the board itself.
- Encoder pins broken out for each motor
- All unused gpio pins broken out to headers
- Unused PWM pins broken out (you can control servos or LED's with these)
- Uses PCA9685 PWM driver via i2c – frees up a lot of pins (but also limits PWM frequency to 1.6khz max)
- NeoPIXEL LED on board for sassy RGB lighting
- RUN-button to allow restarting the Pico (big timesaver when programming it)
- I2C headers including StemmaQT/Qwiic connectors to allow connecting external sensors and devices via i2c.
- Power features:
    - 5V-15V input for motors
    - Reverse polarity protection
    - Onboard 5V regulator – the board only needs one power source to power both motors and the microcontroller board.
    - Power outputs for 3.3V, 5V and the motor power supply (after reverse polarity protection circuitry).
- Completely [open source](https://github.com/hyaline-systems/Hyaline-Motor-Controller-XL).
- 4 x M3 mounting holes
- Includes [software examples](https://github.com/hyaline-systems/Hyaline-Motor-Controller-XL/tree/main/software/examples).
- Small (59.07 mm x 76.33 mm)

## Datasheets

- PWM chip: [PCA9685](https://www.nxp.com/docs/en/data-sheet/PCA9685.pdf)
- Motor driver: [TB6612FNG](https://cdn.sparkfun.com/assets/0/1/b/b/3/TB6612FNG.pdf)


## Videos

{{< video src="motorcontrollerxl-demo1" >}}

*A silly demo: Randomizing the motor speeds and directions to make some bells jingle*.

## Credits

- Thanks [PCBWay](https://pcbway.com/) for sponsoring the PCB's for this project during prototyping.
- Thanks Thom, Niklas, Eirik, Fredrik and others for inspiration.

