module fplt_arg

! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Module for argument construction.                                  |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! FORD
!! Module for argument construction.

! load modules
  use :: fplt_typ
  use :: fplt_utl

! basic options
  implicit none
  private

! declare public procedures
  public :: f_arg_xyz2grd, f_arg_settings, f_arg_cmap, f_arg_map, f_arg_finish


contains


! ==================================================================== !
! -------------------------------------------------------------------- !
function f_arg_xyz2grd(map_opt, outfile) result(fstring)

! ==== Description
!! Crafts a fortran argument string for converting an xyz text file
!! to a grid file.

! ==== Declarations
  type(TYP_map)     , intent(in) :: map_opt
  character(len=*)  , intent(in) :: outfile
  character(len=256)             :: fstring

! ==== Instructions

! start with infile
  fstring = trim(map_opt%infile)

! region option
  fstring = trim(fstring) // " -R"&
  & // trim(f_utl_r2c( map_opt%xmin )) // "/"&
  & // trim(f_utl_r2c( map_opt%xmax )) // "/"&
  & // trim(f_utl_r2c( map_opt%ymin )) // "/"&
  & // trim(f_utl_r2c( map_opt%ymax ))

! set grid spacing; make high res (1 degrees) as default
! TODO: worth making an option? not an attribute of map, so perhaps make
! derived type for files. Alternatively determine automatically
! NOTE: this MUST be 1 for all heatmaps
  fstring = trim(fstring) // " -I1d"

! grid output
  fstring = trim(fstring) // " -G" // trim(outfile)

end function f_arg_xyz2grd


! ==================================================================== !
! -------------------------------------------------------------------- !
function f_arg_finish(outfile, format) result(fstring)

! ==== Description
!! Crafts a fortran argument string for cropping an image.

! ==== Declarations
  character(len=*)  , intent(in) :: outfile
  character(len=16) , intent(in) :: format
  character(len=256)             :: fstring

! ==== Instructions

! start with outfile
  fstring = trim(outfile)

! automated cropping (A)
  fstring = trim(fstring) // " -A -T"

! format option
  select case (format)
     case ("bmp", "BMP")
        fstring = trim(fstring) // "b"
     case ("eps", "EPS")
        fstring = trim(fstring) // "e"
     case ("pdf", "PDF")
        fstring = trim(fstring) // "f"
     case ("jpg", "jpeg", "JPG", "JPEG")
        fstring = trim(fstring) // "j"
     case ("png", "PNG")
        fstring = trim(fstring) // "g"
     case ("pnga", "PNGA") ! png with transparent untouched regions
        fstring = trim(fstring) // "G"
     case ("ppm", "PPM")
        fstring = trim(fstring) // "m"
     case ("tif", "tiff", "TIF", "TIFF")
        fstring = trim(fstring) // "t"
  end select

end function f_arg_finish


! ==================================================================== !
! -------------------------------------------------------------------- !
function f_arg_settings(param, settings) result(fstring)

! ==== Description
!! Crafts a fortran argument string for gmt settings;
!! argument string to be used in the gmtset module.

! ==== Declarations
  character(len=256), intent(in) :: param
  type(TYP_settings), intent(in) :: settings
  character(len=256)             :: fstring

! ==== Instructions

  select case (param)

     ! paper settings
     case ("size")
        fstring = "PS_MEDIA Custom_"&
        & // trim(f_utl_r2c( settings%paper_height )) // "x"&
        & // trim(f_utl_r2c( settings%paper_width )) // "p"

    ! page background colour
     case ("page")
        fstring = "PS_PAGE_COLOR "&
        & // trim(f_utl_i2c( settings%col_background(1) )) // "/"&
        & // trim(f_utl_i2c( settings%col_background(2) )) // "/"&
        & // trim(f_utl_i2c( settings%col_background(3) ))

     ! map frame colour
     case ("frame")
        fstring = "MAP_FRAME_PEN "&
        & // trim(f_utl_i2c( settings%col_frame(1) )) // "/"&
        & // trim(f_utl_i2c( settings%col_frame(2) )) // "/"&
        & // trim(f_utl_i2c( settings%col_frame(3) ))

     ! map grid line colour
     case ("grid")
        fstring = "MAP_GRID_PEN_PRIMARY "&
        & // trim(f_utl_i2c( settings%col_lines_primary(1) )) // "/"&
        & // trim(f_utl_i2c( settings%col_lines_primary(2) )) // "/"&
        & // trim(f_utl_i2c( settings%col_lines_primary(3) ))

    ! map annotation colour (make same as primary font)
     case ("tick")
        fstring = "MAP_TICK_PEN_PRIMARY "&
        & // trim(f_utl_i2c( settings%col_font_primary(1) )) // "/"&
        & // trim(f_utl_i2c( settings%col_font_primary(2) )) // "/"&
        & // trim(f_utl_i2c( settings%col_font_primary(3) ))

     ! font options
     case ("font")
        fstring = "FONT_ANNOT_PRIMARY "&
        & // trim(f_utl_r2c( settings%font_size_primary )) // "p,"&
        & // char(34) // trim( settings%font ) // char(34) // ","&
        & // trim(f_utl_i2c( settings%col_font_primary(1) )) // "/"&
        & // trim(f_utl_i2c( settings%col_font_primary(2) )) // "/"&
        & // trim(f_utl_i2c( settings%col_font_primary(3) ))
  end select

end function f_arg_settings


! ==================================================================== !
! -------------------------------------------------------------------- !
function f_arg_cmap(map_opt, cmap_opt) result(fstring)

! ==== Description
!! Crafts a fortran argument string for making a colour map;
!! argument string to be used in the gmt module.

! ==== Declarations
  type(TYP_map)     , intent(in) :: map_opt
  type(TYP_cmap)    , intent(in) :: cmap_opt
  character(len=256)             :: fstring
  character(len=32)              :: fstring_partial
  integer(i4)                    :: i

! ==== Instructions

! ---- RGB args
  fstring = " -C"
! loop through all rgb values and append to-be-used ones to arguments
  do i=1,size(cmap_opt%picker)-1
     if (cmap_opt%picker(i) .eq. 1) then
        fstring = trim(fstring)&
        & // trim(f_utl_i2c( cmap_opt%rgb(1,i) )) // "/"&
        & // trim(f_utl_i2c( cmap_opt%rgb(2,i) )) // "/"&
        & // trim(f_utl_i2c( cmap_opt%rgb(3,i) )) // ","
     endif
  enddo
! append string for last rgb value
  i=size(cmap_opt%picker)
  fstring = trim(fstring)&
  & // trim(f_utl_i2c( cmap_opt%rgb(1,i) )) // "/"&
  & // trim(f_utl_i2c( cmap_opt%rgb(2,i) )) // "/"&
  & // trim(f_utl_i2c( cmap_opt%rgb(3,i) ))

! ---- Z value args
! TODO: think about changing float length in f_utl_r2c to enable larger numbers here
  fstring = trim(fstring) // " -T"&
  & // trim(f_utl_r2c( map_opt%zmin )) // "/"&
  & // trim(f_utl_r2c( map_opt%zmax )) // "/"&
  & // trim(f_utl_r2c( map_opt%zstep ))

! ---- output
  fstring = trim(fstring) // " -Z > " // trim(cmap_opt%name) // ".cpt"

end function f_arg_cmap


! ==================================================================== !
! -------------------------------------------------------------------- !
function f_arg_map(map_opt, infile, outfile, module_opt) result(fstring)

! ==== Description
!! Crafts a fortran string from map options that serves
!! as argument string to be used in the gmt module
! TODO: generalise for all plots and also generalise map_opt to plt_opt?

! ==== Declarations
  type(TYP_map)     , intent(in) :: map_opt
  character(len=*)  , intent(in) :: infile, outfile
  type(TYP_module)  , intent(in) :: module_opt
  character(len=256)             :: fstring

! ==== Instructions

  fstring = ""

  ! infile
  if (module_opt%infile) then
     fstring = trim(fstring) // trim(infile)
  endif

  ! region option
  if (module_opt%region) then
     fstring = trim(fstring) // " -R" &
     & // trim(f_utl_r2c( map_opt%xmin )) // "/"&
     & // trim(f_utl_r2c( map_opt%xmax )) // "/"&
     & // trim(f_utl_r2c( map_opt%ymin )) // "/"&
     & // trim(f_utl_r2c( map_opt%ymax ))
  endif

  ! projection and scale
  if (module_opt%projection) then
     select case (map_opt%projection)
        ! M - Mercator
        ! J - Miller Cylindrical
        ! Q - Cylindrical equidistant
        case ("M", "J", "Q")
           fstring = trim(fstring) // " -J"&
           & // trim(map_opt%projection)&
           & // trim(f_utl_r2c( map_opt%scale )) // "p"
        ! T - Transverse Mercator
        case ("T")
           fstring = trim(fstring) // " -J"&
           & // trim(map_opt%projection)&
           & // trim(f_utl_r2c( map_opt%centre(1) )) // "/"&
           & // trim(f_utl_r2c( map_opt%scale )) // "p"
        ! L - Lambert conic conformal
        ! B - Albers conic equal-area
        ! D - Equidistant conic
        case ("L", "B", "D")
           fstring = trim(fstring) // " -J"&
           & // trim(map_opt%projection)&
           & // trim(f_utl_r2c( map_opt%centre(1) )) // "/"&
           & // trim(f_utl_r2c( map_opt%centre(2) )) // "/"&
           & // trim(f_utl_r2c( map_opt%parallels(1) )) // "/"&
           & // trim(f_utl_r2c( map_opt%parallels(2) )) // "/"&
           & // trim(f_utl_r2c( map_opt%scale )) // "p"
        ! X - XY plot (generic heat map)
        case ("X")
           fstring = trim(fstring) // " -J"&
           & // trim(map_opt%projection)&
           & // trim(f_utl_r2c( map_opt%scale )) // "p/"&
           & // trim(f_utl_r2c( map_opt%scale * &
           & (map_opt%ymax-map_opt%ymin) / (map_opt%xmax-map_opt%xmin) )) &
           & // "p"
     end select
  endif

  ! resolution
  if (module_opt%resolution) then
     fstring = trim(fstring) // " -D" // trim(map_opt%resolution)
  endif

  ! fill
  if (module_opt%fill) then
     fstring = trim(fstring) // " -G"&
     & // trim(f_utl_i2c( map_opt%fill(1) )) // "/"&
     & // trim(f_utl_i2c( map_opt%fill(2) )) // "/"&
     & // trim(f_utl_i2c( map_opt%fill(3) ))
  endif

  ! annotations and grid
  if (module_opt%an_major .and. module_opt%an_minor .and. module_opt%grid) then
     fstring = trim(fstring) // " -Ba" &
     & // trim(f_utl_r2c( map_opt%an_major )) // "f"&
     & // trim(f_utl_r2c( map_opt%an_minor )) // "g"&
     & // trim(f_utl_r2c( map_opt%grid )) // " -B"&
     & // trim(map_opt%an_ticks)
  endif

  ! pen
  if (module_opt%pen) then
     fstring = trim(fstring) // " -W" // trim(f_utl_r2c( map_opt%pen )) // "p"
  endif

  ! colour map
  if (module_opt%cmap) then
     fstring = trim(fstring) // " -C" // trim(map_opt%cmap) // ".cpt"
  endif

  if (module_opt%offset) then
     fstring = trim(fstring)&
     & // " -X" // trim( f_utl_r2c( module_opt%xoffset )) // "p" &
     & // " -Y" // trim( f_utl_r2c( module_opt%yoffset )) // "p"
  endif

  ! additional colour bar options
  if (module_opt%cbar) then
     fstring = trim(fstring) // " -B"&
     & // trim(f_utl_r2c( map_opt%cbar_tick_major )) // "f"&
     & // trim(f_utl_r2c( map_opt%cbar_tick_minor )) // " -DJRM+v+w"&
     & // trim(f_utl_r2c( map_opt%cbar_size )) // "%"&
     & // " -X" // trim(f_utl_r2c( map_opt%padding )) // "p"
  endif

  ! title (top centre)
  if (module_opt%title) then
     ! add Y offset based on font sizes and padding (title+label+2*padding)
     fstring = trim(fstring) // " -Y" // trim(f_utl_r2c( &
     & map_opt%font_size_title + &
     & map_opt%font_size_label + &
     & 2*map_opt%padding )) // "p"&
     & // " -X-" // trim(f_utl_r2c( map_opt%padding )) // "p" &
     ! placement (top centre) and font options
     & // " -F+cTC+f" // trim(f_utl_r2c( map_opt%font_size_title )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%title) // char(34) // ""
  endif

  ! top left corner text
  if (module_opt%label_left) then
     ! add Y offset relative to title based on font sizes and padding (title+padding)
     fstring = trim(fstring) // " -Y-" // trim(f_utl_r2c( &
     & map_opt%font_size_title + &
     & map_opt%padding )) // "p"&
     ! placement (top left) and font options
     & // " -F+cTL+f" // trim(f_utl_r2c( map_opt%font_size_label )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%label_left) // char(34) // ""
  endif

  ! top right text
  if (module_opt%label_right) then
     ! note: no Y offset needed relative to top left text
     ! placement (top right) and font options
     fstring = trim(fstring) // " -F+cTR+f"&
     & // trim(f_utl_r2c( map_opt%font_size_label )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%label_right) // char(34) // ""
  endif

  ! writing/adding to outfile
  if (module_opt%first) then
     if (module_opt%last) then
        ! single layer plot
        fstring = trim(fstring) // " > " // trim(outfile)
     else
        ! first layer in a stack
        fstring = trim(fstring) // " -K > " // trim(outfile)
     endif
  else
     if (module_opt%last) then
        ! last layer in a stack
        fstring = trim(fstring) // " -O >> " // trim(outfile)
     else
        ! sandwiched layer in stack
        fstring = trim(fstring) // " -O -K >> " // trim(outfile)
     endif
  endif

end function f_arg_map

end module fplt_arg
