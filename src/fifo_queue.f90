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
  end type fifo


contains

  function new_fifo_queue(data_size) result(f)
    implicit none

    integer(c_size_t), intent(in), value :: data_size
    type(fifo) :: f

    f%data = internal_new_fifo_queue(data_size)
  end function new_fifo_queue


  subroutine fifo_queue_push(this, raw_c_ptr)
    implicit none

    class(fifo), intent(in) :: this
    type(c_ptr), intent(in) :: raw_c_ptr

    call internal_fifo_queue_push(this%data, raw_c_ptr)
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






end module fifo_queue
