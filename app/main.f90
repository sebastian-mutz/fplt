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
  type(TYP_map)      :: europe
  type(TYP_cmap)     :: greys
  character(len=256) :: outfile

! ==== Instructions

! define colour map
  greys%name = "monochrome"
  allocate(greys%rgb(3, 2))
  greys%rgb(:,1) = [0, 0, 0]
  greys%rgb(:,2) = [255, 255, 255]

! map options
  europe%region     = [-10, 50, 30, 60]
  europe%fill       = [200, 200, 200]
  europe%projection = "M15c"
  europe%resolution = "l"
  europe%an_maj     = 20
  europe%an_min     = 10
  europe%grid       = 2
  europe%pen        = 0.5
  europe%z_range    = [0,100]
  europe%z_step     = 5
  europe%cmap       = greys

! output
  outfile = "test.ps"

!args = "-R-10/50/30/60 -JM6i -Glightgray -W1p > map.ps" // c_null_char
!gmt psbasemap -R${REGION} -J${PROJECTION} -Ba20f20g1 -BWS -X2.5 -Y6 -P -K >${OUTFILE}
!gmt grdimage resampled.grd -R${REGION} -J${PROJECTION} -Ccol1.cpt -P -K -O >>${OUTFILE}
!gmt pscoast -R${REGION} -J${PROJECTION} -A40 -Df -W1/0.8,${C_LINES} -P -K -O >> ${OUTFILE}
!gmt psbasemap -R${REGION} -J${PROJECTION} -Bg10f10g10 -P -K -O >>${OUTFILE}

  call fplt_map(europe, outfile)

  deallocate(greys%rgb)

end program main
