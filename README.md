//-- *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
//-- Title: CineCam | Cinematic Third-Person Camera Replacement
//-- Author: Zooloo75
//-- BIForums Topic: https://forums.bohemia.net/forums/topic/220040-cinecam-an-immersive-third-person-camera-replacement/
//-- Known Issues / ToDo:
//-- * [Issue] Reloading a secondary weapon while in third-person will reload the primary weapon first if it needs to be reloaded (limitation of `reload` command).
//-- * [Issue] Certain actions can't be performed in third-person due to technical limitations of being switched to a separate camera.
//-- * [ToDo] Camera yaw does not utilize torque yet (need to figure out how to handle rotation from 359deg to 0deg, as it rotates 359deg backwards instead of 1deg forward).
//-- * [ToDo] Respect different vision modes, such as night vision, and thermal vision.
//-- * [ToDo] Separate camera position offset handling for both left and right leaning (common problem of limited visibility when leaning left with right-oriented shoulder cam).
//-- * [ToDo] Improve recoil feedback (perhaps tie it to arm/shoulder movement since that should accurately represent the recoil motion?).
//-- * [ToDo] Make camera settings user-configurable.
//-- * [ToDo] Handle third-person vehicle camera.
//-- * [ToDo] Obligatory code refactor.
//-- *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
