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

! load modules and import map template to modify
  use :: fplt, my_map => DAT_map, my_heatmap => DAT_heatmap

! basic options
  implicit none

! TODO: based on opts, load dat_* and pass to working types (cp_template function) using identifiers, then simply modify those


! ===== map

! set output file format
  my_map%infile  = "./test/maps/Mutz_et_al_2018_pd_temp2.asc"
  my_map%outfile = "map01" ! default
  my_map%format  = "png"   ! default

! set plot labels
  my_map%title = "Simulated Temperature (1979-2000)"
  my_map%label_left = "2m air temperature"
  my_map%label_right= "deg C"

! change colour map
  my_map%cmap="bluered01"

! modify preset colour map
  my_map%zmin  = -30
  my_map%zmax  = 30
  my_map%zstep = 1

! change theme
  my_map%theme = "dark"

! change projection
  my_map%projection = "L"

! plot map from text file using the default map cp_template
  call fplt_map(my_map)


! ===== heatmap

! set output file format
  my_heatmap%infile  = "./test/heatmaps/Mutz_et_al_2021_rcp26_rcp85.asc"

! set plot labels
  my_heatmap%title = "Fix the Heatmap!"
  my_heatmap%label_left = "2m air temperature"
  my_heatmap%label_right= "deg C"

! change colour map
  my_heatmap%cmap="bluered01"

! modify preset colour map
 my_heatmap%xmax  = 24
 my_heatmap%ymax  = 10

! modify preset colour map
 my_heatmap%zmin  = -10
 my_heatmap%zmax  = 10
 my_heatmap%zstep = 1.0

! change theme
  my_heatmap%theme = "dark"

! plot map from text file using the default map cp_template
  call fplt_map(my_heatmap)


end program main
