# FPLT

A Fortran plotting library built mostly on GMT (Generic Mapping Tools).

## Description

FPLT creates an fortran interface for GMT through C bindings (using GMT's C API). It adds another abstraction layer and provides a few extras that make make plotting a little easier. These extras include:
- derived types for colour maps.
- derived types for options for different types of plots (maps, xy-scatter plots, etc.).
- automatic construction of colour maps and GMT argument strings from pre-defined or user-defined instances of the above.

## Development

FPLT is currently developed further "as needed" for my research, but I hope it may become useful for other researchers as it continues to grow. However, you are very welcome to contribute (through suggestions, coding, etc.).

## Installation

FPLT can be installed/compiled with the Fortran Package Manager.
