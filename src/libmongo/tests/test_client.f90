program test_client
  use mongo
  use bson 
  use, intrinsic :: ISO_C_BINDING
  implicit none

  ! Declare variables to connect to the server
  type(c_ptr) :: uri_ptr, client_ptr, db_ptr, bson_ptr, reply_ptr, coll_ptr
  type(bson_error_t) :: error

  ! Initialize the mongoc library
  call mongoc_init()

  ! Connect to the server
  client_ptr = connect('mongodb://host.docker.internal:27017', uri_ptr, error)

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
end program test_client
