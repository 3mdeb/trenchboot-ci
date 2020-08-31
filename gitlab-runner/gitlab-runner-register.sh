#!/bin/sh

if [ -z "$REGISTRATION_TOKEN" ]; then
  echo "REGISTRATION_TOKEN is missing"
  exit 1
fi

register_runner() {
  local _runner_id="$1"
  local _runner_tags="$2"

  docker-compose exec gitlab-runner${_runner_id}-trenchboot gitlab-runner register \
      --non-interactive \
      --registration-token "${REGISTRATION_TOKEN}" \
      --tag-list "${_runner_tags}" \
      --locked=false \
      --description docker-stable \
      --url https://gitlab.com/ \
      --executor docker \
      --docker-image docker:stable \
      --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
      --docker-disable-cache \
      --output-limit 131072
}

register_runner 1 "local,build"
register_runner 2 "local,build"
register_runner 3 "local,test"
register_runner 4 "local,test"
