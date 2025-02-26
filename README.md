# <span style="color:#734f96">FPLT - Fortran Plotting Library</span>

A Fortran plotting library built mostly on GMT (Generic Mapping Tools).

## <span style="color:#734f96">Description</span>

![image info](./doc/logo/FPLT.png)

FPLT is a Fortran plotting library for producing publication-ready, high quality geographical maps, xy-plots, heat maps, animated figures, and more. It is built mostly on GMT (Generic Mapping Tools). FPLT includes a Fortran interface for several GMT modules (using GMT’s C API). Additional features, provided through an abstraction layer, include Fortran derived types for colour maps, font management, and options for specific kinds of plots. Furthermore, FPLT includes procedures for the automatic construction of colour maps and (the infamously cryptic) GMT argument strings from pre-defined or user-defined option sets.

The aim is to create a library that lets you:
 - visualise your data directly from your Fortran programme,
 - produce professional figures quickly through the use of presets and automatic argument construction,
 - modify or create new presets easily from your programme (since these are simple data collections in the form of Fortran derived types).

## <span style="color:#734f96">Example</span>

The following code modifies a colour map preset *cmap_monochrome* before creating a topographic map of europe using the *map_europe* preset. All presets are simple derived types with initialised values that can be overwritten, as done with *cmap_monochrome* below. The *fplt_map* subroutine automatically generates gmt arguments (based on  *map_europe* presets) and works through a stack of gmt modules to successively build your map "behind the scenes".

```
program main

! load library
  use :: fplt

  implicit none

! modify lower bound of colour map present
  cmap_monochrome%rgb(:,1) =[50, 50, 50]

! modify preset value range and step size
  cmap_monochrome%z_max = 2000
  cmap_monochrome%z_step = 250

! create a topography map of europe using the "map_europe" template
  call fplt_map(map_europe, "ETOPO1_Bed_g_gmt4.grd", "topo.ps")

end program main
```

The code above will generate the map below:

![image info](./doc/map_europe.png)

## <span style="color:#734f96">Development</span>

FPLT is mostly developed “as needed” for my research, but it may become useful for other researchers as it continues to grow - you are very welcome to contribute (through suggestions, coding, etc.) at any stage.

## <span style="color:#734f96">Installation</span>

FPLT can be installed/compiled with the [fortran package manager (fpm)](https://github.com/fortran-lang/fpm).
