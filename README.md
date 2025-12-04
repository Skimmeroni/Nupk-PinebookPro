# Nupk-PinebookPro
Packages and resources tailored for the Pinebook Pro.
The CFLAGS and CXXFLAGS specific for the PBP architecture are as follows:

```
export CFLAGS="-march=armv8-a -mtune=cortex-a72.cortex-a53"
export CXXFLAGS="$CFLAGS"
```

Since the PBP has 6 cores, it is possible to set:

```
export MAKEFLAGS="-j6"
```

However, having only (!) 4 GBs of RAM, using all cores can quickly saturate
the available memory, especially for big projects. Remember to lower the
number of parallel jobs where needed.
