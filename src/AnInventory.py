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


import sys
import copy
import json
sys.dont_write_bytecode = True

class AnHost:

    def __init__(self, meta_data):
        """
        :param meta_data: Metadata for a single host, dictinary or like dict.
        """
        self.mdh = copy.deepcopy(meta_data)
        self.group = self.get_group()
        self.host = self.get_host()
        self.nickname = self.get_nickname()

    def get_group(self):
        """
        :return: Value for Ansible internal variable 'ansible_group'.
        """
        ansible_group = self.mdh["position"]
        return ansible_group

    def get_host(self):
        """
        :return: Value for Ansible internal variable 'ansible_host'. 
        """
        ansible_host = self.mdh["hostname"] + "." + self.mdh["domain"]
        return ansible_host

    def get_nickname(self):
        """
        :return: Name of Ansible inventory object with ansible target host 
        description in Ansible inventory. I.e. the name 'nickname' of 
        corresponding section 'nickname' in pseudo code example below:
            inventory.yaml = 
                ansible_group:
                    hosts:
                        nickname:
                            ansible_host: localhost
                            hst_ip: 127.0.0.1
        """
        ansible_host_nickname = self.group \
                                + "_" + self.mdh["hostname"] \
                                + "." + self.mdh["domain"]
        return ansible_host_nickname


class AnInventory:
    def __init__(self, meta_data):
        """
        :param meta_data: Initial metadata for all hosts, dictinary or 
        like dict.
        """
        self.mdh = copy.deepcopy(meta_data)
        self.inventory = json.loads('{}')
        self.get_inventory(meta_data)
        self.pretty_formated = self.get_pretty_formated()
        self.example = self.get_example()

    def get_inventory(self, meta_data_hosts):
        for hst_data in meta_data_hosts:
            self.append_host(AnHost(hst_data))
        return self.inventory

    def get_pretty_formated(self):
        return json.dumps(self.inventory, indent=4, sort_keys=True)

    def append_host(self, an_host):
        """
        TODO - implement decorator-validator
        :param an_host: 
        :return: 
        """
        if an_host.group in self.inventory:
            self.inventory[an_host.group]['hosts'][an_host.nickname] = \
                { 'ansible_host': an_host.host }
        else:
            self.inventory[an_host.group] = {
                'hosts': {
                    an_host.nickname: {
                        'ansible_host': an_host.host
                    }
                }
            }

    def get_host_var(host_meta_data, hostname):
        """
        https://docs.ansible.com/ansible/2.7/dev_guide/developing_inventory.html
        When called with the argument --host <hostname> (where <hostname> is
        a host from above), the script must print either an empty JSON
        hash/dictionary, or a hash/dictionary of variables to make available
        to templates and playbooks.
        For example:
            {
                "VAR001": "VALUE",
                "VAR002": "VALUE",
            }
        Printing variables is optional.

        :param meta_data_hosts: 
        :return: 
        """
        return '{}'

    def get_example(self):
        """
        :return: Example of Ansible JSON as it is in 
        https://docs.ansible.com/ansible/2.7/dev_guide/developing_inventory.html
        Was not tested, Ansible code was broken, as of summer 2019 and did 
        not worked with data struct-s described by the documentation.
        """
        example = json.loads('''{
            "group001": {
                "hosts": ["host001", "host002"],
                "vars": {
                    "var1": true
                },
                "children": ["group002"]
            },
            "group002": {
                "hosts": ["host003", "host004"],
                "vars": {
                    "var2": 500
                },
                "children": []
            }

        }''')

        return example
