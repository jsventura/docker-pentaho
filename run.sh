#!/bin/bash
docker run -p 8080:8080 -it -e RDS_HOSTNAME=localhost -e RDS_USERNAME=postgres -e RDS_PASSWORD=postgres -e RDS_DB_NAME=postgres -e RDS_PORT=5432 jsventura/pentaho:7.1