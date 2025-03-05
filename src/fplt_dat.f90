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
  public :: DAT_mod_base01, DAT_mod_grdimg01, DAT_mod_coast01
  public :: DAT_mod_text01, DAT_mod_text02, DAT_mod_text03
  public :: DAT_mod_scale01

! ==== Declarations

  type(TYP_map)    :: DAT_map_europe
  type(TYP_module) :: DAT_mod_base01, DAT_mod_grdimg01, DAT_mod_coast01
  type(TYP_module) :: DAT_mod_text01, DAT_mod_text02, DAT_mod_text03
  type(TYP_module) :: DAT_mod_scale01
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
  data DAT_map_europe%region       /-30.0_wp, 60.0_wp, 30.0_wp, 72.0_wp/
  data DAT_map_europe%fill         /200, 200, 200/
  data DAT_map_europe%projection   /"M"/
  data DAT_map_europe%scale        /15.0_wp/
  data DAT_map_europe%resolution   /"l"/
  data DAT_map_europe%an_maj       /20.0_wp/
  data DAT_map_europe%an_min       /10.0_wp/
  data DAT_map_europe%an_ticks     /"WNes"/
  data DAT_map_europe%grid         /2.0_wp/
  data DAT_map_europe%pen          /0.5_wp/
  data DAT_map_europe%cmap         /"monochrome"/
  data DAT_map_europe%title        /"title"/
  data DAT_map_europe%label_top    /"units"/
  data DAT_map_europe%label_bottom /"variable"/

! ---- gmt module options (args construction)

! gmt argument selection - coast
  data DAT_mod_coast01%name         /"pscoast_fill"/
  data DAT_mod_coast01%gmt_module   /"pscoast"/
  data DAT_mod_coast01%infile       /.false./
  data DAT_mod_coast01%region       /.true./
  data DAT_mod_coast01%fill         /.false./
  data DAT_mod_coast01%projection   /.true./
  data DAT_mod_coast01%resolution   /.true./
  data DAT_mod_coast01%an_maj       /.true./
  data DAT_mod_coast01%an_min       /.true./
  data DAT_mod_coast01%grid         /.true./
  data DAT_mod_coast01%pen          /.true./
  data DAT_mod_coast01%cmap         /.false./
  data DAT_mod_coast01%cbar         /.false./
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
  data DAT_mod_grdimg01%cbar         /.false./
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
  data DAT_mod_base01%cbar         /.false./
  data DAT_mod_base01%title        /.false./
  data DAT_mod_base01%label_top    /.false./
  data DAT_mod_base01%label_bottom /.false./
  data DAT_mod_base01%first        /.true./
  data DAT_mod_base01%last         /.false./

! gmt argument selection - basemap layer
  data DAT_mod_text01%name         /"title"/
  data DAT_mod_text01%gmt_module   /"pstext"/
  data DAT_mod_text01%infile       /.false./
  data DAT_mod_text01%region       /.true./
  data DAT_mod_text01%fill         /.false./
  data DAT_mod_text01%projection   /.true./
  data DAT_mod_text01%resolution   /.false./
  data DAT_mod_text01%an_maj       /.false./
  data DAT_mod_text01%an_min       /.false./
  data DAT_mod_text01%grid         /.false./
  data DAT_mod_text01%pen          /.false./
  data DAT_mod_text01%cmap         /.false./
  data DAT_mod_text01%cbar         /.false./
  data DAT_mod_text01%title        /.true./
  data DAT_mod_text01%label_top    /.false./
  data DAT_mod_text01%label_bottom /.false./
  data DAT_mod_text01%first        /.false./
  data DAT_mod_text01%last         /.false./

! gmt argument selection - basemap layer
  data DAT_mod_text02%name         /"top"/
  data DAT_mod_text02%gmt_module   /"pstext"/
  data DAT_mod_text02%infile       /.false./
  data DAT_mod_text02%region       /.true./
  data DAT_mod_text02%fill         /.false./
  data DAT_mod_text02%projection   /.true./
  data DAT_mod_text02%resolution   /.false./
  data DAT_mod_text02%an_maj       /.false./
  data DAT_mod_text02%an_min       /.false./
  data DAT_mod_text02%grid         /.false./
  data DAT_mod_text02%pen          /.false./
  data DAT_mod_text02%cmap         /.false./
  data DAT_mod_text02%cbar         /.false./
  data DAT_mod_text02%title        /.false./
  data DAT_mod_text02%label_top    /.true./
  data DAT_mod_text02%label_bottom /.false./
  data DAT_mod_text02%first        /.false./
  data DAT_mod_text02%last         /.false./

! gmt argument selection - bottom text
  data DAT_mod_text03%name         /"bottom"/
  data DAT_mod_text03%gmt_module   /"pstext"/
  data DAT_mod_text03%infile       /.false./
  data DAT_mod_text03%region       /.true./
  data DAT_mod_text03%fill         /.false./
  data DAT_mod_text03%projection   /.true./
  data DAT_mod_text03%resolution   /.false./
  data DAT_mod_text03%an_maj       /.false./
  data DAT_mod_text03%an_min       /.false./
  data DAT_mod_text03%grid         /.false./
  data DAT_mod_text03%pen          /.false./
  data DAT_mod_text03%cmap         /.false./
  data DAT_mod_text03%cbar         /.false./
  data DAT_mod_text03%title        /.false./
  data DAT_mod_text03%label_top    /.false./
  data DAT_mod_text03%label_bottom /.true./
  data DAT_mod_text03%first        /.false./
  data DAT_mod_text03%last         /.false./

! gmt argument selection - scale
  data DAT_mod_scale01%name         /"scale"/
  data DAT_mod_scale01%gmt_module   /"psscale"/
  data DAT_mod_scale01%infile       /.false./
  data DAT_mod_scale01%region       /.true./
  data DAT_mod_scale01%fill         /.false./
  data DAT_mod_scale01%projection   /.true./
  data DAT_mod_scale01%resolution   /.false./
  data DAT_mod_scale01%an_maj       /.true./
  data DAT_mod_scale01%an_min       /.false./
  data DAT_mod_scale01%grid         /.false./
  data DAT_mod_scale01%pen          /.false./
  data DAT_mod_scale01%cmap         /.true./
  data DAT_mod_scale01%cbar         /.true./
  data DAT_mod_scale01%title        /.false./
  data DAT_mod_scale01%label_top    /.false./
  data DAT_mod_scale01%label_bottom /.false./
  data DAT_mod_scale01%first        /.false./
  data DAT_mod_scale01%last         /.false./

! gmt psscale -R${REGION} -J${PROJECTION} -X0 -Y-8.2 -DjCT+w5.0i/0.4c+o0/2c -Ccol1.cpt -B0.5f0.1 -K -O >> $OUTFILE

! ! gmt argument selection - filled text layer
!   data DAT_mod_title01%name         /"fill text"/
!   data DAT_mod_title01%gmt_module   /"pstext"/
!   data DAT_mod_title01%infile       /.false./
!   data DAT_mod_title01%region       /.true./
!   data DAT_mod_title01%fill         /.true./
!   data DAT_mod_title01%projection   /.true./
!   data DAT_mod_title01%resolution   /.false./
!   data DAT_mod_title01%an_maj       /.false./
!   data DAT_mod_title01%an_min       /.false./
!   data DAT_mod_title01%grid         /.false./
!   data DAT_mod_title01%pen          /.false./
!   data DAT_mod_title01%cmap         /.false./
!   data DAT_mod_title01%title        /.true./
!   data DAT_mod_title01%label_top    /.false./
!   data DAT_mod_title01%label_bottom /.false./
!   data DAT_mod_title01%first        /.false./
!   data DAT_mod_title01%last         /.false./

end module fplt_dat
