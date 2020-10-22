#!/bin/bash

docker-compose up -d
docker exec -it -w /root/server-admin server-admin bash
docker-compose down