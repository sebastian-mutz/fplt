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

! FORD
!! Utilities.

! load modules
  use :: fplt_typ

! basic options
  implicit none
  private

! declare public
  public :: f_utl_r2c, f_utl_i2c, f_utl_get_format


contains

! ==================================================================== !
! -------------------------------------------------------------------- !
function f_utl_r2c(r) result(c)

! ==== Description
!! Convert real to char.

! ==== Declarations
  real(wp), intent(in) :: r
  character(len=256)   :: c

! ==== Instructions
  write(c, '(F7.2)') r
  c=adjustl(c)

end function f_utl_r2c


! ==================================================================== !
! -------------------------------------------------------------------- !
function f_utl_i2c(i) result(c)

! ==== Description
!! Convert integer to char.

! ==== Declarations
  integer(i4), intent(in) :: i
  character(len=256)      :: c

! ==== Instructions
  write(c, '(I3)') i
  c=adjustl(c)

end function f_utl_i2c


! ==================================================================== !
! -------------------------------------------------------------------- !
function f_utl_get_format(filename) result(fmt)

! ==== Description
!! Determines file format by extension.
!! in : filename - name of file
!! out: fmt      - file format description

! ==== Declarations
  character(len=*), intent(in)  :: filename
  character(len=64)             :: fmt
  integer                       :: i, pos, length
  character(len=10)             :: ext

! ==== Instructions

! initialize format
  fmt = "unknown"

! get the length of the filename
  length = len(trim(filename))

! find the last occurrence of '.'
  pos = 0
  do i = length, 1, -1
     if (filename(i:i) .eq. ".") then
        pos = i
        exit
     endif
  enddo

! if a dot is found and it's not the first character
  if (pos .gt. 1 .and. pos .lt. length) then
     ext = filename(pos+1:length)

     ! compare extensions to known formats
     select case (trim(ext))
        case ("txt", "TXT", "asc", "ASC")
           fmt = "text"
        case ("grd", "GRD")
           fmt = "grid"
        case default
           fmt = 'unknown'
     end select
  endif

end function f_utl_get_format

end module fplt_utl
