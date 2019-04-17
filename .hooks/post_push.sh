#!/bin/sh
# Post push git command
# @Note: We use the .sh extension so the linter & shellcheck will pick up on it.
{
set -e

    # gets the last 10 repo commits, tags them, and uploads them to docker via push.
    tagStart=$(expr index "$IMAGE_NAME" :)
    repoName=${IMAGE_NAME:0:tagStart-1}

    for tag in 10; do
        #$("docker tag $IMAGE_NAME ${repoName}:${tag}")
        #$("docker push ${repoName}:${tag}")
    done

} || echo "Something went wrong. Error: $!"; exit 1;

exit 0;