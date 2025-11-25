# Windows 5.8 Starship Prompt Theme

This directory contains a custom **Starship** prompt configuration designed to emulate the look and structure of
Windows 95 and 98 system information panels. The theme uses Unicode box-drawing characters, simple emoji icons, and Starship's
formatting engine to create a nostalgic and retro terminal prompt that is still functional across modern shells. 

The goal of this configuration is to provide a fun, readable, multi-line prompt that recalls late-90s desktop computing while
remaining practical for daily use. 

## Table of Contents

1. Preview
2. Features
3. Requirements
4. Installation
5. Customization
6. Troubleshooting
7. License

## Preview 

```
┌─────────────── 🖥️ WINDOWS 98 SYSTEM
│ DIR: 📁 ~
│ DEVICES: 💾 A:\ READY 📞 DIAL-UP CONNECTED
│ HELPERS: 📎 Clippy ENABLED 🛡️ Norton 0 Threats
└> C:>\\\\█
```

## Features

- Classic Windows-inspired multi-line prompt layout
- Clear "system panel" design for directory, device info, and status
- Fully customizable Starship configuration
- Supports Bash, Zsh, Fish, and any Starship-compatible shell
- Works with Nerd Fonts and standard Unicode fonts

## Requirements

To ensure the interface renders correctly, use a Nerd Font or any fully Unicode-compatible font, such: 

- JetBrainsMono Nerd Font
- FiraCode Nerd Font
- Hack Nerd Font
- Iosevka Nerd Font

## Installation 

### 1. Install Starship

Downloand [Starship](https://starship.rs/guide/) and follow the guide.

### 2. Download & Copy Windows 5.8 File

Place the Windows 5.8 `starship.toml` file in `~/.config`.

### 3. Enable Starship in Your Shell

- **Bash**

`eval "$(starship init bash)"`

- **Zsh**

`eval "$(starship init zsh)"`

- **Fish**

`starship init fish | source`

### 4. Restart Your Terminal

## Customization 

### Modules

This theme uses Starship's `format` field to create a custom multi-line box. It also restyles:

- Directory module
- OS module
- Character module
- Symbol colors
- Prompt spacing

Add [Starship modules](https://starship.rs/config/) (git, node, python, battery, etc) inside the box layout if you want the theme 
to show more system information. 

### Emojis

All emojis were chosen to given early-internet vibes:

- 💾 — Floppy disk
- 📁 — File folder
- 📞 — Dial-up phone
- 📎 — Clippy
- 🛡️ — Norton AntiVirus
- 🖥️  — CRT computer

Replace the emojis with your favorites 90s symbols:

- 🕹️ — Joystick
- 📟 — Pager
- ⌨️ — Keyboard

### Colors

Starship uses style strings such as `green`. `blue`. `bold`, or hex values. 

```
[directory]
style = white
```

### Content

Modify or remove lines such as "DEVICES," "HELPERS," and rename the banner. 

## Troubleshooting

### Prompt Doesn't Load

You shell may not be initializing Starship. Verify that the correct `eval` command is present in your shell's
configuration file (`.bashrc`, `.zshrc`, etc).

### Unicode Character Look Incorrect

Switch to a Nerd Font or another fully UTF-8-compatible font. 

### Prompt Elements Appears Misaligned 

Try reducing or increasing your terminal's font size or disabling ligatures depening on the font. 

### Prompt Resets to a Single Line

Another tool (such as neofetch or fastfetch) may be overriding your shell prompt. Disable them in your configuration file to see
if that helps. 

## License

This theme is released under the MIT license. 
Feel free to modify, fork, and integrate it into your own setups. 
