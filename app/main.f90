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
  type(TYP_map) :: europe

  data europe%reg%lon_min/-10/, europe%reg%lon_max/50/ &
    &, europe%reg%lat_min/30/, europe%reg%lat_max/60/ &
    &, europe%proj/"JM6i"/, europe%res/"f"/ &
    &, europe%l_maj/20/, europe%l_min/20/ &
    &, europe%grid/1/, europe%pen/1/

!args = "-R-10/50/30/60 -JM6i -Glightgray -W1p > map.ps" // c_null_char
!gmt psbasemap -R${REGION} -J${PROJECTION} -Ba20f20g1 -BWS -X2.5 -Y6 -P -K >${OUTFILE}
!gmt grdimage resampled.grd -R${REGION} -J${PROJECTION} -Ccol1.cpt -P -K -O >>${OUTFILE}
!gmt pscoast -R${REGION} -J${PROJECTION} -A40 -Df -W1/0.8,${C_LINES} -P -K -O >> ${OUTFILE}
!gmt psbasemap -R${REGION} -J${PROJECTION} -Bg10f10g10 -P -K -O >>${OUTFILE}

! ==== Instructions
  call fplt_map(europe)

end program main
