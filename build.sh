#!/bin/sh

echo
echo "Building Xyce and installing it in the ACT_HOME directory."
echo
echo "Xyce needs flex and bison; make sure you have those setup"
echo "on your system. Sometimes on MacOS you will need to set"
echo "the environment FLEX_INCLUDE_DIR to point to the location"
echo "of FlexLexer.h."
echo

if [ "x`which bison`" = "x" ]
then
	echo "bison not found!"
	exit 1
fi

if [ "x`which flex`" = "x" ]
then
	echo "flex not found!"
	exit 1
fi

case `uname -s` in
Darwin|darwin) flex_odd=1;;
*) flex_odd=0;;
esac

# check for weird mac issue
if [ $flex_odd -eq 1 ]
then
	res=`find /Applications/Xcode.app/Contents/Developer/Toolchains/ -name FlexLexer.h 2>/dev/null | sed 's/\(.*\)FlexLexer.h/\1/'`
	if [ "x$res" = "x" ]
	then
		flexdir=
	else
		flexdir="-DFLEX_INCLUDE_DIR=$res"
	fi
fi

echo "*** Build and install cmake ***"
./build_cmake.sh

echo "*** Build/install SuiteSparse ***"
(cd SuiteSparse && \
 if [ ! -d build ]; then mkdir build; fi && \
 cd build && \
 cmake -DCMAKE_INSTALL_PREFIX=$ACT_HOME -DSUITESPARSE_ENABLE_PROJECTS="suitesparse_config;amd" .. && \
 make && make install || exit 1)

(cd $ACT_HOME/include; ln -s suitesparse/* .)

echo "*** Build/install Trilinos with Xyce options ***"

(cd trilinos && \
 if [ ! -d build ]; then mkdir build; fi && \
 cd build &&
 cmake \
-G "Unix Makefiles" \
-DCMAKE_Fortran_COMPILER=gfortran \
-DCMAKE_CXX_FLAGS="-O3 -fPIC" \
-DCMAKE_C_FLAGS="-O3 -fPIC" \
-DCMAKE_Fortran_FLAGS="-O3 -fPIC" \
-DCMAKE_INSTALL_PREFIX=$ACT_HOME \
-DCMAKE_MAKE_PROGRAM="make" \
-DTrilinos_ENABLE_NOX=ON \
  -DNOX_ENABLE_LOCA=ON \
-DTrilinos_ENABLE_EpetraExt=ON \
  -DEpetraExt_BUILD_BTF=ON \
  -DEpetraExt_BUILD_EXPERIMENTAL=ON \
  -DEpetraExt_BUILD_GRAPH_REORDERINGS=ON \
-DTrilinos_ENABLE_TrilinosCouplings=ON \
-DTrilinos_ENABLE_Ifpack=ON \
-DTrilinos_ENABLE_AztecOO=ON \
-DTrilinos_ENABLE_Belos=ON \
-DTrilinos_ENABLE_Teuchos=ON \
-DTeuchos_ENABLE_COMPLEX=ON \
-DTrilinos_ENABLE_Amesos=ON \
  -DAmesos_ENABLE_KLU=ON \
-DTrilinos_ENABLE_Amesos2=ON \
 -DAmesos2_ENABLE_KLU2=ON \
 -DAmesos2_ENABLE_Basker=ON \
-DTrilinos_ENABLE_Sacado=ON \
-DTrilinos_ENABLE_Stokhos=ON \
-DTrilinos_ENABLE_Kokkos=ON \
-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF \
-DTrilinos_ENABLE_CXX11=ON \
-DAMD_LIBRARY_DIRS=$ACT_HOME/lib \
-DTPL_AMD_INCLUDE_DIRS=$ACT_HOME/include \
-DTPL_ENABLE_AMD=ON \
-DTPL_ENABLE_BLAS=ON \
-DTPL_ENABLE_LAPACK=ON \
 .. && \
 make -j && make install || exit 1)

echo "*** Build/install Xyce ***"
(cd Xyce &&
 if [ ! -d build ]; then mkdir build; fi && \
 cd build &&
 cmake -DCMAKE_INSTALL_PREFIX=$ACT_HOME $flexdir .. && \
 make -j && make xycecinterface && make install || exit 1)
