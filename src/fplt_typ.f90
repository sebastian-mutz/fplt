module mod_typ
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
  public :: TYP_region, TYP_map

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

! region
  type :: TYP_region
     !! Derived type for regions.
     !!
     !! Region defined by longitudinal and latitudinal bounds.
     real(wp) :: lon_min, lon_max, lat_min, lat_max
  end type TYP_region

! map
  type :: TYP_map
     !! Derived type for map options.
     !!
     !! reg          : regional bounds
     !! proj         : projection used
     !! l_maj, l_min : major and minor (tick) annotations/labels
     !! grid         : grid line spacing
     !! pen          : pen width (point)
     type(TYP_region)  :: reg
     character(len=20) :: proj, res
     real(wp)          :: l_maj, l_min, grid, pen
  end type TYP_map

end module mod_typ
