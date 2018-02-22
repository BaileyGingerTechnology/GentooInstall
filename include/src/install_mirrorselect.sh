#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/22/2018
# Purpose : Install tools to do Gentoo mirrorselection

function get_sources
{
    cd /tmp
    git clone https://github.com/BaileyGingerTechnology/mirrorselect.git
    git clone https://github.com/BaileyGingerTechnology/ssl-fetch.git
    git clone https://github.com/BaileyGingerTechnology/netselect.git
}

function install_sslfetch
{
    cd /tmp/ssl-fetch
    ./setup.py build
    ./setup.py install
}

function install_netselect
{
    cd /tmp/netselect
    make && make install
}

function install_mirrorselect
{
    cd /tmp/mirrorselect
    ./setup.py build
    ./setup.py install
}

get_sources
install_sslfetch
install_netselect
install_mirrorselect