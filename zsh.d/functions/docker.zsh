function docker-destroy() {
  local -a containers
  containers=${(z)@}

  if [ "$containers" = "" ]; then
    echo "Usage: $0 CONTAINER"
    return 2;
  fi

  for container in ${containers}; do
    docker kill ${container} && docker rm ${container}
  done
}

# clean up unused containers and non-named images
function docker-clean() {
  local pattern
  local -a protected_containers
  protected_containers=${(z)@:-${DOCKER_PROTECTED_CONTAINERS}}

  for c in ${protected_containers}; do
    id=`docker inspect --format "{{ .ID }}" ${c} 2>/dev/null`
    if [ "$id" != "" ]; then
      echo "'${id}'"
      pattern="${pattern}|$id"
    fi
  done
  pattern=${pattern#|}

  echo '---> removing unused containers...'
  docker rm `docker ps -a -q --no-trunc | grep -v -E "^${pattern}$"`

  echo '---> removing all <none> images...'
  docker rmi $(docker images | grep -e '^<none>' | awk '{ print $3 }' )
}

function docker-ssh() {
  if [ $# -lt 1 ]; then
    echo "Usage: $0 CONTAINER"
    return 2
  fi

  local container=$1; shift
  local args="$*"
  local port="$(docker port ${container} 22 | awk -F: '{print $2}')"
  local host="${$(echo ${DOCKER_HOST} | sed 's/^.*:\/\/\([^:]*\).*$/\1/'):-localhost}"

  if [ "$port" != "" ]; then
    sh -xc "ssh ${host} -p ${port} ${args}"
  fi
}

function docker-open-browser() {
  if [ $# -lt 1 ]; then
    echo "Usage: $0 CONTAINER [PRIVATE_PORT]"
    return 2
  fi
  local container="$1"
  local private_port="${2:-80}"
  local port="$(docker port ${container} ${private_port} | awk -F: '{print $2}')"
  local host="${$(echo ${DOCKER_HOST} | sed 's/^.*:\/\/\([^:]*\).*$/\1/'):-localhost}"

  if [ "${port}" = "" ]; then
    echo "Error: can't get port ${private_port} on ${container}"
    return 1
  fi

  local open_cmd;
  if [ `uname` = "Darwin" ]; then
    open_cmd="open"
  else
  fi

  sh -xc "${open_cmd} 'http://${host}:${port}/'"
}
