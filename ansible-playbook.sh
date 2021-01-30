#!/usr/bin/env bash
docker run --rm -it \
    --memory="1g" \
    --cpus="1" \
    -v ${PWD}:/ansible:ro \
    -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
    -v ${PWD}/ansible:/var/log/ansible:rw \
    ansible-playbook \
    ansible-playbook "$@"