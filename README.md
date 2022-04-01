
# International Hack Release Day

This repository is for the annual International Hack Release Day (`IHRD`) celebrated on the first of April.

Most of this will be assembly hacks for Fire Emblem: Thracia 776, but some might also be other things.

### Building from source

For assembly hack projects:

These hacks are meant to be assembled with [**64tass**](https://sourceforge.net/projects/tass64/). They require the [**VoltEdge library**](https://github.com/ZaneAvernathy/VoltEdge).

Please edit the `Makefile` to reflect the location of your clean `FE5.sfc`, `64tass` executable, and `VOLTEDGE` folder.

Then, you can build individual years' projects with `make <year>`, i.e. `make 2022`. You can also just do `make` or `make all` to build every year's project along with a file that lumps all of them into one image.

Have fun!
