
# Installation on Chrome OS

:::tip[Note]
Mojang has released [a version of Minecraft for Chrome OS](https://play.google.com/store/apps/details?id=com.mojang.minecraftpe), which is sold separately. It is likely that this version will run and perform better on your device than the Java Edition.
:::

:::warning[Please note!]
Before you start, ensure that your device can [run Linux applications](https://www.chromium.org/chromium-os/chrome-os-systems-supporting-linux/). Typically, this includes computers running on Chrome OS Flex, or Chromebook devices released in 2019 or later. If your Chromebook is owned by an organization (such as a school or university), its administrator may have disabled this functionality.
:::

In this article, we will try to show how you can run Legacy Launcher for Minecraft: Java Edition on supported Chrome OS devices.

1. [Set up the Linux environment](https://support.google.com/chromebook/answer/9145439) on your device. ![Developer menu in Chrome OS](/img/chromeos_1.png) ![Installing Linux on Chrome OS](/img/chromeos_2.png)
2. A Terminal window will open. ![Terminal Window](/img/chromeos_3.png)
3. Enter the following commands to install Java and "wake up" X11:
   ```shell
   sudo apt update
   sudo apt install openjdk-17-jre x11-apps
   ```
   ![Terminal Window](/img/chromeos_4.png)
4. Download the launcher to your working directory:
   ```shell
   wget https://llaun.ch/jar -O LL.jar
   chmod +x LL.jar
   ```
   ![Terminal Window](/img/chromeos_5.png)
5. Start the launcher:
   ```shell
   java -jar LL.jar
   ```
   ![Launcher Window](/img/chromeos_6.png)
6. Create an account and launch the game
   ![Launcher Window](/img/chromeos_7.png)

:::warning[Please note!]
Your experience may vary from "terrible" to "acceptable," as Chrome OS devices typically have relatively weak specifications.
[In any case, let us know](https://llaun.ch/discord/intl) if you manage to get it working.
:::

If everything works, you can restart the launcher after closing the game by entering the following command in the Terminal:
```shell
java -jar LL.jar
```
