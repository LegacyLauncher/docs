---
description: How to customize Java
---
# Using custom Java versions
Legacy Launcher uses Mojang's recommended Java builds by Microsoft. This guide will help you to replace these Java versions with the ones of your choice.
:::info
This page requires localization of screenshots. Feel free to [open a PR](https://github.com/LegacyLauncher/docs) if you want to help
:::

## How to? {#how-to}
1. Install required Minecraft version
2. Open launcher settings, select "Minecraft" tab and open Java settings
    ![Settings => Minecraft => Java => Java => "Customize"](./img/override-jre-0.png)
3. Select "Recommended" option
    ![Select "Recommended" Java](./img/override-jre-1.png)
4. Click "open folder"
    ![Open folder](./img/override-jre-2.png)
5. In the folder, create a file named `override`, e.g. `override.txt`
    ![Creating an `override` file](./img/override-jre-3.png)
6. Done! This Java version is customized, and can be freely modified or replaced
:::tip[Where I can get alternative Java distributions?]
You can download alternate Java distributions from their developers' websites, such as [Temurin](https://adoptium.net/temurin/releases/?package=jre) and [Azul](https://www.azul.com/downloads/#downloads-table-zulu). *You should download the **archive**, not the installer*.
:::

## Simplified method {#how-to-simplified}
Due to complaints about the stability of Mojang recommended Java builds we have prepared a ready-to-use package to replace Java with more stable ones.
1. Download the archive:
    * [For 32-bit Windows](https://disk.yandex.ru/d/xcXWahjDYbKqKg)
    * [For 64-bit Windows](https://disk.yandex.ru/d/6sEKgkJNeT90fA)
    :::note[Sources].
    Java versions for these archives are taken from open sources: [Adoptium Temurin](https://adoptium.net/temurin/releases/?package=jre) (Java 8, Java 17) and [AdoptOpenJDK](https://github.com/AdoptOpenJDK/openjdk16-binaries/) (Java 16)
    :::
2. Open the launcher settings, select "Minecraft" tab and go to Java settings
    ![Settings => Minecraft => Java => Java => "Customize"](./img/override-jre-0.png).
3. In the window that opens, select the "Recommended" option
    ![Select "Recommended" Java](./img/override-jre-1.png)
4. Click "Open Folder"
    ![Open folder](./img/override-jre-2.png)
5. In the opened folder, **twice move up a level**.
    :::tip
    If you see folders named `java-runtime-alpha`, `java-runtime-beta`, `java-runtime-gamma`, `jre-legacy` then you have done everything correctly
    :::
    :::warning
    If you see the `.version` file next to a folder and/or don't see any other Java folders, or see `lib` and `bin` folders - you're probably in the wrong folder
    :::
6. Replace folder contents with the one from the downloaded archive.
7. Run the launcher and the game
