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

! TODO: based on opts, load dat_* and pass to working types (cp_template function) using identifiers, then simply modify those

! set plot labels
  DAT_map%title = "Simulated Temperature (1979-2000)"
  DAT_map%label_left = "2m air temperature"
  DAT_map%label_right= "deg C"

! change colour map
  DAT_map%cmap="bluered01"

! modify preset colour map
  DAT_map%z_min = -25
  DAT_map%z_max = 25
  DAT_map%z_step = 1

! change theme
  DAT_map%theme = "dark"

! change projection
  DAT_map%projection = "L"

! plot map from text file using the default map cp_template
! TODO: make in & outfile part of map options?
  call fplt_map(DAT_map, "./test/maps/Mutz_et_al_2018_pd_temp2.asc", "./test/maps/map01.ps")

end program main
