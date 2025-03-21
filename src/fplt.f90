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
subroutine fplt_map(map_opt)

! ==== Description
!! Uses fortran-gmt interface for creating a map.

! ==== Declarations
  type(TYP_map)   , intent(in)            :: map_opt         !! map options
  type(c_ptr)                             :: session         !! gmt session c pointer
  integer(c_int)                          :: status          !! gmt session return status
  character(kind=c_char, len=20)          :: session_name    !! gmt session name
  character(kind=c_char, len=256), target :: args            !! gmt argument string
  character(len=32)                       :: module_stack(7) !! names of module templates to work through
  character(len=256)                      :: w_infile        !! name of input file
  character(len=256)                      :: w_outfile       !! name of output file
  type(TYP_cmap)                          :: w_cmap          !! colour map worked with (looked up)
  type(TYP_settings)                      :: w_set           !! settings worked with (looked up)
  type(TYP_module)                        :: w_mod           !! module template worked with (looked up)
  character(len=256)                      :: fstring         !! fortran string
  integer(i4)                             :: i, j

! construct module stack for maps
  data module_stack /"basemap01", "grdimage01", "pscoast01", "scale01"&
                  &, "title01", "label01", "label02"/

! ==== Instructions

! initialise GMT session
  call fplt_init(session, session_name)


! ---- Input file handling

! determine file format
  fstring = f_utl_get_format(map_opt%infile)
  write(std_o, *) "> Input file format: ", trim(fstring)

! convert file (if necessary) and set working infile
  select case (fstring)
     case ("text")
     ! construct arguments
        w_infile = "temp.grd"
        fstring = f_arg_xyz2grd(map_opt, w_infile)
        args = trim(fstring) // c_null_char
        write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)
        ! gmt module calls
        call fplt_module(session, "xyz2grd", args)
        ! update infile
        write(std_o, *) "> Text file converted to grid file: ", trim(w_infile)
     case ("grd")
        w_infile = map_opt%infile
     case ("unknown")
        write(std_o, *) "> Unknown file format. Stopping."
        stop
  end select

! set working outfile (work with ps output before converting it at the end)
  w_outfile = trim(map_opt%outfile) // ".ps"


! ---- Apply settings

! find theme/settings in dict
  do i = 1, size(DAT_set)
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
  do i = 1, size(DAT_cmap)
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
  do i = 1, size(module_stack)

     ! find colour map in dict
     do j = 1, size(DAT_mod)
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
     fstring = f_arg_map(map_opt, w_infile, w_outfile, w_mod)
     args = trim(fstring) // c_null_char
     write(std_o, *) "> Fortran-GMT args constructed: ", trim(fstring)

     ! gmt module calls
     call fplt_module(session, trim(w_mod%gmt_module), args)
  enddo


! ---- Finish

! crop and convert image
  fstring = f_arg_finish(w_outfile, map_opt%format)
  args = trim(fstring) // c_null_char
  call fplt_module(session, "psconvert", args)

! destroy GMT session
  call fplt_destroy(session)

! clean up
  call fplt_clean()

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

! module stack
  data stack/"size", "page", "frame", "grid", "tick", "font"/

! ==== Instructions

  do i = 1, size(stack)
     fstring = f_arg_settings(stack(i), settings)
     args = fstring // c_null_char
     call fplt_module(session, "gmtset", args)
  enddo

end subroutine fplt_set


! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_clean()

! ==== Description
!! Delete temporary files.

! ==== Declarations
  integer(i4) :: status

! ==== Instructions
  status = system("rm *.ps *.cpt gmt.conf gmt.history temp.grd")

end subroutine fplt_clean

end module fplt
