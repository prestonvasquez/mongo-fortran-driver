cmake_minimum_required(VERSION 3.12)

# Define the project name and languages
project(libmongo LANGUAGES Fortran)

# Set the relative path to the common directory
set(COMMON_DIR ../common)

# Path to the installed `libbson` module files
set(LIBBSON_MOD_DIR /usr/local/include)  # Change this to the actual install directory if different

# Add the library
add_library(mongof STATIC mongo.f90)

# Include the libbson module directory and common directory
target_include_directories(mongof PRIVATE ${LIBBSON_MOD_DIR} ${COMMON_DIR})

# Add common source files
target_sources(mongof PRIVATE ${COMMON_DIR}/util.f90)

# Specify the output directory for module files
set_target_properties(mongof PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules)

# Installation rules
install(TARGETS mongof DESTINATION lib)
install(DIRECTORY ${CMAKE_BINARY_DIR}/modules/ DESTINATION include)
