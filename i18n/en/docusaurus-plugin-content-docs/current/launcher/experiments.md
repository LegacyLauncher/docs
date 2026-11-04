---
description: Experimental launcher features
---
# Experimental features
:::info
Experiments are only available in Legacy Launcher 160.0 or newer
:::

## What is it? {#what}
**Experiments** are potentially unstable features that we are not ready to enable for all users by default

## How to enable? {#enable}
1. Close Legacy Launcher
2. Open the Legacy Launcher configuration file with any text editor (e.g. [Notepad++](https://notepad-plus-plus.org/downloads/)).
    :::tip[Where can I find the Legacy Launcher configuration file?]
    Most often it will be located either in the `.tlauncher/legacy.properties` file, or in the `tl.properties` file in the launcher install (e.g. `.tlauncher/legacy/Minecraft/tl.properties`)
    :::
3. Find the `experiments.available` line in the opened file - this is the list of available experiments
4. Find the `experiments.enabled` line in the opened file and list the experiments you want, separated by `;`
    ```properties title="legacy.properties"
    # Available experiments list
    experiments.available=zgc;zgc_generational;shenandoah;tenuring;max_xms;updated_lwjgl;updated_jna
    # "none" will disable all experiments
    experiments.enabled=none
    # Example to enable "updated_lwjgl" and "updated_jna" experiments
    experiments.enabled=updated_lwjgl;updated_jna
    ```
5. Start Legacy Launcher

## Experiments list {#list}
:::note
`zgc`, `zgc_generational`, `shenandoah`, `tenuring` and `max_xms` experiments require "optimized arguments" feature
:::
:::warning
`zgc` and `shenandoah` experiments were moved to the updated "Optimized arguments" option in launcher version 161.4 and are no longer considered experimental
:::
* `zgc` - replaces CMS/G1 in the "optimized arguments" with ZGC. This garbage collector is quite efficient, but requires a very powerful CPU. ZGC was automatically enabled in older versions of LL on powerful PCs. Requires Java 15 or newer.
* `zgc_generational` - enables "generations" support in ZGC, which should improve its performance. Requires Java 21 or newer and a `zgc` experiment.
* `shenandoah` - replaces CMS/G1/ZGC in "optimized arguments" with Shenandoah. This garbage collector should be best suited for Minecraft, as it claims to provide the shortest GC pause times. Requires Java 11.0.9 or newer.
* `tenuring` - Changes the MaxTenuringThreshold parameter of the garbage collector so that quickly aging data in game memory is "aged" slower and cleared faster. Should reduce the stutters duration during memory cleanup. *When using G1, these parameters are applied by default, the experiment enables this feature for other garbage collectors*.
* `max_xms` - allocates the entire selected RAM amount at the game startup.
* `updated_lwjgl` - Forcibly updates LWJGL on versions using LWJGL3 to 3.3.2. **Recommended for solving Apple Silicon (M1/M2/M3/...) issues**.
* `updated_jna` - Forcibly updates JNA on versions that use it to 5.13.0. **Recommended for solving macOS issues**.
