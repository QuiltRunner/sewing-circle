# Arch Linux Fastfetch Config
A Fastfetch config for Arch Linux (or any distro) that uses a cyan and magenta accent palette, aligned keys, readable separators, and a couple of "fun" modules (media, weather, and color blocks).

## Preview
<img width="1355" height="612" alt="arch-fastfetch" src="https://github.com/user-attachments/assets/cdfa0132-995a-411d-9df9-8d78659c26eb" />

## Use
1. Install Fastfetch (Arch)
   - `sudo pacman -S fastfetch`
2. Save the config
   - Create the config directory if needed: `mkdir -p ~/.config/fastfetch` or `fastfetch --gen-config`
   - Save the jsonc as: `~/.config/fastfetch/config.jsonc` or open the general config found in `~/.config/fastfetch/` and replace with this jsonc.
3. Run Fastfetch
   - `fastfetch` or `fastfetch --config ~/.config/fastfetch/config.jsonc`
