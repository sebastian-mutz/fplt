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
  public :: DAT_map_default, DAT_mod_coast01, DAT_cmap_greys, DAT_cmap_bluered01

! declare public procedures
  public :: fplt_map


contains

! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_map(map_opt, infile, outfile)

! ==== Description
!! Uses fortran-gmt interface for creating a map.

! ==== Declarations
  type(TYP_map)                  , intent(in) :: map_opt
  character(len=*)               , intent(in) :: infile, outfile
  character(len=256)                          :: workfile
  type(c_ptr)                                 :: session
  character(kind=c_char, len=20)              :: session_name
  character(kind=c_char, len=256), target     :: args
  integer(c_int)                              :: status
  character(len=256)                          :: fstring
  type(TYP_module)                            :: module_stack(7)
  integer(i4)                                 :: i

! ==== Instructions

! construct module stack for maps
  module_stack(1) = DAT_mod_base01
  module_stack(2) = DAT_mod_grdimg01
  module_stack(3) = DAT_mod_coast01
  module_stack(4) = DAT_mod_scale01
  module_stack(5) = DAT_mod_text01
  module_stack(6) = DAT_mod_text02
  module_stack(7) = DAT_mod_text03
  write(std_o, *) "> Fortran-GMT module stack created"

! initialise GMT session
  call plt_init(session, session_name)

! gmt settings
  call plt_set(session, DAT_set_default)
  write(std_o, *) "test"

! determine file format
  call plt_get_format(infile, fstring)
  write(std_o, *) "> Input file format: ", trim(fstring)

! convert file format if necessary
! TODO: seperatre module if expanded
  select case (fstring)
     case ("text")
        ! update workfile
        workfile="temp.grd"

        ! construct arguments
        call plt_args_xyz2grd(map_opt, infile, workfile, fstring)
        args = trim(fstring) // c_null_char
        write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

        ! gmt module calls
        call plt_module(session, "xyz2grd", args)
        write(std_o, *) "> Text file converted to grid file: ", trim(workfile)

     case ("grid")
        ! use infile as working file
        workfile=infile

     case ("unknown")
        write(std_o, *) "> Unknown file format. Stopping."
        stop
  end select

! get args for making colour map
! TODO: search for cmap based on name
  call plt_args_cmap(DAT_cmap_bluered01, fstring)
  args = trim(fstring) // c_null_char
  write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

! make colour map
  call plt_module(session, "makecpt", args)
  write(std_o, *) "> Colour map created: ", trim(DAT_cmap_bluered01%name)

! work through module stack
  do i=1,size(module_stack)

     ! prepare the arguments
     call plt_args_map(map_opt, workfile, outfile, module_stack(i), fstring)
     args = trim(fstring) // c_null_char
     write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

     ! gmt module calls
     call plt_module(session, trim(module_stack(i)%gmt_module), args)
  enddo

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
subroutine plt_set(session, settings)

! ==== Description
!! Apply GMT settings.

! ==== Declarations
  type(TYP_settings)             , intent(in) :: settings
  type(c_ptr)                    , intent(in) :: session
  character(kind=c_char, len=256), target     :: args
  integer(c_int)                              :: status
  character(len=256)                          :: fstring

! TODO: adjust paper size depending on plot size (both in pixels)

! ==== Instructions

! paper settings
  fstring = "PS_MEDIA Custom_"&
  & // trim(f_r2c( settings%paper_height )) // "x"&
  & // trim(f_r2c( settings%paper_width )) // "p"
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
subroutine plt_args_cmap(cmap_opt, fstring)

! ==== Description
!! Crafts a fortran string for making a colour map
!! as argument string to be used in the gmt module

! ==== Declarations
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
  & // trim(f_r2c( cmap_opt%z_min )) // "/"&
  & // trim(f_r2c( cmap_opt%z_max )) // "/"&
  & // trim(f_r2c( cmap_opt%z_step ))

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
     fstring = trim(fstring) // " -J"&
     & // trim(map_opt%projection)&
     & // trim(f_r2c( map_opt%scale )) // "p"
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
     & // trim(f_r2c( map_opt%cbar_size )) // "%"
  endif

  ! title (top centre)
  if (module_opt%title) then
     ! add Y offset based on font sizes and padding (title+label+2*padding)
     fstring = trim(fstring) // " -Y" // trim(f_r2c( &
     & map_opt%font_size_title + &
     & map_opt%font_size_label + &
     & 2*map_opt%padding )) // "p"&
     ! placement (top centre) and font options
     & // " -F+cTC+f" // trim(f_r2c( map_opt%font_size_title )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%title) // char(34) // ""
  endif

  ! top left corner text
  if (module_opt%label_topleft) then
     ! add Y offset relative to title based on font sizes and padding (title+padding)
     fstring = trim(fstring) // " -Y-" // trim(f_r2c( &
     & map_opt%font_size_title + &
     & map_opt%padding )) // "p"&
     ! placement (top left) and font options
     & // " -F+cTL+f" // trim(f_r2c( map_opt%font_size_label )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%label_topleft) // char(34) // ""
  endif

  ! top right text
  if (module_opt%label_topright) then
     ! note: no Y offset needed relative to top left text
     ! placement (top right) and font options
     fstring = trim(fstring) // " -F+cTR+f"&
     & // trim(f_r2c( map_opt%font_size_label )) // "p"&
     ! add text in double quotation marks to preserve spaces
     & // "+t" // char(34) // trim(map_opt%label_topright) // char(34) // ""
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


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine plt_get_format(filename, fmt)

! ==== Description
!! Determines file format by extension.
!! in : filename - name of file
!! out: fmt      - file format description

! ==== Declarations
  character(len=*), intent(in)  :: filename
  character(len=*), intent(out) :: fmt
  integer                       :: i, position, len_filename
  character(len=10)             :: ext

! ==== Instructions

! initialize format
  fmt = "unknown"

! get the length of the filename
  len_filename = len(trim(filename))

! find the last occurrence of '.'
  position = 0
  do i = len_filename, 1, -1
     if (filename(i:i) .eq. ".") then
        position = i
        exit
     endif
  enddo

! if a dot is found and it's not the first character
  if (position .gt. 1 .and. position .lt. len_filename) then
     ext = filename(position+1:len_filename)

     ! compare extensions to known formats
     select case (trim(ext))
        case ("txt", "TXT", "asc", "ASC")
           fmt = "text"
        case ("grd", "GRD")
           fmt = "grid"
        case default
           fmt = 'unknown'
     end select
  endif

end subroutine plt_get_format


end module fplt
