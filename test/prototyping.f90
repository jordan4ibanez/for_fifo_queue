program prototyping
  use :: fifo_queue
  use, intrinsic :: iso_c_binding
  implicit none

  type(fifo) :: queue
  integer(c_int) :: i
  type(c_ptr) :: raw_c_ptr
  integer(c_int), pointer :: gotten

  queue = new_fifo_queue(sizeof(10))

  do i = 1,3
    call queue%push(i)
  end do

  do while(queue%pop(raw_c_ptr))
    call c_f_pointer(raw_c_ptr, gotten)
    print*,gotten
  end do


end program prototyping
