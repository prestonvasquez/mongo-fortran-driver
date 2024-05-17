module util
   use, intrinsic :: iso_c_binding, only: c_char, c_null_char
   implicit none

contains

   function f_c_string(string, trim) result(c_string)
      character(len=*), intent(in) :: string
      logical, intent(in), optional :: trim

      character(kind=c_char, len=:), allocatable :: c_string
      logical :: trim_

      trim_ = .true.
      if (present(trim)) trim_ = trim

      block
         intrinsic trim
         if (trim_) then
            c_string = trim(string)//c_null_char
         else
            c_string = string//c_null_char
         end if
      end block
   end function f_c_string

   function c_f_string(char_array) result(scalar_string)
      character(kind=c_char), dimension(*), intent(in) :: char_array
      character(len=:), allocatable :: scalar_string
      integer :: i, len_string

      ! Find the length of the string up to the null terminator
      len_string = 0
      i = 1
      do while (char_array(i) /= c_null_char)
         len_string = len_string + 1
         i = i + 1
      end do

      ! Allocate and assign the scalar string
      allocate (character(len=len_string) :: scalar_string)
      scalar_string = ''
      if (len_string > 0) then
         scalar_string = transfer(char_array(1:len_string), scalar_string)
      end if
   end function c_f_string

end module util
