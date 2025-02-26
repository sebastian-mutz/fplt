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

! modify preset colour map
  DAT_cmap_greys%rgb(:,1) =[50, 50, 50]
  DAT_cmap_greys%rgb(:,2) =[255, 255, 255]
! modify preset range
  DAT_cmap_greys%z_max = 2000
  DAT_cmap_greys%z_step = 250

! plot map
  call fplt_map(DAT_map_europe, "ETOPO1_Bed_g_gmt4.grd", "topo.ps")

end program main
