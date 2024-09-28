#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>

typedef struct header header;
typedef struct fifo_queue fifo_queue;

/**
 * Simple header to allow quickly jumping over the Fortran data to get the next memory address.
 *
 * The header actually comes after the fortran data. [ fortran data | header ]
 *
 * I call it header because that's what I'm used to.
 */
struct header
{
  char *next;
};

const static size_t HEADER_SIZE = sizeof(header);

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

/**
 * Create a new fifo queue.
 */
char *new_fifo_queue(size_t fortran_data_width)
{
  char *raw_memory = malloc(sizeof(fifo_queue));

  fifo_queue *fifo = (fifo_queue *)raw_memory;

  fifo->head = NULL;
  fifo->tail = NULL;
  fifo->element_size = fortran_data_width + HEADER_SIZE;
  fifo->fortran_data_size = fortran_data_width;
  fifo->count = 0;
}