cmake_minimum_required(VERSION 3.12)

# Define the project name and languages
project(libbson LANGUAGES Fortran)

# Add the library
add_library(bsonf STATIC
    bson.f90
)

# Set the module output directory
set_target_properties(bsonf PROPERTIES
    Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules
)

# Installation rules
install(TARGETS bsonf DESTINATION lib)
install(DIRECTORY ${CMAKE_BINARY_DIR}/modules/ DESTINATION include)
