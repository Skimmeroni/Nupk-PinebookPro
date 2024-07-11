# Nupk-PinebookPro
Packages and resources tailored for the Pinebook Pro
For some compiler-related flags, try this: 

```
export CFLAGS=""
       CFLAGS="$CFLAGS -O2" 
       CFLAGS="$CFLAGS -march=armv8-a+simd+crc" 
       CFLAGS="$CFLAGS -mtune=cortex-a72.cortex-a53" 
export CXXFLAGS="$CFLAGS"
export FFLAGS="$CFLAGS"
export MAKEFLAGS="-j6"
```
