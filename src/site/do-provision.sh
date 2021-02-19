#!/bin/bash
#
#  Copyright 2007-2021 ASC
#
#  This file is part of "Οἰκουμένη" ("Ecumene") - set of applications and
#  configurations to assist with deploy and set up of an environments.
#
#  Οἰκουμένη is free software: you can redistribute it and/or
#  modify it under the terms of the GNU General Public License as
#  published by the Free Software Foundation, either version 3 of
#  the License, or (at your option) any later version.
#
#  Οἰκουμένη is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Οἰκουμένη.
#  If not, see <http://www.gnu.org/licenses/>.
#
##


PS4="+:\${0}:\${LINENO}: "
set -xeu -o pipefail


if [ "${#}" -lt 1 ] || [ "${*}" != "${*/--help/}" ] ; then
    cat "${0}" | egrep "([[:space:]]|\|)[\-]{1,2}[a-zA-Z0-9_\-]{1,})"
    exit 1
fi

declare -r dir_this="$( dirname "${0}" )"

declare -r file_inventory="inventory.json"


function validate_json {
    set -e
    local -r file_json="${1:-$file_json}"
    jq --raw-output '.' "${file_json}" 1>/dev/null
}

function launch_ansible {
    set -e
    local -r f_inventory="${1}"
    shift
    time \
        ansible-playbook \
            --inventory "${f_inventory}" \
            "${@}"
}

###
##
#


cd "${dir_this}"

"inventories/inventory.py" --list > "${file_inventory}"
set -e ; validate_json "${file_inventory}"

req_arbitrary="false"
req_delete="false"
req_k8s="false"
req_k8s_purge="false"
while [ ${#} -gt 0 ] ; do
    arg_name="${1}"
    case "${arg_name}" in
        --arbitrary)
            req_arbitrary="true"
            ;;
        --delete)
            req_delete="true"
            ;;
        --k8s)
            req_k8s="true"
            ;;
        --no-k8s)
            req_k8s_purge="true"
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "ERROR:${0}:${LINENO}: Unknown CLI argument '${arg_name}'." >&2
            exit 1
    esac
    shift
done


if [ "${req_arbitrary,,}" == "true" ] ; then
    launch_ansible "${file_inventory}" "${@}"
fi
if [ "${req_k8s_purge,,}" == "true" ] ; then
    launch_ansible "${file_inventory}" "${@}" k8s-empty.yaml
fi
if [ "${req_k8s,,}" == "true" ] ; then
    mkdir -p -m 700 ~/.kube
    launch_ansible "${file_inventory}" "${@}" k8s.yaml
fi
if [ "${req_delete,,}" == "true" ] ; then
    vagrant destroy --force --parallel
fi

set +x
echo "INFO:${0}:${LINENO}: Job done." >&2
echo "" >&2
