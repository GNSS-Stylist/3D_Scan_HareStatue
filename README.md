# 3D_Scan_HareStatue

This repository contains data and other things used when making this youtube-video: https://www.youtube.com/watch?v=WE_fD6qsLKQ

GNSS-stylus, V1.3.0 was used to log and post-process the data. It's downloadable here: https://github.com/GNSS-Stylist/GNSS-Stylus/releases/tag/V1.3.0

Overall directory structure:

* Godot_Playback: Project made in Godot engine that can be used to "playback" the scanning data. This was used to generate overlays for the youtube video. Godot-version used was 3.2.4-beta (custom build), but any 3.2.x-version (and probably later ones) will most likely work. See more detailed readme.md in the directory itself. Directories:
  
  * GNSS_Stylus_Scripts: Files generated using GNSS-Stylus' Post-processing.
  
  * HareScan2_Model: 3D-model generated from the point cloud using MeshLab.

* Logs_Params: Raw log files and parameters used when post-processing the data using GNSS-Stylus-application. These files can be used in the application's post-processing operations (use "Files->Add from files including other fields (parameters)..." to read all at once). Includes data from GNSS- and lidar-devices. Files:
  
  * CameraRig.AntennaLocations: Locations of rover antennas in relation to rig's origin. Needed for the location/orientation solver.
  
  * HareScan2.distances: Distances measured from a laser distance measurement module. As this module is not used, the file is empty.
  
  * HareScan2.lidar: Measurements from the lidar. This is in binary format so it's not readable by text editor or similar.
  
  * HareScan2.PPParameters: Parameters used when handling the data in post-processing-phase. When this is read to GNSS-Stylus' (ver 1.3.0) Post-processing window using "Load all editable fields from file..." or "Files->Mass operations->Add from files including other fields (parameters)..." it should generate identical files used to generate the video and used by the Godot-project (see below).
  
  * HareScan2.sync: Synchronization data for rovers (iTOWs and corresponding uptimes). This is needed to make it possible to sync data from rovers and other devices (in this case lidar).
  
  * HareScan2.Transformation: "Final" translation&transformation performed when generating files using GNSS-Stylus' post-processing operations. In this case the statue's origin is shifted to the approximate center of the statue in NE (=ground)-plane and relative to the ground (statue is on top of a tube). Coordinate system is changed from NED to EUS used by MeshLab and Godot engine.
  
  * HareScan2_RoverX_RELPOSNED.ubx: UBX-format "RELPOSNED" (message type of UBX-protocol including coordinates relative to the base) data logged from rovers. GNSS-Stylus writes more log files, but in this case they are redundant and therefore removed. Base logs not included as they are not needed here.
  
  * HareScan2_tags.tags: Tags used to start/stop objects/scanning etc. These were edited by hand afterwards, since the mouse didn't work when scanning.
  
  * HareScan2_tags_Original_No_MouseButtonTags.tags: Original tags (only "New object" here since mouse didn't work).
  
  * HareScan2_unfiltered.distances: Distances (without filtering) measured from a laser distance measurement module. As this module is not used, the file is empty.
  
  * Lidar_AfterRotation.Operations: "Operations" (matrix transformations) basically used to place the lidar into correct location/orientation in relation to rig's origin. See the file itself for more info.
  
  * Lidar_BeforeRotation.Operations: "Operations" (matrix transformations) performed in lidar's rotating coordinate system. See the file itself for more info.
  
  * LOSolver_Camera.Operations: "Operations" (matrix transformations) performed in rig's coordinate system to place the camera into correct location/orientation when generating location/orientation script. See the file itself for more info.
  
  * LOSolver_Rig.Operations: "Operations" (matrix transformations) performed in rig's coordinate system to place the rig object into correct location/orientation when generating location/orientation script. In this case there's no operations as the rig objects' origin equals the real rig's origin (could be also otherwise).

* MeshLab: MeshLab-project (version 2020.12 used) used to create mesh and texturing of the statue. The model is not exactly the same as used in the video or 3D-model uploaded to Sketchfab ( https://skfb.ly/6XUtD ) (since I didn't save the exact point cloud used then) but quite close. Point cloud itself in this is the original output from GNSS-stylus and contains some outliers underside the statue (measured from the supporting tube).
