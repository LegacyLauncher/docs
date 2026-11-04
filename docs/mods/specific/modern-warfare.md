---
description: Крашится игра после установки мода Modern Warfare
---
# Vic's Modern Warfare
:::note[В чём проблема?]
Vic's Modern Warfare частично несовместим с последней версией Forge, однако эту проблему можно решить
:::

## Изменение настроек Forge {#config-tweaks}
:::tip[Этот способ является рекомендуемым]
:::
1. Откройте папку игры. Это можно сделать кнопкой в лаунчере.
2. Перейдите в папку `config`
3. Найдите файл `forge.cfg` и откройте его любым текстовым редактором (например, [Notepad++](https://notepad-plus-plus.org/downloads/))
4. В открывшемся файле найдите строку `B:allowEmissiveItems=true` и замените значение `true` на `false`
```ini title="config/forge.cfg"
B:allowEmissiveItems=false
```
5. Сохраните файл и запустите игру

## Установка OptiFine {#optibad}
:::warning[Этот способ не является рекомендуемым]
:::
Установка OptiFine способна исправить данную проблему. Установите OptiFine по [инструкции](../optifine#forge)

## Установка более старой версии Forge {#downgrading-forge}
Если у вас нет модов, требующих новые версии Forge, вы можете установить Forge версии `14.23.4.2759` по [инструкции](../forge)