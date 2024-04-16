#!/bin/sh

wget https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2.tar.gz
tar -xzf cmake-3.29.2.tar.gz
cd cmake-3.29.2
./configure
make
make install
