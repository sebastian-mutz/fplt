program main

! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Test application for fplt lib.                                     |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! load modules
  use :: fplt

! basic options
  implicit none

! ==== Declarations
  character(len=256) :: outfile

! ==== Instructions

! output
  outfile = "test.ps"

! plot map
  call fplt_map(DAT_map_europe, outfile)

end program main
