[] spawn {
  call compile preprocessFileLineNumbers "CineCam\scripts\helper-functions.sqf";
  call compile preprocessFileLineNumbers "CineCam\scripts\constants.sqf";
  call compile preprocessFileLineNumbers "CineCam\scripts\settings.sqf";
  call compile preprocessFileLineNumbers "CineCam\scripts\state.sqf";
  call compile preprocessFileLineNumbers "CineCam\scripts\camera-functions.sqf";
  waitUntil { !isNull (findDisplay 46) && time > 0 };
  call compile preprocessFileLineNumbers "CineCam\scripts\input-handling.sqf";
  call compile preprocessFileLineNumbers "CineCam\scripts\frame-handling.sqf"
};
