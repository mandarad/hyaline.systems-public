+++
title = 'Linux tutorial: Starting an audio program after boot'
date = 2025-03-06
draft = true
author = "Mads Kjeldgaard"
authorlink = "https://madskjeldgaard.dk"
tags = ['linux', 'raspberrypi', 'tutorial', 'audioprocessing', 'bash', 'cli', 'systemd', 'jack', 'supercollider', 'puredata']
toc = true
description = "Turn any computer or Raspberry Pi into a dedicated audio device, music instrument or installation, with everything audio related automatically and correctly started every time the device turns on."
images = ["/tapemachine.jpg"]
+++

{{< kofi >}}

## Introduction

Basing a music instrument or audio system on a Linux system or Raspberry Pi is a great idea, but getting it to start up properly with all audio systems and programs in the correct order can be a hassle. That said, it *IS* possible, and in this tutorial we show you how.

The following will show you how to set up your system so that JACK is automatically started as an audio server after the computer boots. Then, when JACK is ready to make sound via your sound interface, it runs a script that starts any audio software of your choice. An example is shown of how to do this with SuperCollider but it could be any software really.

It's really just a bit of Linux plumbing that needs to happen when the system boots:

1. Wait for all audio drivers and audio components of the boot process to finish (done using `systemd`)
2. Then and only then start up JACK as your audio server
3. Wait for JACK to be ready
4. Once JACK is ready and started, run your audio software

It is crucial that these steps happen in this order – and thankfully we can do all of this automatically with a bit of setup using `systemd` – the program responsible for managing the bootup process and services in your Linux system.

## Setting up user and group

```bash
groupadd audio 
usermod -a -G audio $USER
```

{{< lftri >}}

## Setting up Jack 

### Installation

#### Debian-based systems

```bash
sudo apt-get install jackd2
```

### Arch based systems

Using an AUR-helper like `yay`, install both jack and the example tools (which contains `jack_wait` – needed in our systemd-service below):

```bash
yay -S jack2 jack-example-tools
```

### Configuration file
We need a configuration file for Jack. This is where you set sample rate and other things. 

If you already have a `.jackdrc` in your home folder, skip this part.

```bash
echo "/usr/bin/jackd -P95 -dalsa -dhw:0 -r44100 -n3 -p512" > /home/$USER/.jackdrc
```


{{< lftri animationSpeed=100s >}}

## Plugging into systemd

### Start JACK when audio system is ready

To automatically boot JACK with the configurations file we set up earlier, we need to create a systemd-service.

This will be triggered when all audio in your system is ready.

```bash
echo "
# A systemd service file that will be responsible for starting jack once audio is initialized
[Unit]
After=sound.target
Description=Starts jack when audio is ready on the system

[Service]
Type=simple
User=$USER
Group=audio
Environment="JACK_NO_AUDIO_RESERVATION=1"
LimitRTPRIO=99
LimitMEMLOCK=infinity
ExecStart=/usr/bin/zsh /home/$USER/.jackdrc

ExecStartPost=/usr/bin/jack_wait -w -t 10
Restart=on-failure
TimeoutSec=30

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/start-jack.service

sudo systemctl enable start-jack.service --now
```

Check it worked:
```bash
systemctl status start-jack.service
```
### Run script when JACK is ready

```bash
echo "
[Unit]
Description=After the jack audio system has started, this will be launched
After=start-jack.service

[Service]
Type=simple
User=$USER
Group=audio
CapabilityBoundingSet=CAP_SYS_NICE
AmbientCapabilities=CAP_SYS_NICE
ExecStart=/usr/bin/bash /home/$USER/post-jack.sh

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/after-jack.service
```

Check it worked:
```bash
systemctl status after-jack.service
```

{{< lfsine animationSpeed=100s >}}

## The script: Actually starting your audio software

Okay, phew, we are now ready to start a piece of audio software.

Let's create a script which will be run when the audio system has started, and JACK has been booted up and is ready to make sound.

Now, this script could be any audio software you want. Popular choices are [Pure Data](https://puredata.info/) or [SuperCollider](https://supercollider.github.io/).

I won't go over how to install any of them here but here is an example of a script that starts SuperCollider in a headless state, running a file called `startup.scd`.

What is important here is that this startup script is called `post-jack.sh` and is placed in the home folder of your user because this is what systemd relies on.

```bash

echo "
#!/bin/bash

export QT_QPA_PLATFORM=offscreen
sclang startup.scd
" > /home/$USER/post-jack.sh
```


{{< kofi >}}
