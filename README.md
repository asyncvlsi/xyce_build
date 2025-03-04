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
in the `XYCE_INSTALL` (or `ACT_HOME`) installation path.

The packages that are assumed to be already installed on the system (along with their package names for Ubuntu in parentheses) are:

   * Compression library zlib (`zlib1g-dev`)
   * m4 macro package (`m4`)
   * Build tools (`build-essential`)
   * Git (`git`)
   * Parser generator bison (`bison`)
   * Lexer generator flex (`flex`)
   * wget, For downloading tarballs (`wget`)
   * SSL (`libssl-dev`)
   * BLAS libraries (`libopenblas-dev`)
   * Python v3 (`python3`)
   * GNU Fortran compiler (`gfortran`)

On Ubuntu, these can be installed (as root) using:

```
apt-get -q install -y zlib1g-dev m4 build-essential bison flex wget libssl-dev libopenblas-dev python3 gfortran
```
