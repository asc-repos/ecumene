#!/bin/bash

#
#  Copyright 2019-2021 ASC
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
set -xeu

declare -r helm_version="${1:-$helm_version}"  # I.e.: '3.4.2'.
declare -r os_family="${2:-$os_family}"  # I.e.: 'linux'.
declare -r hw_arch="${3:-$hw_arch}"  # I.e.: 'amd64'.

declare -r dir_install="/usr/local/bin"

declare -r timestamp="$( date '+%Y-%m-%d-%H%M-%S.%N_%z' )"
declare -r dir_temp="$( mktemp --directory --suffix -heml-installer )"
trap "rm -rf '${dir_temp}'" EXIT ABRT INT KILL STOP TSTP TERM

declare -r file_zip_donor="helm-v${helm_version}-${os_family}-${hw_arch}.tar.gz"
declare -r url_donor="https://get.helm.sh/${file_zip_donor}"
declare -r file_zip_acceptor="${file_zip_donor}"
declare -r file_download_cache="${dir_temp}/$( sed 's#\.tar\.gz$##g' <<< "${file_zip_donor}" )_${timestamp}.tar.gz"



test -d "${dir_install}" \
    || mkdir -p "${dir_install}"

if [ ! -e "${file_zip_acceptor}" ] ; then
    wget \
        --show-progress \
        --progress=bar:force \
        "${url_donor}" \
        --output-document "${file_download_cache}"
    mv  "${file_download_cache}"  "${file_zip_acceptor}"
    sha256sum -b "${file_zip_acceptor}" > "${file_zip_acceptor}.sha256"
else
    sha256sum --check "${file_zip_acceptor}.sha256"
fi

tar xz -f "${file_zip_acceptor}" --directory="${dir_temp}"
sudo install --owner root --group root --mode 755 \
        "${dir_temp}/${os_family}-${hw_arch}/helm" \
        "${dir_install}/helm-${helm_version}"
sudo ln --force --symbolic \
        "${dir_install}/helm-${helm_version}" \
        "${dir_install}/helm"

helm version

# Helm2 have Tiller - "...distro/linux-amd64/tiller" - to be installed. It's install out of scope today.

set +x
echo "INFO:${0}:${LINENO}: Helm has been installed. Job done." >&2
echo ""
