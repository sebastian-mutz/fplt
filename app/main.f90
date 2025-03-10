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
!  DAT_cmap_greys%rgb(:,1) =[50, 50, 50]
!  DAT_cmap_greys%rgb(:,2) =[255, 255, 255]
! modify preset range
  DAT_cmap_bluered01%z_min = -20 !2000
  DAT_cmap_bluered01%z_max = 30 !2000
  DAT_cmap_bluered01%z_step = 1 !250

! change colour map
  DAT_map_default%cmap="whitered01"

! plot map
  call fplt_map(DAT_map_default, "Mutz_et_al_2018_pd_temp2.asc", "topo.ps")
!  call fplt_map(DAT_map_europe, "tmp.grd", "topo.ps")

end program main
