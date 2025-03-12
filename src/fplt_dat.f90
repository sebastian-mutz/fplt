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
  public :: DAT_set

! declare public maps
  public :: DAT_map

! declare public colour maps
  public :: DAT_cmap

! declase public module option lists
  public :: DAT_mod_base01, DAT_mod_grdimg01, DAT_mod_coast01
  public :: DAT_mod_text01, DAT_mod_text02, DAT_mod_text03
  public :: DAT_mod_scale01

! ==== Declarations

! TODO: store map and settings templates in dictionaries (like cmaps) and identify by map template name
! TODO: think about doing this for module templates (or perhaps separate by gmt module type)
  type(TYP_map)      :: DAT_map
  type(TYP_settings) :: DAT_set(2)
  type(TYP_module)   :: DAT_mod_base01, DAT_mod_grdimg01, DAT_mod_coast01
  type(TYP_module)   :: DAT_mod_text01, DAT_mod_text02, DAT_mod_text03
  type(TYP_module)   :: DAT_mod_scale01
  type(TYP_cmap)     :: DAT_cmap(2)     ! colour map collection
  integer            :: i

! ==== Data (presents)

! ---- gmt settings

  data DAT_set(1)%name               /"light"/
  data DAT_set(1)%font               /"Helvetica"/
  data DAT_set(1)%col_font_primary   /50, 50, 50/
  data DAT_set(1)%col_font_secondary /100, 100, 100/
  data DAT_set(1)%col_lines_primary  /100, 100, 100/
  data DAT_set(1)%col_background     /255, 255, 255/
  data DAT_set(1)%col_frame          /50, 50, 50/
  data DAT_set(1)%col_nan            /255, 255, 255/
  data DAT_set(1)%font_size_primary  /18.0_wp/
  data DAT_set(1)%pen_grid           /0.1_wp/
  data DAT_set(1)%pen_tick           /1.0_wp/
  data DAT_set(1)%pen_frame          /0.5_wp/
  data DAT_set(1)%paper_width        /560.0_wp/
  data DAT_set(1)%paper_height       /480.0_wp/

  data DAT_set(2)%name               /"dark"/
  data DAT_set(2)%font               /"Helvetica"/
  data DAT_set(2)%col_font_primary   /200, 200, 200/
  data DAT_set(2)%col_font_secondary /150, 150, 150/
  data DAT_set(2)%col_lines_primary  /255, 255, 255/
  data DAT_set(2)%col_background     /0, 0, 0/
  data DAT_set(2)%col_frame          /220, 220, 220/
  data DAT_set(2)%col_nan            /0, 0, 0/
  data DAT_set(2)%font_size_primary  /18.0_wp/
  data DAT_set(2)%pen_grid           /0.1_wp/
  data DAT_set(2)%pen_tick           /1.0_wp/
  data DAT_set(2)%pen_frame          /0.5_wp/
  data DAT_set(2)%paper_width        /560.0_wp/
  data DAT_set(2)%paper_height       /480.0_wp/


! ---- colour maps

! monochrome scales
  data DAT_cmap(1)%name /"monochrome"/
  data (DAT_cmap(1)%rgb(i,1), i=1,3) /0, 0, 0/
  data (DAT_cmap(1)%rgb(i,2), i=1,3) /0, 0, 0/
  data (DAT_cmap(1)%rgb(i,3), i=1,3) /0, 0, 0/
  data (DAT_cmap(1)%rgb(i,4), i=1,3) /0, 0, 0/
  data (DAT_cmap(1)%rgb(i,5), i=1,3) /255, 255, 255/
  data DAT_cmap(1)%picker            /1, 0, 0, 0, 1/

! 2 colour scale
  data DAT_cmap(2)%name /"bluered01"/
  data (DAT_cmap(2)%rgb(i,1), i=1,3) /0, 20, 180/
  data (DAT_cmap(2)%rgb(i,2), i=1,3) /0, 0, 0/
  data (DAT_cmap(2)%rgb(i,3), i=1,3) /220, 220, 220/
  data (DAT_cmap(2)%rgb(i,4), i=1,3) /0, 0, 0/
  data (DAT_cmap(2)%rgb(i,5), i=1,3) /180, 20, 0/
  data DAT_cmap(2)%picker            /1, 0, 1, 0, 1/


! ---- maps

! default map options
  data DAT_map%name            /"default"/
  data DAT_map%theme           /"light"/
  data DAT_map%region          /-30.0_wp, 60.0_wp, 30.0_wp, 72.0_wp/
  data DAT_map%fill            /200, 200, 200/
  data DAT_map%projection      /"M"/
  data DAT_map%scale           /400.0_wp/
  data DAT_map%centre          /15.0_wp, 30.0_wp/
  data DAT_map%parallels       /40.0_wp, 60.0_wp/
  data DAT_map%resolution      /"l"/
  data DAT_map%an_major        /20.0_wp/
  data DAT_map%an_minor        /10.0_wp/
  data DAT_map%an_ticks        /"WneS"/
  data DAT_map%grid            /5.0_wp/
  data DAT_map%pen             /0.5_wp/
  data DAT_map%cmap            /"monochrome"/
  data DAT_map%cbar_tick_major /10.0_wp/
  data DAT_map%cbar_tick_minor /2.0_wp/
  data DAT_map%z_min           /0.0_wp/
  data DAT_map%z_max           /100.0_wp/
  data DAT_map%z_step          /5.0_wp/
  data DAT_map%title           /"The Plot Title Can Include Spaces"/
  data DAT_map%label_left      /"variable name"/
  data DAT_map%label_right     /"units"/
  data DAT_map%font_size_title /25.0_wp/
  data DAT_map%font_size_label /20.0_wp/
  data DAT_map%padding         /10.0_wp/
  data DAT_map%cbar_size       /100.0_wp/

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
  data DAT_mod_coast01%label_left     /.false./
  data DAT_mod_coast01%label_right    /.false./
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
  data DAT_mod_grdimg01%label_left     /.false./
  data DAT_mod_grdimg01%label_right    /.false./
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
  data DAT_mod_base01%label_left     /.false./
  data DAT_mod_base01%label_right    /.false./
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
  data DAT_mod_text01%label_left     /.false./
  data DAT_mod_text01%label_right    /.false./
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
  data DAT_mod_text02%label_left     /.true./
  data DAT_mod_text02%label_right    /.false./
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
  data DAT_mod_text03%label_left     /.false./
  data DAT_mod_text03%label_right    /.true./
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
  data DAT_mod_scale01%label_left     /.false./
  data DAT_mod_scale01%label_right    /.false./
  data DAT_mod_scale01%first          /.false./
  data DAT_mod_scale01%last           /.false./

end module fplt_dat
