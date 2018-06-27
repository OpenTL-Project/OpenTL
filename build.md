This project is pre-1.0 status and as a result may have changing requirements. As a consequence, this document may fall out of date until things are stabilized.


## Prerequisites ##
### HaXe ###

You can get that on their website:
https://haxe.org

Follow directions for your platform.

### Several HaXe Libraries ###

From HaXelib you need:

* actuate
* hxcpp
* lime
* openfl
* svg

Because of doacracy, you also need a library designed by one of this project's developers that isn't in haxelib yet: https://github.com/PXshadow/App

Haxelib can manage these for you just fine. To install them all, run the following lines, one at a time, in a terminal. (Depending on platform and your settings, you may need root or administrator rights to do this.)

``` SH
haxelib install actuate
haxelib install hxcpp
haxelib install lime
haxelib install openfl
haxelib install svg
haxelib git app "https://github.com/PXshadow/App"
```

## Building ##

From the project root, in a terminal, run:

``` sh
haxelib run lime build cpp
```

This will build the current target, a native binary for your current platform.

You may find the binary, when the build is done, in the project folder, under `/bin/PLATFORM_HERE/bin`. It should be runnable directly from there.

## What to do if this document is out of date ##

Specific versions of libraries aren't defined at the present time. Try using the latest versions.

You might also try the `.travis.yml` in the project root for some basic hints. This is the same file given to the CI server to build the project, and in order for builds to pass must be up to date.

If all else fails and you feel a need to build it locally, you can try asking for help.
