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

! FORD
!! Data, presents, templates.

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
  public :: DAT_mod

! ==== Declarations

! TODO: store map and settings templates in dictionaries (like cmaps) and identify by map template name, but pass to working map that can be modified from main
  type(TYP_map)      :: DAT_map
  type(TYP_settings) :: DAT_set(2)
  type(TYP_module)   :: DAT_mod(7)
  type(TYP_cmap)     :: DAT_cmap(2)     ! colour map collection
  integer            :: i

! ==== Data (presents)


! ---- gmt settings

! default light theme
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
  data DAT_set(1)%paper_height       /560.0_wp/

! dark theme
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
  data DAT_set(2)%paper_height       /560.0_wp/


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
  data DAT_map%infile          /"data.asc"/
  data DAT_map%outfile         /"map01"/
  data DAT_map%format          /"png"/

! ---- gmt module options (args construction)

! gmt argument selection - coast
  data DAT_mod(1)%name           /"pscoast01"/
  data DAT_mod(1)%gmt_module     /"pscoast"/
  data DAT_mod(1)%infile         /.false./
  data DAT_mod(1)%region         /.true./
  data DAT_mod(1)%fill           /.false./
  data DAT_mod(1)%projection     /.true./
  data DAT_mod(1)%resolution     /.true./
  data DAT_mod(1)%an_major       /.true./
  data DAT_mod(1)%an_minor       /.true./
  data DAT_mod(1)%grid           /.true./
  data DAT_mod(1)%pen            /.true./
  data DAT_mod(1)%cmap           /.false./
  data DAT_mod(1)%cbar           /.false./
  data DAT_mod(1)%title          /.false./
  data DAT_mod(1)%label_left     /.false./
  data DAT_mod(1)%label_right    /.false./
  data DAT_mod(1)%first          /.false./
  data DAT_mod(1)%last           /.false./

! gmt argument selection - grid image
  data DAT_mod(2)%name           /"grdimage01"/
  data DAT_mod(2)%gmt_module     /"grdimage"/
  data DAT_mod(2)%infile         /.true./
  data DAT_mod(2)%region         /.true./
  data DAT_mod(2)%fill           /.false./
  data DAT_mod(2)%projection     /.true./
  data DAT_mod(2)%resolution     /.false./
  data DAT_mod(2)%an_major       /.false./
  data DAT_mod(2)%an_minor       /.false./
  data DAT_mod(2)%grid           /.false./
  data DAT_mod(2)%pen            /.false./
  data DAT_mod(2)%cmap           /.true./
  data DAT_mod(2)%cbar           /.false./
  data DAT_mod(2)%title          /.false./
  data DAT_mod(2)%label_left     /.false./
  data DAT_mod(2)%label_right    /.false./
  data DAT_mod(2)%first          /.false./
  data DAT_mod(2)%last           /.false./

! gmt argument selection - bottom basemap
  data DAT_mod(3)%name           /"basemap01"/
  data DAT_mod(3)%gmt_module     /"psbasemap"/
  data DAT_mod(3)%infile         /.false./
  data DAT_mod(3)%region         /.true./
  data DAT_mod(3)%fill           /.false./
  data DAT_mod(3)%projection     /.true./
  data DAT_mod(3)%resolution     /.false./
  data DAT_mod(3)%an_major       /.true./
  data DAT_mod(3)%an_minor       /.true./
  data DAT_mod(3)%grid           /.true./
  data DAT_mod(3)%pen            /.false./
  data DAT_mod(3)%cmap           /.false./
  data DAT_mod(3)%cbar           /.false./
  data DAT_mod(3)%title          /.false./
  data DAT_mod(3)%label_left     /.false./
  data DAT_mod(3)%label_right    /.false./
  data DAT_mod(3)%first          /.true./
  data DAT_mod(3)%last           /.false./

! gmt argument selection - title text
  data DAT_mod(4)%name           /"title01"/
  data DAT_mod(4)%gmt_module     /"pstext"/
  data DAT_mod(4)%infile         /.false./
  data DAT_mod(4)%region         /.true./
  data DAT_mod(4)%fill           /.false./
  data DAT_mod(4)%projection     /.true./
  data DAT_mod(4)%resolution     /.false./
  data DAT_mod(4)%an_major       /.false./
  data DAT_mod(4)%an_minor       /.false./
  data DAT_mod(4)%grid           /.false./
  data DAT_mod(4)%pen            /.false./
  data DAT_mod(4)%cmap           /.false./
  data DAT_mod(4)%cbar           /.false./
  data DAT_mod(4)%title          /.true./
  data DAT_mod(4)%label_left     /.false./
  data DAT_mod(4)%label_right    /.false./
  data DAT_mod(4)%first          /.false./
  data DAT_mod(4)%last           /.false./

! gmt argument selection- label text 1
  data DAT_mod(5)%name           /"label01"/
  data DAT_mod(5)%gmt_module     /"pstext"/
  data DAT_mod(5)%infile         /.false./
  data DAT_mod(5)%region         /.true./
  data DAT_mod(5)%fill           /.false./
  data DAT_mod(5)%projection     /.true./
  data DAT_mod(5)%resolution     /.false./
  data DAT_mod(5)%an_major       /.false./
  data DAT_mod(5)%an_minor       /.false./
  data DAT_mod(5)%grid           /.false./
  data DAT_mod(5)%pen            /.false./
  data DAT_mod(5)%cmap           /.false./
  data DAT_mod(5)%cbar           /.false./
  data DAT_mod(5)%title          /.false./
  data DAT_mod(5)%label_left     /.true./
  data DAT_mod(5)%label_right    /.false./
  data DAT_mod(5)%first          /.false./
  data DAT_mod(5)%last           /.false./

! gmt argument selection - label text 2
  data DAT_mod(6)%name           /"label02"/
  data DAT_mod(6)%gmt_module     /"pstext"/
  data DAT_mod(6)%infile         /.false./
  data DAT_mod(6)%region         /.true./
  data DAT_mod(6)%fill           /.false./
  data DAT_mod(6)%projection     /.true./
  data DAT_mod(6)%resolution     /.false./
  data DAT_mod(6)%an_major       /.false./
  data DAT_mod(6)%an_minor       /.false./
  data DAT_mod(6)%grid           /.false./
  data DAT_mod(6)%pen            /.false./
  data DAT_mod(6)%cmap           /.false./
  data DAT_mod(6)%cbar           /.false./
  data DAT_mod(6)%title          /.false./
  data DAT_mod(6)%label_left     /.false./
  data DAT_mod(6)%label_right    /.true./
  data DAT_mod(6)%first          /.false./
  data DAT_mod(6)%last           /.true./

! gmt argument selection - scale
  data DAT_mod(7)%name           /"scale01"/
  data DAT_mod(7)%gmt_module     /"psscale"/
  data DAT_mod(7)%infile         /.false./
  data DAT_mod(7)%region         /.true./
  data DAT_mod(7)%fill           /.false./
  data DAT_mod(7)%projection     /.true./
  data DAT_mod(7)%resolution     /.false./
  data DAT_mod(7)%an_major       /.true./
  data DAT_mod(7)%an_minor       /.false./
  data DAT_mod(7)%grid           /.false./
  data DAT_mod(7)%pen            /.false./
  data DAT_mod(7)%cmap           /.true./
  data DAT_mod(7)%cbar           /.true./
  data DAT_mod(7)%title          /.false./
  data DAT_mod(7)%label_left     /.false./
  data DAT_mod(7)%label_right    /.false./
  data DAT_mod(7)%first          /.false./
  data DAT_mod(7)%last           /.false./

end module fplt_dat
