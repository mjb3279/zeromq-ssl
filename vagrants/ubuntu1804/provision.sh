#!/bin/bash
# MIT License
#
# Copyright (c) 2020 Michael J Boquard
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# enable echoing of commands
set -x

# update repo
apt update

# install
apt -y install cmake automake autoconf pkg-config lcov gdb libzmq3-dev libssl-dev || exit 1
# Remove cloud-init
apt -y remove cloud-init || exit 1

if [ ! -f /usr/local/bin/uncrustify ]; then
  # Grab uncrustify version 0.70.1
  git clone --branch uncrustify-0.70.1 https://github.com/uncrustify/uncrustify.git /opt/uncrustify || exit 1
  # Make uncrustify
  pushd /opt/uncrustify || exit 1
  mkdir -pv build
  cd build || exit 1
  cmake ..
  cmake --build .
  make install
  popd || exit 1
  rm -rf /opt/uncrustify
fi

# Now grab the latest CPPZMQ headers (verison v4.6.0)
if [ ! -f ~/.cpp_zmq_installed ]; then
  git clone --branch v4.6.0 https://github.com/zeromq/cppzmq.git /opt/cppzmq || exit 1
  pushd /opt/cppzmq || exit 1
  mkdir -pv build || exit 1
  cd build || exit 1
  cmake .. -DCPPZMQ_BUILD_TESTS=OFF || exit 1
  make -j4 install || exit 1
  touch ~/.cpp_zmq_installed
  popd || exit 1
  rm -rf /opt/cppzmq
fi

# Now grab flatbuffers

if [ ! -f ~/.flatbuffers_installed ]; then
  git clone --branch v1.12.0 https://github.com/google/flatbuffers.git /opt/flatbuffers || exit 1
  pushd /opt/flatbuffers || exit 1
  mkdir -pv build || exit 1
  cd build || exit 1
  cmake .. -DFLATBUFFERS_BUILD_TESTS=OFF -DFLATBUFFERS_BUILD_SHAREDLIB=ON -DFLATBUFFERS_BUILD_CPP17=ON || exit 1
  make -j4 install || exit 1
  touch ~/.flatbuffers_installed
  popd || exit
fi