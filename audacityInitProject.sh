#!/bin/sh
#defaults here /// create a folder in Music/church with the date of the recording and in there projectData
recordingDate="dateDummy"
defaultParent="$HOME/Music/church"
dependencies=( "zenity" "7z")
# start a project with these fancy functions U.U
importRawRecording () {
    rawFile="$(zenity --file-selection --title "Import a raw recording file")"

    cp $rawFile $1
} 

folderStructure() {
    mkdir "$1/$2"
    mkdir "$1/$2/projectData/"
    mkdir "$1/$2/projectData/output"
    importRawRecording "$1/$2/"
}


initialSetup() {
    read -p "What is this project called? " recordingDate

    read -p "Do you want to use the default folder ($defaultParent)? [Y/n] " answer
    answer=${answer:-y}

    if [ "$answer" != "${answer#[Yy]}" ] ;then
        parent=$defaultParent
    else
        parent="$(zenity --file-selection --directory)"
    fi

    folderStructure $parent $recordingDate
}
# finished the project? welcome to this section!
outputExport(){
    newName="output${1}"
    cp -r $defaultParent/$1/projectData/output/ $2/$newName
    cd $2 && 7z a "${newName}.7z" "$newName/" && rm -Ir $newName
}

zipEverything(){
    cd "$defaultParent/$1/" && 7z a projectData.7z "projectData/"
    7z a "original${1}.7z" *.wav
}

workFinished(){
    read -p "Press enter and select your project " dummy
    project="$(zenity --file-selection --directory)"
    checkForStructure $project
    project="$(basename "$project")"
    read -p "Have you finished with this project? [y/N] " answer
    answer=${answer:-n}

    if [ "$answer" != "${answer#[Nn]}" ] ;then
        echo "Take your time."
    elif [ "$answer" != "${answer#[Yy]}" ] ; then
        echo "Well done!"
        read -p "I'm going to zip everything in the project to reduce space. Do you want to export the output folder as separate? [Y/n]" outputChoice
        outputChoice=${outputChoice:-y}
        if [ "$outputChoice" != "${outputChoice#[Yy]}" ] ;then
            outputExportFolder="$(zenity --file-selection --directory --title 'Select folder for the exported output')"
            outputExport $project $outputExportFolder
        fi
        zipEverything $project
    fi
}

#check for correct structure
checkForStructure(){
    if [ ! -d "$1/projectData/output" ] ;then
        echo "$1/projectData/output";
	    echo "This folder has not the correct structure, please check if it contains projectData/output and retry.";
        exit 1;
    fi
}

# initial check for depencies
checkForDependencies(){
    for i in "${dependencies[@]}"
    do
        command -v $i >/dev/null 2>&1 || { 
            echo >&2 "$i required, can't run without it."; 
            exit 1; 
        }
    done
}

checkForDependencies

#gets options
if [ $1 != "${1#[Ii]}" ] ;then
    initialSetup
elif [ $1 != "${1#[Ff]}" ] ;then
    workFinished
else
    echo "Invalid option. Available ones are:
                    i (initialize a project)
                    f (finished a project)"
fi