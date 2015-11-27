#!/bin/bash

cd ~/.atom/
apm list -ib | awk -F@ '{ print $1 }' > ./atom_packages.txt

