program main

! |--------------------------------------------------------------------|
! | fortra-gmt interface                                               |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Test application for fortran-gmt lib.                              |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! load modules
  use, intrinsic :: iso_c_binding
  use :: fortran_gmt

! basic options
  implicit none


! ==== Declarations
  type(c_ptr) :: session, parent
  character(kind=c_char, len=20)          :: session_name
  character(kind=c_char, len=256), target :: args
  integer(c_int)                          :: status
  integer(c_int), parameter               :: pad = 0, mode = 0
  integer(c_int), parameter               :: GMT_MODULE_CMD = 0

! ==== Instructions

  session_name = "fortran" // c_null_char
  parent = c_null_ptr

! create session
  session = gmt_create_session(session_name, pad, mode, parent)
  if (c_associated(session)) then
    print *, "GMT session created successfully."
  else
    print *, "Failed to create GMT session."
    stop
  end if

! Prepare the arguments for pscoast
  args = "-R-10/50/30/60 -JM6i -Glightgray -W1p > map.ps" // c_null_char
! Call the pscoast module
  status = GMT_Call_Module(session, "pscoast" // c_null_char, GMT_MODULE_CMD, c_loc(args))
  if (status == 0) then
    print *, "GMT module executed successfully."
  else
    print *, "GMT module execution failed. Error code:", status
    stop
  end if

! Destroy session
  status = gmt_destroy_session(session)
  if (status == 0) then
    print *, "GMT session destroyed successfully."
  else
    print *, "Failed to destroy GMT session. Error code:", status
    stop
  end if

end program main
