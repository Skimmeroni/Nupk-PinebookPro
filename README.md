# Nupk-PinebookPro
Packages and resources tailored for the Pinebook Pro
For some compiler-related flags, try this: 

```
export CFLAGS="-O2 -march=armv8-a -mtune=cortex-a72.cortex-a53"
export CXXFLAGS="$CFLAGS"
export FFLAGS="$CFLAGS"
export LDFLAGS="-Wl, --as-needed"
export MAKEFLAGS="-j6"
```
