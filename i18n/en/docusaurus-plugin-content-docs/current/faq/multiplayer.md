---
description: How to play with friends online?
---
# Multiplayer
Minecraft is a game that you can play with your friends. So how do you do it?
:::warning
If you play with mods, you and your friends must have **the same set of mods**, otherwise you won't be able to connect to each other. The exception is some client mods, such as OptiFine or Sodium.
:::

## Public server {#public-server}
This is the easiest option. Find a public server to your liking (for example, in the list of servers in the Launcher), invite your friends there (or find your friends on this server) and enjoy the game.

To connect to a public server from the list in the Launcher, just click the button next to the ad of the corresponding server.

If you were given the address of a public server or you found one in the Internet and want to connect - open the game, go to the "Multiplayer" section, click the "Add" button and enter the desired server name and address. After clicking "Done" the server will appear in the list in the "Multiplayer".

## Mods {#mods}
### WorldHost {#mods-worldhost}
Download: [Modrinth](https://modrinth.com/mod/world-host)

This mod is considered the most universal. To connect to each other use its "friends system" or `/worldhost tempip` (gives temporary address for 60 seconds, requires router to support `uPnP` function) and `/worldhost ip` (permanent address) commands.

### e4mc {#mods-e4mc}
Download: [Modrinth](https://modrinth.com/mod/e4mc)

Install the mod and use the "Open to LAN" button in the game pause menu. An address will appear in the chat, which will allow other players to connect to your world.

### NgrokLAN {#mods-ngrok}
Download: [Modrinth](https://modrinth.com/mod/ngrok-lan)

This mod is similar to e4mc, but uses the [Ngrok](https://ngrok.com/) service to publish your server. The mod requires setup and will not work "out of the box". Instructions on how to setup the mod can be found on [its page](https://modrinth.com/mod/ngrok-lan).

### LAN Extender {#mods-lan-extender}
Download: [Modrinth](https://modrinth.com/mod/lan-extender)

NgrokLAN alternative, also uses [Ngrok](https://ngrok.com/) service, but easier to set up. There's a detailed instruction with pictures on the [mod page](https://modrinth.com/mod/lan-extender).

### LAN World Plug-n-Play {#mods-lan-plug-n-play}
Download: [Modrinth](https://modrinth.com/mod/mcwifipnp)

Allows fine-tuning of the opened world (e.g. you can disable PvP or disable Minecraft Premium requirement) directly from the game menu. Requires the router to support the `uPnP' feature.

## LAN {#lan}
This is the simplest, and at the same time the most complicated method. The simplicity of it is that you don't need to do anything - you just need to be on the same *local network* - that is, roughly speaking, connected to the same router or Wi-Fi network. Just open the world to the LAN with the button of the same name in the game menu - and your world will be visible on all computers in your house.

### LAN emulation {#lan-emulation}
If you are in different local networks, the local network for the game can be simulated using special programs. This method is much more complicated than those described above, and its use can lead to bad multiplayer experience (e.g. high ping).

You can use programs like [Radmin VPN](https://www.radmin-vpn.com/) or [Hamachi](https://vpn.net/) to emulate a local network.
:::note
This guide does not cover the use of such programs at this time. If you have the opportunity - help us to complete this section with instructions
:::

## Port forwarding {#port-forwarding}
If you have a "public" ("external") IP address, you can try to open the world to the network by forwarding the port received by the game when opening the world to LAN.  
This guide does not cover this method, as the necessary steps depend greatly on the model of router you are using. As a rule, you need to find the NAT or "port forwarding" settings, enter the IP address or MAC address of your computer and enter the required port numbers.

### Port tunneling {#port-tunneling}
There are some services that allows you to publish your port on one of their public IPs. You can use it to host your Minecraft world/server. Known services are [PlayIt](https://playit.gg) and [Ngrok](https://ngrok.com/)

## Free hosting {#free-hosting}
You can try to create a public server for yourself and your friends on free hostings. Typically, free hostings are very limited in resources, so the game on such servers will be associated with discomfort and lags. Also, in most cases, you will not be able to install an interesting modpack because of the limited resources of the server. In addition, some free hosting limit the uptime, and your server will be forcibly stopped after some time after launching.  
The list of free hosting sites we know of: [FalixNodes](https://falixnodes.net/), [Aternos](https://aternos.org/), [server.pro](https://server.pro/), [Minehut](https://minehut.com/).  
Instructions on how to set up the server can usually be found on the hosting site itself.

## Paid hosting {#paid-hosting}
If you and your friends don't mind spending some money on hosting, you can find a paid game hosting service to suit your needs and run a server on it. As a rule, you will have full access to the server files, and can install any set of mods (provided that you have enough money to pay for a server of suitable capacity). From the pros of this method - non-stop server operation and independence from the players' power.  
You can find situable paid Minecraft hosting on the web. As a rule, hosting already has instructions on how to set up the server and they are unnecessary in this guide.

## Dedicated server {#dedicated-server}
This is the most complicated option for real pros!  
A dedicated server can be run on your home PC or on a rented server. You can create it only for your local network (for example, to improve game client performance), or open for friends through a virtual LAN or public IP.  
To run a dedicated game server, you will need to [download the server itself](https://www.minecraft.net/download/server) and configure it according to [this article](https://minecraft.wiki/w/Tutorials/Setting_up_a_server).  
Most [modloaders](/tags/modloader) support installation as a game server.

## Common issues {#troubleshooting}
### Invalid session (try restarting your game) {#invalid-session}
The server you are connecting to allows only Minecraft Premium players.
* If this is your server, change the `online-mode` parameter to `false`.
:::danger
Attention! This will allow **any** player to connect under **any** nickname!
:::
:::tip
Perhaps you should think about using [Ely.by authorization for servers](https://docs.ely.by/en/minecraft-auth.html#id4).
:::
* If it's a public server - most likely you can only log in to it from a **Minecraft Premium account**
* If you are connecting to a friend's world - you both need to use either **Minecraft Premium** accounts or **Ely.by** accounts. You can also try installing a mod that allows you to customize the world opening settings for the network.

### Connection refused: no further information {#connection-refused}
If this problem occurs on all servers, it means that something on your PC (antivirus or firewall) is blocking the game from connecting to the servers. Try temporarily disabling antivirus and firewall or add Java to their exceptions.  
If the problem appears only with a particular server, it is probably a problem on its side - contact the server administration for further help

### We are on the same LAN, but I can't see my friend's world! {#invisible-lan}
Check that you can connect to other servers. If not - most likely something on your PC (antivirus or firewall) is blocking the game connection to the servers. Try to temporarily disable antivirus and firewall or add Java to their exceptions. Otherwise, you need to perform similar actions on your friend's side.

### Game crashes when connecting to a server! {#server-crash}
* **Uninstall OptiFine**. It causes most crashes in multiplayer.
* Remove cheats, "PVP software" and "visuals".
* Make sure you have the same set of mods installed as on the server.

Nothing helps? You can contact our [technical support](../support/game).

### I logged into the server and can't move, and after a few seconds I get kicked out! {#server-kicks}
Take a close look at the game chat. Most likely, the server required you to register and kicked you out for inactivity.
:::warning[Can't register? Exceeded the number of registrations?]
It is not uncommon for several different users from the same apartment building, neighborhood *or even city* to use the same *IP address*. In this case, the server may refuse to register a new account. Contact the server administration to resolve this issue.
:::

### The server asks me for my password, but I don't know any! {#server-password}
Most cracked servers use plugins to protect user accounts.  
If you **first** logged into the server and it asks you to *enter password* - most likely someone has already registered on this server under your nickname. Change your nickname or contact the server administration.

### I've been banned on the server! {#server-banned}
Contact the server administration. We provide the game itself and are in no way connected with any game servers.

### I bought something on a server website for real money and got nothing! {#server-shop}
Contact the server administration. We provide the game itself and are in no way connected with any game servers. You can also ask your bank for chargeback.

### I logged on to the server and it's all gone! {#server-wipe}
Check that you are logging into the server from the correct account.  
If the account is correct, contact the server administration for further assistance.

### The other player is bullying me! {#server-griefing}
Contact the server administration to resolve this issue.

### I lost my account from the Launcher and it had all the server items and purchases on it! {#missing-accounts}
Information about your actions on a server is stored **exclusively on that server**. Log in to the server under the same nickname and all your progress and purchases will not be lost.
