module fifo_queue
  use, intrinsic :: iso_c_binding
  use :: fifo_queue_bindings
  implicit none


  private


  public :: fifo
  public :: new_fifo_queue


  !* Keep in mind:
  !* This is using raw pointers, make sure you free the given pointer upon pop.
  type :: fifo
    private
    type(c_ptr) :: data = c_null_ptr
  contains
    procedure :: push => fifo_queue_push
    procedure :: pop => fifo_queue_pop
    procedure :: destroy => fifo_queue_destroy
    procedure :: count => fifo_queue_get_count
    procedure :: is_empty => fifo_queue_is_empty
  end type fifo


contains


  function new_fifo_queue(data_size) result(f)
    implicit none

    integer(c_size_t), intent(in), value :: data_size
    type(fifo) :: f

    f%data = internal_new_fifo_queue(data_size)
  end function new_fifo_queue


  !* I recommend you use stack variables.
  subroutine fifo_queue_push(this, generic)
    implicit none

    class(fifo), intent(in) :: this
    class(*), intent(in), target :: generic
    type(c_ptr) :: black_magic

    black_magic = transfer(loc(generic), black_magic)

    call internal_fifo_queue_push(this%data, black_magic)
  end subroutine fifo_queue_push


  !* Keep in mind:
  !* This is using raw pointers, make sure you free the given pointer.
  function fifo_queue_pop(this, raw_c_ptr) result(exists)
    implicit none

    class(fifo), intent(in) :: this
    type(c_ptr), intent(inout) :: raw_c_ptr
    logical(c_bool) :: exists

    raw_c_ptr = internal_fifo_queue_pop(this%data)

    exists = c_associated(raw_c_ptr)
  end function fifo_queue_pop


  !* No special GC in this container. Just keep popping it and run a free on your data type
  !* until it is empty.
  subroutine fifo_queue_destroy(this)
    implicit none

    class(fifo), intent(in) :: this

    call internal_fifo_queue_free(this%data)
  end subroutine fifo_queue_destroy


  !* Get the number of elements in the fifo queue.
  function fifo_queue_get_count(this) result(count)
    implicit none

    class(fifo), intent(in) :: this
    integer(c_size_t) :: count

    count = internal_fifo_queue_get_count(this%data)
  end function fifo_queue_get_count


  !* Check if the fifo queue is empty.
  function fifo_queue_is_empty(this) result(is_empty)
    implicit none

    class(fifo), intent(in) :: this
    logical(c_bool) :: is_empty

    is_empty = internal_fifo_queue_get_count(this%data) == 0
  end function fifo_queue_is_empty


end module fifo_queue
