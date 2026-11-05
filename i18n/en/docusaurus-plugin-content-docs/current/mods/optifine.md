---
description: OptiFine installation manual
---
# OptiFine Installation
:::tip
You don't have to install OptiFine manually. There are versions with pre-installed recommended OptiFine builds in the Legacy Launcher
:::
:::danger[OptiFine Previews]
There are preview versions of OptiFine available on the OptiFine download page. They are highly unstable and are not recommended for installation
:::
:::note[Downloading OptiFine with fewer ads]
We recommend that you use the "Mirror" button instead of the "Download" so you don't see any extra ads
:::

## Standalone installation {#standalone}
1. Make sure you have [Java installed](../faq/java)
2. Download non-modified ("vanilla") Minecraft version using Legacy Launcher
3. Download required OptiFine version from [the website](https://optifine.net/downloads)
4. Launch OptiFine installer by double-clicking it
5. Install OptiFine. It will be installed as separate version
    1. Make sure the game folder path in the "Folder" field is the same as in the launcher settings
        :::info[How to find the game folder?]
        Start Legacy Launcher and click the button with the folder icon. \
        *If you have the "Subfolders" feature enabled, select "Open Minecraft root folder"*. \
        You can also find it in the launcher settings, in the "Game folder" field
        :::
    2. Click "Install" button
5. Restart the launcher
6. Select newly installed OptiFine version
    :::tip[How can I find it?]
    Manually installed OptiFine version will be named like `XXX-OptiFine_YYY`, where `XXX` is the Minecraft version and `YYY` is the OptiFine version, e.g. `1.20.1-OptiFine_HD_U_I6`
    :::
7. Launch the game

## Installation using modloader {#mod}
### Forge
The official supported modloader is Forge.
You can check if the required version of Forge is supported on the [OptiFine downloads page](https://optifine.net/downloads) in the second to last column.
:::info[Forge support]
Make sure the supported Forge version is neither empty nor "Forge N/A" - either means that the selected OptiFine version **does not support** Forge installation
:::
:::warning
OptiFine is a highly unstable, highly invasive modification. Consider using [alternatives](../faq/optifine-alternatives)
:::

1. Make sure you have [Java installed](../faq/java)
2. Download non-modified ("vanilla") Minecraft version using Legacy Launcher
3. [Install](./forge) required Forge version
4. Download required OptiFine version from [the website](https://optifine.net/downloads)
5. Launch OptiFine installer by double-clicking it
6. Install OptiFine to mods folder
    1. Make sure the game folder path in the "Folder" field is the same as in the launcher settings
        :::info[How to find the game folder?]
        Start Legacy Launcher and click the button with the folder icon. \
        *If you have the "Subfolders" feature enabled, select "Open Minecraft root folder"*. \
        You can also find it in the launcher settings, in the "Game folder" field
        :::
    2. Click "Extract" button
    3. In the window select the mods folder
    4. Make sure OptiFine mod file appeared in the selected folder
        :::tip
        You don't have to extract OptiFine mod to mods folder. You can specify any folder you want and then just move the file to wherever you need it
        :::
7. Select installed on step 3 Forge version
8. Launch the game

### Fabric
:::danger[Unsupported method!]
OptiFine does not support Fabric installation. This method **is not recommended** to use as it may break most Fabric mods. Consider using [alternatives](../faq/optifine-alternatives)
:::
1.  [Install](./fabric) required Fabric version
2. Download [OptiFabric](https://www.curseforge.com/minecraft/mc-mods/optifabric) mod
3. Download OptiFine installer from [the website](https://optifine.net/downloads)
4. Move both OptiFabric and OptiFine to mods folder
5. Start the launcher, select Fabric version and launch the game
