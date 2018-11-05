ThirdPerson_FocusCameraOnPlayer = {
  ThirdPerson_FocusedUnit = player;
};

ThirdPerson_ClampCameraShakeAmount = {
  ThirdPerson_CameraShakeAmount = [ThirdPerson_CameraShakeAmount, 0, 1] call ThirdPerson_ClampValue;
};

ThirdPerson_UpdateCameraTransformation = {
  // Calculate stuff.
  _focusedUnitEyeDirection = getCameraViewDirection ThirdPerson_FocusedUnit;
  _focusedUnitNeckModelPosition = ThirdPerson_FocusedUnit selectionPosition "neck";
  _focusedUnitSpineModelPosition = ThirdPerson_FocusedUnit selectionPosition "spine2";
  _focusedUnitLeanAmount = (_focusedUnitNeckModelPosition select 0) - (_focusedUnitSpineModelPosition select 0);
  _freeLookCameraOffset = [0, 0, 0];
  if (freeLook) then {
     _freeLookCameraOffset = [ThirdPerson_FreeLookCameraPositionOffsetX * ThirdPerson_CameraShoulder, ThirdPerson_FreeLookCameraPositionOffsetY, ThirdPerson_FreeLookCameraPositionOffsetZ];
  };
  _proneCameraPositionOffset = [0, 0, 0];
  if (stance ThirdPerson_FocusedUnit == "prone") then {
    _proneCameraPositionOffset = [ThirdPerson_ProneCameraPositionOffsetX, ThirdPerson_ProneCameraPositionOffsetY, ThirdPerson_ProneCameraPositionOffsetZ];
  };
  _weaponRaisedCameraPositionOffset = [0, 0, 0];
  _weaponRaisedCameraPitchOffset = 0;
  _weaponRaisedCameraBankOffset = 0;
  _cameraPositionLeanOffset = [0, 0, 0];
  if (!(ThirdPerson_FocusedUnit call ThirdPerson_IsWeaponLowered)) then {
    if (!(call ThirdPerson_IsToggleCameraShoulderKeybindingDefined)) then {
      if (_focusedUnitLeanAmount < 0 &&
          inputAction "LeanLeft" > 0 ||
          inputAction "LeanLeftToggle" > 0 ||
          ThirdPerson_FocusedUnit call ThirdPerson_IsUnitInLeftCombatStance) then {
        _cameraPositionLeanOffset = [ThirdPerson_CameraPositionLeanLeftOffset, 0, 0];
        if (ThirdPerson_ShouldAutoFlipShoulderCameraPositionOnLean) then {
          ThirdPerson_CameraShoulder = -1;
        };
      } else {
        if (_focusedUnitLeanAmount > 0 &&
            inputAction "LeanRight" > 0 ||
            inputAction "LeanRightToggle" > 0 ||
            ThirdPerson_FocusedUnit call ThirdPerson_IsUnitInRightCombatStance) then {
          _cameraPositionLeanOffset = [ThirdPerson_CameraPositionLeanRightOffset, 0, 0];
          if (ThirdPerson_ShouldAutoFlipShoulderCameraPositionOnLean) then {
            ThirdPerson_CameraShoulder = 1;
          };
        };
      };
    };
    _weaponRaisedCameraPositionOffset = [ThirdPerson_WeaponRaisedCameraPositionOffsetX * ThirdPerson_CameraShoulder, ThirdPerson_WeaponRaisedCameraPositionOffsetY, ThirdPerson_WeaponRaisedCameraPositionOffsetZ];
    _weaponRaisedCameraPitchOffset = ThirdPerson_WeaponRaisedCameraPitchOffset;
    _weaponRaisedCameraBankOffset = ThirdPerson_WeaponRaisedCameraBankOffset;
  };
  _cameraPositionSwayOffset = [sin (time * 45) * 0.015, cos (time * 60) * 0.0085, sin (time * 50) * 0.001];
  _cameraPositionShakeOffset = [0, (ThirdPerson_CameraShakeAmount * -0.3), -0.2 * ThirdPerson_CameraShakeAmount];
  _cameraPositionLookOffset = [0, ((_focusedUnitEyeDirection select 2) * -0.5), ((_focusedUnitEyeDirection select 2) * -0.75)];
  _cameraPositionOffset = [ThirdPerson_CameraPositionOffsetX * ThirdPerson_CameraShoulder, ThirdPerson_CameraPositionOffsetY, ThirdPerson_CameraPositionOffsetZ];
  _finalCameraPosition =
    _focusedUnitNeckModelPosition      vectorAdd
    _cameraPositionOffset              vectorAdd
    _cameraPositionLeanOffset          vectorAdd
    _cameraPositionLookOffset          vectorAdd
    _cameraPositionSwayOffset          vectorAdd
    _cameraPositionShakeOffset         vectorAdd
    _freeLookCameraOffset              vectorAdd
    _proneCameraPositionOffset         vectorAdd
    _weaponRaisedCameraPositionOffset;

  // Update position.
  _cameraTargetPosition = AGLToASL (ThirdPerson_FocusedUnit modelToWorldVisual _finalCameraPosition);
  _positionDifference = _cameraTargetPosition vectorDiff ThirdPerson_CameraPosition;
  ThirdPerson_CameraVelocity = _positionDifference vectorMultiply ThirdPerson_CameraMovementSpeed;
  ThirdPerson_CameraPosition = ThirdPerson_CameraPosition vectorAdd ThirdPerson_CameraVelocity;
  ThirdPerson_Camera setPosASL ThirdPerson_CameraPosition;

  // Update rotation.
  _cameraTargetPitchBank = [
    ((_focusedUnitEyeDirection select 2) * 90) + ThirdPerson_CameraPitchOffset + _weaponRaisedCameraPitchOffset + (cos (time * 70) * 0.2) + (ThirdPerson_CameraShakeAmount * 30) + ((random ThirdPerson_CameraShakeAmount - random ThirdPerson_CameraShakeAmount) * 10), // Pitch.
    (_focusedUnitLeanAmount * 30) + ThirdPerson_CameraBankOffset + _weaponRaisedCameraBankOffset + (cos (time * 190) * 0.075) + ((random ThirdPerson_CameraShakeAmount - random ThirdPerson_CameraShakeAmount) * 10) // Bank.
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
};

ThirdPerson_DecreaseCameraShake = {
  ThirdPerson_CameraShakeAmount = ThirdPerson_CameraShakeAmount * 0.85;
};

ThirdPerson_UpdatePostProcessEffects = {
  if (ThirdPerson_ArePostProcessingEffectsEnabled) then {
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectAdjust [0.0015, 0.0015, true];
    "chromAberration" ppEffectCommit 0;

    "filmGrain" ppEffectEnable true;
    "filmGrain" ppEffectAdjust [0.02, 0.02, 0.4, 0.4, 0.4, false];
    "filmGrain" ppEffectCommit 0;

    "colorCorrections" ppEffectEnable true;
    "colorCorrections" ppEffectAdjust [1, 1, -0.035, [0.06, 0.075, 0.08, 0.25], [1, 1, 1, 1], [1, 1, 1, 1]];
    "colorCorrections" ppEffectCommit 0;
  };
};

ThirdPerson_UpdatePointOfView = {
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
};

ThirdPerson_UpdateWeaponFireState = {
  if (ThirdPerson_IsFiring) then {
    ThirdPerson_FocusedUnit forceWeaponFire [weaponState ThirdPerson_FocusedUnit select 1, weaponState ThirdPerson_FocusedUnit select 2];
    _weaponState = weaponState ThirdPerson_FocusedUnit;
    _fireMode = _weaponState select 2;
    _roundsInMagazine = _weaponState select 4;
    _isFocusedUnitWeaponOutOfAmmo = _roundsInMagazine == 0;
    _shouldContinueFiring = !_isFocusedUnitWeaponOutOfAmmo && _fireMode in ThirdPerson_AutomaticWeaponFireModes;
    ThirdPerson_IsFiring = _shouldContinueFiring;
  };
};
