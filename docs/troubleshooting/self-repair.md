---
description: Как самостоятельно решить проблему
sidebar_position: 3
---
# Самостоятельное решение проблем

Крашится игра?
Вы можете попробовать найти причину проблемы самостоятельно.
Для этого нажмите в окне ошибки кнопку "открыть логи" или включите в настройках лаунчера "журнал событий". Ниже мы перечислим относительно простые и распространенные проблемы запуска игры, в том числе с модами.  
**Все примеры ниже основаны на реальных обращениях наших пользователей**.

:::tip[Как найти нужный раздел]
Найдите в логе строку с ошибкой - обычно она начинается с `Caused by` или содержит слова `Exception` или `Error`. Затем поищите ключевую часть этой строки на этой странице (Ctrl+F, на macOS - Cmd+F): во всех примерах ниже приведены настоящие строки из логов
:::

## Java и система {#java-system}

### Неправильная версия Java {#wrong-java}
Каждой версии игры нужна своя версия Java. Если в настройках лаунчера выбрана "Рекомендуемая" Java, лаунчер подбирает её сам. Чаще всего мод, которому нужна Java новее рекомендуемой, просто собран для более новой версии игры - в этом случае нужна версия мода для вашей версии игры, а не другая Java.

#### Мод требует более новую Java {#mod-needs-newer-java}
В строке `caused by` будет ошибка `java.lang.UnsupportedClassVersionError`
```log title="Пример лога"
> Exception in thread "main" java.util.ServiceConfigurationError: net.minecraftforge.forgespi.language.IModLanguageProvider: Unable to load thedarkcolour.kotlinforforge.KotlinLanguageProvider
>   at java.base/java.util.ServiceLoader.fail(ServiceLoader.java:586)
// highlight-next-line
> Caused by: java.lang.UnsupportedClassVersionError: thedarkcolour/kotlinforforge/KotlinLanguageProvider has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
>   at java.base/java.lang.ClassLoader.defineClass1(Native Method)
```
В данном примере видно, что мод `kotlinforforge` не смог загрузиться, т.к. запускается со слишком старой Java. Требуемую версию Java можно определить по `class file version`, используя [этот сайт](https://javaalmanac.io/bytecode/versions/). Для данного примера игра была запущена на Java 17 (61.0), а мод требует Java 21 (65.0)

Что делать:
* Если в настройках лаунчера выбрана "Рекомендуемая" Java - мод сделан для другой версии игры. Скачайте версию мода для вашей версии игры
* Если Java выбрана вручную - выберите "Рекомендуемую"

Fabric сообщает о неподходящей Java так же, как о недостающей зависимости - в виде "мода" `java`:
```log title="Пример лога"
> net.fabricmc.loader.impl.FormattedException: Some of your mods are incompatible with the game or each other!
> A potential solution has been determined, this may resolve your problem:
// highlight-next-line
>    - Replace 'Java HotSpot(TM) 64-Bit Server VM' (java) 8 with version 21 or later.
> More details:
>    - Mod 'Fabric API' (fabric-api) 0.119.4+1.21.4 requires version 21 or later of 'Java HotSpot(TM) 64-Bit Server VM' (java), but only the wrong version is present: 8!
```
Не нужно искать и устанавливать нужную Java самостоятельно - действуйте так же, как описано выше

#### Игра требует более новую Java {#game-needs-newer-java}
```log title="Пример лога"
> Error: LinkageError occurred while loading main class net.minecraft.client.main.Main
// highlight-next-line
>   java.lang.UnsupportedClassVersionError: net/minecraft/client/main/Main has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0
```
Та же ошибка `UnsupportedClassVersionError` возникает при запуске самой игры на слишком старой Java.  
Выберите в настройках лаунчера "Рекомендуемую" Java. Если она уже выбрана - воспользуйтесь галочкой "Обновить клиент"

На NeoForge та же проблема может выглядеть иначе - игра падает еще до загрузки модов:
```log title="Пример лога"
> Error occurred during initialization of boot layer
> java.lang.module.FindException: Error reading module: D:\Minecraft\game\libraries\cpw\mods\bootstraplauncher\2.0.2\bootstraplauncher-2.0.2.jar
// highlight-next-line
> Caused by: java.lang.module.InvalidModuleDescriptorException: Unsupported major.minor version 65.0
```
Решение то же - выберите "Рекомендуемую" Java. Если она уже выбрана - один из модов сделан для другой версии игры

#### Старая версия игры на новой Java {#old-game-new-java}
Forge, OptiFine и LiteLoader для версий до 1.12.2, а также самые старые версии игры используют т.н. `launchwrapper`, который не работает с Java 9 или новее. Подобные версии будут вылетать со следующим логом при запуске на слишком новых версиях Java:
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" java.lang.ClassCastException: class jdk.internal.loader.ClassLoaders$AppClassLoader cannot be cast to class java.net.URLClassLoader (jdk.internal.loader.ClassLoaders$AppClassLoader and java.net.URLClassLoader are in module java.base of loader 'bootstrap')
>   at net.minecraft.launchwrapper.Launch.<init>(Launch.java:33)
>   at net.minecraft.launchwrapper.Launch.main(Launch.java:27)

```
Решение - запуск игры на Java 8. Почти всегда эта ошибка означает, что Java выбрана вручную - выберите "Рекомендуемую" Java

#### Мод требует более старую Java {#mod-needs-older-java}
Бывает и обратная ситуация - мод требует более **старую** Java. Например, некоторые моды для 1.16.5 написаны для Java 8 и не работают на Java 16. Лаунчер по умолчанию запускает 1.16.5 на Java 16 вместо рекомендуемой Mojang Java 8, так как многие моды для этой версии требуют более новую Java:
```log title="Пример лога"
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
Ключевая строка - `NoSuchFieldException: modifiers`. В этом примере проблема в моде `timecore`. Выберите для этой версии Java 8 вручную ([как это сделать](../faq/custom-java#edit-version))

### Краш Java {#jvm-crash}
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

По имени библиотеки можно понять, к чему она относится:

| Имя библиотеки начинается с | Что это | Что делать |
|---|---|---|
| `nvoglv`, `nvwgf`, `nvd3d` | Драйвер видеокарты NVIDIA | [Обновите или откатите драйвер](./win-problems#gpu-driver) |
| `ig4icd`, `ig7icd`, `ig8icd`, `ig9icd`, `ig11icd`, `ig12icd`, `ig75icd`, `igxelpicd`, `igvk`, `igdumd`, `igd10` | Драйвер видеокарты Intel | [Обновите или откатите драйвер](./win-problems#gpu-driver) |
| `atio`, `aticfx`, `amdvlk`, `amdxc` | Драйвер видеокарты AMD | [Обновите или откатите драйвер](./win-problems#gpu-driver) |
| `jvm.dll`, `libjvm` | Java | [Установите другую сборку Java](./win-problems#replace-java) |
| `SafeIPs` | SafeIP | [Удалите программу](./win-problems#injectors) |
| `LavasoftTcpService` | Lavasoft Web Companion | [Удалите программу](./win-problems#injectors) |
| `graphics-hook` | Захват игры в OBS | Отключите в OBS источник "Захват игры" или используйте "Захват окна" |
| `medal-hook` | Medal | Закройте Medal или отключите в нём запись игры |

:::note[EXCEPTION_ILLEGAL_INSTRUCTION]
Ошибка `EXCEPTION_ILLEGAL_INSTRUCTION` означает, что программа требует более новый процессор, чем установлен в вашем ПК. Ошибка может быть не только в драйвере видеокарты, но и в библиотеке Java или мода. Попробуйте более старую версию этой программы (драйвера, Java или мода)
:::

К сожалению, эти ошибки слишком нетривиальны для решения и помочь с ними зачастую не можем даже мы. Гуглите, обращайтесь в поддержку производителя компонента (например, видеодрайвера).
:::danger
Ни в коем случае не пытайтесь вручную удалить или заменить проблемный dll-файл! Вы можете усугубить проблему или сломать вашу ОС!
:::
:::tip
Вы можете _попробовать_ решить данную проблему с помощью [этой инструкции](./win-problems#replace-java)
:::

### Код выхода 1114 {#exit-code-1114}
Игра закрывается сразу после строки `Backend library: LWJGL version ...`, а лаунчер сообщает о коде выхода 1114:
```log title="Пример лога"
> [19:21:07] [Render thread/INFO]: Backend library: LWJGL version 3.3.3+5
19:21:28,697 [MinecraftLauncher] Launcher has stopped.
// highlight-next-line
19:21:28,697 [MinecraftLauncher] Child process closed with exit code: 1114 (0x45a)
```
Код 1114 означает, что драйвер видеокарты не смог запуститься. Чаще всего это происходит на ноутбуках с двумя видеокартами - встроенной Intel и дискретной AMD.  
Решение - включите в Windows схему электропитания "Максимальная производительность". Переустанавливать драйвер при этом обычно не нужно

### Нехватка памяти {#out-of-memory}
Игре может не хватить как выделенной ей памяти, так и памяти всей системы. Решения у этих случаев разные.

#### Не хватило выделенной памяти {#heap-exhausted}
Если игре не хватило **выделенной** памяти, в логе будет ошибка `java.lang.OutOfMemoryError: Java heap space` или `java.lang.OutOfMemoryError: GC overhead limit exceeded`:
```log title="Пример лога"
> Description: Initializing game
> 
// highlight-next-line
> java.lang.OutOfMemoryError: Java heap space
>   at java.desktop/java.awt.image.DataBufferInt.<init>(Unknown Source)
>   at java.desktop/java.awt.image.Raster.createPackedRaster(Unknown Source)
```
Выделите игре больше памяти в [настройках лаунчера](../launcher/settings#minecraft) (пункт "Память (ОЗУ)"), но не больше, чем свободно в системе. Рекомендуемые значения указаны в [системных требованиях](../system-requirements#minecraft). Если памяти в системе мало - уберите часть модов или шейдеры

#### Не хватило памяти системы {#system-memory}
Если памяти не хватило **системе**, ошибки выглядят иначе:
```log title="Java не смогла занять выделенную память"
> Error occurred during initialization of VM
// highlight-next-line
> Could not reserve enough space for 1048576KB object heap
```
```log title="Не хватило памяти или файла подкачки (Windows)"
// highlight-next-line
> OpenJDK 64-Bit Server VM warning: INFO: os::commit_memory(0x0000000781000000, 427819008, 0) failed; error='The paging file is too small for this operation to complete' (DOS error/errno=1455)
> #
> # There is insufficient memory for the Java Runtime Environment to continue.
> # Native memory allocation (mmap) failed to map 427819008 bytes. Error detail: G1 virtual space
```
```log title="Система завершила игру из-за нехватки памяти (macOS, Linux)"
// highlight-next-line
08:35:36,152 [MinecraftLauncher] Child process closed with exit code: 137 (0x89)
```
В этих случаях выделение игре дополнительной памяти не поможет. Что делать:
1. Проверьте объем выделенной ОЗУ в [настройках лаунчера](../launcher/settings#minecraft): он должен быть меньше свободной памяти в системе. Выделять меньше 1 ГиБ смысла нет
2. Закройте другие программы
3. Перезагрузите компьютер - это освободит память и уменьшит её фрагментацию
4. На Windows проверьте файл подкачки: нажмите Win+R, введите `sysdm.cpl`, перейдите на вкладку "Дополнительно" - "Быстродействие" - "Параметры" - "Дополнительно" - "Виртуальная память" - "Изменить" и включите "Автоматически выбирать объем файла подкачки"

:::warning[32-битная Java]
На 32-битной Java невозможно выделить игре больше 1 ГиБ ОЗУ
:::

### Не найден класс запуска {#main-class-missing}
```log title="Пример лога"
// highlight-next-line
> Error: Could not find or load main class cpw.mods.bootstraplauncher.BootstrapLauncher
> Caused by: java.lang.ClassNotFoundException: cpw.mods.bootstraplauncher.BootstrapLauncher
```
Если после `main class` указан класс самой игры или загрузчика модов (`net.minecraft...`, `cpw.mods...`, `net.minecraftforge...`, `net.fabricmc...`), значит, файлы версии отсутствуют или повреждены. Переустановите версию с галочкой "Обновить клиент". Если ошибка повторяется - проверьте [антивирус](./common#av-software)

```log title="Пример лога"
// highlight-next-line
> Error: Could not find or load main class C:\Program Files\Java\jdk-17
> Caused by: java.lang.ClassNotFoundException: C:\Program Files\Java\jdk-17
```
Если же там указано что-то постороннее - путь, ссылка или просто слово, - значит, в поле "Аргументы Java" в настройках лаунчера вписано лишнее, и Java приняла это за имя класса. [Очистите поле "Аргументы Java"](./common#check-args)

### Языковые настройки системы {#system-locale}
При некоторых языках системы (например, турецком или арабском) игра и моды подставляют в имена посторонние символы и сами же отказываются их принимать:
```log title="Пример лога"
// highlight-next-line
> net.minecraft.util.ResourceLocationException: Non [a-z0-9/._-] character in path of location: minecraft:dynamic/light_map_١
>   at net.minecraft.util.ResourceLocation.<init>(ResourceLocation.java:33) ~[?:?] {re:classloading}
```
```log title="Пример лога"
// highlight-next-line
> [19:28:11] [Server thread/ERROR] [ne.mi.ev.EventBus/EVENTBUS]: Exception caught during firing event: 'addition' is not a valid enum constant! Valid values are: 'addıtıon', 'multıply_base', 'multıply_total'
```
В первом примере вместо цифры `1` стоит арабская цифра `١`, во втором вместо латинской `i` - турецкая `ı`. Моды здесь ни при чем. Добавьте в поле "Аргументы Java" в [настройках лаунчера](../launcher/settings#minecraft) аргумент `-Duser.language=en` или переключите язык системы на английский

### Имя пользователя Windows не латиницей {#non-latin-username}
Некоторые моды и библиотеки распаковывают свои файлы во временную папку, которая находится в папке пользователя Windows. Если имя пользователя написано не латиницей (например, кириллицей), Java может не суметь загрузить такой файл:
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" java.lang.UnsatisfiedLinkError: Could not load library. Reasons: [no jansi in java.library.path, C:\Users\Пользователь\AppData\Local\Temp\jansi-64-7040785544641368972.dll: Can't find dependent libraries]
>   at org.fusesource.hawtjni.runtime.Library.doLoad(Library.java:182)
```
Переустановка игры в другую папку не поможет: дело в папке пользователя, а не в папке игры. Что делать:
* Укажите для временных файлов папку с латинским путем: нажмите Win+R, введите `sysdm.cpl`, перейдите на вкладку "Дополнительно" - "Переменные среды" и в переменных среды пользователя измените значения `TEMP` и `TMP` на путь из латинских букв (например, `C:\Temp`; папку нужно создать заранее)
* Надежнее - создать пользователя Windows с латинским именем

### Проблема GLFW с устройствами ввода {#input-device-crash}
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

## OptiFine и моды отрисовки {#renderers}

### OptiFine - несовместимый загрузчик или версия игры {#optifine-incompatible-forge}
OptiFine - довольно капризный мод, требующий конкретные версии Forge.
```log title="Пример лога"
> [11:43:13] [main/ERROR] [cp.mo.mo.TransformationServiceDecorator/MODLAUNCHER]: Service failed to load OptiFine
> cpw.mods.modlauncher.api.IncompatibleEnvironmentException: Error loading OptiFine ZIP file: union:/C:/Users/User/AppData/Roaming/.tlauncher/legacy/Minecraft/game/mods/OptiFine_1.21.1_HD_U_J1.jar%23159!/
>   at optifine.OptiFineTransformationService.onLoad(OptiFineTransformationService.java:122) ~[?:?] {}
// highlight-next-line
> [11:43:13] [main/ERROR] [cp.mo.mo.TransformationServicesHandler/MODLAUNCHER]: Found 1 services that failed to load : [OptiFine]
// highlight-next-line
> Exception in thread "main" cpw.mods.modlauncher.InvalidLauncherSetupException: Invalid Services found OptiFine
```
По строкам `services that failed to load : [OptiFine]` и `Invalid Services found OptiFine` мы видим, что OptiFine не может работать в текущей сборке. Чаще всего причина одна из двух:
* OptiFine запускается на NeoForge - OptiFine не работает с NeoForge ни в какой версии. Удалите OptiFine
* OptiFine сделан для другой версии игры - проверьте версию в имени файла (например, `OptiFine_1.20.1_HD_U_I6.jar` не подойдет для 1.21.1). Установите подходящую версию OptiFine или удалите его

### OptiFine - несовместимая версия игры {#optifine-version}
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
Ключевая строчка здесь - `optifine.xdelta.PatchException`. Если видите её в логе - проверьте, что версия OptiFine подходит к вашей версии игры и Forge.

### OptiFine и VulkanMod - конфликты с другими модами {#optifine-conflict}
OptiFine заменяет классы игры своими копиями, поэтому многие моды с ним не работают.

#### Ошибка в другом моде {#optifine-nosuchmethod}
Ошибка при этом часто происходит не в самом OptiFine, а в другом моде:
```log title="Пример лога"
// highlight-next-line
> Caused by: java.lang.NoSuchMethodError: 'net.minecraft.resources.ResourceLocation net.minecraft.resources.ResourceLocation.fromNamespaceAndPath(java.lang.String, java.lang.String)'
>   at com.skniro.skniro_furniture.block.renderer.OvenBlockEntityRenderer.<clinit>(OvenBlockEntityRenderer.java:24) ~[SkniroFurniture-1.5.0-1.20.1-Forge.jar%23159!/:1.5.0-1.20.1-Forge] {re:classloading}
```
Здесь падает мод `SkniroFurniture`: он вызывает метод игры (`net.minecraft...`), которого нет в измененной OptiFine копии класса. Если установлен OptiFine, а другой мод падает с `NoSuchMethodError` на методе игры - скорее всего, виноват OptiFine. Удалите его

#### Dynamic Lights {#optifine-dynamic-lights}
Другой частый пример - OptiFine вместе с модом Dynamic Lights на 1.12.2:
```log title="Пример лога"
// highlight-next-line
> [15:44:50] [Client thread/INFO] [STDERR]: [net.optifine.reflect.ReflectorMethod:getTargetMethod:97]: java.lang.VerifyError: Inconsistent stackmap frames at branch target 47
> Exception Details:
>   Location:
>     net/minecraft/world/World.func_175638_a(Lnet/minecraft/util/math/BlockPos;Lnet/minecraft/world/EnumSkyBlock;)I @32: goto
>   Reason:
>     Current frame's stack size doesn't match stackmap.
```
Обычно помогает удаление OptiFine или обновление Dynamic Lights. В OptiFine есть собственное динамическое освещение (настройка `Dynamic Lights` в настройках графики), поэтому отдельный мод с ним не нужен

#### Sodium и VulkanMod {#sodium-vulkanmod}
OptiFine также несовместим с Sodium и модами на его основе (Embeddium, Rubidium, Oculus и подобными). Подробнее - в разделе [Удаление OptiFine](./common#remove-optifine)

:::warning[VulkanMod]
VulkanMod производит глубокую модификацию движка отрисовки и несовместим с огромным количеством модов. При краше проверьте, запускается ли игра без VulkanMod
:::

## Моды {#mods}

### Моды для другого загрузчика {#wrong-loader}
Моды для Fabric/Quilt и Forge/NeoForge несовместимы друг с другом. Чаще всего загрузчик молча пропускает чужой мод, и игра падает позже - например, из-за "недостающего" мода. Иногда загрузчик сразу отказывается запускаться.

:::note[Исключения]
* Quilt запускает моды для Fabric, но Fabric не запускает моды для Quilt
* NeoForge запускает моды для Forge только на версии 1.20.1
* Мод [Sinytra Connector](https://modrinth.com/mod/connector) позволяет запускать моды для Fabric на Forge и NeoForge
:::

#### Как проверить {#check-mod-loader}
После краша лаунчер выводит в лог список модов из папки `mods` с указанием загрузчика, для которого сделан каждый мод:
```log title="Пример лога"
[:] D:\Minecraft\game\mods
├ aaa-particles-fabric-1.20.1-1.4.12.jar [4952 KiB]
│ ├ md5 = 490f45c52192f63371599f4a07d27908
// highlight-next-line
│ └ aaa_particles [Fabric mod]
│   ├ version = "1.20.1-1.4.12"
```
Пометки `[Fabric mod]`, `[Forge mod]` и `[NeoForge mod]` должны совпадать с запущенным загрузчиком.
* Если чужих модов несколько - замените их версиями для вашего загрузчика или удалите
* Если чужие почти все - сборка сделана для другого загрузчика. Выберите в лаунчере версию с нужным загрузчиком

#### Намеренный краш {#wrong-loader-stub}
Некоторые моды намеренно крашат игру при запуске на неправильном загрузчике:
```log title="Пример лога"
> Caused by: java.lang.UnsupportedOperationException:
> ######################## - USER ERROR - ######################
// highlight-next-line
> User Attempting to load JourneyMap for Forge in Fabric Loader.
> Please Download the Fabric version of JourneyMap.
```

#### Нет нужных метаданных {#wrong-loader-metadata}
Моды для другого загрузчика могут не содержать нужных загрузчику метаданных - тогда загрузчик упадет еще на начальном этапе загрузки модов:
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" net.minecraftforge.forgespi.locating.ModFileLoadingException: Mod candidate despawntweaks-fabric-1.0.0-1.20.1.jar contains a corrupt or misconfigured toml.
>   at MC-BOOTSTRAP/fmlloader@1.20.1-47.4.21/net.minecraftforge.fml.loading.moddiscovery.ModFileParser.modsTomlParser(ModFileParser.java:52)
```
Здесь на Forge запущен мод для Fabric (`despawntweaks-fabric`)

### Лишние файлы в папке mods {#mods-folder}
Загрузчики модов читают только jar-файлы модов, лежащие прямо в папке `mods`. Что лежит в этой папке, можно посмотреть в списке модов, который лаунчер выводит в лог после краша (см. [Моды для другого загрузчика](#wrong-loader)).

#### Подпапки {#mods-subfolders}
Моды из подпапок (в списке они помечены как `[dir]`) не загружаются:
```log title="Пример лога"
// highlight-next-line
├ assets [dir]
│ ├ appleskin-fabric-mc1.21.11-3.0.8.jar [175 KiB]
│ │ ├ md5 = e725606e8b0ae1c83ade7cfd0aea9e73
│ │ └ appleskin [Fabric mod]
```
Здесь мод `appleskin` лежит в папке `mods/assets` и не будет загружен. Переместите его в саму папку `mods`. Исключение - папка `mods/<версия игры>` (например, `mods/1.12.2`), которая работала до версии 1.12.2 включительно. Служебные папки, которые создают сами моды (например, `.connector` или `.index`), трогать не нужно

#### Распакованные моды {#extracted-mods}
Не распаковывайте jar-файл мода, если об этом явно не сказано в инструкции по его установке. Многие загрузчики намеренно крашат игру, увидев распакованный мод:
```log title="Пример лога"
// highlight-next-line
> [11:14:04] [main/FATAL]: There appear to be jars extracted into the mods directory. This is VERY BAD and will almost NEVER WORK WELL
> [11:14:04] [main/FATAL]: You should place original jars only in the mods directory. NEVER extract them to the mods directory.
> [11:14:04] [main/FATAL]: The directories below appear to be extracted jar files. Fix this before you continue.
> [11:14:04] [main/FATAL]: Directory Keystrokes-8.1.2 (1.8.9) contains [MANIFEST.MF]
```
Удалите папку с распакованным модом и скачайте мод заново ([подробнее](../mods/installation#extracted))

#### Установщики {#loader-installers}
Не кладите в папку `mods` установщики загрузчиков модов и сами загрузчики (`fabric-installer`, `fabric-loader`, `forge-...-installer` и подобные), а также установщики модов (например, Iris Installer). Установщик нужно запустить, а не копировать в `mods` - смотрите инструкции по установке [Forge](../mods/forge), [NeoForge](../mods/neoforge), [Fabric](../mods/fabric) и [Quilt](../mods/quilt):
```log title="Пример лога"
// highlight-next-line
> [17:59:26] [ForkJoinPool.commonPool-worker-9/WARN] [ne.ne.fm.lo.mo.ModDiscoverer/SCAN]: Skipping jar. File mods/Iris-Installer-3.3.0.jar is a Fabric mod and cannot be loaded
```

#### Файлы, не являющиеся модами {#not-mods}
Ярлыки (`.lnk`), архивы с модами внутри (`.rar`, `.7z`, [подробнее](../mods/installation#archive)) и дополнения для Bedrock Edition (`.mcaddon`, `.mcpack`) модами не являются. Legacy Launcher не поддерживает Bedrock Edition

### Forge/NeoForge - ошибка мода {#forge-mod-error}
Если игра падает из-за ошибки в одном из модов, виновника обычно можно найти по тексту краша. Ниже - три способа это сделать.

#### Строка `Caused by` {#caused-by}
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
Виноват мод, которому принадлежит файл `*.mixins.json` из этой строки (здесь `magnesium.mixins.json`). Скорее всего, он сделан для другой версии игры - установите версию мода для вашей версии игры или удалите его.  
Если один мод дополняет другой (например, Iris и Sodium, дополнение и основной мод), их версии должны подходить друг к другу - обновляйте их вместе.  

#### Строки `at` {#at-lines}
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
:::warning[Ошибки mixin]
Для ошибок mixin (в тексте ошибки есть `mixin`) это не работает: строчки `at` указывают на пострадавший мод, а не на виновника. Виновника ищите по имени файла `*.mixins.json`
:::

#### Таблица модов старого Forge {#old-forge-mod-table}
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

### Forge/NeoForge - нехватка мода {#forge-mod-dep}
Многим модам для работы нужны другие моды - библиотеки. Если нужного мода нет или его версия не подходит, игра не запустится. Forge и NeoForge сообщают об этом двумя способами.

#### NoClassDefFoundError {#noclassdeffound}
```log title="Пример лога"
[:] net.minecraftforge.fml.common.LoaderExceptionModCrash: Caught exception from XujMod (xujmod)
// highlight-next-line
[:] Caused by: java.lang.NoClassDefFoundError: blusunrize/immersiveengineering/common/items/ItemIEBase
[:]     at net.lasernet.xuj.ModItems.init(ModItems.java:55)
[:]     at net.lasernet.xuj.XujMod.preInit(XujMod.java:60)
```
Ошибка `NoClassDefFoundError` обычно сигнализирует об отсутствующем моде. Из этой строчки мы видим, что не хватает мода `immersiveengineering`. После установки всех требуемых модов игра заработает.

Но не всегда `NoClassDefFoundError` означает нехватку мода. Посмотрите, с чего начинается имя класса из ошибки (в некоторых ошибках вместо `/` стоят точки):
* `net/minecraft`, `net/minecraftforge`, `net/neoforged`, `net/fabricmc` - это класс самой игры или загрузчика модов. Устанавливать ничего не нужно: мод из ошибки сделан для другой версии игры или загрузчика
* `kotlin/` - установите Kotlin for Forge (для Forge и NeoForge) или Fabric Language Kotlin (для Fabric и Quilt)
* `javafx/` - мод не может работать на Java, с которой запускается игра. Удалите его
* `org/lwjgl`, `io/netty`, `com/google/common` - это библиотеки самой игры. Воспользуйтесь галочкой "Обновить клиент"

Если нужный мод уже установлен - обновите его: в установленной версии нет нужного класса.  
Если непонятно, какой мод нужен - поищите на [Modrinth](https://modrinth.com/mods) по части имени класса. Например, для `blusunrize/immersiveengineering/...` - по слову `immersiveengineering`

#### Недостающие зависимости {#missing-dependencies}
```log title="Пример лога"
> [17:01:14] [main/ERROR] [ne.mi.fm.lo.ModSorter/LOADING]: Missing or unsupported mandatory dependencies:
// highlight-next-line
>   Mod ID: 'valhelsia_core', Requested by: 'valhelsia_structures', Expected range: '[1.1.1,)', Actual version: '[MISSING]'
```
:::tip[Подобные строки появляются **в начале** лога]
:::
По этой строке видно, что моду `valhelsia_structures` нужен мод `valhelsia_core` версии `1.1.1` или новее, который сейчас не установлен (`MISSING`). После установки всех требуемых модов **соответствующих версий** игра запустится.

### Forge/NeoForge - некорректное название мода {#forge-invalid-name}
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
`IllegalArgumentException` с комментарием `Invalid module name` говорит нам о недопустимом названии модуля для мода. Обычно это сигнализирует об одной из двух вещей: мод сломан или загружается мод для неправильной версии игры. Также есть шанс, что проблема в имени файла мода. Попробуйте переименовать мод (для данного примера - `multi-piston` в `multipiston`) или удалите его
:::warning
Настоятельно не рекомендуем переименовывать файлы модов кириллицей! Некоторые версии Forge будут назначать таким модам пустые имена модулей и ломаться. Лучше всего оставить оригинальное имя файла мода
:::

### Forge/NeoForge - конфликт модулей {#module-conflict}
Начиная с версии 1.17 Forge и NeoForge загружают каждый мод как отдельный Java-модуль, и два модуля не могут содержать один и тот же пакет. В таком случае игра падает с ошибкой `java.lang.module.ResolutionException`. Порядок модулей в сообщении ничего не говорит о виновнике - смотрите, какие из названных модулей являются установленными вами модами.

#### Мод несет в себе чужой код {#bundled-code}
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" java.lang.module.ResolutionException: Module voicechat.forge contains package org.spongepowered.asm.util.perf, module org.spongepowered.mixin exports package org.spongepowered.asm.util.perf to voicechat.forge
>   at java.base/java.lang.module.Resolver.resolveFail(Resolver.java:901)
```
Здесь в мод Simple Voice Chat (`voicechat`) встроена собственная копия Mixin, который уже есть в игре. Скачайте версию мода для вашей версии игры и загрузчика или удалите мод

#### Один и тот же код в двух файлах {#same-code-twice}
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" java.lang.module.ResolutionException: Module optifine contains package srg.net.optifine.entity.model.anim, module OptiFine.OptiFine.HD.U.G8.pre2 exports package srg.net.optifine.entity.model.anim to optifine
>   at java.base/java.lang.module.Resolver.resolveFail(Resolver.java:901)
```
Здесь OptiFine установлен дважды: в виде версии с OptiFine и отдельным файлом в папке `mods`. Оставьте только одну копию

#### Два файла самой игры {#two-game-jars}
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" java.lang.module.ResolutionException: Modules minecraft and client export package net.minecraft.world.level.levelgen.feature.stateproviders to module mclib
>   at java.base/java.lang.module.Resolver.resolveFail(Resolver.java:901)
```
Если среди названных модулей нет установленных вами модов, а есть `minecraft` и `client` - в установленной версии два файла игры. Переустановите версию с галочкой "Обновить клиент"

### Forge/NeoForge - дубликаты модов {#forge-duplicates}
Если в папке `mods` один мод лежит дважды (например, две его версии), игра не запустится. Как это выглядит в логе, зависит от версии Forge.

#### Ошибка Duplicate interface name {#duplicate-interface}
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

#### Старые версии Forge {#duplicates-old-forge}
На старых версиях Forge дубликат выглядит так - в строке перечислены оба файла мода:
```log title="Пример лога"
// highlight-next-line
> [10:58:25] [Client thread/FATAL] [FML]: Found a duplicate mod grapplemod at [D:\Games\Minecraft\files\mods\grapplemod_1.11.2_v10.jar, D:\Games\Minecraft\files\mods\Grappling-Hook-Mod-v13-for-1.12.2.jar]
> [10:58:25] [Client thread/ERROR] [FML]: An exception was thrown, the game will display an error screen and halt.
> net.minecraftforge.fml.common.DuplicateModsFoundException
```
Здесь в папке модов лежат две версии одного мода - для 1.11.2 и для 1.12.2. Удалите ту, что не подходит к вашей версии игры.

#### Новые версии Forge {#duplicates-new-forge}
На новых версиях Forge об этом сообщает строка `Found duplicate mods`, а под ней - строка `Mod ID: '...' from mod files: ...` с обоими файлами:
```log title="Пример лога"
> [20:50:17] [main/ERROR] [ne.mi.fm.lo.UniqueModListBuilder/LOADING]: Found duplicate mods:
// highlight-next-line
>   Mod ID: 'rubidium' from mod files: rubidium-mc1.20.1-0.7.1.jar, embeddium-0.3.31mc1.20.1.jar
> [20:50:17] [main/ERROR] [ne.mi.fm.lo.mo.ModDiscoverer/SCAN]: Failed to build unique mod list after mod discovery.
> net.minecraftforge.fml.loading.EarlyLoadingException: Duplicate mods found
```
Эта ошибка возникает еще до загрузки модов, поэтому списка модов в логе не будет.
* Если в строке две версии одного мода - удалите старую
* Если это два разных мода - они выполняют одну и ту же задачу. В примере выше Embeddium заменяет Rubidium и поэтому называет себя `rubidium`, так же REI Plugin Compatibilities заменяет JEI. Оставьте один из них

### Fabric - сломанный мод {#fabric-broken-mod}
Fabric не всегда прямо называет мод, из-за которого упала игра. Ниже - три типичных случая и как в них найти виновника.

#### Ошибка при запуске мода {#entrypoint-error}
```log title="Пример лога"
// highlight-next-line
> java.lang.RuntimeException: Could not execute entrypoint stage 'main' due to errors, provided by 'bosses_of_mass_destruction'!
>   at net.fabricmc.loader.impl.FabricLoaderImpl.lambda$invokeEntrypoints$2(FabricLoaderImpl.java:388)
>   Suppressed: java.lang.NoClassDefFoundError: Could not initialize class net.barribob.maelstrom.MaelstromMod
>       at net.barribob.maelstrom.MaelstromModKt.init(MaelstromMod.kt:46)

```
По этому логу мы видим, что запуску игры помешал мод `bosses_of_mass_destruction`, которому, в свою очередь, помешала ошибка мода `Maelstrom`. После замены мода `Maelstrom` или удаления мода `bosses_of_mass_destruction` ошибка, скорее всего, пропадет

#### Ошибка mixin {#fabric-mixin-error}
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
Мы видим, что проблемой стал мод `sodium-extra` (ему принадлежит `sodium-extra.mixins.json`). Скорее всего, он сделан для другой версии игры - установите версию мода для вашей версии игры или удалите его

#### Ошибка во время игры {#fabric-runtime-error}
```log title="Пример лога"
[:] java.lang.NoSuchFieldError: stateTicks
// highlight-next-line
[:]     at com.github.mim1q.minecells.entity.ProtectorEntity.<init>(ProtectorEntity.java:31)
[:]     at net.minecraft.class_1299.method_5883(class_1299.java:544)
```
На этот раз ошибка произошла уже во время игры, и Fabric снова не может определить проблемный мод. Но нам повезло - если почитать строчки `at`, мы видим, что сбой произошел при работе мода `minecells` и его удаление, скорее всего, решит проблему.

### Fabric - зависимости мода {#fabric-mod-dep}
Моды для Fabric часто требуют другие моды или определенные версии Fabric Loader. Обычно Fabric проверяет это перед запуском и сам пишет, чего не хватает, - но не всегда.

#### Неподходящие версии {#fabric-version-ranges}
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

#### Indium {#indium}
На Sodium до версии 0.6.0 моды, использующие Fabric Rendering API, падают, если не установлен мод [Indium](https://modrinth.com/mod/indium):
```log title="Пример лога"
// highlight-next-line
> Caused by: java.lang.NullPointerException: Cannot invoke "net.fabricmc.fabric.api.renderer.v1.Renderer.meshBuilder()" because the return value of "net.fabricmc.fabric.api.renderer.v1.RendererAccess.getRenderer()" is null
>   at me.pepperbell.continuity.impl.client.ProcessingContextImpl.<init>(ProcessingContextImpl.java:20) ~[continuity-3.0.0+1.19.4.jar:?]
```
Ключевая строка - `RendererAccess.getRenderer()` в тексте `NullPointerException`. Установите Indium, удалять упавший мод (здесь `continuity`) не нужно.
:::note
Начиная с Sodium 0.6.0 Indium не нужен, и эта ошибка неактуальна
:::

## Поврежденные файлы {#corrupted-files}

### Повреждение мода {#corruption-mod}
Файлы модов и самой игры могут повредиться или пропасть - из-за оборванной загрузки, антивируса или проблем с диском.

#### Поврежденный файл {#corrupted-file}
```log title="Пример лога"
Exception in thread "main" cpw.mods.niofs.union.UnionFileSystem$UncheckedIOException: java.util.zip.ZipException: zip END header not found
// highlight-next-line
Caused by: java.util.zip.ZipException: zip END header not found
    at jdk.zipfs/jdk.nio.zipfs.ZipFileSystem.findEND(ZipFileSystem.java:1315)

```
Ошибка `java.util.zip.ZipException: zip END header not found` в логе сигнализирует о повреждении файлов игры и/или модов. Воспользуйтесь галочкой "Обновить клиент", перекачайте моды с CurseForge/Modrinth.  
Если файлы снова оказываются повреждены после скачивания - проверьте диск на ошибки
:::tip[Особенности Fabric и Quilt]
Fabric и Quilt хранят часть данных игры в папках `.fabric` и `.cache` в папке игры. Если ошибка указывает на файл из этих папок - удалите папку, загрузчик создаст её заново. Скачивать такой файл повторно бесполезно
:::

#### Файл отсутствует {#missing-file}
Бывает, что нужного файла нет вовсе - чаще всего его удалил антивирус или не завершилась загрузка:
```log title="Пример лога"
// highlight-next-line
> Exception in thread "main" java.lang.module.FindException: Module org.apache.logging.log4j not found, required by cpw.mods.modlauncher
>   at java.base/java.lang.module.Resolver.findFail(Resolver.java:893)
```
```log title="Пример лога"
15:46:36,709 [MinecraftLauncher] Caught an exception
// highlight-next-line
net.legacylauncher.minecraft.launcher.MinecraftException: Classpath is not found: D:\Minecraft\Minecraft\game\libraries\at\yawk\lz4\lz4-java\1.8.1\lz4-java-1.8.1.jar
    at net.legacylauncher.minecraft.launcher.MinecraftLauncher.constructClassPath(MinecraftLauncher.java:1484)
```
Воспользуйтесь галочкой "Обновить клиент". Если файлы пропадают снова - проверьте [антивирус](./common#av-software)

### Повреждение конфигов {#corruption-config}
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
Если у вас есть исходная папка `config` (например, в архиве сборки) - лучше замените ею текущую.  
Некоторые моды хранят часть настроек в папке мира: если файла нет в папке `config`, поищите его в `saves/<название мира>/serverconfig`.