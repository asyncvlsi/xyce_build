#!/bin/sh

res=`which cmake 2>/dev/null`

found=1
if [ "x$res" = "x" ]
then
  found=0
fi

if [ $found -eq 1 ]
then
   res=`cmake --version | grep version | awk '{print $NF}' | sed 's/\./ /g'`
   v0=`echo $res | awk '{print $1}'`
   v1=`echo $res | awk '{print $2}'`
   if [ $v0 -gt 3 -o $v0 -eq 3 -a $v1 -ge 29 ]
   then
	found=1
   else
	found=0
   fi
fi


if [ $found -eq 0 ]
then
if [ ! -f cmake-3.29.2.tar.gz ]
then
wget https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2.tar.gz
tar -xzf cmake-3.29.2.tar.gz
fi
cd cmake-3.29.2
echo "CMAKE installation: $XYCE_INSTALL"
if [ -z ${XYCE_INSTALL+x} ]
then
   XYCE_INSTALL=${ACT_HOME}
fi
echo "CMAKE installation: $XYCE_INSTALL"
./configure --prefix=$XYCE_INSTALL
make
make install

fi
