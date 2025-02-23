module fplt

! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Module serves as abstraction layer and contains core procedures.   |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! load modules
  use, intrinsic :: iso_c_binding
  use :: mod_typ
  use :: mod_gmt

! basic options
  implicit none
!  private

! declare public
!  public :: fplt_s_map


contains

! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_map(map)

! ==== Description
!! Uses fortran-gmt interface for creating a map.

! ==== Declarations
  type(TYP_map), intent(in)               :: map
  type(c_ptr)                             :: session, parent
  character(kind=c_char, len=20)          :: session_name
  character(kind=c_char, len=256), target :: args
  integer(c_int)                          :: status
  integer(c_int), parameter               :: pad=0, mode=0, cmd=0

!   data europe%reg%lon_min/-10/, europe%reg%lon_max/50/ &
!     &, europe%reg%lat_min/30/, europe%reg%lat_max/60/ &
!     &, europe%proj/"JM6i"/, europe%res/"f"/ &
!     &, europe%l_maj/20/, europe%l_min/20/ &
!     &, europe%grid/1/, europe%pen/1/

! ==== Instructions

  session_name = "fortran" // c_null_char
  parent = c_null_ptr

! create session
  session = gmt_create_session(session_name, pad, mode, parent)
  if (c_associated(session)) then
    print *, "> GMT session created successfully."
  else
    print *, "> Failed to create GMT session."
    stop
  end if

! Prepare the arguments for pscoast
  args = "-R-10/50/30/60 -JM6i -Glightgray -W1p > map.ps" // c_null_char
!  args = "-R" // map%reg%lon_min // "/" // map%reg%lon_max // "/"&
!      & // map%reg%lat_min // "/" // map%reg%lat_max &
!      & // " -" // trim(map%proj) // " -Glightgray -W1p > map.ps" // c_null_char

! Call the pscoast module
  status = GMT_Call_Module(session, "pscoast" // c_null_char, cmd, c_loc(args))
  if (status == 0) then
    print *, "> GMT module executed successfully."
  else
    print *, "> GMT module execution failed. Error code:", status
    stop
  end if

! Destroy session
  status = gmt_destroy_session(session)
  if (status == 0) then
    print *, "> GMT session destroyed successfully."
  else
    print *, "> Failed to destroy GMT session. Error code:", status
    stop
  end if

end subroutine fplt_map

end module fplt
