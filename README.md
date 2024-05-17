# mongo-fortran-driver

mongo-fortran-driver provides a Fortran interface to the [MongoDB C driver|https://github.com/mongodb/mongo-c-driver], enabling Fortran applications to interact with MongoDB databases. The project is organized into two main libraries: libbsonf for BSON handling and libmongof for MongoDB operations.

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
