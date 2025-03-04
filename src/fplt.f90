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
  use            :: fplt_gmt
  use            :: fplt_dat

! basic options
  implicit none
  private

! declare public types
  public :: TYP_cmap, TYP_map, TYP_module

! declare public data
  public :: DAT_map_europe, DAT_mod_coast01, DAT_cmap_greys

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
  type(c_ptr)                                 :: session
  character(kind=c_char, len=20)              :: session_name
  character(kind=c_char, len=256), target     :: args
  integer(c_int)                              :: status
  character(len=256)                          :: fstring
  type(TYP_module)                            :: module_stack(4)
  integer(i4)                                 :: i

! ==== Instructions

! construct module stack for maps
  module_stack(1) = DAT_mod_base01
  module_stack(2) = DAT_mod_grdimg01
  module_stack(3) = DAT_mod_coast01
  module_stack(4) = DAT_mod_coast01

! initialise GMT session
  call gmt_init(session, session_name)

! determine file format
  call get_format(infile, fstring)
  write(std_o, *) "> File format: ", trim(fstring)

! convert file format if necessary
  if (fstring .eq. "text") then
     ! construct arguments
     call gmt_args_xyz2grd(map_opt, infile, "temp.grd", fstring)
     args = trim(fstring) // c_null_char
     write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)
     ! gmt module calls
     call gmt_module(session, "xyz2grd", args)
     ! update infile
!     infile="temp.grd"
     stop
  endif

! get args for making colour map
  call gmt_args_cmap(DAT_cmap_greys, fstring)
  args = trim(fstring) // c_null_char
  write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

! make colour map
  call gmt_module(session, "makecpt", args)
  write(std_o, *) "> Colour map created: ", trim(DAT_cmap_greys%name)

! work through module stack
  do i=1,2

     ! prepare the arguments
     call gmt_args_map(map_opt, infile, outfile, module_stack(i), fstring)
     args = trim(fstring) // c_null_char
     write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

     ! gmt module calls
     call gmt_module(session, trim(module_stack(i)%gmt_module), args)
  enddo

! destroy GMT session
  call gmt_destroy(session)

end subroutine fplt_map


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine gmt_module(session, module_name, args)

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

end subroutine gmt_module


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine gmt_init(session, session_name)

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

end subroutine gmt_init


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine gmt_destroy(session)

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

end subroutine gmt_destroy


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine gmt_args_xyz2grd(map_opt, infile, outfile, fstring)

! ==== Description
!! Crafts a fortran string for making a colour map
!! as argument string to be used in the gmt module

! ==== Declarations
  type(TYP_map)     , intent(in)  :: map_opt
  character(len=*)  , intent(in)  :: infile, outfile
  character(len=256), intent(out) :: fstring
  character(len=32)               :: fstring_partial

! ==== Instructions

  fstring = ""

! infile
  fstring = trim(fstring) // trim(infile)

! region option
  fstring = trim(fstring) // " -R"
  write(fstring_partial, '(F7.2)') map_opt%region(1)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(F7.2)') map_opt%region(2)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(F7.2)') map_opt%region(3)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(F7.2)') map_opt%region(4)
  fstring = trim(fstring) // trim(adjustl(fstring_partial))

! set grid spacing; make high res (0.01 degrees) as default
! TODO: worth making an option? not an attribute of map, so perhaps make
! derived type for files
  fstring = trim(fstring) // " -I1d"

! grid output
  fstring = trim(fstring) // " -G" // trim(outfile)

end subroutine gmt_args_xyz2grd



! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine gmt_args_cmap(cmap_opt, fstring)

! ==== Description
!! Crafts a fortran string for making a colour map
!! as argument string to be used in the gmt module

! ==== Declarations
  type(TYP_cmap)    , intent(in)  :: cmap_opt
  character(len=256), intent(out) :: fstring
  character(len=32)               :: fstring_partial

! ==== Instructions

  fstring = ""

! RGB args
  fstring = trim(fstring) // " -C"
  write(fstring_partial, '(I3)') cmap_opt%rgb(1,1)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(I3)') cmap_opt%rgb(2,1)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(I3)') cmap_opt%rgb(3,1)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // ","
  write(fstring_partial, '(I3)') cmap_opt%rgb(1,2)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(I3)') cmap_opt%rgb(2,2)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(I3)') cmap_opt%rgb(3,2)
  fstring = trim(fstring) // trim(adjustl(fstring_partial))

! Z value args
  fstring = trim(fstring) // " -T"
  write(fstring_partial, '(F17.2)') cmap_opt%z_min
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(F17.2)') cmap_opt%z_max
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(F17.2)') cmap_opt%z_step
  fstring = trim(fstring) // trim(adjustl(fstring_partial))

! output
  fstring = trim(fstring) // " -Z > " // trim(cmap_opt%name) // ".cpt"

end subroutine gmt_args_cmap


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine gmt_args_map(map_opt, infile, outfile, module_opt, fstring)

! ==== Description
!! Crafts a fortran string from map options that serves
!! as argument string to be used in the gmt module
!! TODO: pass more args: typ_module (determines what args) are needed.
!! TODO: make each option block conditional on logical values of module presets

! ==== Declarations
  type(TYP_map)     , intent(in)  :: map_opt
  type(TYP_module)  , intent(in)  :: module_opt
  character(len=*)  , intent(in)  :: infile, outfile
  character(len=256), intent(out) :: fstring
  character(len=32)               :: fstring_partial

! ==== Instructions

  fstring = ""

  ! infile
  if (module_opt%infile) then
     fstring = trim(fstring) // trim(infile)
  endif

  ! region option
  if (module_opt%region) then
     fstring = trim(fstring) // " -R"
     write(fstring_partial, '(F7.2)') map_opt%region(1)
     fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
     write(fstring_partial, '(F7.2)') map_opt%region(2)
     fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
     write(fstring_partial, '(F7.2)') map_opt%region(3)
     fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
     write(fstring_partial, '(F7.2)') map_opt%region(4)
     fstring = trim(fstring) // trim(adjustl(fstring_partial))
  endif

  ! projection and scale
  if (module_opt%projection) then
     fstring = trim(fstring) // " -J" // trim(map_opt%projection)
  endif

  ! resolution
  if (module_opt%resolution) then
     fstring = trim(fstring) // " -D" // trim(map_opt%resolution)
  endif

  ! fill
  if (module_opt%fill) then
     fstring = trim(fstring) // " -G"
     write(fstring_partial, '(I3)') map_opt%fill(1)
     fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
     write(fstring_partial, '(I3)') map_opt%fill(2)
     fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
     write(fstring_partial, '(I3)') map_opt%fill(3)
     fstring = trim(fstring) // trim(adjustl(fstring_partial))
  endif

  ! annotations and grid
  if (module_opt%an_maj .and. module_opt%an_min .and. module_opt%grid) then
     fstring = trim(fstring) // " -B"
     write(fstring_partial, '(F7.2)') map_opt%an_maj
     fstring = trim(fstring) // "a" // trim(adjustl(fstring_partial))
     write(fstring_partial, '(F7.2)') map_opt%an_min
     fstring = trim(fstring) // "f" // trim(adjustl(fstring_partial))
     write(fstring_partial, '(F7.2)') map_opt%grid
     fstring = trim(fstring) // "g" // trim(adjustl(fstring_partial))
  endif

  ! pen
  if (module_opt%pen) then
     fstring = trim(fstring) // " -W"
     write(fstring_partial, '(F3.1)') map_opt%pen
     fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "p"
  endif

  ! colour map
  if (module_opt%cmap) then
     fstring = trim(fstring) // " -C" // trim(map_opt%cmap) // ".cpt"
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
        ! sandwiched layer in stack
        fstring = trim(fstring) // " -O >> " // trim(outfile)
     else
        ! last layer in a stack
        fstring = trim(fstring) // " -O -K >> " // trim(outfile)
     endif
  endif

end subroutine gmt_args_map


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine get_format(filename, fmt)

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

end subroutine get_format


end module fplt
