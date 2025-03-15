# <span style="color:#734f96">FPLT - Fortran Plotting Library</span>

[![GitHub](https://img.shields.io/github/license/sebastian-mutz/fplt)](https://github.com/sebastian-mutz/fplt/blob/main/LICENCE)
![20%](https://progress-bar.xyz/20?title=Alpha)


> [!IMPORTANT]
> FPLT is in a pre-alpha state, and only suitable for developers at this point.
>

## <span style="color:#734f96">Description</span>

![logo](doc/media/logo/FPLT_small.png)

FPLT is a scientific plotting library for producing high-quality ("publication-ready") figures quickly by leveraging the GMT(Generic Mapping Tools) C-API and modern Fortran's derived types. FPLT includes procedures for producing geographical maps, xy-plots, heat maps, animated figures, and more.

FPLT includes a Fortran interface for several GMT modules (using GMT’s C API). Additional features, provided through an abstraction layer, include Fortran derived types for colour maps, font management, and options for specific kinds of plots. Furthermore, FPLT includes procedures for the automatic construction of colour maps and (the infamously cryptic) GMT argument strings from pre-defined or user-defined options.

The aim is to create a library that lets you:

 - visualise your data directly from your Fortran programme though familiar Fortran-native constructs,
 - produce professional figures quickly through the use of templates and automatic argument construction,
 - modify or create new templates easily from your programme.

## <span style="color:#734f96">Example</span>

The following code modifies a colour map template *cmap_bluered01* before creating a temperature map of Europe using the *map_default* template. All templates are simple derived types with initialised values that can be overwritten, as done with *cmap_bluered01* below. The *fplt_map* subroutine automatically generates gmt arguments (based on  *map_default* template) and works through a stack of gmt modules to successively build your map "behind the scenes".

```fortran
program check_maps01

! load modules
  use :: fplt

! basic options
  implicit none

! modify preset colour map
  cmap_bluered01%z_min = -25
  cmap_bluered01%z_max = 25
  cmap_bluered01%z_step = 1

! set plot labels
  map_default%title = "Lambert Conic Conformal Projection"
  map_default%label_left = "2m air temperature"
  map_default%label_right = "deg C"

! change theme
  map_default%theme = "dark"

! change projection (L = Lambert conic conformal, default = Mercator)
  map_default%projection = "L"

! change colour map
  map_default%cmap = "bluered01"

! plot map from text file using the default map template
  call fplt_map(map_default, "data_Mutz_et_al_2018.asc", "map01.pdf")

end program check_maps01
```

The code above will generate the map below; not changing the projection and theme will make FPLT default to a Mercator projection and the light theme (map at bottom):

![map](doc/media/map.png)

## <span style="color:#734f96">Development</span>

FPLT is mostly developed “as needed” for my research. As such, it will cover a lot of different plot styles, but its features will never be exhaustive. However, you are very welcome to contribute and add new features (through suggestions, coding, etc.) at any stage.

### <span style="color:#734f96">Alpha</span>

I will consider the library to be in "alpha" once FPLT is able to reproduce ~80% of all the plots I've created in the past ~15 years.

### <span style="color:#734f96">Implemented and Planned Features</span>

#### <span style="color:#734f96">Plot Types</span> <br/>

![80%](https://progress-bar.xyz/80?title=Maps)
![0%](https://progress-bar.xyz/0?title=Heatmaps)
![0%](https://progress-bar.xyz/0?title=XYPlots)
![0%](https://progress-bar.xyz/0?title=BarPlots)

#### <span style="color:#734f96">Map Projections</span> <br/>

| Map Projections           | Implemented |
| ------------------------- | ----------- |
| Mercator                  | ✓           |
| Miller Cylindrical        | ✓           |
| Cylindrical Equidistant   | ✓           |
| Lambert Conic Conformal   | ✓           |
| Albers Conic Equal-Area   | ✓           |
| Equidistant Conic         | ✓           |
| Transverse Mercator       | -           |
| Orthographic              | -           |

#### <span style="color:#734f96">Progress Details</span> <br/>

| Features                  | Implemented |
| ------------------------- | ----------- |
| Bindings for GMT's C-API  | ✓           |
| Geographical maps         | ✓           |
| Heat maps                 | -           |
| XY scatter and line plots | -           |
| Bar plots                 | -           |
| GMT argument construction | 40%         |
| GMT module templates      | 20%         |
| GMT auto settings         | 50%         |
| Themes for plot setting   | ✓           |
| Auto-generate colour maps | ✓           |
| Auto label and positioning| 80%         |
| Read and convert text     | ✓           |
| Read and convert netcdf   | -           |


## <span style="color:#734f96">Installation</span>

FPLT can be installed/compiled with the [fortran package manager (fpm)](https://github.com/fortran-lang/fpm). You will need to make sure you have the [Generic Mapping Tools (GMT) 6](https://github.com/GenericMappingTools) lib installed and properly linked.


