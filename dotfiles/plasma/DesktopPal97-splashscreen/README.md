# DesktopPal97 - Plasma 6 Splash Screen (Fork)
This repo is a Plasma 6-compatible fork of the original DesktopPal97 Global Theme, created to restore splash screen functionality under KDE Plasma 6.

Original Project:
https://www.pling.com/p/1985239/.

Plasma 6 changed how splash screens are discovered, validated, and loaded. As a result, Plasma-5 era themes like DesktopPal97 may appear selectable but silently fall back to the default splash at boot. This repo adapts the theme's metadata and Splash.qml files to meet Plasma 6 requirements.

## Repo Files
This repo includes all files required for a working Plasma 6 splash screen:
- Global theme (`look-and-feel`) `metadata.json`
- Splash-specific `metadata.json`
- Updated Plasma-6 compatible `Splash.qml`
- Image and asset files used by the splash

## Directory Structure
```
DesktopPal97/
  ├── metadata.json/
  └── contents/
  └── splash/
  ├── metadata.json
  ├── Splash.qml
  └── images/
```
## Installation
1. Copy the `DesktopPal97` directory to your local Plasma themes folder:
```
mkdir -p ~/.local/share/plasma/look-and-feel
cp -r DesktopPal97 ~/.local/share/plasma/look-and-feel/
```
2. Clear the Plasma theme and package cache:
```
rm -rf ~/.cache/plasma*
rm -rf ~/.cache/kpackage*
```
3. Restart Plasma
```
plasmashell --replace &
```
4. Open System Settings > Appearance:
5. Select DesktopPal in Splash Screen
6. Reboot to verify splash displays correctly

## Credits
All original visual design, concept, and inspiration belong to the original DesktopPal97 author. Found here: https://www.opencode.net/bunnymnemonic/desktoppal97.

This fork focuses on compatibility and maintenance. 

## License
This repo and all included files are distributed under the terms of the GNU Affero General Public License Version 3 (AGPL-3.0).

For the full license text, see `LICENSE` in this repo or view it here: https://www.gnu.org/licenses/agpl-3.0.html.

   
