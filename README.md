# About

This is the re-assembled source code for *Master Editor*, a combination of three graphics tools by H. Rosenfeldt, first published in a special issue of the German magazine *64'er* in 1989. The included tools are:

- a character editor
- a screen editor
- a sprite editor

## Modifications

I have made some modifications to the orginal program, see the [ChangeLog](./ChangeLog.md) for details.

# Build instructions

## Prerequisites

- [dasm assembler](https://dasm-assembler.github.io)
- [mk64](https://github.com/Zirias/c64_tool_mkd64)
- [Exomizer](https://bitbucket.org/magli143/exomizer/wiki/Home)
- [GNU make](https://www.gnu.org/software/make)

## Building

1. Type `make`
1. That's all :grin:

The output is a [D64 disk image](./dist/master-editor.d64) as well as a [PRG file](./dist/master-editor.prg) that can be started directly via `make run` (requires [VICE](https://vice-emu.sourceforge.io)), both to be found in the [dist](./dist/) sub-directory.

# Usage instructions

## Starting

```
LOAD"*",8
RUN
```
## Operating

The main program menu allows selecting between the three editors, getting a directory listing, issuing floppy commands, executing a "special" (user-defined) program, or performing a warm reset to BASIC.

The editor functions themselves can be accessed via keyboard shortcuts. I have included the [original article](./doc/anleitung_64er_sh42.pdf) introducing *Master Editor* from the *64'er* magazine, which is in German. For English speakers I will try to briefly list the keyboard shortcuts below.

### Character Editor


#### Basic settings

| Key | Function |
|---|---|
| `M` | Toggle between single and multi-colour mode. |
| `C` | Choose colours (MC mode). |
| `O` + `SHIFT-£` | Copy charset #1 to editor memory. |
| `SHIFT-O` + `SHIFT-£` | Copy charset #2 to editor memory. |
| `Q` | Return to main program menu. |

#### Creating characters

| Key | Function |
|---|---|
| `F1` | Select character to the right. |
| `F3` | Select character to the left. |
| `F5` | Select character above. |
| `F7` | Select character below. |
| `SHIFT` + `CLR/HOME` | Erase all characters in charset. |
| `1` | Select colour #1. |
| `2` | Select colour #2. |
| `3` | Select colour #3. |
| `SPACE` | Set or erase the point under cursor in the current character. |

#### Transforming characters

| Key | Function |
|---|---|
| `T` | Copy a character, whose code you will be prompted for, to the cursor location. |
| `I` | Invert character. |

#### Loading and saving

| Key | Function |
|---|---|
| `S` | Save the current character set to disk. |
| `L` | Load a character set from disk. |

___

### Screen editor

#### Basic settings

| Key | Function |
|---|---|
| `CTRL` | Toggle between command and write mode. |

The following keys must be entered in command mode.

| Key | Function |
|---|---|
| `M` | Toggle between single and multi-colour mode. |
| `C` | Choose colour. |
| `B` | Set screen starting address. |
| `E` | Set width of screen in characters. |
| `F` `RET` | After pressing `F` `RET`, press an arbitrary key to fill the screen with the corresponding character. |

#### Further commands

| Key | Function |
|---|---|
| `S` | Save the current screen to disk. |
| `L` | Load a screen from disk. |
| `Q` | Return to main program menu. |

#### Screen creation

In write mode, use the cursor keys to position the cursor and set the desired character by pressing the corresponding key.

| Key | Function |
|---|---|
| `F7`| Toggle between normal and reverse characters. |
| `F1` | Scroll screen to the left by 1 character. |
| `F3` | Scroll screen to the right by 1 character. |
| `F2`| Scroll screen to the left by 11 characters. |
| `F3` | Scroll screen to the right by 11 characters. |
| `F5` | Toggle "pen" down (the currently selected character will be drawn with every cursor movement) or up. |
| `P` | Send the entire screen to a connected printer. |

___

### Sprite editor

#### Basic settings

| Key | Function |
|---|---|
| `M` | Toggle between single-color, overlay, and multi-colour mode. |
| `C` | Choose colours. |
| `F1` | Increment selected sprite block by 1. |
| `F2` | Increment selected sprite block by 16. |
| `F3` | Decrement selected sprite block by 1. |
| `F4` | Decrement selected sprite block by 16. |
| `Q` | Return to main program menu. |

#### Sprite creation

| Key | Function |
|---|---|
| `SHIFT` + `CLR/HOME` | Erase current sprite. |
| `F7` | Switch between set and clear mode. |
| `SPACE` | Set/erase the point under cursor in the current sprite. |
| `1` | Select colour #1. |
| `2` | Select colour #2. |
| `3` | Select colour #3. |
| `F5` | Toggle "pen" down (a point will be drawn with every cursor movement) or up. |
| `CLR/HOME` | Position cursor in the upper-left corner |
| `E` | Expand sprite on the X- or Y-axis (press `Y`or `N`). Press `RET` when done. |
| `T` | Copy a sprite whose sprite block number must be entered at the prompt to the currently selected sprite block. |
| `RET` | Toggle between sprite table and editor. In the sprite table, use `F1`to `F4` and `Y`/`N`to set parameters. |
| `D` | First populate the upper half of the sprite table and return to the editor before issuing this command. The sprites from the sprite table will be displayed. Use `0`to`7` and the cursor keys to position the sprites. Press `Q` to return to the editor. |
| `A` | First populate the lower half of the sprite table, use `D` to position the sprites, and return to the editor before issuing this command. This will play the configured sprite animation. |
| `Q` | Return to main program menu. |

#### Loading and saving

| Key | Function |
|---|---|
| `S` | Save the current sprite to disk. |
| `L` | Load a sprite from disk. |
