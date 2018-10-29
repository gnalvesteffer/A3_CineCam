[] spawn {
  waitUntil { !isNull (findDisplay 46) && time > 0 };
  call compile preprocessFileLineNumbers "CineCam\scripts\camera.sqf"
};
