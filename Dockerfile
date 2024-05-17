FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y gfortran gcc cmake valgrind libbson-dev libmongoc-dev

# Set the working directory
WORKDIR /usr/src/app

# Copy the current directory contents into the container
COPY . .

# Clean any existing CMake cache and build directories
RUN rm -rf src/libbson/build CMakeCache.txt
RUN rm -rf src/libmongo/build CMakeCache.txt

# Create a build directory and run cmake and make for libbson
RUN mkdir -p src/libbson/build && cd src/libbson/build && \
    cmake .. && \
    make && \
    make install

# Create a build directory and run cmake and make for libmongo
RUN mkdir -p src/libmongo/build && cd src/libmongo/build && \
    cmake .. && \
    make && \
    make install

# Set the working directory to the tests directory
WORKDIR /usr/src/app/src/libmongo/tests

# Build and run the tests
CMD make clean && make && make test
