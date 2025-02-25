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
  public :: DAT_map_europe, DAT_mod_map01, DAT_cmap_greys

! declare public procedures
  public :: fplt_map


contains

! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_map(map, outfile)

! ==== Description
!! Uses fortran-gmt interface for creating a map.

! ==== Declarations
  type(TYP_map)                  , intent(in) :: map
  character(len=256)             , intent(in) :: outfile
  type(c_ptr)                                 :: session
  character(kind=c_char, len=20)              :: session_name
  character(kind=c_char, len=256), target     :: args
  integer(c_int)                              :: status
  character(len=256)                          :: fstring
  type(TYP_module)                            :: module_stack(4)

! ==== Instructions

! TODO: decouple gmt module as subroutine and pass module_stack (and associated arguments) from fplt_map, fplt_xy, fplt_raster, etc.
! TODO: create type for module stack and also includes arguments for each module

! construct  module stack
  module_stack(1) = DAT_mod_map01
  module_stack(2) = DAT_mod_map01
  module_stack(3) = DAT_mod_map01 ! pscoast
  module_stack(4) = DAT_mod_map01

! initialise GMT session
  call gmt_init(session, session_name)

! prepare the arguments
  call gmt_args(map, outfile, fstring)
  args = trim(fstring) // c_null_char
  write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

! gmt module calls
! TODO: loop through module stack
  call gmt_module(session, trim(module_stack(3)%gmt_module), args)

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
subroutine gmt_args(map, outfile, fstring)

! ==== Description
!! crafts a fortran string from map options that serves
!! as argument string to be used in the gmt module
!! TODO: pass more args: typ_module (determines what args) are needed.
!! TODO: make each option block conditional on logical values of module presets

! ==== Declarations
  type(TYP_map)     , intent(in)   :: map
  character(len=256), intent(in)   :: outfile
  character(len=256), intent(out)  :: fstring
  character(len=32)                :: fstring_partial

  ! region option
  fstring="-R"
  write(fstring_partial, '(F7.2)') map%region(1)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(F7.2)') map%region(2)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(F7.2)') map%region(3)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(F7.2)') map%region(4)
  fstring = trim(fstring) // trim(adjustl(fstring_partial))

  ! projection and scale
  fstring = trim(fstring) // " -J" // trim(map%projection)

  ! resolution
  fstring = trim(fstring) // " -D" // trim(map%resolution)

  ! fill
  fstring = trim(fstring) // " -G"
  write(fstring_partial, '(I3)') map%fill(1)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(I3)') map%fill(2)
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "/"
  write(fstring_partial, '(I3)') map%fill(3)
  fstring = trim(fstring) // trim(adjustl(fstring_partial))

  ! annotations and grid
  fstring = trim(fstring) // " -B"
  write(fstring_partial, '(F7.2)') map%an_maj
  fstring = trim(fstring) // "a" // trim(adjustl(fstring_partial))
  write(fstring_partial, '(F7.2)') map%an_min
  fstring = trim(fstring) // "f" // trim(adjustl(fstring_partial))
  write(fstring_partial, '(F7.2)') map%grid
  fstring = trim(fstring) // "g" // trim(adjustl(fstring_partial))

  ! pen
  fstring = trim(fstring) // " -W"
  write(fstring_partial, '(F3.1)') map%pen
  fstring = trim(fstring) // trim(adjustl(fstring_partial)) // "p"

  ! outfile
  fstring = trim(fstring) // " > " // trim(outfile)

end subroutine gmt_args


end module fplt
