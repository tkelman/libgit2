#!/bin/sh
set -e
cd `dirname "$0"`/..
if [ "$ARCH" = "32" ]; then
  echo 'C:\MinGW\ /MinGW' > /etc/fstab
  # if the following stops working at some point when appveyor upgrades chocolatey,
  # try with --forcex86
  choco install openssl.light -forcex86
elif [ "$ARCH" = "i686" ]; then
  f=i686-4.9.2-release-win32-sjlj-rt_v3-rev1.7z
  if ! [ -e $f ]; then
    curl -LsSO http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/4.9.2/threads-win32/sjlj/$f
  fi
  7z x $f > /dev/null
  mv mingw32 /MinGW
  # if the following stops working at some point when appveyor upgrades chocolatey,
  # try with --forcex86
  choco install openssl.light -forcex86
else
  f=x86_64-4.9.2-release-win32-seh-rt_v3-rev1.7z
  if ! [ -e $f ]; then
    curl -LsSO http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/4.9.2/threads-win32/seh/$f
  fi
  7z x $f > /dev/null
  mv mingw64 /MinGW
  choco install openssl.light
fi
ls -al /c/Program\ Files/OpenSSL/*
cd build
cmake -D ENABLE_TRACE=ON -D BUILD_CLAR=ON -D CMAKE_FIND_ROOT_PATH="C:\\Program Files\\OpenSSL" .. -G"$GENERATOR"
cmake --build . --config RelWithDebInfo
