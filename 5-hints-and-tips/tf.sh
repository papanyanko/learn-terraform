#!/bin/bash

command=${@:1} 

SCRIPT_DIR=$(realpath $(dirname $0))
WORK_DIR=$(realpath --relative-to=$SCRIPT_DIR $PWD)

docker container run -it --rm \
  -v $SCRIPT_DIR:/work \
  -w /work/$WORK_DIR \
  --env-file ~/.config/aws/.env \
  --entrypoint "/bin/sh" \
  hashicorp/terraform:1.8.5 \
  -c "terraform $command"