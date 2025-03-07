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

! basic options
  implicit none
  private

! declare public
  public :: append_real, append_int, append_char


contains

! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine append_real(fstring, r)

! ==== Description
!! Convert real to char and append to passed string.

! ==== Declarations
  character(*), intent(inout) :: fstring
  real(wp)    , intent(in)    :: r
  character(len=256)          :: fstring_partial

! ==== Instructions
  write(fstring_partial, '(F7.2)') r
  fstring = trim(fstring) // trim(adjustl(fstring_partial))

end module append_real


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine append_int(fstring, i)

! ==== Description
!! Convert integer to char and append to passed string.

! ==== Declarations
  character(*), intent(inout) :: fstring
  real(wp)    , intent(in)    :: i
  character(len=256)          :: fstring_partial

! ==== Instructions
  write(fstring_partial, '(I3)') i
  fstring = trim(fstring) // trim(adjustl(fstring_partial))

end module append_real


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine append_char(fstring, fstring_partial)

! ==== Description
!! Append char to passed string.

! ==== Declarations
  character(*), intent(inout) :: fstring
  character(*), intent(in)    :: fstring_partial

! ==== Instructions
  fstring = trim(fstring) // trim(adjustl(fstring_partial))

end module append_real


end module fplt_utl
