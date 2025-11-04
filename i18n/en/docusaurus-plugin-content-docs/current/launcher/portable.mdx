---
description: Creating a Portable Client
---
# Portable Client
:::tip[Example client]
Example portable client aka portable client template is available [on our website](https://llaun.ch/portable)
:::
:::note[Launcher arguments]
To create a portable client you should know launcher startup arguments. Consider reading [this article](./arguments)
:::

## Portable setup {#setup}
Portable client allows you to run the game on any computer without unnecessary manipulations.

Paths in configuration files can be set as *absolute* or *relative*. It is recommended to use *relative* paths.

### Bootstrap arguments setup {#bootstrap}
You must select the type of configuration file(s) before you can proceed with the configuration.

| File name                        | Description                                                                                                                                                        |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `tl.bootargs`                    | Traditional configuration file option. Same arguments for all operating systems.                                                                   |
| `tl-<OS>.bootargs`               | Advanced configuration file option. Different arguments for different operating systems (`windows`, `linux`, `osx` (macOS)).                                  |
| `tl-<OS>-<bits>.bootargs` | Most advanced configuration file option. Different arguments for different operating systems (`windows`, `linux`, `osx` (macOS)) and different for `x64` and `x86` operating systems. |

```bash title="tl.bootargs example"
# Some Java arguments
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=127.0.0.1:5005
-Dsun.java2d.uiScale=2

# Bootstrap arguments passed as system properties
-Dtlauncher.bootstrap.targetJar=./launcher/bin/legacy.jar
-Dtlauncher.bootstrap.targetLibFolder=./launcher/libraries
```
:::warning
Older versions of the launcher read the file in its entirety without taking lines into account, dividing arguments by spaces. Thus, it was impossible to use the space character in the arguments file (for example, in file and folder names).

Newer versions of bootstrap (1.14.0) support the new format: one argument per line.

If there is more than 1 non-empty line in the file, the launcher will read arguments using the new format.
:::

### Launcher arguments setup {#launcher}
You must select the type of configuration file(s) before you can proceed with the configuration.

| Имя файла                    | Описание                                                                                                                                                           |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `tl.args`                    | Traditional configuration file option. Same arguments for all operating systems.                                                                   |
| `tl-<OS>.args`               | Advanced configuration file option. Different arguments for different operating systems (`windows`, `linux`, `osx` (macOS)).                                  |
| `tl-<OS>-<bits>.args` | Most advanced configuration file option. Different arguments for different operating systems (`windows`, `linux`, `osx` (macOS)) and different for `x64` and `x86` operating systems. |

```bash title="tl.args example"
--directory
./game

--settings
./launcher/config/legacy.properties
```
:::warning
Older versions of the launcher read the file in its entirety without taking lines into account, dividing arguments by spaces. Thus, it was impossible to use the space character in the arguments file (for example, in file and folder names).

Newer versions of bootstrap (1.14.0) support the new format: one argument per line.

If there is more than 1 non-empty line in the file, the launcher will read arguments using the new format.
:::

## Frequently Asked Questions {#faq}
### Can I use launcher arguments from the Command Prompt or Terminal? {#terminal}
Yes, of course. Console arguments are set as follows:
```bash
java <JVM arguments and bootstrap system variables> -cp LegacyLauncher.jar Bootstrap <bootstrap and launcher arguments> 
```

### Launcher is not picking up the arguments! {#not-picking}
First, make sure that all argument parameters are entered correctly.  
Secondly, if you are sure that this is not your error, but a launcher bug - write us about it.
:::note[Linux specific note]
The current folder can be the user's folder (`~`, `$HOME`), not the application folder. Take this into account when creating portable clients. You may need to use a bash-script to start a portable client
:::
