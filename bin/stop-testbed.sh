#!/bin/bash
#
# Start a test docker container of postgresql to test with
#
docker rm --force postgres
docker network rm documentum-network 
