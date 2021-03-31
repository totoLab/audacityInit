# Audacity Init Project
Little script that initialieses an arbitrary directory structure that suits my needs for audio editing for my church recordings.

### SYNOPSIS <br />
audacityInitProject [OPTION]  <br />

You must enter one option when running the script.

### OPTIONS <br />
- `i` creates the directories the project following a certain structure
- `f` zips everything using zip

`"i" option`:
This option creates interactively the structure asking where to put the origin. <br />
```
Structure: "defaultParentFolder/name-of-the-project/projectData/output/"
```
I usually import the only .wav file in "<name-of-the-project>/" and save the project file in "projectData/", then when exporting parts of the recordings I put them in "output/".

`"f" option`:
This option zips "projectData/" and the .wav file as individual archives, you'll have to remove original folders manually <br />
(optional: the scripts is going to ask if you to zip the "output/" folder, moving it somewhere else based on your needs - enabled by default).

### DEPENDENCIES
```
zenity 7z
```