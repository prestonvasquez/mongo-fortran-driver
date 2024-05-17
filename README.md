# mongo-fortran-driver

mongo-fortran-driver provides a Fortran interface to the [MongoDB C Driver](https://github.com/mongodb/mongo-c-driver), enabling Fortran applications to interact with MongoDB databases. The project is organized into two main libraries: libbsonf for BSON handling and libmongof for MongoDB operations.

## Usage 

```fortran
program main 
  use mongo
  use bson 
  use, intrinsic :: iso_c_binding
  implicit none

  ! Declare variables to connect to the server
  type(c_ptr) :: uri_ptr, client_ptr, db_ptr, bson_ptr, reply_ptr, coll_ptr
  type(bson_error_t) :: error

  ! Initialize the mongoc library
  call mongoc_init()

  ! Connect to the server
  client_ptr = connect('mongodb://localhost:27017', uri_ptr, error)

  if (error%code .ne. 0) then 
    call print_bson_error_message(error)

    stop
  endif

  ! Create a databse
  db_ptr = client_get_database(client_ptr, 'db')

  ! Ping the server
  bson_ptr = bson_new()

  if (bson_append_int32(bson_ptr, "ping", 4, 1) == 0) then
    bson_ptr = c_null_ptr
    print *, "failed to append"
    stop 
  endif

  if (mongoc_database_command_simple(db_ptr, bson_ptr, c_null_ptr, reply_ptr, error) /= 1) then
    print *, "Failed to run command"
    call print_bson_error_message(error)

    stop
  endif

  if (error%code .ne. 0) then 
    call print_bson_error_message(error)

    stop
  endif

  ! Create a collection 
  coll_ptr = database_get_collection(db_ptr, 'coll')

  ! Create a new BSON document
  bson_ptr = bson_new()

  ! Append the integer 1 to the document with the key "x"
  if (bson_append_int32(bson_ptr, "b", 1, 1) == 0) then
    bson_ptr = c_null_ptr

    print *, "failed to append"
    stop
  endif
  
  if (.not. mongoc_collection_insert_one(coll_ptr, bson_ptr, c_null_ptr, reply_ptr, error)) then 
    call print_bson_error_message(error)

    print *, "failed to insert data"
  endif

  ! Release handles and cleanup libmongoc
  call mongoc_database_destroy(db_ptr)
  call mongoc_uri_destroy(uri_ptr)
  call mongoc_client_destroy(client_ptr)
  call mongoc_collection_destroy(coll_ptr)

end program main
```

## Contributing 

### Prerequisites

- Docker
- MongoDB 

### Docker 

```
docker build -t fortran-tests .
```

```
docker run --rm --add-host=host.docker.internal:host-gateway fortran-tests
```

### Local 

TODO
