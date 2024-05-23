# Docker Builds for Documentum

## Overview

## Components Included.

- Content Server
- Documentum Administrator
- REST
- Webtop
- Headless Composer (WIP)

## Repository Organization

The Dockerfile, scripts, etc. for each stack component are encapsulated in a directory in the poject.  The [bin](./bin/) folder contains conviennce scripts for buiding and deploying the various components.  [docker-compose](./docker-compose/docker-compose.yml) can be used to deploy the entire stack.

## Versions and Supporting Technologies

- OpenText Documentum 22.2 stack components.
Developed and Tested on Ubumtu 23.10 and Docker Engine 24.0.5
- Base Images Used
    - tomcat:9-jdk11-temurin-focal (Used to build WebApp images
    )
    - ubuntu:focal (Used to build Content Server images)
    - dockurr/windows (used for CTS - run directly)