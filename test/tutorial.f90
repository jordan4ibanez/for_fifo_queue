program tutorial
  use :: fifo_queue
  use, intrinsic :: iso_c_binding
  implicit none

  type(fifo) :: queue
  integer(c_int) :: i
  type(c_ptr) :: raw_c_ptr
  integer(c_int), pointer :: gotten


  !* This is going to be the simplest tutorial out of all my tutorials.

  !* Create the fifo queue.
  !* Data width: 4
  !? Technical info: You could shove anything 4 bytes wide into it with this
  !? specific fifo queue, but I would highly recommend you stick to one type
  !? AND ONLY one type.
  queue = new_fifo_queue(sizeof(10))

  !* Let us push 3.2 GB of integers into it.
  !? NOTICE:
  !* I am pushing STACK variables into it. It uses memcpy under the hood.
  !* I highly recommend you push stack variables into the queue for performance.
  !* The type you push in can contain Fortran pointers.
  do i = 1,100000000
    call queue%push(i)
  end do

  !* A lot of items.
  print*,queue%count()

  !* Now, we will pop it until empty.
  !? Important note: You are getting actual pointers from malloc in C.
  do while(queue%pop(raw_c_ptr))
    !* Transfer the pointer into fortran.
    call c_f_pointer(raw_c_ptr, gotten)
    !* Enable this if you want to be here all day.
    ! print*,gotten
    !! Very important:
    !* You must deallocate the transfered pointer or else you will have a memory leak.
    !* If your type contains Fortran pointers, deallocate them before deallocating
    !* the transfered pointer.
    deallocate(gotten)
  end do

  !* It is empty.
  print*,queue%count()
  print*,queue%is_empty()

  !! Very important:
  !* Now, we are done with it.
  !* This will free the underlying memory.
  !? There is NO GC on fifo queue.
  !? Simply pop it until it is empty with your deallocation strategy on
  !? whatever type you are using it for.
  call queue%destroy()


end program tutorial
