module fplt_typ
!
! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Kinds and derived types for fplt.                                  |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! load modules
  use :: iso_fortran_env, only: int32, int64, real32, real64&
                            &, input_unit, output_unit, error_unit

! basic options
  implicit none
  private

! declare public
  public :: dp, sp, wp, i4, i8
  public :: std_i, std_o, std_e, std_rw
  public :: TYP_settings, TYP_cmap, TYP_map, TYP_module

! ==== Declarations

! define kinds (used consistently and explicitly in derived types and entire project)
  integer, parameter :: sp = real32  ! single precision
  integer, parameter :: dp = real64  ! double precision
  integer, parameter :: wp = sp      ! working precision
  integer, parameter :: i4 = int32
  integer, parameter :: i8 = int64

  ! standard i/o
  integer, parameter :: std_i  = input_unit
  integer, parameter :: std_o  = output_unit
  integer, parameter :: std_e  = error_unit
  integer, parameter :: std_rw = 21

! ==== Definitions

! gmt font settings
  type :: TYP_settings
     !! Derived type for gmt settings.
     !!
     !! font               : name of font to be used
     !! col_font_primary   : primary font colour (rgb value)
     !! col_font_secondary : secondary font colour (rgb value)
     !! col_lines_primary  : primary annotation line colour (rgb value)
     !! col_background     : background colour (rgb value)
     !! col_foreground     : foreground colour (rgb value)
     !! col_nan            : colour for NANs (rgb value)
     !! font_size_primary  : size of primary font (pixels)
     !! pen_grid           : pen size for grid (pixels)
     !! pen_tick           : pen size for ticks (pixels)
     !! pen_frame          : pen size for frame (pixels)
     !! paper_width        : width of paper to plot on (pixels)
     !! paper_height       : height of paper to plot on (pixels)
     character(len=64) :: font
     integer(i4)       :: col_font_primary(3), col_font_secondary(3)
     integer(i4)       :: col_lines_primary(3)
     integer(i4)       :: col_background(3), col_foreground(3), col_nan(3)
     real(wp)          :: font_size_primary
     real(wp)          :: pen_grid, pen_tick, pen_frame
     real(wp)          :: paper_width, paper_height
  end type TYP_settings

! colour map
  type :: TYP_cmap
     !! Derived type for colour maps.
     !!
     !! name         : name of colour map
     !! rgb          : array of rgb values to interpolate between to make cmap
     !!                dimensions=(3,5), where 3 is for rgb, 5 = up to 5 colours on scale
     !! picker       : which of the 5 rgb values are to be used for creating a colour map
     !!                0 = do not use, 1 = use; last colour must always be used.
     !! z_min, z_max : range bounds (min and max value)
     !! z_step       : step size (used for plotting)
     !!
     !! TODO: change to max 5 colours to interpolate between and add attribute
     !!       that informs cpt construction (e.g., "use only first 2 colours")
     character(len=16) :: name
     integer(i4)       :: rgb(3,5), picker(5)
     real(wp)          :: z_min, z_max, z_step
  end type TYP_cmap

! map
  type :: TYP_map
     !! Derived type for map options.
     !!
     !! region          : regional bounds: lon_min, lon_max, lat_min, lat_max
     !! fill            : RGB values for fill
     !! projection      : projection
     !! scale           : scale (width in pixels)
     !! centre          : N-E coordinate pair for centres (for conic projections)
     !! parallels       : 2 N coordinates; standard parallels (for conic projections)
     !! resolution      : resolution ((f)ull, (h)igh, (i)ntermediate, (l)ow, (c)rude)
     !! an_major        : major annotations/labels
     !! an_minor        : minor annotations/labels
     !! an_ticks        : which side to put major annotation ticks (coordinates) on
     !!                   e.g., WNes = coordinates annotated on west and north side
     !! grid            : grid spacing drawn
     !! cbar_tick_major : colour bar major ticks
     !! cbar_tick_minor : colour bar minor ticks
     !! cbar_size       : colour bar size (percentage of map length)
     !! pen             : pen width (point)
     !! title           : plot title (very top, larger)
     !! label_left      : label above figure (right aligned)
     !! label_right     : label below figure (centre)
     !! font_size_title : font size of title (pixels)
     !! font_size_label : font size for labels (pixels)
     !! padding         : padding value used for labels
     real(wp)           :: region(4)
     integer(i4)        :: fill(3)
     character(len=16)  :: projection, resolution, cmap
     real(wp)           :: scale, centre(2), parallels(2)
     real(wp)           :: an_major, an_minor, grid, pen
     real(wp)           :: cbar_tick_major, cbar_tick_minor, cbar_size
     character(len=64)  :: an_ticks
     character(len=64)  :: title, label_left, label_right
     real(wp)           :: font_size_title, font_size_label, padding
  end type TYP_map

! module templates
  type :: TYP_module
     !! Derived type for gmt modules. Includes a list of which arguments
     !! are included and which aren't. Used as "blueprints" for gmt module
     !! calls (mostly relevant for argument construction).
     !!
     !! name            : name given to module template
     !! gmt_module      : name of gmt module to be used with template (e.g., pscoast)
     !! region          : regional bounds: lon_min, lon_max, lat_min, lat_max
     !! fill            : RGB values for fill
     !! projection      : projection and scale
     !! resolution      : resolution ((f)ull, (h)igh, (i)ntermediate, (l)ow, (c)rude)
     !! an_major        : major annotations/labels
     !! an_minor        : minor annotations/labels
     !! grid            : grid spacing
     !! pen             : pen width (point)
     !! cmap            : use colour map
     !! cbar            : additional colour bar options
     !! title           : plot title (very top, larger)
     !! label_left      : label above figure (right aligned)
     !! label_right     : label below figure (centre)
     !! first           : is module the bottom layer in stack
     !! top             : is module the top layer in stack
     character(len=32) :: name, gmt_module
     logical           :: infile
     logical           :: region, fill, projection, resolution
     logical           :: an_major, an_minor, grid, pen, cmap, cbar
     logical           :: title, label_left, label_right
     logical           :: first, last
  end type TYP_module

end module fplt_typ
