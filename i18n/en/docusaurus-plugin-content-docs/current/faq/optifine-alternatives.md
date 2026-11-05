---
description: Replacing OptiFine
sidebar_position: 4
---
# OptiFine Alternatives
OptiFine is an extremely unstable mod that has a huge number of incompatibility problems with other modifications. \
This page contains mods that can replace the functionality of OptiFine.

## Optimization {#optimization}
* Sodium ([Fabric/NeoForge](https://modrinth.com/mod/sodium), [Forge](https://modrinth.com/mod/embeddium)) - the core rendering optimization layer
    * Indium ([Fabric](https://modrinth.com/mod/indium)) - Sodium compatibility layer with mods using Fabric Rendering API. Only needed for Sodium before 0.6.0
    * Reese's Sodium Options ([Fabric](https://modrinth.com/mod/reeses-sodium-options), [Forge](https://modrinth.com/mod/textrues-embeddium-options)) - advanced Sodium settings
    * Sodium Extra ([Fabric](https://modrinth.com/mod/sodium-extra), [Forge](https://modrinth.com/mod/rubidium-extra)) - more detailed graphics configuration (e.g. animations, particles, sky, weather...)
* Cull Leaves ([Forge/Fabric](https://modrinth.com/mod/cull-leaves)) - Smart Leaves alternative
* Entity Culling ([Forge/Fabric](https://modrinth.com/mod/entityculling)) - disables rendering of creatures invisible to the player
* Lithium: ([Fabric](https://modrinth.com/mod/lithium), [Forge](https://modrinth.com/mod/canary), [Forge (another port)](https://modrinth.com/mod/radium)) - in-game server optimization
* Phosphor ([Fabric](https://modrinth.com/mod/phosphor), [Forge](https://modrinth.com/mod/radon)) - lighting optimization. Not updated after 1.19
    :::warning[The mod conflicts with Starlight]
    :::
* Starlight ([Fabric](https://modrinth.com/mod/starlight), [Forge](https://modrinth.com/mod/starlight-forge)) - improved lighting optimization, but may not be compatible with some mods. Has little effect since 1.20
    :::warning[The mod conflicts with Phosphor]
    :::
* FerriteCore ([Forge/Fabric](https://modrinth.com/mod/ferrite-core)) - memory usage optimization
* VulkanMod ([Fabric](https://modrinth.com/mod/vulkanmod)) - replaces the OpenGL renderer with a Vulkan implementation
    :::danger[Warning!]
    While this mod can greatly increase game performance, [it will break all mods](https://github.com/xCollateral/VulkanMod/discussions/226) that use OpenGL directly
    :::

## Resourcepack Features {#features}
* LambDynamicLights ([Fabric](https://modrinth.com/mod/lambdynamiclights), [Forge](https://www.curseforge.com/minecraft/mc-mods/dynamiclights-reforged)) - dynamic lighting
* LambdaBetterGrass ([Fabric](https://modrinth.com/mod/lambdabettergrass)) - improved grass and snow visualization
* OptiGUI ([Fabric](https://modrinth.com/mod/optigui)) - interface modification support via resourcepacks
* Animatica ([Fabric](https://modrinth.com/mod/animatica), [Forge](https://www.curseforge.com/minecraft/mc-mods/animaticareforged)) - interface animation support via OptiFine resource packs
* MoreMCmeta ([Forge/Fabric](https://modrinth.com/mod/moremcmeta)) - OptiFine animations and animated textures support (Animatica alternative)
* Colormatic ([Fabric](https://modrinth.com/mod/colormatic)) - OptiFine Custom Colors
* Entity Model Features ([Forge/Fabric](https://modrinth.com/mod/entity-model-features)) - OptiFine Custom Entity Models
* CIT Resewn ([Fabric](https://modrinth.com/mod/cit-resewn)) - OptiFine Custom Item Textures
* Entity Texture Features ([Forge/Fabric](https://modrinth.com/mod/entitytexturefeatures)) - OptiFine Custom Entity Textures and Random Entity Textures
* Continuity ([Fabric](https://modrinth.com/mod/continuity), [Forge](https://modrinth.com/mod/connectedness)) - OptiFine Connected Textures

## Shaders {#shaders}
* Iris ([Fabric](https://modrinth.com/mod/iris), [Forge](https://modrinth.com/mod/oculus)) - Sodium addon, supports shaders in OptiFine compatible format
    * Vulkanite ([Fabric](https://modrinth.com/mod/vulkanite-mod)) - Iris addon which adds support for **hardware-accelerated raytracing** in Minecraft
        :::danger[Warning!]
        Vulkanite requires a graphics card with hardware raytracing support, such as NVIDIA RTX. \
        Also, this mod is **very early in development** and **is extremely unstable**.
        :::
* Canvas ([Fabric/Quilt](https://modrinth.com/mod/canvas)) - an alternative rendering engine for Minecraft with custom (non-OptiFine-compatible) shaders support
    :::info
    OptiFine shaders will not work with Canvas. Canvas states full compatibility with the Fabric API, but has many compatibility issues with other mods.
    :::
