#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>

typedef struct header header;
typedef struct fifo_queue fifo_queue;

/**
 * Simple header to allow quickly jumping over the Fortran data.
 */
struct header
{
  char *next;
};

/**
 * The base struct that controls the underlying pointer data.
 */
struct fifo_queue
{
  char *head;
  char *tail;
  size_t element_size;
  size_t fortran_data_size;
  size_t count;
};

char *new_fifo_queue(size_t fortran_data_width)
{
}