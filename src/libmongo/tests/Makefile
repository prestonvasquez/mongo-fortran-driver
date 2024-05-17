# Paths
COMMON_INCLUDE_DIR = /usr/local/include
MONGO_INCLUDE_DIR = /usr/local/include
BSON_INCLUDE_DIR = /usr/local/include
MONGO_C_INCLUDE_DIR = /usr/include
BSON_C_INCLUDE_DIR = /usr/include
MONGO_LIB_DIR = /usr/local/lib
BSON_LIB_DIR = /usr/local/lib
MONGO_C_LIB_DIR = /usr/lib/aarch64-linux-gnu
BSON_C_LIB_DIR = /usr/lib/aarch64-linux-gnu

# Compiler
FC = gfortran

# Compiler flags
FFLAGS = -I$(COMMON_INCLUDE_DIR) -I$(MONGO_INCLUDE_DIR) -I$(BSON_INCLUDE_DIR) -I$(MONGO_C_INCLUDE_DIR) -I$(BSON_C_INCLUDE_DIR)
LDFLAGS = -L$(MONGO_LIB_DIR) -L$(BSON_LIB_DIR) -L$(MONGO_C_LIB_DIR) -L$(BSON_C_LIB_DIR) -lmongof -lbsonf -lmongoc-1.0 -lbson-1.0

# Source files
SRC = test_client.f90

# Output executable
OUT = test_client

# Targets
all: $(OUT)

$(OUT): $(SRC)
	$(FC) $(FFLAGS) $(SRC) -o $(OUT) $(LDFLAGS)

test:
	./test_client

clean:
	rm -f $(OUT) *.o

.PHONY: all clean
