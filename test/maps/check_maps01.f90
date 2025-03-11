program check_maps01

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

! modify preset colour map
  DAT_cmap_bluered01%z_min = -25
  DAT_cmap_bluered01%z_max = 25
  DAT_cmap_bluered01%z_step = 1

! set plot labels
  DAT_map_default%title = "Simulated Temperature (1979-2000)"
  DAT_map_default%label_left = "2m air temperature"
  DAT_map_default%label_right= "deg C"

! change colour map
  DAT_map_default%cmap="bluered01"

! plot map from text file using the default map template
  call fplt_map(DAT_map_default, "./test/maps/Mutz_et_al_2018_pd_temp2.asc", "./test/maps/map01.ps")

end program check_maps01
