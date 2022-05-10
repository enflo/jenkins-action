#!/bin/sh
#shellcheck disable=SC3014,SC3010
set -eu

url="${1}"
user="${2}"
token="${3}"
job="${4}"
parameters="${5}"

credential="${user}:${token}"
jobPath="${url}/${job}"

if [ -n "${parameters}" ]
then
    if [ "${parameters}" == "BRANCH" ]
    then
        parameters="BRANCH=${GITHUB_HEAD_REF}"
    fi

    if [[ "${job}" == *"buildWithParameters"* ]];
    then
        jobPathParameter="${jobPath}?${parameters}"
    else
        jobPathParameter="${jobPath}/buildWithParameters?${parameters}"
    fi
else
    jobPathParameter="${jobPath}"
fi

#replace spaces
jobPathParameter=$(echo "${jobPathParameter}" | sed -e 's/ /%20/g');

/usr/bin/curl -v -X POST -u "${credential}" "${jobPathParameter}"

