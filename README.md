# Bulk DeOldify with AutoIt

This is an implementation of a much requested feature (three whole issues begged for it since 2021: [one](https://github.com/ColorfulSoft/DeOldify.NET/issues/12), [two](https://github.com/ColorfulSoft/DeOldify.NET/issues/19), [three](https://github.com/ColorfulSoft/DeOldify.NET/issues/22)) that allows to process a folder of photos automatically. Let this hackish workaround exist until folks from DeOldify incorporate this feature into DeOldify itself.

This script should work well on Windows. Other OSes will require some tweaks to the script such as changes in the class names and the like.

To make use of this script you need to install AutoIt from [this page](https://www.autoitscript.com/site/autoit/downloads/) (select the AutoIt Full Installation software). Then build your desired version of [DeOldify](https://github.com/ColorfulSoft/DeOldify.NET) into the `.exe` file. Place both the `bulk-deoldify.au3` script and the built exe file to the folder where your black and white photos are located and double-click the script. Also, to ensure proper working conditions for the script close all windows before lauching the script and don't touch your mouse thereafter. In case the script stopped unexpectedly just kill it and relaunch - it will resume the process.

## Instuctions to build DeOldify:
Run the following commands in the console:
```
git clone https://https://github.com/polomoshnov/DeOldify.NET.git
cd DeOldify.NET
wget https://github.com/ColorfulSoft/DeOldify.NET/releases/download/Weights/Artistic.model -O Implementation/src/Resources/Artistic.model
```

Then go to `DeOldify.NET\Implementation` and double-click `Compile.artistic.simd.float.bat`.

Finally, go to `DeOldify.NET\Implementation\Release` and grab the exe file.