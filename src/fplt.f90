module fplt

! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Module serves as abstraction layer and contains core procedures.   |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! FORD
!! Abstraction layer and contains core procedures.

! load modules
  use, intrinsic :: iso_c_binding
  use            :: fplt_typ
  use            :: fplt_utl
  use            :: fplt_gmt
  use            :: fplt_dat

! basic options
  implicit none
  private

! declare public types
  public :: TYP_cmap, TYP_map, TYP_module

! declare public data
  public :: DAT_map, DAT_mod, DAT_cmap

! declare public procedures
  public :: fplt_map


contains

! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_map(map_opt, infile, outfile)

! ==== Description
!! Uses fortran-gmt interface for creating a map.
!!
!! map_opt        : map options
!! infile/outfile : name of input and output files
!! module_stack   : names of module templates to work through in order
!! w_file         : working file (original or converted infile)
!! w_cmap         : colour map being worked with (looked up)
!! w_set          : settings being worked with (looked up)
!! w_mod          : module template being worked with (looked up)

! ==== Declarations
  type(TYP_map)                  , intent(in) :: map_opt
  character(len=*)               , intent(in) :: infile, outfile
  type(c_ptr)                                 :: session
  integer(c_int)                              :: status
  character(kind=c_char, len=20)              :: session_name
  character(kind=c_char, len=256), target     :: args
  character(len=32)                           :: module_stack(7)
  character(len=256)                          :: w_file
  type(TYP_cmap)                              :: w_cmap
  type(TYP_settings)                          :: w_set
  type(TYP_module)                            :: w_mod
  character(len=256)                          :: fstring
  integer(i4)                                 :: i, j

! ==== Instructions

! construct module stack for maps
  data module_stack /"basemap01", "grdimage01", "pscoast01", "scale01"&
                  &, "title01", "label01", "label02"/
  write(std_o, *) "> Fortran-GMT module stack created"

! initialise GMT session
  call plt_init(session, session_name)


! ---- Input file handling

! determine file format
  fstring = f_get_format(infile)
  write(std_o, *) "> Input file format: ", trim(fstring)

! convert file format if necessary
! TODO: seperatre module if expanded
  select case (fstring)
     case ("text")
        ! update workfile
        w_file="temp.grd"
        ! construct arguments
        call plt_args_xyz2grd(map_opt, infile, w_file, fstring)
        args = trim(fstring) // c_null_char
        write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)
        ! gmt module calls
        call plt_module(session, "xyz2grd", args)
        write(std_o, *) "> Text file converted to grid file: ", trim(w_file)
     case ("grid")
        ! use infile as working file
        w_file=infile
     case ("unknown")
        write(std_o, *) "> Unknown file format. Stopping."
        stop
  end select


! ---- Apply settings

! find theme/settings in dict
  do i=1,size(DAT_set)
     ! check if names match
     if (map_opt%theme .eq. DAT_set(i)%name) then
       w_set = DAT_set(i)
       exit
     ! if end of dict is reached and no match found, stop
     elseif (i .eq. size(DAT_set)) then
        write(std_o, *) "> Error: specified theme not found"
        stop
     endif
  enddo

! gmt settings
  call plt_set(session, w_set)


! ---- Create colour map

! find colour map in dict
  do i=1,size(DAT_cmap)
     ! check if names match
     if (map_opt%cmap .eq. DAT_cmap(i)%name) then
       w_cmap = DAT_cmap(i)
       exit
     ! if end of dict is reached and no match found, stop
     elseif (i .eq. size(DAT_cmap)) then
        write(std_o, *) "> Error: specified colour map not found"
        stop
     endif
  enddo

! get args for making colour map
  call plt_args_cmap(map_opt, w_cmap, fstring)
  args = trim(fstring) // c_null_char
  write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

! make colour map
  call plt_module(session, "makecpt", args)
  write(std_o, *) "> Colour map created: ", trim(w_cmap%name)


! ---- Create map

! work through module stack
  do i=1,size(module_stack)

     ! find colour map in dict
     do j=1,size(DAT_mod)
        ! check if names match
        if (module_stack(i) .eq. DAT_mod(j)%name) then
          w_mod = DAT_mod(j)
          exit
        ! if end of dict is reached and no match found, stop
        elseif (j .eq. size(DAT_mod)) then
           write(std_o, *) "> Error: specified module template not found"
           stop
        endif
     enddo

     ! prepare the arguments
     call plt_args_map(map_opt, w_file, outfile, w_mod, fstring)
     args = trim(fstring) // c_null_char
     write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

     ! gmt module calls
     call plt_module(session, trim(w_mod%gmt_module), args)
  enddo


! ---- Finish

! destroy GMT session
  call plt_destroy(session)

! TODO: clean up temporary files (separate subroutine)

end subroutine fplt_map


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine plt_module(session, module_name, args)

! ==== Description
!! Single GMT  module call.

! ==== Declarations
  type(c_ptr)                            , intent(in) :: session
  character(len=*)                       , intent(in) :: module_name
  character(kind=c_char, len=256), target, intent(in) :: args
  integer(c_int), parameter                           :: cmd=0
  integer(c_int)                                      :: status

! ==== Instructions

! Call the module
  status = GMT_Call_Module(session, trim(module_name) // c_null_char, cmd, c_loc(args))
  if (status .eq. 0) then
     write(std_o, *) "> Fortran-GMT module executed successfully: ", trim(module_name)
  else
     write(std_o, *) "> Fortran-GMT module execution failed. Error code:", status
     stop
  end if

end subroutine plt_module


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine plt_init(session, session_name)

! ==== Description
!! Create GMT session.

! ==== Declarations
  type(c_ptr)                   , intent(out) :: session
  character(kind=c_char, len=20), intent(out) :: session_name
  integer(c_int), parameter                   :: pad=0, mode=0, cmd=0
  type(c_ptr)                                 :: parent

! ==== Instructions

! create session
  session_name = "fortran-gmt-session" // c_null_char
  parent = c_null_ptr
  session = gmt_create_session(session_name, pad, mode, parent)
  if (c_associated(session)) then
     write(std_o, *) "> Fortran-GMT session created successfully: ", trim(session_name)
  else
     write(std_o, *) "> Failed to create Fortran-GMT session."
     stop
  endif

end subroutine plt_init


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine plt_destroy(session)

! ==== Description
!! Destroy GMT session.

! ==== Declarations
  type(c_ptr), intent(in) :: session
  integer(c_int)          :: status

! ==== Instructions

! destroy session
  status = gmt_destroy_session(session)
  if (status .eq. 0) then
     write(std_o, *) "> Fortran-GMT session destroyed successfully"
  else
     write(std_o, *) "> Failed to destroy Fortran-GMT session. Error code:", status
     stop
  endif

end subroutine plt_destroy


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine plt_set(session, settings)

! ==== Description
!! Apply GMT settings based on general settings and map options.

! ==== Declarations
  type(TYP_settings)             , intent(in) :: settings
  type(c_ptr)                    , intent(in) :: session
  character(kind=c_char, len=256), target     :: args
  integer(c_int)                              :: status
  character(len=256)                          :: fstring

! TODO: Option to adjust paper size depending on plot size (both in pixels).
!       Would have to convert coordinates to paper dims based on projection.

! ==== Instructions

! paper settings
  fstring = "PS_MEDIA Custom_"&
  & // trim(f_r2c( settings%paper_height )) // "x"&
  & // trim(f_r2c( settings%paper_width )) // "p"
  args = fstring // c_null_char
  call plt_module(session, "gmtset", args)

! page background colour
  fstring = "PS_PAGE_COLOR "&
  & // trim(f_i2c( settings%col_background(1) )) // "/"&
  & // trim(f_i2c( settings%col_background(2) )) // "/"&
  & // trim(f_i2c( settings%col_background(3) ))
  args = fstring // c_null_char
  call plt_module(session, "gmtset", args)

! map frame colour
  fstring = "MAP_FRAME_PEN "&
  & // trim(f_i2c( settings%col_frame(1) )) // "/"&
  & // trim(f_i2c( settings%col_frame(2) )) // "/"&
  & // trim(f_i2c( settings%col_frame(3) ))
  args = fstring // c_null_char
  call plt_module(session, "gmtset", args)

! map grid line colour
  fstring = "MAP_GRID_PEN_PRIMARY "&
  & // trim(f_i2c( settings%col_lines_primary(1) )) // "/"&
  & // trim(f_i2c( settings%col_lines_primary(2) )) // "/"&
  & // trim(f_i2c( settings%col_lines_primary(3) ))
  args = fstring // c_null_char
  call plt_module(session, "gmtset", args)

! map annotation colour (make same as primary font)
  fstring = "MAP_TICK_PEN_PRIMARY "&
  & // trim(f_i2c( settings%col_font_primary(1) )) // "/"&
  & // trim(f_i2c( settings%col_font_primary(2) )) // "/"&
  & // trim(f_i2c( settings%col_font_primary(3) ))
  args = fstring // c_null_char
  call plt_module(session, "gmtset", args)

! font options
  fstring = "FONT_ANNOT_PRIMARY "&
  & // trim(f_r2c( settings%font_size_primary )) // "p,"&
  & // char(34) // trim( settings%font ) // char(34) // ","&
  & // trim(f_i2c( settings%col_font_primary(1) )) // "/"&
  & // trim(f_i2c( settings%col_font_primary(2) )) // "/"&
  & // trim(f_i2c( settings%col_font_primary(3) ))
  args = fstring // c_null_char
  call plt_module(session, "gmtset", args)

end subroutine plt_set


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine plt_args_xyz2grd(map_opt, infile, outfile, fstring)

! ==== Description
!! Crafts a fortran string for making a colour map
!! as argument string to be used in the gmt module

! ==== Declarations
  type(TYP_map)     , intent(in)  :: map_opt
  character(len=*)  , intent(in)  :: infile, outfile
  character(len=256), intent(out) :: fstring

! ==== Instructions

! start with infile
  fstring = trim(infile)

! region option
  fstring = trim(fstring) // " -R"&
  & // trim(f_r2c( map_opt%region(1) )) // "/"&
  & // trim(f_r2c( map_opt%region(2) )) // "/"&
  & // trim(f_r2c( map_opt%region(3) )) // "/"&
  & // trim(f_r2c( map_opt%region(4) ))

! set grid spacing; make high res (2 degrees) as default
! TODO: worth making an option? not an attribute of map, so perhaps make
! derived type for files. Alternatively determine automatically
  fstring = trim(fstring) // " -I2d"

! grid output
  fstring = trim(fstring) // " -G" // trim(outfile)

end subroutine plt_args_xyz2grd


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine plt_args_cmap(map_opt, cmap_opt, fstring)

! ==== Description
!! Crafts a fortran string for making a colour map
!! as argument string to be used in the gmt module

! ==== Declarations
  type(TYP_map)     , intent(in)  :: map_opt
  type(TYP_cmap)    , intent(in)  :: cmap_opt
  character(len=256), intent(out) :: fstring
  character(len=32)               :: fstring_partial
  integer(i4)                     :: i

! ==== Instructions

! ---- RGB args
  fstring = " -C"
! loop through all rgb values and append to-be-used ones to arguments
  do i=1,size(cmap_opt%picker)-1
     if (cmap_opt%picker(i) .eq. 1) then
        fstring = trim(fstring)&
        & // trim(f_i2c( cmap_opt%rgb(1,i) )) // "/"&
        & // trim(f_i2c( cmap_opt%rgb(2,i) )) // "/"&
        & // trim(f_i2c( cmap_opt%rgb(3,i) )) // ","
     endif
  enddo
! append string for last rgb value
  i=size(cmap_opt%picker)
  fstring = trim(fstring)&
  & // trim(f_i2c( cmap_opt%rgb(1,i) )) // "/"&
  & // trim(f_i2c( cmap_opt%rgb(2,i) )) // "/"&
  & // trim(f_i2c( cmap_opt%rgb(3,i) ))

! ---- Z value args
! TODO: think about changing float length in f_r2c to enable larger numbers here
  fstring = trim(fstring) // " -T"&
  & // trim(f_r2c( map_opt%z_min )) // "/"&
  & // trim(f_r2c( map_opt%z_max )) // "/"&
  & // trim(f_r2c( map_opt%z_step ))

! ---- output
  fstring = trim(fstring) // " -Z > " // trim(cmap_opt%name) // ".cpt"

end subroutine plt_args_cmap


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine plt_args_map(map_opt, infile, outfile, module_opt, fstring)

! ==== Description
!! Crafts a fortran string from map options that serves
!! as argument string to be used in the gmt module

! ==== Declarations
  type(TYP_map)     , intent(in)  :: map_opt
  type(TYP_module)  , intent(in)  :: module_opt
  character(len=*)  , intent(in)  :: infile, outfile
  character(len=256), intent(out) :: fstring

! ==== Instructions

  fstring = ""

  ! infile
  if (module_opt%infile) then
     fstring = trim(fstring) // trim(infile)
  endif

  ! region option
  if (module_opt%region) then
     fstring = trim(fstring) // " -R" &
     & // trim(f_r2c( map_opt%region(1) )) // "/"&
     & // trim(f_r2c( map_opt%region(2) )) // "/"&
     & // trim(f_r2c( map_opt%region(3) )) // "/"&
     & // trim(f_r2c( map_opt%region(4) ))
  endif

  ! projection and scale
  if (module_opt%projection) then
     select case (map_opt%projection)
        ! M - Mercator projection
        ! J - Miller Cylindrical projection
        ! Q - Cylindrical equidistant projection
        case ("M", "J", "Q")
           fstring = trim(fstring) // " -J"&
           & // trim(map_opt%projection)&
           & // trim(f_r2c( map_opt%scale )) // "p"
        ! L - Lambert conic conformal projection
        ! B - Albers conic equal-area
        ! D - Equidistant conic projection
        case ("L", "B", "D")
           fstring = trim(fstring) // " -J"&
           & // trim(map_opt%projection)&
           & // trim(f_r2c( map_opt%centre(1) )) // "/"&
           & // trim(f_r2c( map_opt%centre(2) )) // "/"&
           & // trim(f_r2c( map_opt%parallels(1) )) // "/"&
           & // trim(f_r2c( map_opt%parallels(2) )) // "/"&
           & // trim(f_r2c( map_opt%scale )) // "p"
     end select
  endif

  ! resolution
  if (module_opt%resolution) then
     fstring = trim(fstring) // " -D" // trim(map_opt%resolution)
  endif

  ! fill
  if (module_opt%fill) then
     fstring = trim(fstring) // " -G"&
     & // trim(f_i2c( map_opt%fill(1) )) // "/"&
     & // trim(f_i2c( map_opt%fill(2) )) // "/"&
     & // trim(f_i2c( map_opt%fill(3) ))
  endif

  ! annotations and grid
  if (module_opt%an_major .and. module_opt%an_minor .and. module_opt%grid) then
     fstring = trim(fstring) // " -Ba" &
     & // trim(f_r2c( map_opt%an_major )) // "f"&
     & // trim(f_r2c( map_opt%an_minor )) // "g"&
     & // trim(f_r2c( map_opt%grid )) // " -B"&
     & // trim(map_opt%an_ticks)
  endif

  ! pen
  if (module_opt%pen) then
     fstring = trim(fstring) // " -W" // trim(f_r2c( map_opt%pen )) // "p"
  endif

  ! colour map
  if (module_opt%cmap) then
     fstring = trim(fstring) // " -C" // trim(map_opt%cmap) // ".cpt"
  endif

  ! additional colour bar options
  if (module_opt%cbar) then
     fstring = trim(fstring) // " -B"&
     & // trim(f_r2c( map_opt%cbar_tick_major )) // "f"&
     & // trim(f_r2c( map_opt%cbar_tick_minor )) // " -DJRM+v+w"&
     & // trim(f_r2c( map_opt%cbar_size )) // "%"&
     & // " -X" // trim(f_r2c( map_opt%padding )) // "p"
  endif

  ! title (top centre)
  if (module_opt%title) then
     ! add Y offset based on font sizes and padding (title+label+2*padding)
     fstring = trim(fstring) // " -Y" // trim(f_r2c( &
     & map_opt%font_size_title + &
     & map_opt%font_size_label + &
     & 2*map_opt%padding )) // "p"&
     & // " -X-" // trim(f_r2c( map_opt%padding )) // "p" &
     ! placement (top centre) and font options
     & // " -F+cTC+f" // trim(f_r2c( map_opt%font_size_title )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%title) // char(34) // ""
  endif

  ! top left corner text
  if (module_opt%label_left) then
     ! add Y offset relative to title based on font sizes and padding (title+padding)
     fstring = trim(fstring) // " -Y-" // trim(f_r2c( &
     & map_opt%font_size_title + &
     & map_opt%padding )) // "p"&
     ! placement (top left) and font options
     & // " -F+cTL+f" // trim(f_r2c( map_opt%font_size_label )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%label_left) // char(34) // ""
  endif

  ! top right text
  if (module_opt%label_right) then
     ! note: no Y offset needed relative to top left text
     ! placement (top right) and font options
     fstring = trim(fstring) // " -F+cTR+f"&
     & // trim(f_r2c( map_opt%font_size_label )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%label_right) // char(34) // ""
  endif

  ! writing/adding to outfile
  if (module_opt%first) then
     if (module_opt%last) then
        ! single layer plot
        fstring = trim(fstring) // " > " // trim(outfile)
     else
        ! first layer in a stack
        fstring = trim(fstring) // " -K > " // trim(outfile)
     endif
  else
     if (module_opt%last) then
        ! last layer in a stack
        fstring = trim(fstring) // " -O >> " // trim(outfile)
     else
        ! sandwiched layer in stack
        fstring = trim(fstring) // " -O -K >> " // trim(outfile)
     endif
  endif

end subroutine plt_args_map

end module fplt
