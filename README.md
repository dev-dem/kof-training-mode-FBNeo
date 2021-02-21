# The King of Fighters Training Mode for FB/Fightcade

![Screenshot](https://i.ibb.co/9v483Tj/training-screenshot.png)

I just recently discovered lua scripting and this is my first attempt of a training mode for KOF.  
Big thanks to the contributors of these trainings that helped me to write this code:

https://github.com/Jesuszilla/mame-rr-scripts  
https://github.com/maximusmaxy/JoJoban-Training-Mode-Menu-FBNeo  
https://github.com/peon2/fbneo-spectating  
https://github.com/peon2/fbneo-training-mode


### Features

- OSD
- Input display
- Hitboxes
- Record Input
- Play Input

### Supported Games 

- The King of Fighters '96

### Installation

#### Step 1: Download the script

Working folder

```
#if you don't have the scripts folder please create it
FightcadeFolder\emulator\fbneo\scripts
```

you can use git

```
#make sure to run this in the working folder
git clone https://github.com/dev-dem/kof-training-mode-FBNeo.git 
```

or you can [download](https://github.com/dev-dem/kof-training-mode-FBNeo/releases/download/0.5.0/kof-training-mode-FBNeo-0.5.0.zip) and extract the folder into the working folder 

#### Step 2: Execute Fightcade2 FBNeo emulator
You can click on the Fightcade2 "TEST GAME" button in the supported games rooms or execute it manually

```
FightcadeFolder\emulator\fbneo\fcadefbneo.exe
```

#### Step 3: Run Supported game 

for instance: The King of Fighters '96

```
Game -> load game ->  kof96
```

#### Step 4: Video blitter settings

```
Video -> Select blittler ->  DirectX9Alt
```

#### Step 5: Execute the script

```
Game -> Lua Scripting ->  New Lua Script Window
```
Browse **training.lua** file or browse **spectator.lua** file if you want to use the script in a replay or as spectator and click on **Run** button

![Screenshot2](https://i.ibb.co/Jk3MyKZ/training-screenshot2.png)

### Shortcuts

- alt + 1 = Toggle OSD display
- alt + 2 = Toggle inputs display
- alt + 3 = Toggle hitboxes
- alt + 4 = Record inputs from player1
- alt + 5 = Playback inputs on player2

### Default Options
[training.lua](https://github.com/dev-dem/kof-training-mode-FBNeo/blob/master/training.lua#L19) has the default options, you can change it and save the file
```
local options = {
	replay = false,   -- disables infinite time/health/record-play functionality
	osdDisplay = 3,   -- 0 = disabled  1 = player1  2 = player2  3 = both  
	inputDisplay = 3, -- 0 = disabled  1 = player1  2 = player2  3 = both
	hitboxDisplay = 1 -- 0 = disabled  1 = hurtbox and hitbox  2 = adds pushbox  3 = adds throwable box  
}
```
### Next Releases

- Support more kof versions

### Contact

Follow me on [Twitter](https://twitter.com/Arpeggiate)  
Subscribe to my [Youtube](https://www.youtube.com/user/DemKusa) channel

### Bugs

If you have any issues or improvements please create a new item [here](https://github.com/dev-dem/kof-training-mode-FBNeo/issues)