#!/usr/bin/env bash

set -eu
set -o pipefail

DNS_NAMESERVER=${DNS_NAMESERVER:-"8.8.8.8"}
DOCKER_SOCKET=${DOCKER_SOCKET:-"/tmp/docker.sock"}
RELOAD_SIGNAL=${RELOAD_SIGNAL:-SIGHUP}

function deploy_challenge {
    local args=("$@")
    for ((i=0; i < $#; i+=3)); do
        local domain="${args[i]}" token_value="${args[i+2]}"
        local record="_acme-challenge.${domain}."

        printf 'Setting record "%s" with value "%s" with provider "%s".\n' "$record" "$token_value" "$PROVIDER"

        lexicon "$PROVIDER" create "$domain" TXT --name="$record" --content="$token_value"
    done

    for ((i=0; i < $#; i+=3)); do
        local record="_acme-challenge.${args[i]}" token_value="${args[i+2]}"

        printf 'Waiting for DNS nameserver "%s" to return record "%s"...\n' "$DNS_NAMESERVER" "$record"

        while :; do
            local answer=$(dig "@$DNS_NAMESERVER" +noall +answer "$record" TXT)

            if [[ $answer == *"$token_value"* ]]; then
                break
            fi

            sleep 10
        done

        printf 'Nameserver returned valid record.\n'
    done
}

function clean_challenge {
    local args=("$@")
    for ((i=0; i < $#; i+=3)); do
        local domain="${args[i]}" token_value="${args[i+2]}"
        local record="_acme-challenge.${domain}."

        printf 'Deleting record "%s" with value "%s" with provider "%s".\n' "$record" "$token_value" "$PROVIDER"

        lexicon "$PROVIDER" delete "$domain" TXT --name="$record" --content="$token_value"
    done
}

function deploy_cert {
  local domain="${1}"

  printf 'Deploying certificate for domain "%s"\n' "$domain"

  if [[ -n ${RELOAD_CONTAINER_ID-} ]]; then
    if [[ -S $DOCKER_SOCKET ]]; then
      printf 'Reloading container %s\n' "$RELOAD_CONTAINER_ID"
      curl -s --unix-socket "$DOCKER_SOCKET" -X POST "http://localhost/containers/${RELOAD_CONTAINER_ID}/kill?signal=${RELOAD_SIGNAL}"
    else
      printf 'Warning: No docker socket found to reload container!\n'
    fi
  else
    printf 'Warning: No container ID found to reload!\n'
  fi
}

if [[ "$(type -t "$1")" == function ]]; then
  "$@"
fi
