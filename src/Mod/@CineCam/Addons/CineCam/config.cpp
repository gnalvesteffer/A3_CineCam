class CfgPatches
{
  class CineCam
  {
    units[] = {};
      weapons[] = {};
        requiredAddons[] = { "CBA_xeh" };
        requiredVersion = 1.0;
        projectName = "CineCam";
        author = "Zooloo75";
        url = "https://forums.bohemia.net/forums/topic/220040-wip-cinecam-cinematic-third-person-camera-replacement/";
        version = 0.15;
      };
    };

    class Extended_PreInit_EventHandlers
    {
      class CineCam_PreInit
      {
        init = "call compile preprocessFileLineNumbers '\CineCam\scripts\init.sqf';";
      };
    };
};
