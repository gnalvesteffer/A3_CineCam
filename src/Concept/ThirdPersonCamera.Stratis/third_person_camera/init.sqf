[] spawn {
  waitUntil { !isNull (findDisplay 46) && time > 0 };
  call compile preprocessFileLineNumbers "third_person_camera\camera.sqf"
};
