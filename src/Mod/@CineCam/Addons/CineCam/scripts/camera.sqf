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

// Constants.
ThirdPerson_DegreesToRadians = pi / 180;
ThirdPerson_RadiansToDegrees = 180 / pi;

// Camera settings.
ThirdPerson_CameraPositionOffset = [0.025, -1, 0.2];
ThirdPerson_FreeLookCameraPositionOffset = [0.1, 0.45, 0.02];
ThirdPerson_ProneCameraPositionOffset = [-0.1, -0.3, 0.15];
ThirdPerson_WeaponRaisedCameraPositionOffset = [0.15, 0.15, -0.05];
ThirdPerson_WeaponRaisedCameraPitchOffset = 5;
ThirdPerson_WeaponRaisedCameraBankOffset = -1.5;
ThirdPerson_CameraPitchOffset = -5;
ThirdPerson_CameraBankOffset = -3.5;
ThirdPerson_CameraPositionLeanOffset = 0.75;
ThirdPerson_CameraMovementSpeed = 0.2;
ThirdPerson_CameraRotationSpeed = 0.1;

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

  if (_actionKey in actionKeys "reloadMagazine") then {
    reload ThirdPerson_FocusedUnit;
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
    if (!weaponLowered ThirdPerson_FocusedUnit) then {
      _weaponRaisedCameraPositionOffset = ThirdPerson_WeaponRaisedCameraPositionOffset;
      _weaponRaisedCameraPitchOffset = ThirdPerson_WeaponRaisedCameraPitchOffset;
      _weaponRaisedCameraBankOffset = ThirdPerson_WeaponRaisedCameraBankOffset;
    };
    _cameraPositionLeanOffset = [ThirdPerson_CameraPositionLeanOffset * _focusedUnitLeanAmount, 0, 0];
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
    ThirdPerson_CameraVelocity = _positionDifference vectorMultiply ThirdPerson_CameraMovementSpeed;
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
    if (ThirdPerson_IsInFirstPerson) then {
      if (ThirdPerson_IsAimingDownSightsFromThirdPerson) then {
        ThirdPerson_FocusedUnit switchCamera "gunner";
      } else {
        ThirdPerson_FocusedUnit switchCamera "internal";
      }
    } else {
      switchCamera ThirdPerson_Camera;
    };

    // Handle night vision.
    camUseNVG (currentVisionMode ThirdPerson_FocusedUnit == 1);

    // Handle weapon firing.
    if (ThirdPerson_IsFiring) then {
      ThirdPerson_FocusedUnit forceWeaponFire [weaponState ThirdPerson_FocusedUnit select 1, weaponState ThirdPerson_FocusedUnit select 2];
      // Handle firemode.
      _weaponState = weaponState ThirdPerson_FocusedUnit;
      _fireMode = _weaponState select 2;
      if (_fireMode != "fullauto") then {
        ThirdPerson_IsFiring = false;
      };
    };
  }
] call BIS_fnc_addStackedEventHandler;
