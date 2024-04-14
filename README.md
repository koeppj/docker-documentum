# Docker Builds for Documentum

## Componnts Included.

- Content Server
- Documentum Administrator
- REST
- Webtop

## Repository Organization



## Versions and Supporting Technologies

- Developed and Tested on Ubumtu 23.10 and Docker Engine 24.0.5
- Base Images Used
    - tomcat:9-jdk11-temurin-focal (Used to build WebApp images
    )
    - ubuntu:focal (Used to build Content Server images)
    - dockurr/windows (used for CTS - run directly)