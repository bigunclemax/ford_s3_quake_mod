# The Quake 2 port for Ford Sync 3

This is a port of id Software's Quake II for Ford SYNC3 multimedia
(QNX 6.5/6.6 underhood).

It is based on [Thenesis Quake II v1.1](https://github.com/thenesis-org/lp-public)

[![Watch the video](https://img.youtube.com/vi/fBfvJPajBew/maxresdefault.jpg)](https://youtu.be/fBfvJPajBew)

## How to use
**ℹ️ The package contains only the Quake 2 DEMO `pak0.pak` file.**  

In order to use the Full version, you need to get the `pak0.pak` file
from a **legit purchased** copy of the game and put them
inside the `SyncMyMod\files\other\quake2\baseq2` folder.

## Supported input devices
**⚠️ Bluetooth connections are not supported and will not work**  

The game input relies on self written lib on top of QNX usb-hid subsystem.  
It **supports USB mouse and keyboard** and also it supports several
game controllers.

Tested gamepads list:
 - PS4 Dualshock
 - PS5 DualSense

This list is not complete, therefore feel free to test others
and let us know if they works 😉

## Known bugs and limitations
- No sound.  
  Sound part in not ported yet.

- Popup "USB device not supported".  
  Just ignore this message. It doesn't affect to anything.

## Source code
Source code and build instructions may be found [here](https://github.com/bigunclemax/ford_s3_quake)

## Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [0.1] - 2024-04-26
- Initial Release.

### [0.2] - 2024-05-09
- Updated binary file to be executed on top of Sync 3 HMI.
- Added saves 'restore' feature during app update procedure.
- Moved installation folder to /images partition.

### [0.3] - 2024-05-10
- Fixed a permissions issue in autoinstall.sh

