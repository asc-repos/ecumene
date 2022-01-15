#
#  Copyright 2013-2022 ASC
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

##
#   Default distro's examples:
#       PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#       PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#

###
##
#
# Color chart:
#   Black       0;30     Dark Gray     1;30      Blue        0;34     Light Blue    1;34
#   Red         0;31     Light Red     1;31      Purple      0;35     Light Purple  1;35
#   Green       0;32     Light Green   1;32      Cyan        0;36     Light Cyan    1;36
#   Brown       0;33     Yellow        1;33      Light Gray  0;37     White         1;37
#   No color    0
# red='\e[0;31m'
# RED='\e[1;31m'
# blue='\e[0;34m'
# BLUE='\e[1;34m'
# cyan='\e[0;36m'
# CYAN='\e[1;36m'
# green='\e[0;32m'
# GREEN='\e[1;32m'
# yellow='\e[0;33m'
# YELLOW='\e[1;33m'
# NC='\e[0m'
#
##

PS1='${debian_chroot:+($debian_chroot)}\[\033[0;37m\]\u@\[\033[01;31m\]\h\[\033[01;00m\]: \W\[\033[00m\] \[\033[01;31m\]#\[\033[01;00m\] '
