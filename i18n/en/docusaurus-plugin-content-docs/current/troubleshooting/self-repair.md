---
description: How to solve launch issues yourself
sidebar_position: 3
---
# Solving issues yourself

Got a crash?
You can try to find the cause yourself.
Just press "Open Logs" button in error window or enable "Logger" in the launcher settings.  
Following is a list of relatively simple to detect and common game launch issues, including issues with mods.  
**All examples below are based on real support requests from our users**.

:::tip[How to find the right section]
Find the line with the error in the log - it usually starts with `Caused by` or contains the words `Exception` or `Error`. Then search for the key part of this line on this page (Ctrl+F, or Cmd+F on macOS): all examples below contain real lines from logs
:::

## Java and system {#java-system}

### Wrong Java version {#wrong-java}
Every game version needs its own Java version. If "Recommended" Java is selected in the launcher settings, the launcher picks it itself. Most often a mod that needs a newer Java than the recommended one is simply built for a newer game version - in this case you need the version of the mod for your game version, not another Java.

#### Mod requires a newer Java {#mod-needs-newer-java}
Detected by `java.lang.UnsupportedClassVersionError` in `caused by` string.
```log title="Log example"
> Exception in thread "main" java.util.ServiceConfigurationError: net.minecraftforge.forgespi.language.IModLanguageProvider: Unable to load thedarkcolour.kotlinforforge.KotlinLanguageProvider
>   at java.base/java.util.ServiceLoader.fail(ServiceLoader.java:586)
// highlight-next-line
> Caused by: java.lang.UnsupportedClassVersionError: thedarkcolour/kotlinforforge/KotlinLanguageProvider has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
>   at java.base/java.lang.ClassLoader.defineClass1(Native Method)
```
In this example, it is clear that the mod `kotlinforforge` failed to load because it is being run on an outdated version of Java. The required Java version can be determined by the `class file version`, using [this website](https://javaalmanac.io/bytecode/versions/). In this example, the game was launched with Java 17 (61.0), but the mod requires Java 21 (65.0).

What to do:
* If "Recommended" Java is selected in the launcher settings, the mod is made for a different game version. Download the version of the mod for your game version
* If Java was selected manually, select "Recommended"

Fabric reports an unsuitable Java the same way as a missing dependency - as a "mod" called `java`:
```log title="Log example"
> net.fabricmc.loader.impl.FormattedException: Some of your mods are incompatible with the game or each other!
> A potential solution has been determined, this may resolve your problem:
// highlight-next-line
>    - Replace 'Java HotSpot(TM) 64-Bit Server VM' (java) 8 with version 21 or later.
> More details:
>    - Mod 'Fabric API' (fabric-api) 0.119.4+1.21.4 requires version 21 or later of 'Java HotSpot(TM) 64-Bit Server VM' (java), but only the wrong version is present: 8!
```
There is no need to find and install the required Java yourself - do the same as described above.

#### Game requires a newer Java {#game-needs-newer-java}
```log title="Log example"
> Error: LinkageError occurred while loading main class net.minecraft.client.main.Main
// highlight-next-line
>   java.lang.UnsupportedClassVersionError: net/minecraft/client/main/Main has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
```
The same `UnsupportedClassVersionError` error occurs when the game itself is launched on a too old Java.  
Select "Recommended" Java in the launcher settings. If it is already selected, use the "Force update" checkbox.

On NeoForge the same problem may look different - the game crashes before loading mods:
```log title="Log example"
> Error occurred during initialization of boot layer
> java.lang.module.FindException: Error reading module: D:\Minecraft\game\libraries\cpw\mods\bootstraplauncher\2.0.2\bootstraplauncher-2.0.2.jar
// highlight-next-line
> Caused by: java.lang.module.InvalidModuleDescriptorException: Unsupported major.minor version 65.0
```
The solution is the same - select "Recommended" Java. If it is already selected, one of the mods is made for a different game version.

#### Old game version on a newer Java {#old-game-new-java}
Forge, OptiFine and LiteLoader for versions up to 1.12.2, as well as the oldest game versions, use the so-called `launchwrapper`, which does not work with Java 9 or newer. Such versions will crash with the following log when launched on newer Java versions:
```log title="Log example"
// highlight-next-line
> Exception in thread "main" java.lang.ClassCastException: class jdk.internal.loader.ClassLoaders$AppClassLoader cannot be cast to class java.net.URLClassLoader (jdk.internal.loader.ClassLoaders$AppClassLoader and java.net.URLClassLoader are in module java.base of loader 'bootstrap')
>   at net.minecraft.launchwrapper.Launch.<init>(Launch.java:33)
>   at net.minecraft.launchwrapper.Launch.main(Launch.java:27)

```
The solution is to run the game using Java 8. This error almost always means that Java was selected manually - select "Recommended" Java.

#### Mod requires an older Java {#mod-needs-older-java}
The opposite also happens - a mod requires an **older** Java. For example, some mods for 1.16.5 were written for Java 8 and do not work on Java 16. By default, the launcher runs 1.16.5 on Java 16 instead of Java 8 recommended by Mojang, because many mods for this version require a newer Java:
```log title="Log example"
> [20:43:54] [Render thread/FATAL] [ne.mi.fm.ModLoader/]: Encountered non-modloading exceptions!
> java.util.concurrent.CompletionException: java.lang.RuntimeException
>   Suppressed: java.lang.ExceptionInInitializerError
>   Caused by: java.lang.RuntimeException: Can't retrieve field modifiers from class class java.lang.reflect.Field
>     at ru.timeconqueror.timecore.api.reflection.ReflectionHelper.findField(ReflectionHelper.java:117) ~[timecore:1.16.5-3.4.1.0.build45] {re:classloading}
// highlight-next-line
>   Caused by: java.lang.NoSuchFieldException: modifiers
>     at java.lang.Class.getDeclaredField(Class.java:2549) ~[?:?] {}
>     at ru.timeconqueror.timecore.api.reflection.ReflectionHelper.findField(ReflectionHelper.java:114) ~[timecore:1.16.5-3.4.1.0.build45] {re:classloading}
```
The key line is `NoSuchFieldException: modifiers`. In this example, the problem is in the `timecore` mod. Select Java 8 for this version manually ([how to do it](../faq/custom-java#edit-version)).

### Java VM Crash {#jvm-crash}
Sometimes it's not the game that crashes, but the Java Virtual Machine itself:
```log title="Log example"
[:] #
[:] # A fatal error has been detected by the Java Runtime Environment:
[:] #
// highlight-next-line
[:] #  EXCEPTION_ACCESS_VIOLATION (0xc0000005) at pc=0x00007ff91b3cfdf8, pid=17192, tid=27840
[:] #
[:] # JRE version: OpenJDK Runtime Environment Microsoft-22300 (16.0.1+9) (build 16.0.1+9)
[:] # Java VM: OpenJDK 64-Bit Server VM Microsoft-22300 (16.0.1+9, mixed mode, tiered, compressed oops, compressed class ptrs, g1 gc, windows-amd64)
// highlight-next-line
[:] # Problematic frame:
// highlight-next-line
[:] # V  [jvm.dll+0x69fdf8]
[:] #
[:] # No core dump will be written. Minidumps are not enabled by default on client versions of Windows
[:] #
[:] # If you would like to submit a bug report, please visit:
[:] #   https://github.com/microsoft/openjdk/issues
[:] #
```
In such logs, there are two key points: the error (in the example above, it's `EXCEPTION_ACCESS_VIOLATION`) and the library where the error occurred (`jvm.dll`).
Typical solutions involve tracking down which component the error is related to and removing it (if it's third-party software, such as SafeIP), or updating/rolling back (if it's Java or a graphics driver).

The library name tells what it belongs to:

| Library name starts with | What it is | What to do |
|---|---|---|
| `nvoglv`, `nvwgf`, `nvd3d` | NVIDIA graphics driver | [Update or roll back the driver](./win-problems#gpu-driver) |
| `ig4icd`, `ig7icd`, `ig8icd`, `ig9icd`, `ig11icd`, `ig12icd`, `ig75icd`, `igxelpicd`, `igvk`, `igdumd`, `igd10` | Intel graphics driver | [Update or roll back the driver](./win-problems#gpu-driver) |
| `atio`, `aticfx`, `amdvlk`, `amdxc` | AMD graphics driver | [Update or roll back the driver](./win-problems#gpu-driver) |
| `jvm.dll`, `libjvm` | Java | [Install another Java distribution](./win-problems#replace-java) |
| `SafeIPs` | SafeIP | [Uninstall the program](./win-problems#injectors) |
| `LavasoftTcpService` | Lavasoft Web Companion | [Uninstall the program](./win-problems#injectors) |
| `graphics-hook` | OBS game capture | Disable the "Game Capture" source in OBS or use "Window Capture" instead |
| `medal-hook` | Medal | Close Medal or disable game recording in it |

:::note[EXCEPTION_ILLEGAL_INSTRUCTION]
The `EXCEPTION_ILLEGAL_INSTRUCTION` error means that the program requires a newer processor than the one installed in your PC. The error may be not only in the graphics driver, but also in a Java or mod library. Try an older version of that program (driver, Java or mod)
:::

Unfortunately, these errors are often non-trivial to fix, and even we might not be able to help. Try Googling, or contact the support of the component's manufacturer (e.g., the graphics driver).
:::danger
Never attempt to manually delete or replace the problematic dll file! You could make the problem worse or break your OS!
:::
:::tip
You can _try_ to resolve this issue using [this guide](./win-problems)
:::

### Exit code 1114 {#exit-code-1114}
The game closes right after the `Backend library: LWJGL version ...` line, and the launcher reports exit code 1114:
```log title="Log example"
> [19:21:07] [Render thread/INFO]: Backend library: LWJGL version 3.3.3+5
19:21:28,697 [MinecraftLauncher] Launcher has stopped.
// highlight-next-line
19:21:28,697 [MinecraftLauncher] Child process closed with exit code: 1114 (0x45a)
```
Code 1114 means that the graphics driver failed to start. This most often happens on laptops with two graphics cards - integrated Intel and discrete AMD.  
The solution is to switch the Windows power plan to maximum performance. Reinstalling the driver is usually not necessary

### Out of memory {#out-of-memory}
The game may run out of either the memory allocated to it or the memory of the whole system. These cases have different solutions.

#### Not enough allocated memory {#heap-exhausted}
If the game ran out of **allocated** memory, the log will contain the `java.lang.OutOfMemoryError: Java heap space` or `java.lang.OutOfMemoryError: GC overhead limit exceeded` error:
```log title="Log example"
> Description: Initializing game
> 
// highlight-next-line
> java.lang.OutOfMemoryError: Java heap space
>   at java.desktop/java.awt.image.DataBufferInt.<init>(Unknown Source)
>   at java.desktop/java.awt.image.Raster.createPackedRaster(Unknown Source)
```
Allocate more memory to the game in the [launcher settings](../launcher/settings#minecraft) (the "Memory (RAM)" option), but not more than is free in the system. Recommended values are listed in the [system requirements](../system-requirements#minecraft). If the system has little memory, remove some mods or shaders

#### Not enough system memory {#system-memory}
If the **system** ran out of memory, the errors look different:
```log title="Java could not reserve the allocated memory"
> Error occurred during initialization of VM
// highlight-next-line
> Could not reserve enough space for 1048576KB object heap
```
```log title="Not enough memory or paging file (Windows)"
// highlight-next-line
> OpenJDK 64-Bit Server VM warning: INFO: os::commit_memory(0x0000000781000000, 427819008, 0) failed; error='The paging file is too small for this operation to complete' (DOS error/errno=1455)
> #
> # There is insufficient memory for the Java Runtime Environment to continue.
> # Native memory allocation (mmap) failed to map 427819008 bytes. Error detail: G1 virtual space
```
```log title="The system terminated the game due to lack of memory (macOS, Linux)"
// highlight-next-line
08:35:36,152 [MinecraftLauncher] Child process closed with exit code: 137 (0x89)
```
In these cases allocating more memory to the game will not help. What to do:
1. Check the amount of allocated RAM in the [launcher settings](../launcher/settings#minecraft): it must be less than the free memory in the system. Allocating less than 1 GiB makes no sense
2. Close other programs
3. Restart your computer - this frees memory and reduces its fragmentation
4. On Windows, check the paging file: press Win+R, type `sysdm.cpl`, go to the "Advanced" tab - "Performance" - "Settings" - "Advanced" - "Virtual memory" - "Change" and enable "Automatically manage paging file size for all drives"

:::warning[32-bit Java]
On 32-bit Java it is impossible to allocate more than 1 GiB of RAM to the game
:::

### Main class not found {#main-class-missing}
```log title="Log example"
// highlight-next-line
> Error: Could not find or load main class cpw.mods.bootstraplauncher.BootstrapLauncher
> Caused by: java.lang.ClassNotFoundException: cpw.mods.bootstraplauncher.BootstrapLauncher
```
If `main class` is followed by a class of the game itself or of a mod loader (`net.minecraft...`, `cpw.mods...`, `net.minecraftforge...`, `net.fabricmc...`), the version files are missing or corrupted. Reinstall the version using the "Force update" checkbox. If the error repeats, check your [antivirus](./common#av-software)

```log title="Log example"
// highlight-next-line
> Error: Could not find or load main class C:\Program Files\Java\jdk-17
> Caused by: java.lang.ClassNotFoundException: C:\Program Files\Java\jdk-17
```
If something unrelated is there instead - a path, a link or just a word - the "Java arguments" field in the launcher settings contains something extra, and Java took it for a class name. [Clear the "Java arguments" field](./common#check-args)

### System language settings {#system-locale}
With some system languages (e.g. Turkish or Arabic) the game and mods put foreign characters into names and then refuse to accept them themselves:
```log title="Log example"
// highlight-next-line
> net.minecraft.util.ResourceLocationException: Non [a-z0-9/._-] character in path of location: minecraft:dynamic/light_map_١
>   at net.minecraft.util.ResourceLocation.<init>(ResourceLocation.java:33) ~[?:?] {re:classloading}
```
```log title="Log example"
// highlight-next-line
> [19:28:11] [Server thread/ERROR] [ne.mi.ev.EventBus/EVENTBUS]: Exception caught during firing event: 'addition' is not a valid enum constant! Valid values are: 'addıtıon', 'multıply_base', 'multıply_total'
```
In the first example the digit `1` is replaced with the Arabic digit `١`, in the second the Latin `i` is replaced with the Turkish `ı`. The mods are not to blame here. Add the `-Duser.language=en` argument to the "Java arguments" field in the [launcher settings](../launcher/settings#minecraft) or switch the system language to English

### Non-Latin Windows user name {#non-latin-username}
Some mods and libraries extract their files to the temporary folder, which is located in the Windows user folder. If the user name is not written in Latin letters (e.g. in Cyrillic), Java may fail to load such a file:
```log title="Log example"
// highlight-next-line
> Exception in thread "main" java.lang.UnsatisfiedLinkError: Could not load library. Reasons: [no jansi in java.library.path, C:\Users\Пользователь\AppData\Local\Temp\jansi-64-7040785544641368972.dll: Can't find dependent libraries]
>   at org.fusesource.hawtjni.runtime.Library.doLoad(Library.java:182)
```
Reinstalling the game to another folder will not help: the problem is the user folder, not the game folder. What to do:
* Set a folder with a Latin path for temporary files: press Win+R, type `sysdm.cpl`, go to the "Advanced" tab - "Environment Variables" and change the `TEMP` and `TMP` user variables to a path of Latin letters (e.g. `C:\Temp`; create the folder beforehand)
* A more reliable way is to create a Windows user with a Latin name

### GLFW Input Devices Issue {#input-device-crash}
Some input devices, such as gamepads, joysticks and steering wheels may cause crashes.
```log title="Log example"
// highlight-next-line
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:105]:    Description : Invalid axis in gamepad mapping 03000000790000000600000000000000 (G-Shark GS-GP702)
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:106]:    Stacktrace  :
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: org.lwjgl.glfw.GLFW.glfwInit(GLFW.java:830)
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: net.minecraftforge.fml.loading.progress.ClientVisualization.initWindow(ClientVisualization.java:58)
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: net.minecraftforge.fml.loading.progress.ClientVisualization.start(ClientVisualization.java:335)
```
"Invalid axis in gamepad mapping" may indicate a gamepad issue. Disconnecting gamepads (joysticks, steering wheels) will fix it.

## OptiFine and rendering mods {#renderers}

### OptiFine - incompatible loader or game version {#optifine-incompatible-forge}
OptiFine is a rather finicky mod that requires specific Forge versions.
```log title="Log example"
> [11:43:13] [main/ERROR] [cp.mo.mo.TransformationServiceDecorator/MODLAUNCHER]: Service failed to load OptiFine
> cpw.mods.modlauncher.api.IncompatibleEnvironmentException: Error loading OptiFine ZIP file: union:/C:/Users/User/AppData/Roaming/.tlauncher/legacy/Minecraft/game/mods/OptiFine_1.21.1_HD_U_J1.jar%23159!/
>   at optifine.OptiFineTransformationService.onLoad(OptiFineTransformationService.java:122) ~[?:?] {}
// highlight-next-line
> [11:43:13] [main/ERROR] [cp.mo.mo.TransformationServicesHandler/MODLAUNCHER]: Found 1 services that failed to load : [OptiFine]
// highlight-next-line
> Exception in thread "main" cpw.mods.modlauncher.InvalidLauncherSetupException: Invalid Services found OptiFine
```
From the lines `services that failed to load: [OptiFine]` and `Invalid Services found OptiFine`, we can see that OptiFine cannot work in the current setup. Most often there is one of two reasons:
* OptiFine is launched on NeoForge - OptiFine does not work with NeoForge in any version. Remove OptiFine
* OptiFine is made for a different game version - check the version in the file name (e.g. `OptiFine_1.20.1_HD_U_I6.jar` will not work on 1.21.1). Install a matching OptiFine version or remove it

### OptiFine - incompatible Minecraft version {#optifine-version}
OptiFine is tightly bound to a specific game version. While many mods can survive minor updates (for example, mods for 1.19.1 may still work on 1.19.2), this doesn't apply to OptiFine.
If OptiFine detects an incompatible game version, the following lines will appear in the log:
```log title="Log example"
// highlight-next-line
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]: optifine.xdelta.PatchException: truncated source file, aborting
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]:  at optifine.xdelta.GDiffPatcher.copy(GDiffPatcher.java:181)
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]:  at optifine.xdelta.GDiffPatcher.runPatch(GDiffPatcher.java:130)
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]:  at optifine.xdelta.GDiffPatcher.<init>(GDiffPatcher.java:67)
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]:  at optifine.xdelta.GDiffPatcher.<init>(GDiffPatcher.java:63)
```
The key line here is `optifine.xdelta.PatchException`. If you see this in the log, check that the OptiFine version matches your game and Forge versions.

### OptiFine and VulkanMod - conflicts with other mods {#optifine-conflict}
OptiFine replaces game classes with its own copies, so many mods do not work with it.

#### Error in another mod {#optifine-nosuchmethod}
The error often occurs not in OptiFine itself, but in another mod:
```log title="Log example"
// highlight-next-line
> Caused by: java.lang.NoSuchMethodError: 'net.minecraft.resources.ResourceLocation net.minecraft.resources.ResourceLocation.fromNamespaceAndPath(java.lang.String, java.lang.String)'
>   at com.skniro.skniro_furniture.block.renderer.OvenBlockEntityRenderer.<clinit>(OvenBlockEntityRenderer.java:24) ~[SkniroFurniture-1.5.0-1.20.1-Forge.jar%23159!/:1.5.0-1.20.1-Forge] {re:classloading}
```
Here the `SkniroFurniture` mod crashes: it calls a game method (`net.minecraft...`) that is missing from the class copy modified by OptiFine. If OptiFine is installed and another mod crashes with `NoSuchMethodError` on a game method, OptiFine is most likely the culprit. Remove it

#### Dynamic Lights {#optifine-dynamic-lights}
Another common example is OptiFine together with the Dynamic Lights mod on 1.12.2:
```log title="Log example"
// highlight-next-line
> [15:44:50] [Client thread/INFO] [STDERR]: [net.optifine.reflect.ReflectorMethod:getTargetMethod:97]: java.lang.VerifyError: Inconsistent stackmap frames at branch target 47
> Exception Details:
>   Location:
>     net/minecraft/world/World.func_175638_a(Lnet/minecraft/util/math/BlockPos;Lnet/minecraft/world/EnumSkyBlock;)I @32: goto
>   Reason:
>     Current frame's stack size doesn't match stackmap.
```
Removing OptiFine or updating Dynamic Lights usually helps. OptiFine has its own dynamic lighting (the `Dynamic Lights` option in the video settings), so the separate mod is not needed with it

#### Sodium and VulkanMod {#sodium-vulkanmod}
OptiFine is also incompatible with Sodium and mods based on it (Embeddium, Rubidium, Oculus and similar). See [Removing OptiFine](./common#remove-optifine) for details

:::warning[VulkanMod]
VulkanMod deeply modifies the rendering engine and is incompatible with a huge number of mods. In case of a crash, check whether the game starts without VulkanMod
:::

## Mods {#mods}

### Mods for another loader {#wrong-loader}
Mods for Fabric/Quilt and Forge/NeoForge are not compatible with each other. Most often the loader silently skips a foreign mod, and the game crashes later - for example, because of a "missing" mod. Sometimes the loader refuses to start right away.

:::note[Exceptions]
* Quilt runs Fabric mods, but Fabric does not run Quilt mods
* NeoForge runs Forge mods only on 1.20.1
* The [Sinytra Connector](https://modrinth.com/mod/connector) mod allows running Fabric mods on Forge and NeoForge
:::

#### How to check {#check-mod-loader}
After a crash, the launcher writes the list of mods from the `mods` folder to the log, together with the loader each mod is made for:
```log title="Log example"
[:] D:\Minecraft\game\mods
├ aaa-particles-fabric-1.20.1-1.4.12.jar [4952 KiB]
│ ├ md5 = 490f45c52192f63371599f4a07d27908
// highlight-next-line
│ └ aaa_particles [Fabric mod]
│   ├ version = "1.20.1-1.4.12"
```
The `[Fabric mod]`, `[Forge mod]` and `[NeoForge mod]` labels must match the running loader.
* If there are a few foreign mods, replace them with versions for your loader or remove them
* If almost all mods are foreign, the modpack is made for another loader. Select a version with the right loader in the launcher

#### Intentional crash {#wrong-loader-stub}
Some mods intentionally crash the game when launched on the wrong loader:
```log title="Log example"
> Caused by: java.lang.UnsupportedOperationException:
> ######################## - USER ERROR - ######################
// highlight-next-line
> User Attempting to load JourneyMap for Forge in Fabric Loader.
> Please Download the Fabric version of JourneyMap.
```

#### Missing metadata {#wrong-loader-metadata}
Mods for another loader may lack the metadata the loader needs - then the loader crashes at the very beginning of mod loading:
```log title="Log example"
// highlight-next-line
> Exception in thread "main" net.minecraftforge.forgespi.locating.ModFileLoadingException: Mod candidate despawntweaks-fabric-1.0.0-1.20.1.jar contains a corrupt or misconfigured toml.
>   at MC-BOOTSTRAP/fmlloader@1.20.1-47.4.21/net.minecraftforge.fml.loading.moddiscovery.ModFileParser.modsTomlParser(ModFileParser.java:52)
```
Here a Fabric mod (`despawntweaks-fabric`) is launched on Forge

### Extra files in the mods folder {#mods-folder}
Mod loaders read only mod jar files located directly in the `mods` folder. You can see what this folder contains in the mod list the launcher writes to the log after a crash (see [Mods for another loader](#wrong-loader)).

#### Subfolders {#mods-subfolders}
Mods from subfolders (marked as `[dir]` in the list) are not loaded:
```log title="Log example"
// highlight-next-line
├ assets [dir]
│ ├ appleskin-fabric-mc1.21.11-3.0.8.jar [175 KiB]
│ │ ├ md5 = e725606e8b0ae1c83ade7cfd0aea9e73
│ │ └ appleskin [Fabric mod]
```
Here the `appleskin` mod is located in the `mods/assets` folder and will not be loaded. Move it to the `mods` folder itself. The exception is the `mods/<game version>` folder (e.g. `mods/1.12.2`), which worked up to 1.12.2 inclusive. Service folders created by mods themselves (e.g. `.connector` or `.index`) should be left alone

#### Extracted mods {#extracted-mods}
Do not extract a mod jar file unless the mod's installation instructions explicitly say so. Many loaders intentionally crash the game when they see an extracted mod:
```log title="Log example"
// highlight-next-line
> [11:14:04] [main/FATAL]: There appear to be jars extracted into the mods directory. This is VERY BAD and will almost NEVER WORK WELL
> [11:14:04] [main/FATAL]: You should place original jars only in the mods directory. NEVER extract them to the mods directory.
> [11:14:04] [main/FATAL]: The directories below appear to be extracted jar files. Fix this before you continue.
> [11:14:04] [main/FATAL]: Directory Keystrokes-8.1.2 (1.8.9) contains [MANIFEST.MF]
```
Delete the folder with the extracted mod and download the mod again ([more details](../mods/installation#extracted))

#### Installers {#loader-installers}
Do not put mod loader installers or the loaders themselves into the `mods` folder (`fabric-installer`, `fabric-loader`, `forge-...-installer` and similar), as well as mod installers (e.g. Iris Installer). An installer must be run, not copied to `mods` - see the installation guides for [Forge](../mods/forge), [NeoForge](../mods/neoforge), [Fabric](../mods/fabric) and [Quilt](../mods/quilt):
```log title="Log example"
// highlight-next-line
> [17:59:26] [ForkJoinPool.commonPool-worker-9/WARN] [ne.ne.fm.lo.mo.ModDiscoverer/SCAN]: Skipping jar. File mods/Iris-Installer-3.3.0.jar is a Fabric mod and cannot be loaded
```

#### Files that are not mods {#not-mods}
Shortcuts (`.lnk`), archives with mods inside (`.rar`, `.7z`, [more details](../mods/installation#archive)) and Bedrock Edition add-ons (`.mcaddon`, `.mcpack`) are not mods. Legacy Launcher does not support Bedrock Edition

### Forge/NeoForge - mod error {#forge-mod-error}
If the game crashes because of an error in one of the mods, the culprit can usually be found from the crash text. Below are three ways to do it.

#### The `Caused by` line {#caused-by}
There should be a crash at the end of the log. It looks like a series of lines starting with `at`:
```log title="Log example"
> Exception in thread "main" [00:23:02] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1069]: java.lang.RuntimeException: java.lang.reflect.InvocationTargetException
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1069]:     at cpw.mods.modlauncher.LaunchServiceHandlerDecorator.launch(LaunchServiceHandlerDecorator.java:39)
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1078]:     ... 4 more
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]: Caused by: org.spongepowered.asm.mixin.transformer.throwables.MixinTransformerError: An unexpected critical error was encountered
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]:  at org.spongepowered.asm.mixin.transformer.MixinProcessor.applyMixins(MixinProcessor.java:392)
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]:  at org.spongepowered.asm.mixin.transformer.MixinTransformer.transformClass(MixinTransformer.java:250)
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]:  at org.spongepowered.asm.service.modlauncher.MixinTransformationHandler.processClass(MixinTransformationHandler.java:131)
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]:  ... 10 more
// highlight-next-line
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:682]: Caused by: org.spongepowered.asm.mixin.injection.throwables.InjectionError: Critical injection failure: Redirector redirectGetFancyWeather()Z in magnesium.mixins.json:features.options.MixinWorldRenderer failed injection check, (0/1) succeeded. Scanned 1 target(s). Using refmap magnesium.refmap.json
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:682]:  at org.spongepowered.asm.mixin.injection.struct.InjectionInfo.postInject(InjectionInfo.java:468)
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:682]:  at org.spongepowered.asm.mixin.transformer.MixinTargetContext.applyInjections(MixinTargetContext.java:1362)
> [00:23:02] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:682]:  ... 25 more
```
Look at the line starting with `Caused by`: we can see that the problem is with the `magnesium` mod: `Critical injection failure: Redirector redirectGetFancyWeather()Z in magnesium.mixins.json:features.options.MixinWorldRenderer failed injection check`.  
The culprit is the mod that owns the `*.mixins.json` file from this line (here it is `magnesium.mixins.json`). Most likely, it is made for a different game version - install the version of the mod for your game version or remove it.  
If one mod extends another (e.g. Iris and Sodium, an addon and its base mod), their versions must match each other - update them together.  

#### The `at` lines {#at-lines}
Sometimes the problematic mod will appear not in the `Caused by` line itself, but in one of the `at` lines below:
```log title="Log example"
[:] java.lang.RuntimeException: null
[:]     at net.minecraftforge.registries.GameData.postRegisterEvents(GameData.java:320) ~[forge-1.20.2-48.1.0-universal.jar%23185!/:?] {re:classloading}
[:]     Suppressed: net.minecraftforge.fml.ModLoadingException: Age of Weapons - Reforged (ageofweapons) encountered an error during the common_setup event phase
[:] §7java.lang.NoClassDefFoundError: net/minecraftforge/network/PlayMessages$SpawnEntity
[:]         at net.minecraftforge.fml.javafmlmod.FMLModContainer.acceptEvent(FMLModContainer.java:118) ~[javafmllanguage-1.20.2-48.1.0.jar%23182!/:?] {}
[:]     Caused by: java.lang.NoClassDefFoundError: net/minecraftforge/network/PlayMessages$SpawnEntity
// highlight-next-line
[:]         at xxrexraptorxx.ageofweapons.registry.ModEntities.lambda$static$1(ModEntities.java:25) ~[ageofweapons-reforged-1.20.x-v.1.3.2.jar%23166!/:1.3.2] {re:classloading}
[:]         at net.minecraftforge.registries.DeferredRegister$EventDispatcher.lambda$handleEvent$0(DeferredRegister.java:366) ~[forge-1.20.2-48.1.0-universal.jar%23185!/:?] {re:classloading,pl:eventbus:A}
[:]     Caused by: java.lang.ClassNotFoundException: net.minecraftforge.network.PlayMessages$SpawnEntity
[:]         at net.minecraftforge.securemodules.SecureModuleClassLoader.loadClass(SecureModuleClassLoader.java:397) ~[securemodules-2.2.3.jar:?] {}
[:]         at java.lang.ClassLoader.loadClass(ClassLoader.java:525) ~[?:?] {}
// highlight-next-line
[:]         at xxrexraptorxx.ageofweapons.registry.ModEntities.lambda$static$1(ModEntities.java:25) ~[ageofweapons-reforged-1.20.x-v.1.3.2.jar%23166!/:1.3.2] {re:classloading}
[:]         at net.minecraftforge.registries.DeferredRegister$EventDispatcher.lambda$handleEvent$0(DeferredRegister.java:366) ~[forge-1.20.2-48.1.0-universal.jar%23185!/:?] {re:classloading,pl:eventbus:A}

```
In this example, the error occurs in the `ageofweapons` mod, which probably doesn't support the Forge version in use - it can't find (`ClassNotFoundException`) the Minecraft Forge component (`net.minecraftforge.network.PlayMessages$SpawnEntity`)
:::warning[Mixin errors]
This does not work for mixin errors (the error text contains `mixin`): the `at` lines point to the affected mod, not the culprit. Look for the culprit by the `*.mixins.json` file name
:::

#### Old Forge mod table {#old-forge-mod-table}
Older versions of Forge generated a table with a mods list:
```log title="Log example"
[:]     | State | ID             | Version      | Source                                    | Signature                                |
[:]     |:----- |:-------------- |:------------ |:----------------------------------------- |:---------------------------------------- |
[:]     | LCH   | minecraft      | 1.12.2       | minecraft.jar                             | None                                     |
[:]     | LCH   | mcp            | 9.42         | minecraft.jar                             | None                                     |
[:]     | LCH   | FML            | 8.0.99.99    | forge-1.12.2-14.23.5.2860.jar             | e3c3d50c7c986df74c645c0ac54639741c90a557 |
[:]     | LCH   | forge          | 14.23.5.2860 | forge-1.12.2-14.23.5.2860.jar             | e3c3d50c7c986df74c645c0ac54639741c90a557 |
// highlight-next-line
[:]     | LCE   | xujmod         | 2.0.8        | xujmod-2.0.8.jar                          | None                                     |
```
The presence of the letter `E` in the "State" column signals an error in the mod. For example, in this example `xujmod` is broken. After removing the broken mods, the game will work.

### Forge/NeoForge - missing mod (dependency) {#forge-mod-dep}
Many mods need other mods - libraries - to work. If a required mod is missing or its version does not fit, the game will not start. Forge and NeoForge report this in two ways.

#### NoClassDefFoundError {#noclassdeffound}
```log title="Log example"
[:] net.minecraftforge.fml.common.LoaderExceptionModCrash: Caught exception from XujMod (xujmod)
// highlight-next-line
[:] Caused by: java.lang.NoClassDefFoundError: blusunrize/immersiveengineering/common/items/ItemIEBase
[:]     at net.lasernet.xuj.ModItems.init(ModItems.java:55)
[:]     at net.lasernet.xuj.XujMod.preInit(XujMod.java:60)
```
The `NoClassDefFoundError` error usually signals a missing mod. From this line we can see that the `immersiveengineering` mod is missing. After installing all required mods the game will work.

However, `NoClassDefFoundError` does not always mean a missing mod. Look at how the class name from the error starts (some errors use dots instead of `/`):
* `net/minecraft`, `net/minecraftforge`, `net/neoforged`, `net/fabricmc` - this is a class of the game itself or of the mod loader. There is nothing to install: the mod from the error is made for a different game or loader version
* `kotlin/` - install Kotlin for Forge (for Forge and NeoForge) or Fabric Language Kotlin (for Fabric and Quilt)
* `javafx/` - the mod cannot work on the Java the game runs on. Remove it
* `org/lwjgl`, `io/netty`, `com/google/common` - these are libraries of the game itself. Use the "Force update" checkbox

If the required mod is already installed, update it: the installed version does not have the required class.  
If it is unclear which mod is required, search [Modrinth](https://modrinth.com/mods) for a part of the class name. For example, for `blusunrize/immersiveengineering/...` search for `immersiveengineering`

#### Missing dependencies {#missing-dependencies}
```log title="Log example"
> [17:01:14] [main/ERROR] [ne.mi.fm.lo.ModSorter/LOADING]: Missing or unsupported mandatory dependencies:
// highlight-next-line
>   Mod ID: 'valhelsia_core', Requested by: 'valhelsia_structures', Expected range: '[1.1.1,)', Actual version: '[MISSING]'
```
:::tip[Such lines appear **at the beginning** of the log]
:::
This line shows that the `valhelsia_structures` mod needs `valhelsia_core` mod version `1.1.1` or newer, which is not installed now (`MISSING`). After installing all required mods of **required versions** the game will start.

### Forge/NeoForge - invalid mod name {#forge-invalid-name}
After switching the game to Java 17 Forge may crash due to incorrect names of mods. Do not give mods names containing non-Latin characters.
```log title="Log example"
// highlight-next-line
> Exception in thread "main" java.lang.IllegalArgumentException: 1.0-1.18+: Empty pre-release
>   at java.base/java.lang.module.ModuleDescriptor$Version.<init>(ModuleDescriptor.java:1054)
>   at java.base/java.lang.module.ModuleDescriptor$Version.parse(ModuleDescriptor.java:1090)
```
By the line `1.0-1.18+: Empty pre-release` we can see that Forge cannot understand the line `1.0-1.18+` of some mod. Looking in the mods folder, we find the file `lazydfu-1.0-1.18+`. After renaming the mod, for example, to `lazydfu-1.0`, or uninstalling it the game will work.

In newer versions of the game, there is another case:
```log title="Log example"
> Exception in thread "main" java.lang.IllegalArgumentException: multi-piston: Invalid module name: 'multi-piston' is not a Java identifier
>   at java.base/jdk.internal.module.Checks.requireModuleName(Checks.java:59)
```
The `IllegalArgumentException` with the comment `Invalid module name` indicates an invalid module name for the mod. This usually points to one of two things: either the mod is broken, or the mod is being loaded with the wrong version of the game. There's also a chance the issue lies in the mod's filename. Try renaming the mod (for this example - from `multi-piston` to `multipiston`) or remove it
:::warning
We strongly advise against renaming mod files using non-Latin characters! Some Forge versions will assign empty module names to such mods, causing them to break. It is best to keep the original mod file name
:::

### Forge/NeoForge - module conflict {#module-conflict}
Since 1.17, Forge and NeoForge load every mod as a separate Java module, and two modules cannot contain the same package. In this case the game crashes with a `java.lang.module.ResolutionException` error. The order of modules in the message says nothing about the culprit - check which of the named modules are mods you installed.

#### A mod carries someone else's code {#bundled-code}
```log title="Log example"
// highlight-next-line
> Exception in thread "main" java.lang.module.ResolutionException: Module voicechat.forge contains package org.spongepowered.asm.util.perf, module org.spongepowered.mixin exports package org.spongepowered.asm.util.perf to voicechat.forge
>   at java.base/java.lang.module.Resolver.resolveFail(Resolver.java:901)
```
Here the Simple Voice Chat mod (`voicechat`) contains its own copy of Mixin, which the game already has. Download the version of the mod for your game and loader versions or remove the mod

#### The same code in two files {#same-code-twice}
```log title="Log example"
// highlight-next-line
> Exception in thread "main" java.lang.module.ResolutionException: Module optifine contains package srg.net.optifine.entity.model.anim, module OptiFine.OptiFine.HD.U.G8.pre2 exports package srg.net.optifine.entity.model.anim to optifine
>   at java.base/java.lang.module.Resolver.resolveFail(Resolver.java:901)
```
Here OptiFine is installed twice: as a version with OptiFine and as a separate file in the `mods` folder. Keep only one copy

#### Two files of the game itself {#two-game-jars}
```log title="Log example"
// highlight-next-line
> Exception in thread "main" java.lang.module.ResolutionException: Modules minecraft and client export package net.minecraft.world.level.levelgen.feature.stateproviders to module mclib
>   at java.base/java.lang.module.Resolver.resolveFail(Resolver.java:901)
```
If the named modules include no mods you installed, but `minecraft` and `client` instead, the installed version has two game files. Reinstall the version using the "Force update" checkbox

### Forge/NeoForge - duplicated mods {#forge-duplicates}
If the same mod is in the `mods` folder twice (e.g. two of its versions), the game will not start. What it looks like in the log depends on the Forge version.

#### Duplicate interface name error {#duplicate-interface}
```log title="Log example"
> Exception in thread "main" [16:41:20] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1069]: java.lang.RuntimeException: java.lang.reflect.InvocationTargetException
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1069]:     at cpw.mods.modlauncher.LaunchServiceHandlerDecorator.launch(LaunchServiceHandlerDecorator.java:39)
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1078]: Caused by: java.lang.reflect.InvocationTargetException
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1078]:     at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
// highlight-next-line
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]: Caused by: java.lang.ClassFormatError: Duplicate interface name "xaero/common/minimap/mcworld/IXaeroMinimapClientWorld" in class file net/minecraft/client/world/ClientWorld
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]:  at java.base/java.lang.ClassLoader.defineClass1(Native Method)
```
The `java.lang.ClassFormatError: Duplicate interface name ... in class file ...` signals us that a mod has been installed twice. After removing the duplicate (the name of the mod usually can be found from the error text, for the example above it is `XaeroMinimap`) the game will start.

#### Old Forge versions {#duplicates-old-forge}
On old Forge versions a duplicate looks like this - the line lists both mod files:
```log title="Log example"
// highlight-next-line
> [10:58:25] [Client thread/FATAL] [FML]: Found a duplicate mod grapplemod at [D:\Games\Minecraft\files\mods\grapplemod_1.11.2_v10.jar, D:\Games\Minecraft\files\mods\Grappling-Hook-Mod-v13-for-1.12.2.jar]
> [10:58:25] [Client thread/ERROR] [FML]: An exception was thrown, the game will display an error screen and halt.
> net.minecraftforge.fml.common.DuplicateModsFoundException
```
Here the mods folder contains two versions of the same mod - for 1.11.2 and for 1.12.2. Remove the one that does not match your game version.

#### New Forge versions {#duplicates-new-forge}
On newer Forge versions this is reported by the `Found duplicate mods` line, followed by the `Mod ID: '...' from mod files: ...` line with both files:
```log title="Log example"
> [20:50:17] [main/ERROR] [ne.mi.fm.lo.UniqueModListBuilder/LOADING]: Found duplicate mods:
// highlight-next-line
>   Mod ID: 'rubidium' from mod files: rubidium-mc1.20.1-0.7.1.jar, embeddium-0.3.31mc1.20.1.jar
> [20:50:17] [main/ERROR] [ne.mi.fm.lo.mo.ModDiscoverer/SCAN]: Failed to build unique mod list after mod discovery.
> net.minecraftforge.fml.loading.EarlyLoadingException: Duplicate mods found
```
This error occurs before mods are loaded, so there will be no mod list in the log.
* If the line lists two versions of the same mod, remove the older one
* If these are two different mods, they do the same job. In the example above Embeddium replaces Rubidium and therefore calls itself `rubidium`, and REI Plugin Compatibilities replaces JEI the same way. Keep only one of them

### Fabric - broken mod {#fabric-broken-mod}
Fabric does not always name the mod that crashed the game directly. Below are three typical cases and how to find the culprit in them.

#### Error when starting a mod {#entrypoint-error}
```log title="Log example"
// highlight-next-line
> java.lang.RuntimeException: Could not execute entrypoint stage 'main' due to errors, provided by 'bosses_of_mass_destruction'!
>   at net.fabricmc.loader.impl.FabricLoaderImpl.lambda$invokeEntrypoints$2(FabricLoaderImpl.java:388)
>   Suppressed: java.lang.NoClassDefFoundError: Could not initialize class net.barribob.maelstrom.MaelstromMod
>       at net.barribob.maelstrom.MaelstromModKt.init(MaelstromMod.kt:46)

```
In this log we can see that the `bosses_of_mass_destruction` mod prevented the game from launching, which in turn was prevented by an error in the `Maelstrom` mod. After replacing the `Maelstrom` mod or removing the `bosses_of_mass_destruction` mod, the error will most likely disappear.

#### Mixin error {#fabric-mixin-error}
```log title="Log example"
> java.lang.RuntimeException: Mixin transformation of net.minecraft.class_372 failed
>   at net.fabricmc.loader.impl.launch.knot.KnotClassDelegate.getPostMixinClassByteArray(KnotClassDelegate.java:427)
> Caused by: org.spongepowered.asm.mixin.transformer.throwables.MixinTransformerError: An unexpected critical error was encountered
>   at org.spongepowered.asm.mixin.transformer.MixinProcessor.applyMixins(MixinProcessor.java:392)
// highlight-next-line
> Caused by: org.spongepowered.asm.mixin.throwables.MixinApplyError: Mixin [sodium-extra.mixins.json:toasts.MixinTutorialToast from mod sodium-extra] from phase [DEFAULT] in config [sodium-extra.mixins.json] FAILED during APPLY
>   at org.spongepowered.asm.mixin.transformer.MixinProcessor.handleMixinError(MixinProcessor.java:638)
// highlight-next-line
> Caused by: org.spongepowered.asm.mixin.injection.throwables.InvalidInjectionException: Invalid descriptor on sodium-extra.mixins.json:toasts.MixinTutorialToast from mod sodium-extra->@Inject::draw(Lnet/minecraft/class_4587;Lnet/minecraft/class_374;JLorg/spongepowered/asm/mixin/injection/callback/CallbackInfoReturnable;)V! Expected (Lnet/minecraft/class_332;Lnet/minecraft/class_374;JLorg/spongepowered/asm/mixin/injection/callback/CallbackInfoReturnable;)V but found (Lnet/minecraft/class_4587;Lnet/minecraft/class_374;JLorg/spongepowered/asm/mixin/injection/callback/CallbackInfoReturnable;)V [INJECT Applicator Phase -> sodium-extra.mixins.json:toasts.MixinTutorialToast from mod sodium-extra -> Apply Injections ->  -> Inject -> sodium-extra.mixins.json:toasts.MixinTutorialToast from mod sodium-extra->@Inject::draw(Lnet/minecraft/class_4587;Lnet/minecraft/class_374;JLorg/spongepowered/asm/mixin/injection/callback/CallbackInfoReturnable;)V]
>   at org.spongepowered.asm.mixin.injection.callback.CallbackInjector.inject(CallbackInjector.java:567)
```
This time Fabric can't explicitly point us to the problematic mod, but we can recognize it from the error cause message (`Caused by:`): `Caused by: org.spongepowered.asm.mixin.throwables.MixinApplyError: Mixin [sodium-extra.mixins.json:toasts.MixinTutorialToast from mod sodium-extra]`.  
We can see that the problem is the `sodium-extra` mod (it owns `sodium-extra.mixins.json`). Most likely, it is made for a different game version - install the version of the mod for your game version or remove it.

#### Error during gameplay {#fabric-runtime-error}
```log title="Log example"
[:] java.lang.NoSuchFieldError: stateTicks
// highlight-next-line
[:]     at com.github.mim1q.minecells.entity.ProtectorEntity.<init>(ProtectorEntity.java:31)
[:]     at net.minecraft.class_1299.method_5883(class_1299.java:544)
```
This time the error occurred during the game, and Fabric is again unable to detect the problematic mod. But we are lucky - if we read the `at` lines, we can see that the failure occurred when the `minecells` mod was running and removing it will most likely solve the issue.

### Fabric - mod dependencies {#fabric-mod-dep}
Fabric mods often require other mods or specific Fabric Loader versions. Usually Fabric checks this before launch and reports what is missing itself - but not always.

#### Unsuitable versions {#fabric-version-ranges}
```log title="Log example"
> net.fabricmc.loader.impl.FormattedException: Some of your mods are incompatible with the game or each other!
> A potential solution has been determined, this may resolve your problem:
// highlight-next-line
>    - Replace mod 'Fabric Loader' (fabricloader) 0.15.7 with any version between 0.14.25 (inclusive) and 0.15- (exclusive).
> More details:
// highlight-next-line
>    - Mod 'GoProne' (goprone) 3.1.3 requires any version between 0.14.21 (inclusive) and 0.15- (exclusive) of mod 'Fabric Loader' (fabricloader), but only the wrong version is present: 0.15.7!
>   at net.fabricmc.loader.impl.FormattedException.ofLocalized(FormattedException.java:51) ~[fabric-loader-0.15.7.jar:?]
```
You must install mods that meet the requirements of the installed mods.  
For example, in this case a mod requires a version of Fabric Loader `0.14.25 or newer`, but `older than 0.15`, making it unsuitable for the version `0.15.7` you are using. Updating the mod or installing the required version of `fabric-loader` will fix this problem.

#### Indium {#indium}
On Sodium before 0.6.0, mods using the Fabric Rendering API crash if the [Indium](https://modrinth.com/mod/indium) mod is not installed:
```log title="Log example"
// highlight-next-line
> Caused by: java.lang.NullPointerException: Cannot invoke "net.fabricmc.fabric.api.renderer.v1.Renderer.meshBuilder()" because the return value of "net.fabricmc.fabric.api.renderer.v1.RendererAccess.getRenderer()" is null
>   at me.pepperbell.continuity.impl.client.ProcessingContextImpl.<init>(ProcessingContextImpl.java:20) ~[continuity-3.0.0+1.19.4.jar:?]
```
The key line is `RendererAccess.getRenderer()` in the `NullPointerException` text. Install Indium, there is no need to remove the crashed mod (`continuity` here).
:::note
Since Sodium 0.6.0 Indium is not needed, and this error is no longer relevant
:::

## Corrupted files {#corrupted-files}

### Mod corruption {#corruption-mod}
Files of mods and of the game itself may get corrupted or go missing - due to an interrupted download, an antivirus or disk problems.

#### Corrupted file {#corrupted-file}
```log title="Log example"
Exception in thread "main" cpw.mods.niofs.union.UnionFileSystem$UncheckedIOException: java.util.zip.ZipException: zip END header not found
// highlight-next-line
Caused by: java.util.zip.ZipException: zip END header not found
    at jdk.zipfs/jdk.nio.zipfs.ZipFileSystem.findEND(ZipFileSystem.java:1315)

```
The `java.util.zip.ZipException: zip END header not found` error in the log signals that the game files and/or mods are corrupted. Use the "Force update" checkbox, re-download mods from CurseForge/Modrinth.  
If the files turn out to be corrupted again after downloading, check your disk for errors.
:::tip[Fabric and Quilt specifics]
Fabric and Quilt store some data in the `.fabric` and `.cache` folders in the game folder. If the error points to a file from these folders, delete the folder - the loader will recreate it. Re-downloading such a file is useless
:::

#### Missing file {#missing-file}
Sometimes the required file is missing entirely - most often it was deleted by an antivirus or the download was interrupted:
```log title="Log example"
// highlight-next-line
> Exception in thread "main" java.lang.module.FindException: Module org.apache.logging.log4j not found, required by cpw.mods.modlauncher
>   at java.base/java.lang.module.Resolver.findFail(Resolver.java:893)
```
```log title="Log example"
15:46:36,709 [MinecraftLauncher] Caught an exception
// highlight-next-line
net.legacylauncher.minecraft.launcher.MinecraftException: Classpath is not found: D:\Minecraft\Minecraft\game\libraries\at\yawk\lz4\lz4-java\1.8.1\lz4-java-1.8.1.jar
    at net.legacylauncher.minecraft.launcher.MinecraftLauncher.constructClassPath(MinecraftLauncher.java:1484)
```
Use the "Force update" checkbox. If the files disappear again, check your [antivirus](./common#av-software).

### Config files corruption {#corruption-config}
```log title="Log example"
// highlight-next-line
> net.minecraftforge.fml.config.ConfigFileTypeHandler$ConfigLoadingException: Failed loading config file flywheel-client.toml of type CLIENT for modid flywheel
>   at net.minecraftforge.fml.config.ConfigFileTypeHandler.lambda$reader$1(ConfigFileTypeHandler.java:47) ~[forge:?] {re:classloading}
>   at net.minecraftforge.fml.config.ConfigTracker.openConfig(ConfigTracker.java:90) ~[forge:?] {re:classloading}
// highlight-next-line
> Caused by: com.electronwill.nightconfig.core.io.ParsingException: Not enough data available
>   at com.electronwill.nightconfig.core.io.ParsingException.notEnoughData(ParsingException.java:22) ~[core-3.6.3.jar:?] {}
```
Such errors are usually recognized by the presence of the word "config" or "settings" in the error. In this example you can see that the `flywheel-client.toml` config file of the `flywheel` mod is broken.  
Such problems are solved very simply - by deleting the corresponding file from the `config` folder in the game folder, or by deleting the entire `config` folder - the mods will recreate their settings files.  
If you have the original `config` folder (e.g. in the modpack archive), it is better to replace the current one with it.  
Some mods keep part of their settings in the world folder: if the file is not in the `config` folder, look for it in `saves/<world name>/serverconfig`.