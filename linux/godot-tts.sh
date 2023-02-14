#!/bin/sh

# Installs packages needed for Godot 4's TTS to work

sudo pacman -Syu spd-say festival espeakup

# This should say SOMETHING in SOME voice
spd-say "hi!"
