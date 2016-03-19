# MicroMillingArrayGen
This MATLAB script generates two files containing G-code for removing the top layer of a machinable plate and drilling large array of holes based on a few input paramters.

This repository contains three files. The main file is the MicroMillingArrayGen.m, which contains a combination of the other two .m files. Originally, each script was developed inpetendently one to generate G-code to remove the top layer of material of a machinable plate, while the other one generates G-code to drill an array of holes on a rectangular plate. The two scripts were combined in order to streamline the process. One set of parameters generates two .tap files which can be used for CNCing.

Things to add/modify in the future:
-change conditional if statements for loops which will keep asking a parameter to be input if the previous entry was not valid
-comment more on the functionality of the TopLayerRemoval.m file
-add an option for which file extension to use
-extend the functionality to more geometries than just a rectangular plate
