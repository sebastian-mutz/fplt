module fplt_dat
!
! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Plotting templates for fplt.                                       |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! load modules
  use :: fplt_typ

! basic options
  implicit none
  private

! settings
  public :: DAT_set_default

! declare public maps
  public :: DAT_map_default

! declare public colour maps
  public :: DAT_cmap_greys, DAT_cmap_bluered01

! declase public module option lists
  public :: DAT_mod_base01, DAT_mod_grdimg01, DAT_mod_coast01
  public :: DAT_mod_text01, DAT_mod_text02, DAT_mod_text03
  public :: DAT_mod_scale01

! ==== Declarations

  type(TYP_map)      :: DAT_map_default
  type(TYP_settings) :: DAT_set_default
  type(TYP_module)   :: DAT_mod_base01, DAT_mod_grdimg01, DAT_mod_coast01
  type(TYP_module)   :: DAT_mod_text01, DAT_mod_text02, DAT_mod_text03
  type(TYP_module)   :: DAT_mod_scale01
  type(TYP_cmap)     :: DAT_cmap_greys, DAT_cmap_bluered01
  integer            :: i

! ==== Data (presents)

! ---- gmt settings

  data DAT_set_default%font               /"Helvetica"/
  data DAT_set_default%col_font_primary   /50, 50, 50/
  data DAT_set_default%col_font_secondary /100, 100, 100/
  data DAT_set_default%col_lines_primary  /100, 100, 100/
  data DAT_set_default%col_background     /255, 255, 255/
  data DAT_set_default%col_foreground     /255, 255, 255/
  data DAT_set_default%col_nan            /255, 255, 255/
  data DAT_set_default%font_size_primary  /18.0_wp/
  data DAT_set_default%font_size_title    /25.0_wp/
  data DAT_set_default%font_size_label    /20.0_wp/
  data DAT_set_default%pen_grid           /0.1_wp/
  data DAT_set_default%pen_tick           /1.0_wp/
  data DAT_set_default%pen_frame          /0.5_wp/
  data DAT_set_default%paper_width        /600.0_wp/
  data DAT_set_default%paper_height       /500.0_wp/


! ---- colour maps

! monochrome scales
  data DAT_cmap_greys%name /"monochrome"/
  data (DAT_cmap_greys%rgb(i,1), i=1,3) /0, 0, 0/
  data (DAT_cmap_greys%rgb(i,2), i=1,3) /0, 0, 0/
  data (DAT_cmap_greys%rgb(i,3), i=1,3) /0, 0, 0/
  data (DAT_cmap_greys%rgb(i,4), i=1,3) /0, 0, 0/
  data (DAT_cmap_greys%rgb(i,5), i=1,3) /255, 255, 255/
  data DAT_cmap_greys%picker            /1, 0, 0, 0, 1/
  data DAT_cmap_greys%z_min             /0.0_wp/
  data DAT_cmap_greys%z_max             /100.0_wp/
  data DAT_cmap_greys%z_step            /5.0_wp/

! 2 colour scale
  data DAT_cmap_bluered01%name /"bluered01"/
  data (DAT_cmap_bluered01%rgb(i,1), i=1,3) /0, 20, 150/
  data (DAT_cmap_bluered01%rgb(i,2), i=1,3) /0, 0, 0/
  data (DAT_cmap_bluered01%rgb(i,3), i=1,3) /255, 255, 255/
  data (DAT_cmap_bluered01%rgb(i,4), i=1,3) /0, 0, 0/
  data (DAT_cmap_bluered01%rgb(i,5), i=1,3) /150, 20, 0/
  data DAT_cmap_bluered01%picker            /1, 0, 1, 0, 1/
  data DAT_cmap_bluered01%z_min             /0.0_wp/
  data DAT_cmap_bluered01%z_max             /100.0_wp/
  data DAT_cmap_bluered01%z_step            /5.0_wp/

! ---- maps

! default map options
  data DAT_map_default%region          /-30.0_wp, 60.0_wp, 30.0_wp, 72.0_wp/
  data DAT_map_default%fill            /200, 200, 200/
  data DAT_map_default%projection      /"M"/
  data DAT_map_default%scale           /400.0_wp/
  data DAT_map_default%resolution      /"l"/
  data DAT_map_default%an_major        /20.0_wp/
  data DAT_map_default%an_minor        /10.0_wp/
  data DAT_map_default%an_ticks        /"WneS"/
  data DAT_map_default%grid            /5.0_wp/
  data DAT_map_default%pen             /0.5_wp/
  data DAT_map_default%cmap            /"monochrome"/
  data DAT_map_default%cbar_tick_major /10.0_wp/
  data DAT_map_default%cbar_tick_minor /2.0_wp/
  data DAT_map_default%cbar_size       /100.0_wp/
  data DAT_map_default%title           /"The Plot Title Can Include Spaces"/
  data DAT_map_default%label_topleft   /"variable name"/
  data DAT_map_default%label_topright  /"units"/

! ---- gmt module options (args construction)

! gmt argument selection - coast
  data DAT_mod_coast01%name           /"pscoast_fill"/
  data DAT_mod_coast01%gmt_module     /"pscoast"/
  data DAT_mod_coast01%infile         /.false./
  data DAT_mod_coast01%region         /.true./
  data DAT_mod_coast01%fill           /.false./
  data DAT_mod_coast01%projection     /.true./
  data DAT_mod_coast01%resolution     /.true./
  data DAT_mod_coast01%an_major       /.true./
  data DAT_mod_coast01%an_minor       /.true./
  data DAT_mod_coast01%grid           /.true./
  data DAT_mod_coast01%pen            /.true./
  data DAT_mod_coast01%cmap           /.false./
  data DAT_mod_coast01%cbar           /.false./
  data DAT_mod_coast01%title          /.false./
  data DAT_mod_coast01%label_topleft  /.false./
  data DAT_mod_coast01%label_topright /.false./
  data DAT_mod_coast01%first          /.false./
  data DAT_mod_coast01%last           /.false./

! gmt argument selection - grid image
  data DAT_mod_grdimg01%name           /"grdimage_basic"/
  data DAT_mod_grdimg01%gmt_module     /"grdimage"/
  data DAT_mod_grdimg01%infile         /.true./
  data DAT_mod_grdimg01%region         /.true./
  data DAT_mod_grdimg01%fill           /.false./
  data DAT_mod_grdimg01%projection     /.true./
  data DAT_mod_grdimg01%resolution     /.false./
  data DAT_mod_grdimg01%an_major       /.false./
  data DAT_mod_grdimg01%an_minor       /.false./
  data DAT_mod_grdimg01%grid           /.false./
  data DAT_mod_grdimg01%pen            /.false./
  data DAT_mod_grdimg01%cmap           /.true./
  data DAT_mod_grdimg01%cbar           /.false./
  data DAT_mod_grdimg01%title          /.false./
  data DAT_mod_grdimg01%label_topleft  /.false./
  data DAT_mod_grdimg01%label_topright /.false./
  data DAT_mod_grdimg01%first          /.false./
  data DAT_mod_grdimg01%last           /.false./

! gmt argument selection - bottom basemap
  data DAT_mod_base01%name           /"basemap_base"/
  data DAT_mod_base01%gmt_module     /"psbasemap"/
  data DAT_mod_base01%infile         /.false./
  data DAT_mod_base01%region         /.true./
  data DAT_mod_base01%fill           /.false./
  data DAT_mod_base01%projection     /.true./
  data DAT_mod_base01%resolution     /.false./
  data DAT_mod_base01%an_major       /.true./
  data DAT_mod_base01%an_minor       /.true./
  data DAT_mod_base01%grid           /.true./
  data DAT_mod_base01%pen            /.false./
  data DAT_mod_base01%cmap           /.false./
  data DAT_mod_base01%cbar           /.false./
  data DAT_mod_base01%title          /.false./
  data DAT_mod_base01%label_topleft  /.false./
  data DAT_mod_base01%label_topright /.false./
  data DAT_mod_base01%first          /.true./
  data DAT_mod_base01%last           /.false./

! gmt argument selection - basemap layer
  data DAT_mod_text01%name           /"title"/
  data DAT_mod_text01%gmt_module     /"pstext"/
  data DAT_mod_text01%infile         /.false./
  data DAT_mod_text01%region         /.true./
  data DAT_mod_text01%fill           /.false./
  data DAT_mod_text01%projection     /.true./
  data DAT_mod_text01%resolution     /.false./
  data DAT_mod_text01%an_major       /.false./
  data DAT_mod_text01%an_minor       /.false./
  data DAT_mod_text01%grid           /.false./
  data DAT_mod_text01%pen            /.false./
  data DAT_mod_text01%cmap           /.false./
  data DAT_mod_text01%cbar           /.false./
  data DAT_mod_text01%title          /.true./
  data DAT_mod_text01%label_topleft  /.false./
  data DAT_mod_text01%label_topright /.false./
  data DAT_mod_text01%first          /.false./
  data DAT_mod_text01%last           /.false./

! gmt argument selection - basemap layer
  data DAT_mod_text02%name           /"top"/
  data DAT_mod_text02%gmt_module     /"pstext"/
  data DAT_mod_text02%infile         /.false./
  data DAT_mod_text02%region         /.true./
  data DAT_mod_text02%fill           /.false./
  data DAT_mod_text02%projection     /.true./
  data DAT_mod_text02%resolution     /.false./
  data DAT_mod_text02%an_major       /.false./
  data DAT_mod_text02%an_minor       /.false./
  data DAT_mod_text02%grid           /.false./
  data DAT_mod_text02%pen            /.false./
  data DAT_mod_text02%cmap           /.false./
  data DAT_mod_text02%cbar           /.false./
  data DAT_mod_text02%title          /.false./
  data DAT_mod_text02%label_topleft  /.true./
  data DAT_mod_text02%label_topright /.false./
  data DAT_mod_text02%first          /.false./
  data DAT_mod_text02%last           /.false./

! gmt argument selection - bottom text
  data DAT_mod_text03%name           /"bottom"/
  data DAT_mod_text03%gmt_module     /"pstext"/
  data DAT_mod_text03%infile         /.false./
  data DAT_mod_text03%region         /.true./
  data DAT_mod_text03%fill           /.false./
  data DAT_mod_text03%projection     /.true./
  data DAT_mod_text03%resolution     /.false./
  data DAT_mod_text03%an_major       /.false./
  data DAT_mod_text03%an_minor       /.false./
  data DAT_mod_text03%grid           /.false./
  data DAT_mod_text03%pen            /.false./
  data DAT_mod_text03%cmap           /.false./
  data DAT_mod_text03%cbar           /.false./
  data DAT_mod_text03%title          /.false./
  data DAT_mod_text03%label_topleft  /.false./
  data DAT_mod_text03%label_topright /.true./
  data DAT_mod_text03%first          /.false./
  data DAT_mod_text03%last           /.false./

! gmt argument selection - scale
  data DAT_mod_scale01%name           /"scale"/
  data DAT_mod_scale01%gmt_module     /"psscale"/
  data DAT_mod_scale01%infile         /.false./
  data DAT_mod_scale01%region         /.true./
  data DAT_mod_scale01%fill           /.false./
  data DAT_mod_scale01%projection     /.true./
  data DAT_mod_scale01%resolution     /.false./
  data DAT_mod_scale01%an_major       /.true./
  data DAT_mod_scale01%an_minor       /.false./
  data DAT_mod_scale01%grid           /.false./
  data DAT_mod_scale01%pen            /.false./
  data DAT_mod_scale01%cmap           /.true./
  data DAT_mod_scale01%cbar           /.true./
  data DAT_mod_scale01%title          /.false./
  data DAT_mod_scale01%label_topleft  /.false./
  data DAT_mod_scale01%label_topright /.false./
  data DAT_mod_scale01%first          /.false./
  data DAT_mod_scale01%last           /.false./

! gmt psscale -R${REGION} -J${PROJECTION} -X0 -Y-8.2 -DjCT+w5.0i/0.4c+o0/2c -Ccol1.cpt -B0.5f0.1 -K -O >> $OUTFILE

! ! gmt argument selection - filled text layer
!   data DAT_mod_title01%name         /"fill text"/
!   data DAT_mod_title01%gmt_module   /"pstext"/
!   data DAT_mod_title01%infile       /.false./
!   data DAT_mod_title01%region       /.true./
!   data DAT_mod_title01%fill         /.true./
!   data DAT_mod_title01%projection   /.true./
!   data DAT_mod_title01%resolution   /.false./
!   data DAT_mod_title01%an_major       /.false./
!   data DAT_mod_title01%an_minor       /.false./
!   data DAT_mod_title01%grid         /.false./
!   data DAT_mod_title01%pen          /.false./
!   data DAT_mod_title01%cmap         /.false./
!   data DAT_mod_title01%title        /.true./
!   data DAT_mod_title01%label_topleft    /.false./
!   data DAT_mod_title01%label_topright /.false./
!   data DAT_mod_title01%first        /.false./
!   data DAT_mod_title01%last         /.false./

end module fplt_dat
