# <span style="color:#734f96">FPLT - Fortran Plotting Library</span>

![image info](./doc/logo/FPLT.png)

## <span style="color:#734f96">Description</span>

A scientific plotting library for producing high-quality ("publication-ready") figures quickly by leveraging the GMT(Generic Mapping Tools) C-API and modern Fortran's derived types. FPLT includes procedures for producing geographical maps, xy-plots, heat maps, animated figures, and more.

FPLT includes a Fortran interface for several GMT modules (using GMT’s C API). Additional features, provided through an abstraction layer, include Fortran derived types for colour maps, font management, and options for specific kinds of plots. Furthermore, FPLT includes procedures for the automatic construction of colour maps and (the infamously cryptic) GMT argument strings from pre-defined or user-defined options.

The aim is to create a library that lets you:

 - visualise your data directly from your Fortran programme though familiar Fortran-native constructs,
 - produce professional figures quickly through the use of templates and automatic argument construction,
 - modify or create new templates easily from your programme (since these are simple Fortran-native constructs).

## <span style="color:#734f96">Example</span>

The following code modifies a colour map template *cmap_monochrome* before creating a topographic map of europe using the *map_europe* template. All templates are simple derived types with initialised values that can be overwritten, as done with *cmap_monochrome* below. The *fplt_map* subroutine automatically generates gmt arguments (based on  *map_europe* template) and works through a stack of gmt modules to successively build your map "behind the scenes".

```
program main

! load library
  use :: fplt

  implicit none

! choose colour map
  map_europe%cmap = "monochrome"

! modify lower bound of colour map present (start with dark grey, not black)
  cmap_monochrome%rgb(:,1) =[50, 50, 50]

! modify template value range and step size
  cmap_monochrome%z_max = 2000
  cmap_monochrome%z_step = 250

! create a topography map of europe using the "map_europe" template
  call fplt_map(map_europe, "infile_topo.grd", "outfile.ps")

end program main
```

The code above will generate the map below:

![image info](./doc/map_europe.png)

## <span style="color:#734f96">Development</span>

FPLT is mostly developed “as needed” for my research. You are very welcome to contribute (through suggestions, coding, etc.) at any stage. The library is in early development stages, but already usable for a few type of plots. See details below.

## <span style="color:#734f96">Implemented and Planned Features</span>

![20%](https://progress-bar.xyz/20?title=Beta)

### <span style="color:#734f96">Plot Types</span> <br/>

| Feature                   | Implemented |
| ------------------------- | ----------- |
| Maps (Cylindrical Proj.)  | ✓           |
| Maps (Conic Proj.)        | -           |
| Maps (Orthographic Proj.) | -           |
| Heatmaps                  | -           |
| xy scatter plots          | -           |
| xy line graphs            | -           |
| bar plots                 | -           |


### <span style="color:#734f96">Technical Features</span> <br/>

| Feature                   | Implemented |
| ------------------------- | ----------- |
| Bindings for GMT C-APIs   | 50%         |
| GMT argument construction | 20%         |
| GMT module templates      | 20%         |
| Make colour maps          | 50%         |
| Autolabel                 | 80%         |
| Read text                 | ✓           |
| Read netcdf               | -           |
| Convert text to grid      | ✓           |
| Convert netcdf to grid    | -           |


## <span style="color:#734f96">Installation</span>

FPLT can be installed/compiled with the [fortran package manager (fpm)](https://github.com/fortran-lang/fpm).
