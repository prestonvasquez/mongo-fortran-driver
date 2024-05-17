module mongo 
   use, intrinsic :: iso_c_binding
   use util, only: f_c_string
   use bson, only: bson_error_t
   implicit none
   
  interface
    ! Bindings for client_destroy: Destroys the MongoDB client instance.
    subroutine mongoc_client_destroy(client_ptr) bind(C, name="mongoc_client_destroy")
      use iso_c_binding
      type(c_ptr), value :: client_ptr
    end subroutine mongoc_client_destroy

    ! Bindings for client_get_database: Gets a MongoDB database instance from a 
    ! client.
    function mongoc_client_get_database(client_ptr, name) bind(C, name="mongoc_client_get_database") &
         result(database_ptr)
      use iso_c_binding
      implicit none
      type(c_ptr) :: database_ptr
      type(c_ptr), value :: client_ptr
      character(kind=c_char), dimension(*) :: name
    end function mongoc_client_get_database

    ! Bindings for client_new_from_uri_with_error: Creates a MongoDB client 
    ! instance from a URI with error reporting.
    function mongoc_client_new_from_uri_with_error(uri_ptr, error) bind(C, name="mongoc_client_new_from_uri_with_error")
      use iso_c_binding
      use bson, only: bson_error_t  ! Importing the bson_error_t type

      type(c_ptr) :: mongoc_client_new_from_uri_with_error
      type(c_ptr), value :: uri_ptr
      type(bson_error_t), intent(out) :: error
    end function mongoc_client_new_from_uri_with_error

    ! Bindings for collection_destroy: Destroys a MongoDB collection instance.
    subroutine mongoc_collection_destroy(collection_ptr) bind(C, name="mongoc_collection_destroy")
      use iso_c_binding
      type(c_ptr), value :: collection_ptr
    end subroutine mongoc_collection_destroy

    ! Bindings for collection_insert_one: Inserts a document into a MongoDB 
    ! collection.
    function mongoc_collection_insert_one(collection, document, opts, reply, error) &
         bind(C, name="mongoc_collection_insert_one") result(success)
      use iso_c_binding
      use bson, only: bson_error_t  ! Importing the bson_error_t type

      type(c_ptr), value :: collection
      type(c_ptr), value :: document
      type(c_ptr), value :: opts
      type(c_ptr) :: reply
      type(bson_error_t), intent(out) :: error
      logical(c_bool) :: success
    end function mongoc_collection_insert_one

    ! Bindings for database_command_simple: Sends a command to the MongoDB 
    ! database and gets a reply.
    function mongoc_database_command_simple(database, command, read_prefs, reply, error) &
         bind(C, name="mongoc_database_command_simple") result(success)
      use iso_c_binding
      use bson, only: bson_error_t  ! Importing the bson_error_t type

      type(c_ptr), value :: database
      type(c_ptr), value :: command
      type(c_ptr), value :: read_prefs
      type(c_ptr) :: reply
      type(bson_error_t), intent(out) :: error
      integer(c_int) :: success
    end function mongoc_database_command_simple

    ! Bindings for database_destroy: Destroys a MongoDB database instance.
    subroutine mongoc_database_destroy(database_ptr) bind(C, name="mongoc_database_destroy")
      use iso_c_binding
      type(c_ptr), value :: database_ptr
    end subroutine mongoc_database_destroy

    ! Bindings for database_get_collection: Gets a MongoDB collection instance 
    ! from a database.
    function mongoc_database_get_collection(database_ptr, collection_name) & 
        bind(C, name="mongoc_database_get_collection")
      use iso_c_binding

      type(c_ptr) :: mongoc_database_get_collection
      type(c_ptr), value :: database_ptr
      character(kind=c_char), dimension(*) :: collection_name
    end function mongoc_database_get_collection

    ! Bindings for mongoc_cleanup: Cleans up the MongoDB C driver.
    subroutine mongoc_cleanup() bind(C, name="mongoc_cleanup")
    end subroutine mongoc_cleanup

    ! Bindings for mongoc_init: Initializes the MongoDB C driver.
    subroutine mongoc_init() bind(C, name="mongoc_init")
    end subroutine mongoc_init

    ! Bindings for uri_destroy: Destroys a MongoDB URI instance.
    subroutine mongoc_uri_destroy(uri) bind(C, name="mongoc_uri_destroy")
      use iso_c_binding
      type(c_ptr), value :: uri
    end subroutine mongoc_uri_destroy

    ! Bindings for uri_new_with_error: Creates a MongoDB URI instance with error 
    ! reporting.
    function mongoc_uri_new_with_error(uri_string, error) bind(C, name="mongoc_uri_new_with_error")
      use iso_c_binding, only: c_ptr, c_char
      use bson, only: bson_error_t  ! Importing the bson_error_t type

      type(c_ptr) :: mongoc_uri_new_with_error
      character(kind=c_char), dimension(*) :: uri_string
      type(bson_error_t), intent(out) :: error
    end function mongoc_uri_new_with_error
  end interface
   
  contains 

  ! Connects to a MongoDB instance using the provided URI string.
  function connect(uri_str, uri_ptr, error) result(client_ptr)
    character(len=*), intent(in) :: uri_str
    type(c_ptr), intent(out) :: uri_ptr
    type(bson_error_t), target, intent(out) :: error
    type(bson_error_t), pointer :: error_ptr

    type(c_ptr) :: client_ptr
    character(kind=c_char, len=:), allocatable, target :: c_uri_string

    error_ptr => error

    ! Convert Fortran string to C string
    c_uri_string = f_c_string(uri_str)

    ! Initialize error to zero
    error%domain = 0
    error%code = 0
    error%message = ""

    ! Call the mongoc_uri_new_with_error function
    uri_ptr = mongoc_uri_new_with_error(c_uri_string, error)

    if (error%code .ne. 0) then
      stop
    end if

    client_ptr = mongoc_client_new_from_uri_with_error(uri_ptr, error)

    if (error%code .ne. 0) then
      stop
    end if
  end function connect

  ! Gets a MongoDB database instance from a client.
  function client_get_database(client_ptr, db_name) result(db_ptr)
    type(c_ptr), intent(in) :: client_ptr
    character(len=*), intent(in) :: db_name

    type(c_ptr) :: db_ptr
    character(kind=c_char, len=:), allocatable, target :: c_db_name

    c_db_name = f_c_string(db_name)

    ! Create a database
    db_ptr = mongoc_client_get_database(client_ptr, c_db_name)
  end function client_get_database

  ! Gets a MongoDB collection instance from a database.
  function database_get_collection(db_ptr, coll_name) result(coll_ptr)
    type(c_ptr), intent(in) :: db_ptr
    character(len=*), intent(in) :: coll_name
    type(c_ptr) :: coll_ptr
    character(kind=c_char, len=:), allocatable, target :: c_coll_name

    c_coll_name = f_c_string(coll_name)

    ! Create a database
    coll_ptr = mongoc_database_get_collection(db_ptr, c_coll_name)
  end function database_get_collection

end module mongo
