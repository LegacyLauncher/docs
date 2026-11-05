---
description: На что заменить OptiFine?
sidebar_position: 4
---
# Альтернативы OptiFine
OptiFine - крайне нестабильный мод, имеющий огромное количество проблем с несовместимостью с другими модификациями. \
На этой странице представлены моды, способные заменить функционал OptiFine.

## Оптимизация {#optimization}
* Sodium ([Fabric/NeoForge](https://modrinth.com/mod/sodium), [Forge](https://modrinth.com/mod/embeddium)) - основной слой оптимизации рендеринга и взаимодействия с видеокартой
    * Indium ([Fabric](https://modrinth.com/mod/indium)) - слой совместимости Sodium с модами, использующими Fabric Rendering API. Нужен только для Sodium до версии 0.6.0
    * Reese's Sodium Options ([Fabric](https://modrinth.com/mod/reeses-sodium-options), [Forge](https://modrinth.com/mod/textrues-embeddium-options)) - расширенные настройки для Sodium
    * Sodium Extra ([Fabric](https://modrinth.com/mod/sodium-extra), [Forge](https://modrinth.com/mod/rubidium-extra)) - более подробные настройки графики (например, анимаций, частиц, показа неба, погоды...)
* Cull Leaves ([Forge/Fabric](https://modrinth.com/mod/cull-leaves)) - аналог Smart Leaves
* Entity Culling ([Forge/Fabric](https://modrinth.com/mod/entityculling)) - отключает рендер невидимых для игрока существ
* Lithium ([Fabric](https://modrinth.com/mod/lithium), [Forge](https://modrinth.com/mod/canary), [Forge (другой порт)](https://modrinth.com/mod/radium)) - оптимизация внутриигрового сервера
* Phosphor ([Fabric](https://modrinth.com/mod/phosphor), [Forge](https://modrinth.com/mod/radon)) - оптимизация освещения. Не обновляется после 1.19
    :::warning[Данный мод конфликтует со Starlight]
    :::
* Starlight ([Fabric](https://modrinth.com/mod/starlight), [Forge](https://modrinth.com/mod/starlight-forge)) - улучшенная оптимизация освещения, но может быть несовместима с некоторыми модами. Начиная с 1.20 не дает особого эффекта
    :::warning[Данный мод конфликтует с Phosphor]
    :::
* FerriteCore ([Forge/Fabric](https://modrinth.com/mod/ferrite-core)) - оптимизация использования памяти
* VulkanMod ([Fabric](https://modrinth.com/mod/vulkanmod)) - заменяет OpenGL-рендер на реализацию через Vulkan
    :::danger[Обратите внимание!]
    Хотя этот мод способен значительно увеличить производительность игры, он [сломает все моды](https://github.com/xCollateral/VulkanMod/discussions/226), использующие OpenGL напрямую
    :::

## Функционал для ресурспаков {#features}
* LambDynamicLights ([Fabric](https://modrinth.com/mod/lambdynamiclights), [Forge](https://www.curseforge.com/minecraft/mc-mods/dynamiclights-reforged)) - динамическое освещение
* LambdaBetterGrass ([Fabric](https://modrinth.com/mod/lambdabettergrass)) - улучшенное отображение травы и снега
* OptiGUI ([Fabric](https://modrinth.com/mod/optigui)) - поддержка модификации интерфейса ресурспаками
* Animatica ([Fabric](https://modrinth.com/mod/animatica), [Forge](https://www.curseforge.com/minecraft/mc-mods/animaticareforged)) - поддержка анимации интерфейса ресурспаками из OptiFine
* MoreMCmeta ([Forge/Fabric](https://modrinth.com/mod/moremcmeta)) - поддержка анимаций из OptiFine и анимированных текстур (аналог Animatica)
* Colormatic ([Fabric](https://modrinth.com/mod/colormatic)) - OptiFine Custom Colors
* Entity Model Features ([Forge/Fabric](https://modrinth.com/mod/entity-model-features)) - Custom Entity Models из OptiFine
* CIT Resewn ([Fabric](https://modrinth.com/mod/cit-resewn)) - Custom Item Textures из OptiFine
* Entity Texture Features ([Forge/Fabric](https://modrinth.com/mod/entitytexturefeatures)) - Custom Entity Textures, Random Entity Textures из OptiFine
* Continuity ([Fabric](https://modrinth.com/mod/continuity), [Forge](https://modrinth.com/mod/connectedness)) - Connected Textures из OptiFine



## Шейдеры {#shaders}
* Iris ([Fabric](https://modrinth.com/mod/iris), [Forge](https://modrinth.com/mod/oculus)) - аддон для Sodium, поддерживает шейдеры в совместимом с OptiFine формате
    * Vulkanite ([Fabric](https://modrinth.com/mod/vulkanite-mod)) - аддон для Iris, добавляет поддержку **аппаратного рейтрейсинга** в Minecraft
        :::danger[Обратите внимание!]
        Для работы Vulkanite необходима видеокарта с аппаратной поддержкой рейтрейсинга, например, NVIDIA RTX. \
        Также, этот мод находится **на самой ранней стадии разработки** и **максимально нестабилен**.
        :::
* Canvas ([Fabric/Quilt](https://modrinth.com/mod/canvas)) - альтернативный движок рендеринга для Minecraft с поддержкой шейдеров в собственном формате
    :::info[Обратите внимание!]
    Шейдеры для OptiFine не будут работать с Canvas. Canvas заявляет полную совместимость с Fabric API, но имеет множество проблем с совместимостью с другими модами.
    :::