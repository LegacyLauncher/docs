---
description: The game crashes after Modern Warfare mod installation
---
# Vic's Modern Warfare
:::note[What's the problem?]
Vic's Modern Warfare is not fully compatible with latest Forge versions
:::

## Forge config tweaks {#config-tweaks}
:::tip[Recommended method]
:::
1. Open game folder
2. Go to `config` folder
3. Find `forge.cfg` file and open it with any text editor (e.g. [Notepad++](https://notepad-plus-plus.org/downloads/))
    :::warning
    Do not use any office suite!
    :::
4. In this file in the string `B:allowEmissiveItems=true` replace `true` with `false`
```ini title="config/forge.cfg"
B:allowEmissiveItems=false
```
5. Save the file and launch the game

## OptiFine installation {#optibad}
:::warning[This method is NOT recommended]
:::
OptiFine somehow fixes this problem. You can install OptiFine using [this manual](../optifine#forge)

## Downgrading Forge {#downgrading-forge}
If you don't have mods that require newer Forge versions, you may try to install Forge version `14.23.4.2759` using [this manual](../forge) to work around this issue