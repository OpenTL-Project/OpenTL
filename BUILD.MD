Project is written in haxe and uses OpenFL as the main framework.

The following below are Required for building the project.

### Haxe ###
[Download](https://haxe.org/download/) 

*NOTE:* This project uses haxe 3.4.7 to test compleation with Travis, newer syntax supported by 4.0 will not be able to pass review.

<br>

### Haxelib Libaries ###
after installing haxe, the haxelib command should be available in terminal/command prompt

``` SH
haxelib install lime
haxelib install openfl
haxelib install hxcpp
haxelib install svg
haxelib git app "https://github.com/PXshadow/App"
```

*Note: It is possible to use the haxelib version of app, however app is the ui layer underneath OpenTL and is constantly adapting in order to fit new imerging needs of this project so it is advised to just use the git version and update if new builds return erros.*

<br>

**Tested Versions**
* OpenFL 7-8
* Lime 6.0 - 6.4

<br>

### Platform setup ###
* cpp
``` SH
lime setup cpp
```
* neko, N/A

<br>

### **Building project!** ###

* c++ version
``` SH
lime test cpp
```
* neko virtual machine (worse performance, faster completion)
``` SH
lime test neko
```

### flags ###
explanation: flags are used to set certain atributes for your build, add them to the end of a build/test command.

* -debug for testing/debugging builds
* -release greater performance.
* -final release with [dce full](https://haxe.org/manual/cr-dce.html)


