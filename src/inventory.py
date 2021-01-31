#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#
#  Copyright 2013-2021 ASC
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


from AnInventory import AnInventory, AnHost

import sys
sys.dont_write_bytecode = True

from traceback import format_exc
import argparse
import json


###
##
#


def get_cli_args():
    description = "https://docs.ansible.com/ansible/2.7/dev_guide/developing_inventory.html Inventory scripts must accept the --list and --host <hostname> arguments, other arguments are allowed but Ansible will not use them. They might still be useful for when executing the scripts directly."
    parser = argparse.ArgumentParser(prog='__FILE__', description=description)
    parser.add_argument('--list',
                        dest="req_list_print",
                        default="self",
                        action='store_true',
                        required=False,
                        help='When the script is called with the single argument --list, the script must output to stdout a JSON-encoded hash or dictionary containing all of the groups to be managed.')
    parser.add_argument('--host',
                        dest="cli_addr_pool",
                        default=[],
                        action='store',
                        nargs='+',
                        help='When called with the argument --host <hostname> (where <hostname> is a host from above), the script must print either an empty JSON hash/dictionary, or a hash/dictionary of variables to make available to templates and playbooks.')
    parser.add_argument('--meta-data-file',
                        dest="file_meta_data",
                        default="meta-data.json",
                        action='store',
                        required=False,
                        help='JSON file with descriptions of hosts.')

    return parser.parse_args()


###
##
#


def main():
    cli_args = get_cli_args()

    with open(cli_args.file_meta_data, 'r') as fh:
        meta_data_hosts = json.load(fh)

    inventory = AnInventory(meta_data_hosts)

    if cli_args.req_list_print:
        print(inventory.pretty_formated)
    elif cli_args.cli_addr_pool:
        print('{}')  # TODO
    else:
        print('{}')

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        sys.stderr.write("{} had error:\n{}".format(__file__, format_exc()))
        exit(1)
