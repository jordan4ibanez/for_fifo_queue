module for_fifo_queue
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, for_fifo_queue!"
  end subroutine say_hello
end module for_fifo_queue
