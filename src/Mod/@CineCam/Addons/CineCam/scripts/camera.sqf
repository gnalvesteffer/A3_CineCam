//-- *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
//-- Title: CineCam | Cinematic Third-Person Camera Replacement
//-- Author: Zooloo75
//-- BIForums Topic: https://forums.bohemia.net/forums/topic/220040-cinecam-an-immersive-third-person-camera-replacement/
//-- *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

// Constants.
ThirdPerson_DegreesToRadians = pi / 180;
ThirdPerson_RadiansToDegrees = 180 / pi;
ThirdPerson_AutomaticWeaponFireModes = ["FullAuto", "Manual"];

// Camera settings.
ThirdPerson_CameraPositionOffset = [0.025, -1, 0.2];
ThirdPerson_FreeLookCameraPositionOffset = [0.1, 0.45, 0.02];
ThirdPerson_ProneCameraPositionOffset = [-0.1, -0.3, 0.15];
ThirdPerson_WeaponRaisedCameraPositionOffset = [0.35, 0.15, -0.15];
ThirdPerson_WeaponRaisedCameraPitchOffset = 10;
ThirdPerson_WeaponRaisedCameraBankOffset = -1.5;
ThirdPerson_CameraPitchOffset = -5;
ThirdPerson_CameraBankOffset = -3.5;
ThirdPerson_CameraPositionLeanRightOffset = 0.75;
ThirdPerson_CameraPositionLeanLeftOffset = 10;
ThirdPerson_CameraMovementSpeed = [0.35, 0.35, 0.35];
ThirdPerson_CameraRotationSpeed = 0.15;

// Global state.
ThirdPerson_FocusedUnit = player;
ThirdPerson_Camera = "camera" camCreate (position player);
ThirdPerson_IsInFirstPerson = false;
ThirdPerson_IsAimingDownSightsFromThirdPerson = false;
ThirdPerson_CameraPosition = getPosASLVisual player;
ThirdPerson_CameraVelocity = [0, 0, 0];
ThirdPerson_CameraRotation = [0, 0, 0];
ThirdPerson_CameraTorque = [0, 0, 0];
ThirdPerson_IsFiring = false;
ThirdPerson_CameraShakeAmount = 0;

// Setup camera shake from gunfire near camera.
ThirdPerson_FocusedUnit addEventHandler ["Fired", {
  ThirdPerson_CameraShakeAmount = ThirdPerson_CameraShakeAmount + 0.05 + random 0.02;
}];

// Handle input.
(findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
  _mouseButtonIndex = _this select 1;

  switch (_mouseButtonIndex) do {
    case 0: {
      ThirdPerson_IsFiring = true;
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
  _mouseButtonIndex = _this select 1;

  switch (_mouseButtonIndex) do {
    case 0: {
      ThirdPerson_IsFiring = false;
    };
  };

	false;
}];

(findDisplay 46) displayAddEventHandler ["KeyDown", {
  _actionKey = _this select 1;
  _shouldInterceptKey = false;

  if (cameraOn == ThirdPerson_Camera) then {
    if (_actionKey in actionKeys "reloadMagazine") then {
      reload ThirdPerson_FocusedUnit;
    };
  };

  if (_actionKey in actionKeys "personView") then {
    ThirdPerson_IsInFirstPerson = !ThirdPerson_IsInFirstPerson;
    ThirdPerson_IsAimingDownSightsFromThirdPerson = false;
    _shouldInterceptKey = true;
  };

	_shouldInterceptKey;
}];

// Handle frame update.
[
  "ThirdPerson",
  "onEachFrame",
  {
    // Ensure that camera is focused on player.
    ThirdPerson_FocusedUnit = player;

    // Limit camera shake amount.
    ThirdPerson_CameraShakeAmount = ThirdPerson_CameraShakeAmount min 1;

    // Calculate stuff.
    _focusedUnitEyeDirection = getCameraViewDirection ThirdPerson_FocusedUnit;
    _focusedUnitNeckModelPosition = ThirdPerson_FocusedUnit selectionPosition "neck";
    _focusedUnitSpineModelPosition = ThirdPerson_FocusedUnit selectionPosition "spine2";
    _focusedUnitLeanAmount = (_focusedUnitNeckModelPosition select 0) - (_focusedUnitSpineModelPosition select 0);
    _freeLookCameraOffset = [0, 0, 0];
    if (freeLook) then {
       _freeLookCameraOffset = ThirdPerson_FreeLookCameraPositionOffset;
    };
    _proneCameraPositionOffset = [0, 0, 0];
    if (stance ThirdPerson_FocusedUnit == "prone") then {
      _proneCameraPositionOffset = ThirdPerson_ProneCameraPositionOffset;
    };
    _weaponRaisedCameraPositionOffset = [0, 0, 0];
    _weaponRaisedCameraPitchOffset = 0;
    _weaponRaisedCameraBankOffset = 0;
    _cameraPositionLeanOffset = [0, 0, 0];
    if (!weaponLowered ThirdPerson_FocusedUnit) then {
      _weaponRaisedCameraPositionOffset = ThirdPerson_WeaponRaisedCameraPositionOffset;
      _weaponRaisedCameraPitchOffset = ThirdPerson_WeaponRaisedCameraPitchOffset;
      _weaponRaisedCameraBankOffset = ThirdPerson_WeaponRaisedCameraBankOffset;
      if (inputAction "LeanLeft" > 0 || inputAction "LeanLeftToggle" > 0 || inputAction "LeanRightToggle" > 0 || inputAction "LeanRightToggle" > 0) then {
        if (_focusedUnitLeanAmount > 0) then {
          _cameraPositionLeanOffset = [ThirdPerson_CameraPositionLeanRightOffset * _focusedUnitLeanAmount, 0, 0];
        } else {
          if (_focusedUnitLeanAmount < 0) then {
            _cameraPositionLeanOffset = [ThirdPerson_CameraPositionLeanLeftOffset * _focusedUnitLeanAmount, 0, 0];
          };
        };
      };
    };
    _cameraPositionSwayOffset = [sin (time * 45) * 0.015, cos (time * 60) * 0.0085, sin (time * 50) * 0.001];
    _cameraPositionShakeOffset = [0, (ThirdPerson_CameraShakeAmount * -0.3), -0.2 * ThirdPerson_CameraShakeAmount];
    _cameraPositionLookOffset = [0, ((_focusedUnitEyeDirection select 2) * -0.5), ((_focusedUnitEyeDirection select 2) * -0.75)];
    _cameraPositionOffset =
      ThirdPerson_CameraPositionOffset vectorAdd
       _cameraPositionLeanOffset vectorAdd
       _cameraPositionLookOffset vectorAdd
       _cameraPositionSwayOffset vectorAdd
       _cameraPositionShakeOffset vectorAdd
       _freeLookCameraOffset vectorAdd
       _proneCameraPositionOffset vectorAdd
       _weaponRaisedCameraPositionOffset;
    _focusedUnitModelPositionWithOffset = _focusedUnitNeckModelPosition vectorAdd _cameraPositionOffset;

    // Handle camera position.
    _cameraTargetPosition = AGLToASL (ThirdPerson_FocusedUnit modelToWorldVisual _focusedUnitModelPositionWithOffset);
    _positionDifference = _cameraTargetPosition vectorDiff ThirdPerson_CameraPosition;
    ThirdPerson_CameraVelocity = [
      (_positionDifference select 0) * (ThirdPerson_CameraMovementSpeed select 0),
      (_positionDifference select 1) * (ThirdPerson_CameraMovementSpeed select 1),
      (_positionDifference select 2) * (ThirdPerson_CameraMovementSpeed select 2)
    ];
    ThirdPerson_CameraPosition = ThirdPerson_CameraPosition vectorAdd ThirdPerson_CameraVelocity;
    ThirdPerson_Camera setPosASL ThirdPerson_CameraPosition;

    // Handle camera rotation.
    _cameraTargetPitchBank = [
      ((_focusedUnitEyeDirection select 2) * 90) + ThirdPerson_CameraPitchOffset + _weaponRaisedCameraPitchOffset + (cos (time * 70) * 0.2) + (ThirdPerson_CameraShakeAmount * 30) + ((random ThirdPerson_CameraShakeAmount - random ThirdPerson_CameraShakeAmount) * 10), // Pitch.
      (_focusedUnitLeanAmount * 90) + ThirdPerson_CameraBankOffset + _weaponRaisedCameraBankOffset + (cos (time * 190) * 0.075) + ((random ThirdPerson_CameraShakeAmount - random ThirdPerson_CameraShakeAmount) * 10) // Bank.
    ];
    _pitchBankDifference = [(_cameraTargetPitchBank select 0) - (ThirdPerson_CameraRotation select 0), (_cameraTargetPitchBank select 1) - (ThirdPerson_CameraRotation select 1)];
    _focusedUnitLookYaw = (_focusedUnitEyeDirection select 0) atan2 (_focusedUnitEyeDirection select 1);
    ThirdPerson_CameraTorque = [
      (_pitchBankDifference select 0) * ThirdPerson_CameraRotationSpeed,
      (_pitchBankDifference select 1) * ThirdPerson_CameraRotationSpeed,
      0 // ToDo: Figure out how to rotate camera 360deg without "wrapping" back to 0deg.
    ];
    ThirdPerson_CameraRotation = ThirdPerson_CameraRotation vectorAdd ThirdPerson_CameraTorque;
    ThirdPerson_Camera setDir _focusedUnitLookYaw; // ToDo: Use `ThirdPerson_CameraRotation select 2` once it's populated.
    [ThirdPerson_Camera, ThirdPerson_CameraRotation select 0, ThirdPerson_CameraRotation select 1] call BIS_fnc_setPitchBank;

    // Reduce camera shake.
    ThirdPerson_CameraShakeAmount = ThirdPerson_CameraShakeAmount * 0.85;

    // Handle point of view.
    if (vehicle ThirdPerson_FocusedUnit != ThirdPerson_FocusedUnit) then {
      switchCamera ThirdPerson_FocusedUnit;
    } else {
      if (ThirdPerson_IsInFirstPerson) then {
        if (ThirdPerson_IsAimingDownSightsFromThirdPerson) then {
          ThirdPerson_FocusedUnit switchCamera "gunner";
        } else {
          switchCamera ThirdPerson_FocusedUnit;
        }
      } else {
        switchCamera ThirdPerson_Camera;
      };
    };

    // Handle night vision.
    camUseNVG (currentVisionMode ThirdPerson_FocusedUnit == 1);

    // Handle weapon firing.
    if (ThirdPerson_IsFiring) then {
      ThirdPerson_FocusedUnit forceWeaponFire [weaponState ThirdPerson_FocusedUnit select 1, weaponState ThirdPerson_FocusedUnit select 2];
      _weaponState = weaponState ThirdPerson_FocusedUnit;
      _fireMode = _weaponState select 2;
      ThirdPerson_IsFiring = _fireMode in ThirdPerson_AutomaticWeaponFireModes;
    };
  }
] call BIS_fnc_addStackedEventHandler;
