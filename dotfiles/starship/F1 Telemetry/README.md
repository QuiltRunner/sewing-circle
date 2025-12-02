# F1 Telemetry Starship Prompt

This Starship prompt theme turns your terminal into a race-engineer telemetry 
display. The layout uses a vertical boxed structure and pastel color scheme 
(lavender, magenta, cyan, and teal) to create a clean, readable interface with 
a motorsport feel. 

The configuration uses built-in Starship modules making it portable and stable 
across shells and systems.

## Preview
```
┌──────────────────────────┐
│ 🏁 F1 • TELEMETRY PANEL
│ CHASSIS: Fedora Linux
│ CAR #: fedora-x86
│ TRACK: ~🏆/projects/
│ ENGINE LOAD: 42%
│ PIT: 🚥 main ✓
│ LAP TIME: 113ms
│ CLOCK: 20:55:10
└──────────────────────────┘
➤
```

## Telemetry-Style Metrics

- Chassis | OS
- Car Number | Hostname
- Track Position | Directory
- Engine Load | Memory Usage
- Pit Data | Git
- Lap Time | Command Duration
- Session Clock | Time

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

This theme uses Starship's `format` field to create a custom multi-line box. 
It also restyles:

- Directory module
- OS module
- Character module
- Symbol colors
- Prompt spacing

Add [Starship modules](https://starship.rs/config/) (git, node, python, 
battery, etc) inside the box layout if you want the theme 
to show more system information. 

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

You shell may not be initializing Starship. Verify that the correct `eval` 
command is present in your shell's
configuration file (`.bashrc`, `.zshrc`, etc).

### Unicode Character Look Incorrect

Switch to a Nerd Font or another fully UTF-8-compatible font. 

### Prompt Elements Appears Misaligned 

Try reducing or increasing your terminal's font size or disabling ligatures 
depening on the font. 

### Prompt Resets to a Single Line

Another tool (such as neofetch or fastfetch) may be overriding your shell 
prompt. Disable them in your configuration file to see
if that helps. 

## License

This theme is released under the MIT license. 
Feel free to modify, fork, and integrate it into your own setups. 
