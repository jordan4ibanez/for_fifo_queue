module fifo_queue
  implicit none


  private


  interface


    function internal_new_fifo_queue(fortran_data_width) result(fifo_pointer) bind(c, name = "new_fifo_queue")
      use, intrinsic :: iso_c_binding
      implicit none

      integer(c_size_t), intent(in), value :: fortran_data_width
      type(c_ptr) :: fifo_pointer
    end function internal_new_fifo_queue


  end interface


end module fifo_queue
