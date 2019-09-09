# Clippy

Yes, Clippy from Microsoft Office is back — on macOS!

Clippy can be moved around (drag with mouse) and be animated (right-click).

The `SpriteKit`-Framework is used to animate through Clippy's sprite map.

## First start

1. [Download Clippy for macOS](https://github.com/Cosmo/Clippy/releases/download/2.0.0/Clippy.zip) or build from source.
2. Run
3. Click `📎` → `Show in Finder` in the menu bar
4. Unzip all files
5. Click `📎` → `Reload`
6. Pick an Agent under `📎` → `Agents` → `…`


## Todos

* [x] Animations (Right-Click → Animate!)
* [x] Always on top
* [x] Sounds
  * [x] Mute / Unmute
* [x] Transparent when out of focus
* [x] Support for other agents
* [x] Agent picker 
* [x] Menu bar Item
* [ ] Original size / Zoom
* [ ] Actions
  * [x] Hide
  * [x] Show
  * [ ] MoveTo x y
  * [ ] GestureAt x y
  * [x] Play animation
* [ ] HitTest on transparent regions
* [ ] Support branching and probability
* [ ] Idle animations
* [ ] Languages
* [ ] Control via command line

## Demo

![Demo](https://github.com/Cosmo/Clippy/blob/master/Clippy.gif?raw=true)


## Build

```sh
git clone https://github.com/Cosmo/Clippy.git
```

* Open project with Xcode
* Build and run macOS target


## Add other Agents (optional)

An `*.acs` file includes all required resources (bitmaps, sounds, definitions, etc.) of an agent.
Unfortunately, this project does not support `*.acs` files, but pull-requests are welcome.
 
Until then, you can convert `*.acs` files with the "[Lebeau Software](http://www.lebeausoftware.org/software/decompile.aspx)" by  Lebeau Software.
This software extracts all resources, that we can convert and read.
There are a few steps involved.

### Requirements

```
brew install imagemagick
```
Will be used to merge single `*.bmp` sprites into a single 32 bit PNG-file. 


```
brew install ffmpeg
```
Will be used to convert `*.wav`-files in RIFF format to MP3 files.

### Conversion

Included in this project is a converter called `agent-converter.sh`.
This tool converts opaque BMP sprites, removes background colors, puts them together to one big transparent PNG file and converts all sounds to MP3. 

`./agent-convert.sh AGENT_PATH NEW_NAME`

`AGENT_PATH` path to decompiled agent.
`NEW_NAME` should only include lowercase letters and underscores.

#### Example

`./agent-convert agents/CLIPPIT clippy`

### Final step

After the conversion step, you will get a new folder called `NEW_NAME.agent`.


## Attributions

Inspiration was taken from:

* https://github.com/tanathos/ClippyVS (C#)
* https://github.com/smore-inc/clippy.js (JavaScript)

Graphics were created by *Microsoft*.

## Contact

* Devran "Cosmo" Uenal
* Twitter: [@maccosmo](http://twitter.com/maccosmo)
