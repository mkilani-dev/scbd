## Overview

This package is provided as a companion to the papers

___Transport policies in polycentric cities, by
  Q. David and M. Kilani, 2019.___

The package is composed of two executables :

- **scbd**    : fixed frequencies
- **f_scbd**  : endogenous frequencies

The optimization step relies on the packages BOBYQA
and COBYLA written by Pr. Powell (the double precision 
versions are used).

The file **scbd.dat** is read for model parameters.

The source code is located in the **src** subdirectory.
The subroutines are separated into several files.
The EQUILIBRIUM subroutine is central since it is the 
one where the network equilibrium is computed.


## Installation 

0. Install **gfortran** (or another Fortran compiler)  

1. Clone this directory 
```
    git clone https://gogs.univ-littoral.fr/mkilani/scbd
```

2. Check **makefile** (edit compiler name if not **gfortran**)

2. Type "make" (gfortran should be installed)
   **scbd** and **f_scbd** executables are produced

4. Edit **scbd.dat** file and save

5. The command **./scbd** can then be used and
   the output is written to the screen.
   Standard redirection can be used to save output
   to file.


## Remark

For some parameter values the obtained output may not 
be optimal because the trust region search is 
not convenient. In case of doubt, it is preferable to
change the values of parameters **RHOBEG** and **RHOEND**
and check for robustness. Too small values may miss the
exploration of the optimal region and values that are 
too large are likely to yield instability and non 
convergence. The given values should work well 
if the values of the model parameters are are not 
changed so much.



