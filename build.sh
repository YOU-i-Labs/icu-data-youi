#!/bin/bash

cmake -Bbuild -H. -DCMAKE_TOOLCHAIN_FILE=../uswish/cmake/Toolchain/Toolchain-Osx.cmake -DCMAKE_INSTALL_PREFIX=install/  && cmake --build build/ -t install
