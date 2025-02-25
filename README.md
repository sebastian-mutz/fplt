# FPLT

A Fortran plotting library built mostly on GMT (Generic Mapping Tools).

## Description

FPLT creates a Fortran interface for GMT through C bindings (using GMT's C API). An abstraction layer provides a few extras that make plotting a little easier. These extras include:
- derived types for colour maps and styles.
- derived types for options for different kinds of plots (maps, xy-scatter plots, etc.).
- automatic construction of colour maps and GMT argument strings from pre-defined or user-defined instances of the above.

## Development

FPLT is currently developed further "as needed" for my research, but I hope it may become useful for other researchers as it continues to grow. However, you are very welcome to contribute (through suggestions, coding, etc.) at any stage.

## Installation

FPLT can be installed/compiled with the Fortran Package Manager.
