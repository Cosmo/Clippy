# Clippy

Yes, Clippy from Microsoft Office is back — on macOS!

Clippy can be moved around (drag with mouse) and be animated (right-click).

The `SpriteKit`-Framework is used to animate through Clippy's sprite map.

## Usage

```sh
git clone https://github.com/Cosmo/Clippy.git
```

* Open project with Xcode
* Build and run macOS target

* Right-Click to animate.

## Todos

* [x] Animations (Right-Click → Animate!)
* [x] Sounds
  * [ ] Mute / Unmute
* [x] Always on top
* [x] Transparent when out of focus
* [x] Support for other agents
* [x] Status Bar Item
* [ ] Idle animations
* [ ] HitTest on transparent regions
* [ ] Original size / Zoom
* [ ] Mute
* [ ] Actions
  * [ ] Hide
  * [ ] Show
  * [ ] MoveTo x y
  * [ ] GestureAt x y
  * [x] Play animation
* [ ] Idle animations
* [ ] Languages
* [ ] Support branching and probability
* [ ] Control via command line

## Demo

![Demo](https://github.com/Cosmo/Clippy/blob/master/Clippy.gif?raw=true)

## Add other Agents

### Requirements

`brew install imagemagick`
`brew install ffmpeg`

### Conversion

This project includes an automated converter.
It converts opaque BMP sprites, removes backgrounds, puts them together to one big transparent PNG file and converts all sounds to MP3. 

#### Run converter

`./convert AGENT_PATH NEW_NAME`

`AGENT_PATH` path to decompiled agent.
`NEW_NAME` should only include lowercase letters and underscores.

#### Example

`./convert agents/CLIPPIT clippy`


## Attributions

Inspiration was taken from:

* https://github.com/tanathos/ClippyVS (C#)
* https://github.com/smore-inc/clippy.js (JavaScript)

Graphics were created by Microsoft.

## Contact

* Devran "Cosmo" Uenal
* Twitter: [@maccosmo](http://twitter.com/maccosmo)
