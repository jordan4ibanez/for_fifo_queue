# for_fifo_queue
A dense linked fifo queue.

-----

### Dense?

-----

Why is it dense? It allows unlimited polymorphism in the queue without using additional indirection.

When you pop, you are getting what you put in. The memory address it was assigned to in the queue. No indirection.

If you are having a hard time understanding this, please see the tutorial.

-----

### Why?

-----

Because this allows higher performance without having to write multiple different kinds of queues in Fortran.

This also has 1 less layer of indirection with pure polymorphism because in Fortran you must point to another address as you have no manual control over the width of the element.

This also allows you to push a re-used stack variable into the queue without having to fuss with reallocate over and over with basic (non-pointer containing) derived types.

-----

If you like what I do, and would like to support me: [My Patreon](https://www.patreon.com/jordan4ibanez)

-----

### Add to your project:

-----

```toml
[dependencies]
for_fifo_queue = { git = "https://github.com/jordan4ibanez/for_fifo_queue" }
```

-----

### Tutorial:

-----

You can run this tutorial with: ``make test``

```fortran
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
```


