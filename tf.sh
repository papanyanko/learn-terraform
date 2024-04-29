#!/bin/bash

command=${@:1} 

docker container run -it --rm \
  -v $PWD:/work \
  -w /work \
  --env-file ~/.config/aws/.env \
  --entrypoint "/bin/sh" \
  hashicorp/terraform:1.8.2 \
  -c "terraform $command"