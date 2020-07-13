#!/bin/bash
set -x
docker exec -it $(docker ps -q) /bin/bash
