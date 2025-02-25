module fplt_dat
!
! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Plotting resets for fplt.                                          |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! load modules
  use :: fplt_typ

! basic options
  implicit none
  private

! declare public
  public :: DAT_map_europe, DAT_mod_map01, DAT_cmap_greys

! ==== Declarations

  type(TYP_map)    :: DAT_map_europe
  type(TYP_module) :: DAT_mod_map01
  type(TYP_cmap)   :: DAT_cmap_greys
  integer          :: i

! ==== Data

! define colour map
  data DAT_cmap_greys%name /"monochrome"/
  data (DAT_cmap_greys%rgb(i,1), i=1,3) /0, 0, 0/
  data (DAT_cmap_greys%rgb(i,2), i=1,3) /255, 255, 255/

! map options
  data DAT_map_europe%region     /-30, 60, 30, 72/
  data DAT_map_europe%fill       /200, 200, 200/
  data DAT_map_europe%projection /"M15c"/
  data DAT_map_europe%resolution /"l"/
  data DAT_map_europe%an_maj     /20/
  data DAT_map_europe%an_min     /10/
  data DAT_map_europe%grid       /2/
  data DAT_map_europe%pen        /0.5/
  data DAT_map_europe%z_min      /0.0/
  data DAT_map_europe%z_max      /0.0/
  data DAT_map_europe%z_step     /5.0/

! gmt argument selection
  data DAT_mod_map01%name         /"pscoast_basic"/
  data DAT_mod_map01%gmt_module   /"pscoast"/
  data DAT_mod_map01%region       /.true./
  data DAT_mod_map01%fill         /.true./
  data DAT_mod_map01%projection   /.true./
  data DAT_mod_map01%resolution   /.true./
  data DAT_mod_map01%an_maj       /.true./
  data DAT_mod_map01%an_min       /.true./
  data DAT_mod_map01%grid         /.true./
  data DAT_mod_map01%pen          /.true./
  data DAT_mod_map01%z_min        /.false./
  data DAT_mod_map01%z_max        /.false./
  data DAT_mod_map01%z_step       /.false./
  data DAT_mod_map01%title        /.false./
  data DAT_mod_map01%label_top    /.false./
  data DAT_mod_map01%label_bottom /.false./
  data DAT_mod_map01%overlay      /.false./

! NOTE: for reference for test below:
!args = "-R-10/50/30/60 -JM6i -Glightgray -W1p > map.ps" // c_null_char
!gmt psbasemap -R${REGION} -J${PROJECTION} -Ba20f20g1 -BWS -X2.5 -Y6 -P -K >${OUTFILE}
!gmt grdimage resampled.grd -R${REGION} -J${PROJECTION} -Ccol1.cpt -P -K -O >>${OUTFILE}
!gmt pscoast -R${REGION} -J${PROJECTION} -A40 -Df -W1/0.8,${C_LINES} -P -K -O >> ${OUTFILE}
!gmt psbasemap -R${REGION} -J${PROJECTION} -Bg10f10g10 -P -K -O >>${OUTFILE}

end module fplt_dat
