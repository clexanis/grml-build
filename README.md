grml-build
=========

This repository hold daily automated build of grml modified for my usage.

Daily build are subject to change and are currently build with up-to-date Debian Bullseye, default grml full packages, ClamAV, and OpenZFS.

## List of current modifications

 - [x] Daily build script
 - [x] OpenZFS with Debian DKMS package
 - [x] Removed support for unsupported Debian version
 - [ ] ZFS with PVE kernel?
 - [ ] Backported kernel?

## Original readme

grml-live is a build system for creating a
[Grml](https://grml.org/) and [Debian](https://www.debian.org/)
based Linux Live system. The build system is based on FAI ([Fully
Automatic Installation](https://fai-project.org/)).

Building a Debian based 64bit live system is as simple as running:

    # grml-live -s sid -a amd64 -c GRMLBASE,GRML_FULL,AMD64

You can fully customize the build process, including adding
additional software and your very own configuration files.

Further information is available from https://grml.org/grml-live/

In case you want to run grml-live directly from the checkout
(after making sure all dependencies are installed), you should
set `GRML_FAI_CONFIG`, the `SCRIPTS_DIRECTORY`, the `LIVE_CONF`
and the templates option so that it does not use the config files
of an installed `grml-live` package:

    # export GRML_FAI_CONFIG=$(pwd)/etc/grml/fai
    # export SCRIPTS_DIRECTORY=$(pwd)/scripts
    # export LIVE_CONF=$(pwd)/etc/grml/grml-live.conf
    # export TEMPLATE_DIRECTORY=$(pwd)/templates
    # ln -s ../../../grml-live-grml/templates/boot/addons templates/boot/  # optional
    # ./grml-live -s sid -a amd64 -c GRMLBASE,GRML_FULL,AMD64
