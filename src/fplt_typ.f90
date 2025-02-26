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
  public :: TYP_cmap, TYP_map, TYP_module

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

! colour map
  type :: TYP_cmap
     !! Derived type for colour maps.
     !!
     !! name         : name of colour map
     !! rgb          : array of rgb values to interpolate between to make cmap
     !!                dimensions=(3,5), where 3 is for rgb, 2 = for 2 colour scale
     !! z_min, z_max : range bounds (min and max value)
     !! z_step       : step size (used for plotting)
     !!
     !! TODO: change to max 5 colours to interpolate between and add attribute
     !!       that informs cpt construction (e.g., "use only first 2 colours")
     character(len=16) :: name
     integer(i4)       :: rgb(3,2)
     real(wp)          :: z_min, z_max, z_step
  end type TYP_cmap

! map
  type :: TYP_map
     !! Derived type for map options.
     !!
     !! region          : regional bounds: lon_min, lon_max, lat_min, lat_max
     !! fill            : RGB values for fill
     !! projection      : projection and scale (in cm)
     !! resolution      : resolution ((f)ull, (h)igh, (i)ntermediate, (l)ow, (c)rude)
     !! an_maj, an_min  : major and minor annotations/labels
     !! grid            : grid spacing
     !! pen             : pen width (point)
     !! title           : plot title (very top, larger)
     !! label_top       : label above figure (right aligned)
     !! label_bottom    : label below figure (centre)
     real(wp)           :: region(4)
     integer(i4)        :: fill(3)
     character(len=16)  :: projection, resolution, cmap
     real(wp)           :: an_maj, an_min, grid, pen
     character(len=64)  :: title, label_top, label_bottom
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
     !! projection      : projection and scale (in cm)
     !! resolution      : resolution ((f)ull, (h)igh, (i)ntermediate, (l)ow, (c)rude)
     !! an_maj, an_min  : major and minor annotations/labels
     !! grid            : grid spacing
     !! pen             : pen width (point)
     !! cmap            : use colour map
     !! title           : plot title (very top, larger)
     !! label_top       : label above figure (right aligned)
     !! label_bottom    : label below figure (centre)
     !! first           : is module the bottom layer in stack
     !! top             : is module the top layer in stack
     character(len=32) :: name, gmt_module
     logical           :: infile
     logical           :: region, fill, projection, resolution
     logical           :: an_maj, an_min, grid, pen,  cmap
     logical           :: title, label_top, label_bottom
     logical           :: first, last
  end type TYP_module

end module fplt_typ
