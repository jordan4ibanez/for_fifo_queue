module fifo_queue_bindings
  implicit none


  interface


    function internal_new_fifo_queue(fortran_data_width) result(fifo_pointer) bind(c, name = "new_fifo_queue")
      use, intrinsic :: iso_c_binding
      implicit none

      integer(c_size_t), intent(in), value :: fortran_data_width
      type(c_ptr) :: fifo_pointer
    end function internal_new_fifo_queue


    subroutine internal_fifo_queue_push(fifo, fortran_data) bind(c, name = "fifo_queue_push")
      use, intrinsic :: iso_c_binding
      implicit none

      type(c_ptr), intent(in), value :: fifo
      type(c_ptr), intent(in), value :: fortran_data
    end subroutine internal_fifo_queue_push


    function internal_fifo_queue_pop(fifo) result(char_ptr) bind(c, name = "fifo_queue_pop")
      use, intrinsic :: iso_c_binding
      implicit none

      type(c_ptr), intent(in), value :: fifo
      type(c_ptr) :: char_ptr
    end function internal_fifo_queue_pop


    subroutine internal_fifo_queue_free(fifo) bind(c, name = "fifo_queue_free")
      use, intrinsic :: iso_c_binding
      implicit none

      type(c_ptr), intent(in), value :: fifo
    end subroutine internal_fifo_queue_free


    function internal_fifo_queue_get_count(fifo) result(count) bind(c, name = "fifo_queue_get_count")
      use, intrinsic :: iso_c_binding
      implicit none

      type(c_ptr), intent(in), value :: fifo
      integer(c_size_t) :: count
    end function internal_fifo_queue_get_count


  end interface


end module fifo_queue_bindings
