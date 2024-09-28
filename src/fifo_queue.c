#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

typedef struct header header;
typedef struct fifo_queue fifo_queue;

/**
 * Simple header to allow quickly jumping over the Fortran data to get the next memory address.
 *
 * The header actually comes after the fortran data. [ fortran data | header ]
 *
 * This is designed like this so the deallocate call in fortran will also free the header.
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
char *new_fifo_queue(size_t fortran_data_size)
{
  char *raw_memory = malloc(sizeof(fifo_queue));

  assert(raw_memory);

  fifo_queue *fifo = (fifo_queue *)raw_memory;

  fifo->head = NULL;
  fifo->tail = NULL;
  fifo->element_size = fortran_data_size + HEADER_SIZE;
  fifo->fortran_data_size = fortran_data_size;
  fifo->count = 0;
}

/**
 * Push data to the back of the queue.
 */
void fifo_queue_push(struct fifo_queue *fifo, char *fortran_data)
{
  // Do some abstract memory management.
  // Layout: [ fortran data | header ]
  char *heap_fortran_data = malloc(fifo->element_size);

  memcpy(heap_fortran_data, fortran_data, fifo->fortran_data_size);

  ((header *)(heap_fortran_data + fifo->fortran_data_size))->next = NULL;

  // If the head is NULL, this is the new head.
  if (!fifo->head)
  {
    fifo->head = heap_fortran_data;
  }

  // If we have a tail, it now points to the new element.
  // The new node then becomes the tail.
  if (fifo->tail)
  {
    ((header *)(fifo->tail + fifo->fortran_data_size))->next = heap_fortran_data;
    fifo->tail = heap_fortran_data;
  }
  else
  {
    // If we do not have a tail, this is now the tail.
    fifo->tail = heap_fortran_data;
  }

  // Increment count.
  fifo->count++;
}

/**
 * Pop the front of the queue.
 *
 * Will return NULL if empty.
 */
char *fifo_queue_pop(struct fifo_queue *fifo)
{
  // Well, first of all, if this thing is empty, return NULL.
  if (!fifo->count)
  {
    return NULL;
  }

  // This will get getting returned.
  char *output = NULL;

  // The output will become the head data.
  // The head will now be shifted forward.
  output = fifo->head;

  fifo->head = ((header *)(fifo->head + fifo->fortran_data_size))->next;

  // If this was pointing to NULL, we must nullify the tail.
  if (!fifo->head)
  {
    fifo->tail = NULL;
  }

  // Count down.
  fifo->count--;

  return output;
}

/**
 * Free the underlying queue memory.
 */
void fifo_queue_free(struct fifo_queue *fifo)
{
  // Fortran is responsible for freeing each one of the pointers in the queue.
  free(fifo);
}

/**
 * Get the number of elements in the fifo queue.
 */
size_t fifo_queue_get_count(struct fifo_queue *fifo)
{
  return fifo->count;
}