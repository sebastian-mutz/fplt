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
  use :: fplt_typ
  use :: fplt_gmt

! basic options
  implicit none
  private

! declare public types
  public :: TYP_cmap, TYP_map

! declare public procedures
  public :: fplt_map


contains

! ==================================================================== !
! -------------------------------------------------------------------- !
subroutine fplt_map(map, outfile)

! ==== Description
!! Uses fortran-gmt interface for creating a map.

! ==== Declarations
  type(TYP_map)     , intent(in)          :: map
  character(len=256), intent(in)          :: outfile
  type(c_ptr)                             :: session, parent
  character(kind=c_char, len=20)          :: session_name
  character(kind=c_char, len=256), target :: args
  integer(c_int)                          :: status
  integer(c_int), parameter               :: pad=0, mode=0, cmd=0
  character(len=256)                      :: fstring

! ==== Instructions

  session_name = "fortran" // c_null_char
  parent = c_null_ptr

! create session
  session = gmt_create_session(session_name, pad, mode, parent)
  if (c_associated(session)) then
    print *, "> GMT session created successfully."
  else
    print *, "> Failed to create GMT session."
    stop
  end if

! Prepare the arguments for pscoast
  fstring = craft_args(map, outfile)
  args = trim(fstring) // c_null_char
  print *, "> GMT args constructed: ", trim(fstring)

! Call the pscoast module
  status = GMT_Call_Module(session, "pscoast" // c_null_char, cmd, c_loc(args))
  if (status == 0) then
    print *, "> GMT module executed successfully."
  else
    print *, "> GMT module execution failed. Error code:", status
    stop
  end if

! Destroy session
  status = gmt_destroy_session(session)
  if (status == 0) then
    print *, "> GMT session destroyed successfully."
  else
    print *, "> Failed to destroy GMT session. Error code:", status
    stop
  end if

  contains

     function craft_args(map, outfile) result(fstring)
        !! crafts a fortran string from map options that serves
        !! as argument string to be used in the gmt module
        type(TYP_map)     , intent(in) :: map
        character(len=256), intent(in) :: outfile
        character(len=32)              :: fstring_partial
        character(len=256)             :: fstring

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
     end function craft_args


end subroutine fplt_map

end module fplt
