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
!! Abstraction layer with core procedures.

! load modules
  use, intrinsic :: iso_c_binding
  use            :: fplt_typ
  use            :: fplt_utl
  use            :: fplt_arg
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

! construct module stack for maps
  data module_stack /"basemap01", "grdimage01", "pscoast01", "scale01"&
                  &, "title01", "label01", "label02"/

! ==== Instructions

! initialise GMT session
  call fplt_init(session, session_name)


! ---- Input file handling

! determine file format
  fstring = f_utl_get_format(infile)
  write(std_o, *) "> Input file format: ", trim(fstring)

! convert file format if necessary
! TODO: seperatre module if expanded
  select case (fstring)
     case ("text")
        ! update workfile
        w_file="temp.grd"
        ! construct arguments
        fstring = f_arg_xyz2grd(map_opt, infile, w_file)
        args = trim(fstring) // c_null_char
        write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)
        ! gmt module calls
        call fplt_module(session, "xyz2grd", args)
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
  call fplt_set(session, w_set)


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
  fstring = f_arg_cmap(map_opt, w_cmap)
  args = trim(fstring) // c_null_char
  write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

! make colour map
  call fplt_module(session, "makecpt", args)
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
     fstring = f_arg_map(map_opt, w_file, outfile, w_mod)
     args = trim(fstring) // c_null_char
     write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

     ! gmt module calls
     call fplt_module(session, trim(w_mod%gmt_module), args)
  enddo


! ---- Finish

! destroy GMT session
  call fplt_destroy(session)

! TODO: clean up temporary files (separate subroutine)

end subroutine fplt_map


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_module(session, module_name, args)

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

end subroutine fplt_module


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_init(session, session_name)

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

end subroutine fplt_init


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_destroy(session)

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

end subroutine fplt_destroy


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_set(session, settings)

! ==== Description
!! Apply GMT settings based on general settings and map options.

! ==== Declarations
  type(TYP_settings)             , intent(in) :: settings
  type(c_ptr)                    , intent(in) :: session
  character(kind=c_char, len=256), target     :: args
  character(len=256)                          :: stack(6), fstring
  integer(i4)                                 :: i

  data stack/"size", "page", "frame", "grid", "tick", "font"/

! TODO: Option to adjust paper size depending on plot size (both in pixels).
!       Would have to convert coordinates to paper dims based on projection.

! ==== Instructions

  do i=1,size(stack)
     fstring = f_arg_settings(stack(i), settings)
     args = fstring // c_null_char
     call fplt_module(session, "gmtset", args)
  enddo

end subroutine fplt_set

end module fplt
