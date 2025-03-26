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

! FORD
!! FPLT kinds and derived types.

! load modules
  use :: iso_fortran_env, only: int32, int64, real32, real64&
                            &, input_unit, output_unit, error_unit

! basic options
  implicit none
  private

! declare public
  public :: dp, sp, wp, i4, i8
  public :: std_i, std_o, std_e, std_rw
  public :: TYP_settings, TYP_cmap, TYP_map, TYP_heatmap, TYP_module

! ==== Declarations

! define kinds (used consistently and explicitly in derived types and entire project)
  integer, parameter :: sp = real32  !! single precision
  integer, parameter :: dp = real64  !! double precision
  integer, parameter :: wp = sp      !! working precision
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
     character(len=64) :: name                  !! name of settings template (theme)
     character(len=64) :: font                  !! name of font to be used
     integer(i4)       :: col_font_primary(3)   !! primary font colour (rgb value)
     integer(i4)       :: col_font_secondary(3) !! secondary font colour (rgb value)
     integer(i4)       :: col_lines_primary(3)  !! primary annotation line colour (rgb value)
     integer(i4)       :: col_background(3)     !! background colour (rgb value)
     integer(i4)       :: col_frame(3)          !! map frame colour (rgb value)
     integer(i4)       :: col_nan(3)            !! colour for NANs (rgb value)
     real(wp)          :: font_size_primary     !! size of primary font (pixels)
     real(wp)          :: pen_grid              !! pen size for grid (pixels)
     real(wp)          :: pen_tick              !! pen size for ticks (pixels)
     real(wp)          :: pen_frame             !! pen size for frame (pixels)
     real(wp)          :: paper_width           !! width of paper to plot on (pixels)
     real(wp)          :: paper_height          !! height of paper to plot on (pixels)
  end type TYP_settings

! colour map
  type :: TYP_cmap
     !! Derived type for colour maps.
     character(len=16) :: name      !! name of colour map
     integer(i4)       :: rgb(3,5)  !! array of rgb values to interpolate between to make cmap dimensions=(3,5), where 3 is for rgb, 5 = up to 5 colours on scale
     integer(i4)       :: picker(5) !! which of the 5 rgb values are to be used for creating a colour map; 0 = do not use, 1 = use; last colour must always be used.
  end type TYP_cmap

! map
  type :: TYP_map
     !! Derived type for map options.
     character(len=64)  :: name            !! name of map template
     character(len=64)  :: theme           !! map theme (e.g., "dark")
     integer(i4)        :: fill(3)         !! RGB values for fill
     character(len=16)  :: projection      !! map projection
     character(len=16)  :: resolution      !! map resolution
     real(wp)           :: scale           !! map scale (width in pixels)
     character(len=16)  :: cmap            !! colour map
     real(wp)           :: centre(2)       !! N-E coordinate pair for centres (for conic projections)
     real(wp)           :: parallels(2)    !! 2 N coordinates; standard parallels (for conic projections)
     real(wp)           :: an_major        !! major annotations/labels
     real(wp)           :: an_minor        !! minor annotations/labels
     real(wp)           :: grid            !! grid spacing drawn
     real(wp)           :: pen             !! pen width (point)
     real(wp)           :: cbar_tick_major !! colour bar major ticks
     real(wp)           :: cbar_tick_minor !! colour bar minor ticks
     real(wp)           :: cbar_size       !! colour bar size (percentage of map length)
     real(wp)           :: x_min           !! lower bound for x values (longitures)
     real(wp)           :: x_max           !! upper bound for x values (longitudes)
     real(wp)           :: y_min           !! lower bound for y values (latitudes)
     real(wp)           :: y_max           !! upper bound for y values (latitudes)
     real(wp)           :: z_min           !! lower bound of z value range
     real(wp)           :: z_max           !! upper bound of z value range
     real(wp)           :: z_step          !! z value step size (used in colour map and bar)
     character(len=64)  :: an_ticks        !! which sides have major annotation ticks (coordinates); e.g., WNes = coordinates annotated on west and north side
     character(len=64)  :: title           !! plot title (very top, larger)
     character(len=64)  :: label_left      !! label above figure (left aligned)
     character(len=64)  :: label_right     !! label above figure (right aligned)
     real(wp)           :: font_size_title !! font size of title (pixels)
     real(wp)           :: font_size_label !! font size for labels (pixels)
     real(wp)           :: padding         !! padding value used for labels
     character(len=256) :: infile          !! input file name
     character(len=256) :: outfile         !! output file name
     character(len=16)  :: format          !! output format (e.g., "png")
  end type TYP_map

! map
  type :: TYP_heatmap
     !! Derived type for heatmap options.
     ! TODO: evaluate using region vs. x_min, etc.; make consistent with map?
     character(len=64)  :: name            !! name of map template
     character(len=64)  :: theme           !! map theme (e.g., "dark")
     real(wp)           :: region(4)       !! regional bounds: x_min, x_max, y_min, y_max
     real(wp)           :: scale           !! map scale (width in pixels)
     character(len=16)  :: cmap            !! colour map
     real(wp)           :: an_major        !! major annotations/labels
     real(wp)           :: an_minor        !! minor annotations/labels
     real(wp)           :: grid            !! grid spacing drawn
     real(wp)           :: pen             !! pen width (point)
     real(wp)           :: cbar_tick_major !! colour bar major ticks
     real(wp)           :: cbar_tick_minor !! colour bar minor ticks
     real(wp)           :: cbar_size       !! colour bar size (percentage of map length)
     real(wp)           :: x_min           !! lower bound for x values
     real(wp)           :: x_max           !! upper bound for x values
     real(wp)           :: y_min           !! lower bound for y values
     real(wp)           :: y_max           !! upper bound for y values
     real(wp)           :: z_min           !! lower bound of z value range
     real(wp)           :: z_max           !! upper bound of z value range
     real(wp)           :: z_step          !! z value step size (used in colour map and bar)
     character(len=64)  :: an_ticks        !! which sides have major annotation ticks (coordinates); e.g., WNes = coordinates annotated on west and north side
     character(len=64)  :: title           !! plot title (very top, larger)
     character(len=64)  :: label_left      !! label above figure (left aligned)
     character(len=64)  :: label_right     !! label above figure (right aligned)
     real(wp)           :: font_size_title !! font size of title (pixels)
     real(wp)           :: font_size_label !! font size for labels (pixels)
     real(wp)           :: padding         !! padding value used for labels
     character(len=256) :: infile          !! input file name
     character(len=256) :: outfile         !! output file name
     character(len=16)  :: format          !! output format (e.g., "png")
  end type TYP_heatmap

! module templates
  type :: TYP_module
     !! Derived type for gmt modules. Includes a list of which arguments are included and which aren't.
     !! Used as "blueprints" for gmt module calls (mostly relevant for argument construction).
     character(len=32) :: name             !! name given to module template
     character(len=32) :: gmt_module       !! name of gmt module to be used with template (e.g., pscoast)
     logical           :: infile           !! input file
     logical           :: region           !! regional bounds: x_min, x_max, y_min, y_max
     logical           :: fill             !! RGB values for fill
     logical           :: projection       !! projection and scale
     logical           :: resolution       !! resolution ((f)ull, (h)igh, (i)ntermediate, (l)ow, (c)rude)
     logical           :: an_major         !! major annotations/labels
     logical           :: an_minor         !! minor annotations/labels
     logical           :: grid             !! grid spacing
     logical           :: pen              !! pen width (point)
     logical           :: cmap             !! use colour map
     logical           :: cbar             !! additional colour bar options
     logical           :: title            !! plot title (very top, larger)
     logical           :: label_left       !! label above figure (left aligned)
     logical           :: label_right      !! label above figure (right aligned)
     logical           :: first            !! module is the bottom layer in stack
     logical           :: last             !! module is the top layer in stack
  end type TYP_module

end module fplt_typ
