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


declare -r file_inventory="inventory.json"


function validate_json {
    set -e
    local -r file_json="${1:-$file_json}"
    jq --raw-output '.' "${file_json}" 1>/dev/null
}


"inventories/inventory.py" --list > "${file_inventory}"
set -e ; validate_json "${file_inventory}"

req_common="false"
while [ ${#} -gt 0 ] ; do
    arg_name="${1}"
    case "${arg_name}" in
        --common)
            req_common=true
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


if [ "${req_common,,}" == "true" ] ; then
    time \
        ansible-playbook \
            --inventory "${file_inventory}" \
            "${@}"
fi

set +x
echo "INFO:${0}:${LINENO}: Job done. Collected values are ${arg_abc_values[@]}." >&2
echo "" >&2
