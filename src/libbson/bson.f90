module bson
  use iso_c_binding, only: c_int32_t, c_char, c_null_char
  implicit none

  type, bind(C) :: bson_error_t
    integer(c_int32_t) :: domain
    integer(c_int32_t) :: code
    character(c_char) :: message(504)
  end type bson_error_t

  interface
    ! Creates a new BSON document.
    function bson_append_int32(bson_ptr, key, key_len, value) bind(C, name="bson_append_int32") result(success)
      use iso_c_binding
      type(c_ptr), value :: bson_ptr
      character(kind=c_char), dimension(*), intent(in) :: key
      integer(c_int), value :: key_len
      integer(c_int), value :: value
      integer(c_int) :: success
    end function bson_append_int32

    ! Appends an int32 value to a BSON document.
    function bson_new() bind(C, name="bson_new") result(bson_ptr)
      use iso_c_binding
      type(c_ptr) :: bson_ptr
    end function bson_new
  end interface

contains
  ! Prints the error message contained in a bson_error_t type.
  subroutine print_bson_error_message(error)
    type(bson_error_t), intent(in) :: error
    character(len=:), allocatable :: message_string
    integer :: i, len_message

    ! Find the length of the string up to the null terminator
    len_message = 0
    do i = 1, size(error%message)
      if (error%message(i) == c_null_char) exit
      len_message = len_message + 1
    end do

    ! Allocate and assign the message string
    allocate (character(len=len_message) :: message_string)
    if (len_message > 0) then
      message_string = transfer(error%message(1:len_message), message_string)
    else
      message_string = ''
    end if

    ! Print the message
    print *, trim(adjustl(message_string))
  end subroutine print_bson_error_message

end module bson
