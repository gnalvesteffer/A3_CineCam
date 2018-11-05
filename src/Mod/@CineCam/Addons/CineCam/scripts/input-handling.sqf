(findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
  if (dialog) exitWith {
    false;
  };

  _mouseButtonIndex = _this select 1;

  switch (_mouseButtonIndex) do {
    case 0: {
      _canShoot = !visibleMap;
      if (_canShoot) then {
        ThirdPerson_IsFiring = true;
      };
    };

    case 1: {
      if (cameraOn == ThirdPerson_Camera) then {
        ThirdPerson_IsInFirstPerson = true;
        ThirdPerson_IsAimingDownSightsFromThirdPerson = true;
      } else { // Assume camera is on focused unit.
        if (ThirdPerson_IsAimingDownSightsFromThirdPerson) then {
          ThirdPerson_IsInFirstPerson = false;
          ThirdPerson_IsAimingDownSightsFromThirdPerson = false;
        };
      };
    }
  };

 false;
}];

(findDisplay 46) displayAddEventHandler ["MouseButtonUp", {
  if (dialog) exitWith {
    false;
  };

  _mouseButtonIndex = _this select 1;

  switch (_mouseButtonIndex) do {
    case 0: {
      ThirdPerson_IsFiring = false;
    };
  };

 false;
}];

(findDisplay 46) displayAddEventHandler ["KeyDown", {
  if (dialog) exitWith {
    false;
  };

  _actionKey = _this select 1;
  _shouldInterceptKey = false;

  if (cameraOn == ThirdPerson_Camera) then {
    if (_actionKey in actionKeys "reloadMagazine") then {
      reload ThirdPerson_FocusedUnit;
    };

    if (_actionKey in actionKeys "gear" && !dialog) then {
      switchCamera ThirdPerson_FocusedUnit;
      createGearDialog [ThirdPerson_FocusedUnit];
    }
  };

  if (_actionKey in actionKeys "personView") then {
    ThirdPerson_IsInFirstPerson = !ThirdPerson_IsInFirstPerson;
    ThirdPerson_IsAimingDownSightsFromThirdPerson = false;
    _shouldInterceptKey = true;
  };

 _shouldInterceptKey;
}];
