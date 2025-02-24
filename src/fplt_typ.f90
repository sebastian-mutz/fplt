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
  use iso_fortran_env, only: int32, int64, real32, real64&
                          &, input_unit, output_unit, error_unit

! basic options
  implicit none
  private

! declare public
  public :: dp, sp, wp, i4, i8
  public :: std_i, std_o, std_e, std_rw
  public :: TYP_cmap, TYP_map

! ==== Declarations ================================================== !

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

! ==== Definitions =================================================== !

! colour map
  type :: TYP_cmap
     !! Derived type for colour maps.
     !!
     !! name : name of colour map
     !! rgb  : array of rgb values to interpolate between to make cmap
     !!        dimensions=(3,x), where x=2 for a 2-colour scale, for example
     character(len=20)        :: name
     integer(i4), allocatable :: rgb(:,:)
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
     !! z_range, z_step : range bounds (min and max value) and step size (used for plotting)
     !! cmap            : colour map to use
     !! title           : plot title (very top, larger)
     !! label_top       : label above figure (right aligned)
     !! label_bottom    : label below figure (centre)
     real(wp)           :: region(4)
     integer(i4)        :: fill(3)
     character(len=8)   :: projection, resolution
     real(wp)           :: an_maj, an_min, grid, pen
     real(wp)           :: z_range(2), z_step
     type(TYP_cmap)     :: cmap
     character(len=64)  :: title, label_top, label_bottom
  end type TYP_map

end module fplt_typ
