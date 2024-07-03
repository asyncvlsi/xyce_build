# The Xyce build repo

This repository is simply used to build the packages that Xyce depends on, 
followed by Xyce. 

The installation directory is specified by the environment variable
`XYCE_INSTALL`. This directory is used to install SuiteSparse, Trilinos,
as well as Xyce. If this environment variable is not set, then it is set
to `ACT_HOME`.

The latest Trilinos requires a modern `cmake` version (at least 3.29). 
Some standard package managers install older versions of cmake. If that is 
the case, the build scripts attempt to install a newer version of cmake
in the default installation path for cmake.
