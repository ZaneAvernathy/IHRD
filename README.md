
# International Hack Release Day

This repository is for the annual International Hack Release Day (`IHRD`) celebrated on the first of April.

Currently, this repository features hacks made for Fire Emblem: Thracia 776 and Fire Emblem: The Sacred Stones.

Please see the [releases](https://github.com/ZaneAvernathy/IHRD/releases) for premade `.ups` patches.

## Setup

First, install a recent version of [Python 3](https://www.python.org/) and make sure it's added to your PATH.

Obtain [DevkitARM from DevkitPro](https://devkitpro.org/) and make sure it's added to your PATH.

Place [CLib](https://github.com/StanHash/FE-CLib) (with the folder named `CLib`) in the `TOOLS` folder.
Place [Event Assembler](https://feuniverse.us/t/event-assembler/1749) (with the folder named `EventAssembler`) in the `TOOLS` folder.
Place [ColorzCore](https://feuniverse.us/t/colorzcore/3970) in the `TOOLS/EventAssembler` folder.
Place [ParseFile](https://github.com/FireEmblemUniverse/EAFormattingSuite/releases/tag/parsefile) in the `TOOLS` folder.
Place [lyn](https://feuniverse.us/t/ea-asm-tool-lyn-elf2ea-if-you-will/2986) in your `TOOLS/EventAssembler/Tools` folder.
Place [ea-dep](https://github.com/StanHash/ea-dep) in your `TOOLS/EventAssembler/Tools` folder.
Place [Volt Edge](https://github.com/ZaneAvernathy/VoltEdge) one folder up from root.
Place [64tass](https://sourceforge.net/projects/tass64/) in `TOOLS`

*Legally acquire* an unheadered ROM version of FE5 (named `FE5.sfc`, SHA-1 checksum `75B504921D08E313FF58150E40121AC701884517`) and the U version of FE8 (named `FE8U.gba`, SHA-1 checksum `C25B145E37456171ADA4B0D440BF88A19F4D509F`) and put them in the root folder.

Your final structure should look something like

```
VoltEdge/
  ...
<IHRD>
  TOOLS/
    ParseFile
    64tass
    CLib/
      ...
    EventAssembler/
      ColorzCore
      Tools/
        lyn
        ea-dep
        ...
      ...
    ...
  FE5.sfc
  FE8U.gba
  ...
...
```

## Usage

In the root folder:

`make <year>` e.g. `make 2023` to build that year's project as its own ROM.
`make all` to mash every year into a single ROM for their respective game (this will also build all of the years individually).

`make clean` will remove the output ROMs, `make veryclean` will delete all generated files.

## Credits

* [stan](https://github.com/StanHash) - CLib, lyn, ea-dep, makefiles, CHAX, wizardry, being incredible, the list goes on.
* [CrazyColorz5](https://github.com/CrazyColorz5) - ParseFile, Event Assembler, ColorzCore, the buildfile method.
* [soci](https://sourceforge.net/projects/tass64/) - 64tass

Misc. shout outs:
* circleseverywhere
* Hextator
* Nintenlord
* Leonarth
* Camdar
* Contro
* Snek
* Sme
* Huichelaar
* Teraspark
* Devvy
* Tequila
* Two Who Belong
* Vesly
