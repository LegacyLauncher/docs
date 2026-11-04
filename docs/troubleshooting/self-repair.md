---
description: Как самостоятельно решить проблему
sidebar_position: 3
---
# Самостоятельное решение проблем

Крашится игра?
Вы можете попробовать найти причину проблемы самостоятельно.
Для этого нажмите в окне ошибки кнопку "открыть логи" или включите в настройках лаунчера "журнал событий". Ниже мы перечислим относительно простые и распространенные проблемы запуска игры с модами.  
**Все примеры ниже основаны на реальных обращениях наших пользователей**.

## Неправильная версия Java {#wrong-java}
В строке `caused by` будет ошибка `java.lang.UnsupportedClassVersionError`
```log title="Пример лога"
> Exception in thread "main" java.util.ServiceConfigurationError: net.minecraftforge.forgespi.language.IModLanguageProvider: Unable to load thedarkcolour.kotlinforforge.KotlinLanguageProvider
>   at java.base/java.util.ServiceLoader.fail(ServiceLoader.java:586)
// highlight-next-line
> Caused by: java.lang.UnsupportedClassVersionError: thedarkcolour/kotlinforforge/KotlinLanguageProvider has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
>   at java.base/java.lang.ClassLoader.defineClass1(Native Method)
```
В данном примере видно, что мод `kotlinforforge` не смог загрузиться, т.к. запускается со слишком старой Java. Требуемую версию Java можно определить по `class file version`, используя [этот сайт](https://javaalmanac.io/bytecode/versions/). Для данного примера игра была запущена на Java 17 (61.0), а мод требует Java 21 (65.0)

```log title="Пример лога"
> Error: LinkageError occurred while loading main class net.minecraft.client.main.Main
// highlight-next-line
>   java.lang.UnsupportedClassVersionError: net/minecraft/client/main/Main has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
```
Эта же ошибка характерна для запуска самой игры с несовместимой (слишком старой) версией Java. Эта ошибка также определяется по ключевому слову `UnsupportedClassVersionError`

Старые версии игры используют т.н. `launchwrapper`, который не работает с Java 9 или новее. Подобные версии будут вылетать со следующим логом при запуске на слишком новых версиях Java:
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" java.lang.ClassCastException: class jdk.internal.loader.ClassLoaders$AppClassLoader cannot be cast to class java.net.URLClassLoader (jdk.internal.loader.ClassLoaders$AppClassLoader and java.net.URLClassLoader are in module java.base of loader 'bootstrap')
>   at net.minecraft.launchwrapper.Launch.<init>(Launch.java:33)
>   at net.minecraft.launchwrapper.Launch.main(Launch.java:27)

```
Решение - запуск игры на Java 8 (зачастую поможет выбор "рекомендованной" версии Java)

## Краш Java {#jvm-crash}
Иногда такое бывает, что крашится не игра, а сама виртуальная машина Java
```log title="Пример лога"
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
В подобных логах два ключевых момента: ошибка (в примере выше это `EXCEPTION_ACCESS_VIOLATION`) и библиотека, в которой произошла эта ошибка (`jvm.dll`).  
Типичные способы решения - отследить, к какому компоненту относится ошибка, и удалить его (если это стороннее ПО, например, SafeIP), либо обновить/откатить (если это Java или драйвер видеокарты).  
К сожалению, эти ошибки слишком нетривиальны для решения и помочь с ними зачастую не можем даже мы. Гуглите, обращайтесь в поддержку производителя компонента (например, видеодрайвера).
:::danger
Ни в коем случае не пытайтесь вручную удалить или заменить проблемный dll-файл! Вы можете усугубить проблему или сломать вашу ОС!
:::
:::tip
Вы можете _попробовать_ решить данную проблему с помощью [этой инструкции](./win-problems#replace-java)
:::

## Проблема GLFW с устройствами ввода {#input-device-crash}
Некоторые геймпады, джойстики и рули могут вызывать краши игры
```log title="Пример лога"
// highlight-next-line
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:105]:    Description : Invalid axis in gamepad mapping 03000000790000000600000000000000 (G-Shark GS-GP702)
> [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:106]:    Stacktrace  :
>       [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: org.lwjgl.glfw.GLFW.glfwInit(GLFW.java:830)
>       [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: net.minecraftforge.fml.loading.progress.ClientVisualization.initWindow(ClientVisualization.java:58)
>       [14:49:52] [main/INFO] [STDERR/]: [org.lwjgl.glfw.GLFWErrorCallback$1:invoke:110]: net.minecraftforge.fml.loading.progress.ClientVisualization.start(ClientVisualization.java:335)
```
Строка "Invalid axis in gamepad mapping" в логе указывает на некорректную работу устройства. Отключите проблемные устройства для запуска игры.

## OptiFine - несовместимая версия Forge {#optifine-incompatible-forge}
OptiFine - довольно капризный мод, требующий конкретные версии Forge.
```log title="Пример лога"
> [11:43:13] [main/ERROR] [cp.mo.mo.TransformationServiceDecorator/MODLAUNCHER]: Service failed to load OptiFine
> cpw.mods.modlauncher.api.IncompatibleEnvironmentException: Error loading OptiFine ZIP file: union:/C:/Users/Makc/AppData/Roaming/.tlauncher/legacy/Minecraft/game/mods/OptiFine_1.21.1_HD_U_J1.jar%23159!/
>   at optifine.OptiFineTransformationService.onLoad(OptiFineTransformationService.java:122) ~[?:?] {}
// highlight-next-line
> [11:43:13] [main/ERROR] [cp.mo.mo.TransformationServicesHandler/MODLAUNCHER]: Found 1 services that failed to load : [OptiFine]
// highlight-next-line
> Exception in thread "main" cpw.mods.modlauncher.InvalidLauncherSetupException: Invalid Services found OptiFine
```
По строкам `services that failed to load : [OptiFine]` и `Invalid Services found OptiFine` мы видим, что текущие версии OptiFine и Forge несовместимы

## OptiFine - несовместимая версия игры {#optifine-version}
OptiFine максимально жестко привязан к версии игры. Если многие моды могут пережить незначительное обновление (например, моды для 1.19.1 могут заработать на 1.19.2), то с OptiFine это так не работает.
Если OptiFine обнаруживает несовместимую версию игры, в логе появятся следующие строки:
```log title="Пример лога"
// highlight-next-line
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]: optifine.xdelta.PatchException: truncated source file, aborting
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]:  at optifine.xdelta.GDiffPatcher.copy(GDiffPatcher.java:181)
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]:  at optifine.xdelta.GDiffPatcher.runPatch(GDiffPatcher.java:130)
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]:  at optifine.xdelta.GDiffPatcher.<init>(GDiffPatcher.java:67)
> [21:18:40] [main/INFO] [STDERR]: [optifine.OptiFineClassTransformer:getOptiFineResourcePatched:223]:  at optifine.xdelta.GDiffPatcher.<init>(GDiffPatcher.java:63)
```
Ключевая строчка здесь - `optifine.xdelta.PatchException`. Если видите её в логе - проверьте версию OptiFine.

## Forge - ошибка мода {#forge-mod-error}
В конце лога должен быть краш. Он выглядит как череда строчек, начинающихся на `at`:
```log title="Пример лога"
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
Посмотрите на строчку, начинающуюся на `Caused by`: в ней мы видим, что проблема в моде magnesium: `Critical injection failure: Redirector redirectGetFancyWeather()Z in magnesium.mixins.json:features.options.MixinWorldRenderer failed injection check`.  
Скорее всего, этот мод и стал причиной ошибки. Удаление мода поможет запустить игру.  

Иногда проблемный мод появится не в самой строчке `Caused by`, а в одной из строчек `at` ниже:
```log title="Пример лога"
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
В этом примере ошибка происходит в моде `ageofweapons`, которому, вероятно, не подходит версия Forge - он не может найти (`ClassNotFoundException`) компонент Minecraft Forge (`net.minecraftforge.network.PlayMessages$SpawnEntity`)

Старые версии Forge рисовали таблицу со списком модов:
```log title="Пример лога"
[:]     | State | ID             | Version      | Source                                    | Signature                                |
[:]     |:----- |:-------------- |:------------ |:----------------------------------------- |:---------------------------------------- |
[:]     | LCH   | minecraft      | 1.12.2       | minecraft.jar                             | None                                     |
[:]     | LCH   | mcp            | 9.42         | minecraft.jar                             | None                                     |
[:]     | LCH   | FML            | 8.0.99.99    | forge-1.12.2-14.23.5.2860.jar             | e3c3d50c7c986df74c645c0ac54639741c90a557 |
[:]     | LCH   | forge          | 14.23.5.2860 | forge-1.12.2-14.23.5.2860.jar             | e3c3d50c7c986df74c645c0ac54639741c90a557 |
// highlight-next-line
[:]     | LCE   | xujmod         | 2.0.8        | xujmod-2.0.8.jar                          | None                                     |
```
Наличие буквы `E` в столбце "State" сигнализирует об ошибке в моде. Например, в этом примере сломался `xujmod`. После удаления сломанных модов игра заработает.

## Forge - нехватка мода {#forge-mod-dep}
```log title="Пример лога"
[:] net.minecraftforge.fml.common.LoaderExceptionModCrash: Caught exception from XujMod (xujmod)
// highlight-next-line
[:] Caused by: java.lang.NoClassDefFoundError: blusunrize/immersiveengineering/common/items/ItemIEBase
[:]     at net.lasernet.xuj.ModItems.init(ModItems.java:55)
[:]     at net.lasernet.xuj.XujMod.preInit(XujMod.java:60)
```
Ошибка `NoClassDefFoundError` обычно сигнализирует об отсутствующем моде. Из этой строчки мы видим, что не хватает мода `immersiveengineering`. После установки всех требуемых модов игра заработает.
```log title="Пример лога"
> [17:01:14] [main/ERROR] [ne.mi.fm.lo.ModSorter/LOADING]: Missing or unsupported mandatory dependencies:
// highlight-next-line
>   Mod ID: 'valhelsia_core', Requested by: 'valhelsia_structures', Expected range: '[1.1.1,)', Actual version: '[MISSING]'
```
:::tip[Подобные строки появляются **в начале** лога]
:::
По этой строке видно, что моду `valhelsia_structures` нужен мод `valhelsia_core` версии `1.1.1` или новее, который сейчас не установлен (`MISSING`). После установки всех требуемых модов **соответствующих версий** игра запустится.

## Forge - некорректное название мода {#forge-invalid-name}
После перехода игры на Java 17 Forge может крашиться из-за некорректных названий модов. Не рекомендуется переименовывать моды кириллицей.
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" java.lang.IllegalArgumentException: 1.0-1.18+: Empty pre-release
>   at java.base/java.lang.module.ModuleDescriptor$Version.<init>(ModuleDescriptor.java:1054)
>   at java.base/java.lang.module.ModuleDescriptor$Version.parse(ModuleDescriptor.java:1090)
```
По строке `1.0-1.18+: Empty pre-release` мы видим, что Forge не может понять строку "`1.0-1.18+`" какого-то мода. Посмотрев в папку с модами, мы находим файл `lazydfu-1.0-1.18+`. После переименования мода, например, в `lazydfu-1.0` игра заработает.

На новых версиях игры есть и другой случай:
```log title="Пример лога"
> Exception in thread "main" java.lang.IllegalArgumentException: multi-piston: Invalid module name: 'multi-piston' is not a Java identifier
>   at java.base/jdk.internal.module.Checks.requireModuleName(Checks.java:59)
```
`IllegalArgumentException` с комментарием `Invalid module name` говорит нам о недопустимом названии модуля для мода. Обычно это сигнализирует об одной из двух вещей: мод сломан или загружается мод для неправильной версии игры. Также есть шанс, что проблема в имени файла мода - в данном примере можно попробовать переименовать мод (для данного примера - переименовать мод `multi-piston` в `multipiston`)
:::warning
Не переименовывайте моды кириллицей! Некоторые версии Forge будут назначать таким модам пустые имена модулей и ломаться!
:::

## Forge - дубликаты модов {#forge-duplicates}
```log title="Пример лога"
> Exception in thread "main" [16:41:20] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1069]: java.lang.RuntimeException: java.lang.reflect.InvocationTargetException
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1069]:     at cpw.mods.modlauncher.LaunchServiceHandlerDecorator.launch(LaunchServiceHandlerDecorator.java:39)
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1078]: Caused by: java.lang.reflect.InvocationTargetException
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.ThreadGroup:uncaughtException:1078]:     at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
// highlight-next-line
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]: Caused by: java.lang.ClassFormatError: Duplicate interface name "xaero/common/minimap/mcworld/IXaeroMinimapClientWorld" in class file net/minecraft/client/world/ClientWorld
> [16:41:20] [main/INFO] [STDERR/]: [java.lang.Throwable:printStackTrace:659]:  at java.base/java.lang.ClassLoader.defineClass1(Native Method)
```
Ошибка `java.lang.ClassFormatError: Duplicate interface name ... in class file ...` сигнализирует нам об установленном дважды моде. После удаления дубликата (название мода, как правило, можно выяснить из текста ошибки, для примера выше это `XaeroMinimap`) игра запустится.

## Fabric - сломанный мод {#fabric-broken-mod}
```log title="Пример лога"
// highlight-next-line
> java.lang.RuntimeException: Could not execute entrypoint stage 'main' due to errors, provided by 'bosses_of_mass_destruction'!
>   at net.fabricmc.loader.impl.FabricLoaderImpl.lambda$invokeEntrypoints$2(FabricLoaderImpl.java:388)
>   Suppressed: java.lang.NoClassDefFoundError: Could not initialize class net.barribob.maelstrom.MaelstromMod
>       at net.barribob.maelstrom.MaelstromModKt.init(MaelstromMod.kt:46)

```
По этому логу мы видим, что запуску игры помешал мод `bosses_of_mass_destruction`, которому, в свою очередь, помешала ошибка мода `Maelstrom`. После замены мода `Maelstrom` или удаления мода `bosses_of_mass_destruction` ошибка, скорее всего, пропадет
```log title="Пример лога"
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
На этот раз Fabric нам не может явно указать на проблемный мод, но мы можем узнать его из сообщения о причинах ошибки (`Caused by:`): `Caused by: org.spongepowered.asm.mixin.throwables.MixinApplyError: Mixin [sodium-extra.mixins.json:toasts.MixinTutorialToast from mod sodium-extra]`.  
Мы видим, что проблемой стал мод `sodium-extra`, и после его удаления игра, скорее всего, запустится
```log title="Пример лога"
[:] java.lang.NoSuchFieldError: stateTicks
// highlight-next-line
[:]     at com.github.mim1q.minecells.entity.ProtectorEntity.<init>(ProtectorEntity.java:31)
[:]     at net.minecraft.class_1299.method_5883(class_1299.java:544)
```
На этот раз ошибка произошла уже во время игры, и Fabric снова не может определить проблемный мод. Но нам повезло - если почитать строчки `at`, мы видим, что сбой произошел при работе мода `minecells` и его удаление, скорее всего, решит проблему.

## Fabric - зависимости мода {#fabric-mod-dep}
```log title="Пример лога"
> net.fabricmc.loader.impl.FormattedException: Some of your mods are incompatible with the game or each other!
> A potential solution has been determined, this may resolve your problem:
// highlight-next-line
>    - Replace mod 'Fabric Loader' (fabricloader) 0.15.7 with any version between 0.14.25 (inclusive) and 0.15- (exclusive).
> More details:
// highlight-next-line
>    - Mod 'GoProne' (goprone) 3.1.3 requires any version between 0.14.21 (inclusive) and 0.15- (exclusive) of mod 'Fabric Loader' (fabricloader), but only the wrong version is present: 0.15.7!
>   at net.fabricmc.loader.impl.FormattedException.ofLocalized(FormattedException.java:51) ~[fabric-loader-0.15.7.jar:?]
```
Вы должны установить моды, отвечающие требованиям установленных модов.  
Например, в данном случае мод требует версию Fabric Loader `0.14.25 или новее`, но при этом `старее, чем 0.15`, из-за чего ему не подходит используемая версия `0.15.7`. Обновление мода или установка требуемой версии `fabric-loader` исправит эту проблему.

## Повреждение мода {#corruption-mod}
```log title="Пример лога"
Exception in thread "main" cpw.mods.niofs.union.UnionFileSystem$UncheckedIOException: java.util.zip.ZipException: zip END header not found
// highlight-next-line
Caused by: java.util.zip.ZipException: zip END header not found
    at jdk.zipfs/jdk.nio.zipfs.ZipFileSystem.findEND(ZipFileSystem.java:1315)

```
Ошибка `java.util.zip.ZipException: zip END header not found` в логе сигнализирует о повреждении файлов игры и/или модов. Воспользуйтесь галочкой "обновить клиент", перекачайте моды с CurseForge/Modrinth
:::tip[Особенности Fabric]
Fabric хранит часть данных игры в папке `.fabric` в папке игры. При возникновении подобной ошибки с Fabric рекомендуется удалить эту папку
:::

## Повреждение конфигов {#corruption-config}
```log title="Пример лога"
// highlight-next-line
> net.minecraftforge.fml.config.ConfigFileTypeHandler$ConfigLoadingException: Failed loading config file flywheel-client.toml of type CLIENT for modid flywheel
>   at net.minecraftforge.fml.config.ConfigFileTypeHandler.lambda$reader$1(ConfigFileTypeHandler.java:47) ~[forge:?] {re:classloading}
>   at net.minecraftforge.fml.config.ConfigTracker.openConfig(ConfigTracker.java:90) ~[forge:?] {re:classloading}
// highlight-next-line
> Caused by: com.electronwill.nightconfig.core.io.ParsingException: Not enough data available
>   at com.electronwill.nightconfig.core.io.ParsingException.notEnoughData(ParsingException.java:22) ~[core-3.6.3.jar:?] {}
```
Подобные ошибки характеризуются наличием слова "config" или "settings" в ошибке. В данном примере можно увидеть, что поломался файл настроек `flywheel-client.toml` мода `flywheel`.  
Подобные проблемы решаются крайне просто - удалением соответствующего файла из папки `config` в папке игры, либо удалением всей папки `config` целиком - моды пересоздадут свои файлы настроек.