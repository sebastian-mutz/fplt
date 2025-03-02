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

! declare public maps
  public :: DAT_map_europe

! declare public colour maps
  public :: DAT_cmap_greys

! declase public module option lists
  public :: DAT_mod_base01, DAT_mod_base02, DAT_mod_grdimg01, DAT_mod_coast01

! ==== Declarations

  type(TYP_map)    :: DAT_map_europe
  type(TYP_module) :: DAT_mod_base01, DAT_mod_base02, DAT_mod_grdimg01, DAT_mod_coast01
  type(TYP_cmap)   :: DAT_cmap_greys
  integer          :: i

! ==== Data (presents)

! ---- colour maps

! define colour map (note: min/max/step can simply be overwritten)
  data DAT_cmap_greys%name /"monochrome"/
  data (DAT_cmap_greys%rgb(i,1), i=1,3) /0, 0, 0/
  data (DAT_cmap_greys%rgb(i,2), i=1,3) /255, 255, 255/
  data DAT_cmap_greys%z_min             /0.0_wp/
  data DAT_cmap_greys%z_max             /100.0_wp/
  data DAT_cmap_greys%z_step            /5.0_wp/

! ---- maps

! europe map options
  data DAT_map_europe%region     /-30.0_wp, 60.0_wp, 30.0_wp, 72.0_wp/
  data DAT_map_europe%fill       /200, 200, 200/
  data DAT_map_europe%projection /"M15c"/
  data DAT_map_europe%resolution /"l"/
  data DAT_map_europe%an_maj     /20.0_wp/
  data DAT_map_europe%an_min     /10.0_wp/
  data DAT_map_europe%grid       /2.0_wp/
  data DAT_map_europe%pen        /0.5_wp/
  data DAT_map_europe%cmap       /"monochrome"/

! ---- gmt module options (args construction)

! gmt argument selection - coast
  data DAT_mod_coast01%name         /"pscoast_fill"/
  data DAT_mod_coast01%gmt_module   /"pscoast"/
  data DAT_mod_coast01%infile       /.false./
  data DAT_mod_coast01%region       /.true./
  data DAT_mod_coast01%fill         /.true./
  data DAT_mod_coast01%projection   /.true./
  data DAT_mod_coast01%resolution   /.true./
  data DAT_mod_coast01%an_maj       /.true./
  data DAT_mod_coast01%an_min       /.true./
  data DAT_mod_coast01%grid         /.true./
  data DAT_mod_coast01%pen          /.true./
  data DAT_mod_coast01%cmap         /.false./
  data DAT_mod_coast01%title        /.false./
  data DAT_mod_coast01%label_top    /.false./
  data DAT_mod_coast01%label_bottom /.false./
  data DAT_mod_coast01%first        /.false./
  data DAT_mod_coast01%last         /.false./

! gmt argument selection - grid image
  data DAT_mod_grdimg01%name         /"grdimage_basic"/
  data DAT_mod_grdimg01%gmt_module   /"grdimage"/
  data DAT_mod_grdimg01%infile       /.true./
  data DAT_mod_grdimg01%region       /.true./
  data DAT_mod_grdimg01%fill         /.false./
  data DAT_mod_grdimg01%projection   /.true./
  data DAT_mod_grdimg01%resolution   /.false./
  data DAT_mod_grdimg01%an_maj       /.false./
  data DAT_mod_grdimg01%an_min       /.false./
  data DAT_mod_grdimg01%grid         /.false./
  data DAT_mod_grdimg01%pen          /.false./
  data DAT_mod_grdimg01%cmap         /.true./
  data DAT_mod_grdimg01%title        /.false./
  data DAT_mod_grdimg01%label_top    /.false./
  data DAT_mod_grdimg01%label_bottom /.false./
  data DAT_mod_grdimg01%first        /.false./
  data DAT_mod_grdimg01%last         /.false./

! gmt argument selection - bottom basemap
  data DAT_mod_base01%name         /"basemap_base"/
  data DAT_mod_base01%gmt_module   /"psbasemap"/
  data DAT_mod_base01%infile       /.false./
  data DAT_mod_base01%region       /.true./
  data DAT_mod_base01%fill         /.false./
  data DAT_mod_base01%projection   /.true./
  data DAT_mod_base01%resolution   /.false./
  data DAT_mod_base01%an_maj       /.true./
  data DAT_mod_base01%an_min       /.true./
  data DAT_mod_base01%grid         /.true./
  data DAT_mod_base01%pen          /.false./
  data DAT_mod_base01%cmap         /.false./
  data DAT_mod_base01%title        /.false./
  data DAT_mod_base01%label_top    /.false./
  data DAT_mod_base01%label_bottom /.false./
  data DAT_mod_base01%first        /.true./
  data DAT_mod_base01%last         /.false./

! gmt argument selection - basemap layer
  data DAT_mod_base02%name         /"basemap_top"/
  data DAT_mod_base02%gmt_module   /"psbasemap"/
  data DAT_mod_base02%infile       /.false./
  data DAT_mod_base02%region       /.true./
  data DAT_mod_base02%fill         /.true./
  data DAT_mod_base02%projection   /.true./
  data DAT_mod_base02%resolution   /.false./
  data DAT_mod_base02%an_maj       /.true./
  data DAT_mod_base02%an_min       /.true./
  data DAT_mod_base02%grid         /.true./
  data DAT_mod_base02%pen          /.false./
  data DAT_mod_base02%cmap         /.false./
  data DAT_mod_base02%title        /.false./
  data DAT_mod_base02%label_top    /.false./
  data DAT_mod_base02%label_bottom /.false./
  data DAT_mod_base02%first        /.false./
  data DAT_mod_base02%last         /.false./

! NOTE: for reference for test below:
! gmt psbasemap -R${REGION} -J${PROJECTION} -Ba20f20g1 -BWS -X2.5 -Y6 -P -K >${OUTFILE}
! gmt grdimage resampled.grd -R${REGION} -J${PROJECTION} -Ccol1.cpt -P -K -O >>${OUTFILE}
! gmt pscoast -R${REGION} -J${PROJECTION} -A40 -Df -W1/0.8,${C_LINES} -P -K -O >> ${OUTFILE}
! gmt psbasemap -R${REGION} -J${PROJECTION} -Bg10f10g10 -P -K -O >>${OUTFILE}
! gmt xyz2grd ${INFILE} -Dlon/lat/eof/1/0/ -Gtmp.grd -R${REGION} -I120m -V
! gmt grdimage tmp.grd -R${REGION} -J${PROJECTION} -Ccol1.cpt -P -K -O >>${OUTFILE}

end module fplt_dat
