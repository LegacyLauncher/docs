---
description: How to solve launch issues yourself
sidebar_position: 3
---
# Solving issues yourself

Got a crash?
You can try to find the cause yourself.
Just press "Open Logs" button in error window or enable "Logger" in the launcher settings.  
Following is a list of relatively simple to detect and common game launch issues.  
**All examples below are based on real support requests from our users**.

## Wrong Java version {#wrong-java}
Detected by `java.lang.UnsupportedClassVersionError` in `caused by` string.
```log title="Log example"
> Exception in thread "main" java.util.ServiceConfigurationError: net.minecraftforge.forgespi.language.IModLanguageProvider: Unable to load thedarkcolour.kotlinforforge.KotlinLanguageProvider
>   at java.base/java.util.ServiceLoader.fail(ServiceLoader.java:586)
// highlight-next-line
> Caused by: java.lang.UnsupportedClassVersionError: thedarkcolour/kotlinforforge/KotlinLanguageProvider has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
>   at java.base/java.lang.ClassLoader.defineClass1(Native Method)
```
In this example, it is clear that the mod `kotlinforforge` failed to load because it is being run on an outdated version of Java. The required Java version can be determined by the `class file version`, using [this website](https://javaalmanac.io/bytecode/versions/). In this example, the game was launched with Java 17 (61.0), but the mod requires Java 21 (65.0).

```log title="Log example"
> Error: LinkageError occurred while loading main class net.minecraft.client.main.Main
// highlight-next-line
>   java.lang.UnsupportedClassVersionError: net/minecraft/client/main/Main has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
```
This same error is typical when launching the game itself with an incompatible (too old) version of Java. This error can also be identified by the keyword `UnsupportedClassVersionError`.

Older versions of the game use the so-called `launchwrapper`, which does not work with Java 9 or newer. Such versions will crash with the following log when launched on newer Java versions:
```log title="Log example"
// highlight-next-line
> Exception in thread "main" java.lang.ClassCastException: class jdk.internal.loader.ClassLoaders$AppClassLoader cannot be cast to class java.net.URLClassLoader (jdk.internal.loader.ClassLoaders$AppClassLoader and java.net.URLClassLoader are in module java.base of loader 'bootstrap')
>   at net.minecraft.launchwrapper.Launch.<init>(Launch.java:33)
>   at net.minecraft.launchwrapper.Launch.main(Launch.java:27)

```
The solution is to run the game using Java 8 (often selecting the "recommended" Java version will help).

## Java VM Crash {#jvm-crash}
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
Unfortunately, these errors are often non-trivial to fix, and even we might not be able to help. Try Googling, or contact the support of the component's manufacturer (e.g., the graphics driver).
:::danger
Never attempt to manually delete or replace the problematic dll file! You could make the problem worse or break your OS!
:::
:::tip
You can _try_ to resolve this issue using [this guide](./win-problems#replace-java)
:::

## GLFW Input Devices Issue {#input-device-crash}
Some input devices, such as gamepads, joysticks and steering wheels may cause crashes.
```log title="Log example"
// highlight-next-line
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:105]:    Description : Invalid axis in gamepad mapping 03000000790000000600000000000000 (G-Shark GS-GP702)
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:106]:    Stacktrace  :
>       [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: org.lwjgl.glfw.GLFW.glfwInit(GLFW.java:830)
>       [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: net.minecraftforge.fml.loading.progress.ClientVisualization.initWindow(ClientVisualization.java:58)
>       [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: net.minecraftforge.fml.loading.progress.ClientVisualization.start(ClientVisualization.java:335)
```
"Invalid axis in gamepad mapping" may indicate a gamepad issue. Disconnecting gamepads (joysticks, steering wheels) will fix it.

## OptiFine - incompatible Forge version {#optifine-incompatible-forge}
OptiFine is a rather finicky mod that requires specific Forge versions.
```log title="Log example"
> [11:43:13] [main/ERROR] [cp.mo.mo.TransformationServiceDecorator/MODLAUNCHER]: Service failed to load OptiFine
> cpw.mods.modlauncher.api.IncompatibleEnvironmentException: Error loading OptiFine ZIP file: union:/C:/Users/Makc/AppData/Roaming/.tlauncher/legacy/Minecraft/game/mods/OptiFine_1.21.1_HD_U_J1.jar%23159!/
>   at optifine.OptiFineTransformationService.onLoad(OptiFineTransformationService.java:122) ~[?:?] {}
// highlight-next-line
> [11:43:13] [main/ERROR] [cp.mo.mo.TransformationServicesHandler/MODLAUNCHER]: Found 1 services that failed to load : [OptiFine]
// highlight-next-line
> Exception in thread "main" cpw.mods.modlauncher.InvalidLauncherSetupException: Invalid Services found OptiFine
```
From the lines `services that failed to load: [OptiFine]` and `Invalid Services found OptiFine`, we can see that the current versions of OptiFine and Forge are incompatible.

## OptiFine - incompatible Minecraft version {#optifine-version}
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
The key line here is `optifine.xdelta.PatchException`. If you see this in the log, check the OptiFine version.

## Forge - mod error {#forge-mod-error}
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
Most likely, this mod is the cause of the error. Uninstalling the mod will help to start the game.  

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

## Forge - missing mod (dependency) {#forge-mod-dep}
```log title="Log example"
[:] net.minecraftforge.fml.common.LoaderExceptionModCrash: Caught exception from XujMod (xujmod)
// highlight-next-line
[:] Caused by: java.lang.NoClassDefFoundError: blusunrize/immersiveengineering/common/items/ItemIEBase
[:]     at net.lasernet.xuj.ModItems.init(ModItems.java:55)
[:]     at net.lasernet.xuj.XujMod.preInit(XujMod.java:60)
```
The `NoClassDefFoundError` error usually signals a missing mod. From this line we can see that the `immersiveengineering` mod is missing. After installing all required mods the game will work.
```log title="Log example"
> [17:01:14] [main/ERROR] [ne.mi.fm.lo.ModSorter/LOADING]: Missing or unsupported mandatory dependencies:
// highlight-next-line
>   Mod ID: 'valhelsia_core', Requested by: 'valhelsia_structures', Expected range: '[1.1.1,)', Actual version: '[MISSING]'
```
:::tip[Such lines appear **at the beginning** of the log]
:::
This line shows that the `valhelsia_structures` mod needs `valhelsia_core` mod version `1.1.1` or newer, which is not installed now (`MISSING`). After installing all required mods of **required versions** the game will start.

## Forge - invalid mod name {#forge-invalid-name}
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
The `IllegalArgumentException` with the comment `Invalid module name` indicates an invalid module name for the mod. This usually points to one of two things: either the mod is broken, or the mod is being loaded with the wrong version of the game. There's also a chance the issue lies in the mod's filename - in this case, you could try renaming the mod (for this example - from `multi-piston` to `multipiston`)
:::warning
Do not rename mods using non-Latin characters! Some Forge versions will assign empty module names to such mods, causing them to break!
:::

## Forge - duplicated mods {#forge-duplicates}
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

## Fabric - broken mod {#fabric-broken-mod}
```log title="Log example"
// highlight-next-line
> java.lang.RuntimeException: Could not execute entrypoint stage 'main' due to errors, provided by 'bosses_of_mass_destruction'!
>   at net.fabricmc.loader.impl.FabricLoaderImpl.lambda$invokeEntrypoints$2(FabricLoaderImpl.java:388)
>   Suppressed: java.lang.NoClassDefFoundError: Could not initialize class net.barribob.maelstrom.MaelstromMod
>       at net.barribob.maelstrom.MaelstromModKt.init(MaelstromMod.kt:46)

```
In this log we can see that the `bosses_of_mass_destruction` mod prevented the game from launching, which in turn was prevented by an error in the `Maelstrom` mod. After replacing the `Maelstrom` mod or removing the `bosses_of_mass_destruction` mod, the error will most likely disappear.
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
We can see that the problem was the `sodium-extra` mod, and after removing it the game is likely to run.
```log title="Log example"
[:] java.lang.NoSuchFieldError: stateTicks
// highlight-next-line
[:]     at com.github.mim1q.minecells.entity.ProtectorEntity.<init>(ProtectorEntity.java:31)
[:]     at net.minecraft.class_1299.method_5883(class_1299.java:544)
```
This time the error occurred during the game, and Fabric is again unable to detect the problematic mod. But we are lucky - if we read the `at` lines, we can see that the failure occurred when the `minecells` mod was running and removing it will most likely solve the issue.

## Fabric - mod dependencies {#fabric-mod-dep}
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

## Mod corruption {#corruption-mod}
```log title="Log example"
Exception in thread "main" cpw.mods.niofs.union.UnionFileSystem$UncheckedIOException: java.util.zip.ZipException: zip END header not found
// highlight-next-line
Caused by: java.util.zip.ZipException: zip END header not found
    at jdk.zipfs/jdk.nio.zipfs.ZipFileSystem.findEND(ZipFileSystem.java:1315)

```
The `java.util.zip.ZipException: zip END header not found` error in the log signals that the game files and/or mods are corrupted. Use the "update client" checkbox, re-download mods from CurseForge/Modrinth.
:::tip[Fabric specifics]
Fabric stores some data in the `.fabric` folder in the game folder. If a similar error occurs with Fabric, it is recommended to delete this folder
:::
:::danger
The presence of such a problem signals problems with the hard disk drive. It is recommended to check the entire system for integrity
:::

## Config files corruption {#corruption-config}
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