# AutomatedTreeStructureExtraction

Automated tree structure extraction of 2D images.

Overview
--------
This package provides a fast implementation for tree structure extraction in 2D images. 

A cell containing the traces of neurites associated with each of the somas  is the output.

More information can be found in the papers:
… 

See contents.m for list of files in the package and information about them.

How to use
--------------
The main file to run is Script.m
The major inputs for the main file is segmented soma mask and segmented binary image. A test data is available in main folder: 
inputSeg.mat : segmented image of test data,
inputSoma.mat : segmented soma mask of test data.

Rest of the data can be found in subfolder "dataset". For each data there is a tif file, which is the maximum intensity projection of original stack, a matlab file "inputSeg_..", which is the segmented image and a MATLAB file "inputSoma_..", which is the segmented soma image. For the soma segmentation  the code in https://github.com/cihanbilge/SomaExtraction is used. Image segmentation code can be found  in https://www.math.uh.edu/~dlabate/software.html under the section "Vessel segmentation and centerline tracing code"

Most crucial parameters are for seed search which are set in runCenterLineParallel.m, they can be changed if desired. Another important parameter is the angle threshold for seed search which can be changed from getNextSeed.m . 


Feedback
--------
If you have any questions, comments or suggestions feel free to contact 

   Cihan Bilge Kayasandik <ckayasandk@gmail.com>, Demetrio Labate <dlabate@math.uh.edu>
   University of Houston, Dept. of Mathematics
   

Legal Information & Credits
---------------------------
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
