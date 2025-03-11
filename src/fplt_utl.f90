module fplt_utl

! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Module contains various utility procedures.                        |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! load modules
  use :: fplt_typ

! basic options
  implicit none
  private

! declare public
  public :: f_r2c, f_i2c


contains

! ==================================================================== !
! -------------------------------------------------------------------- !
function f_r2c(r) result(c)

! ==== Description
!! Convert real to char.

! ==== Declarations
  real(wp), intent(in) :: r
  character(len=256)   :: c

! ==== Instructions
  write(c, '(F7.2)') r
  c=adjustl(c)

end function f_r2c

! ==================================================================== !
! -------------------------------------------------------------------- !
function f_i2c(i) result(c)

! ==== Description
!! Convert integer to char.

! ==== Declarations
  integer(i4), intent(in) :: i
  character(len=256)      :: c

! ==== Instructions
  write(c, '(I3)') i
  c=adjustl(c)

end function f_i2c


end module fplt_utl
