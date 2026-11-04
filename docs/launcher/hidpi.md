---
description: Поддержка HiDPI в Legacy Launcher
---
# HiDPI
:::info[Обратите внимание!]
Legacy Launcher поддерживает HiDPI начиная с версии 1.123.0
:::

## Windows и macOS {#windows-macos}
:::note[Обратите внимание!]
Для поддержки HiDPI в Windows и macOS требуется Java 11 или новее
:::
![Скриншот окна лаунчера в Windows](./img/hidpi_win.jpg)
Масштаб интерфейса учитывается автоматически, начиная с Java 11.

## Linux {#linux}
:::note[Обратите внимание!]
Для поддержки HiDPI в Linux требуется Java 11.0.12 и новее, либо Java 17 и новее
:::
![Скриншот окна лаунчера в Linux](./img/hidpi_linux.png)
Лаунчер тестировался в среде GNOME 40 с GTKLookAndFeel на AdoptOpenJDK 11.0.12.

Если лаунчер запускается с обычным L&F и/или без масштабирования, его можно запустить так:
1. Задайте [файл с аргументами](./portable) (задайте переменную `TL_UI_SCALE` как число, напр. `1.25` или `2`)
    ```bash
    TL_UI_SCALE=
    [ -z "$TL_UI_SCALE" ] && echo "Don't just copy-paste. Please actually set TL_UI_SCALE" >&2 || cat <<EOF > tl.bootargs
    -Dsun.java2d.uiScale=$TL_UI_SCALE
    -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel
    -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel
    EOF
    ```
2. Запустите лаунчер
    ```bash
    java -jar LegacyLauncher.jar
    ```