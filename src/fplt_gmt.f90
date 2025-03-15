module fplt_gmt

! |--------------------------------------------------------------------|
! | fplt - fortran plotting library                                    |
! |                                                                    |
! | about                                                              |
! | -----                                                              |
! | Module contains c-bindings; using GMT(6) C API.                    |
! |                                                                    |
! | license : MIT                                                      |
! | author  : Sebastian G. Mutz (sebastian@sebastianmutz.com)          |
! |--------------------------------------------------------------------|

! FORD
!! C-bindings for GMT C API.

! load modules
  use, intrinsic :: iso_c_binding

! basic options
  implicit none
  private

! declare public
  public :: gmt_create_session
  public :: gmt_destroy_session
  public :: gmt_call_module

! c bindings; use GMT C API
  interface
     function gmt_create_session(name, pad, mode, opt) bind(c, name="GMT_Create_Session")
     !! Create GMT session.
        import :: c_ptr, c_char, c_int
        type(c_ptr)                          :: gmt_create_session
        character(c_char), intent(in)        :: name(*)
        integer(c_int)   , intent(in), value :: pad, mode
        type(c_ptr)      , intent(in), value :: opt
     end function gmt_create_session

     function gmt_destroy_session(session) bind(c, name="GMT_Destroy_Session")
     !! Destroy GMT session.
        import :: c_ptr, c_int
        integer(c_int)                 :: gmt_destroy_session
        type(c_ptr), intent(in), value :: session
     end function gmt_destroy_session

     function gmt_call_module(session, gmod, mode, args) bind(c, name="GMT_Call_Module")
     !! GMT modules.
        import :: c_ptr, c_char, c_int
        integer(c_int)                       :: gmt_call_module
        type(c_ptr)      , intent(in), value :: session
        character(c_char), intent(in)        :: gmod(*)
        integer(c_int)   , intent(in), value :: mode
        type(c_ptr)      , intent(in), value :: args
     end function gmt_call_module
  end interface

end module fplt_gmt
