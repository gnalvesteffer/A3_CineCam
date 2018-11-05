[
  "ThirdPerson",
  "onEachFrame",
  {
    call ThirdPerson_FocusCameraOnPlayer;
    call ThirdPerson_ClampCameraShakeAmount;
    call ThirdPerson_UpdateCameraTransformation;
    call ThirdPerson_DecreaseCameraShake;
    call ThirdPerson_UpdatePostProcessEffects;
    call ThirdPerson_UpdatePointOfView;
    call ThirdPerson_UpdateWeaponFireState;
  }
] call BIS_fnc_addStackedEventHandler;
