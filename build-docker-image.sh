#!/bin/bash

. ./docker.config

docker build --no-cache -t $IMAGE_NAME .