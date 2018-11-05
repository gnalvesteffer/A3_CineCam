[
  "ThirdPerson_CameraPositionOffsetX",
  "SLIDER",
  ["Camera X-Position Offset", "The distance the camera is positioned from the player."],
  "CineCam",
  [-25, 25, 0.125, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_CameraPositionOffsetY",
  "SLIDER",
  ["Camera Y-Position Offset", "The distance the camera is positioned from the player."],
  "CineCam",
  [-25, 25, -0.95, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_CameraPositionOffsetZ",
  "SLIDER",
  ["Camera Z-Position Offset", "The distance the camera is positioned from the player."],
  "CineCam",
  [-25, 25, 0.1, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_CameraPitchOffset",
  "SLIDER",
  ["Camera Pitch Offset", "The degrees the camera is tilted forward/backward."],
  "CineCam",
  [-180, 180, 0, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_CameraBankOffset",
  "SLIDER",
  ["Camera Bank Offset", "The degrees the camera is tilted left/right."],
  "CineCam",
  [-180, 180, 0, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_CameraMovementSpeed",
  "SLIDER",
  "Camera Movement Speed",
  "CineCam",
  [0.01, 0.99, 0.35, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_CameraRotationSpeed",
  "SLIDER",
  "Camera Rotation Speed",
  "CineCam",
  [0.01, 1, 0.15, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_FreeLookCameraPositionOffsetX",
  "SLIDER",
  ["Camera X-Position Offset When Free-Looking", "The additional distance the camera is positioned when the player is free-looking."],
  "CineCam",
  [-25, 25, 0.05, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_FreeLookCameraPositionOffsetY",
  "SLIDER",
  ["Camera Y-Position Offset When Free-Looking", "The additional distance the camera is positioned when the player is free-looking."],
  "CineCam",
  [-25, 25, 0.25, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_FreeLookCameraPositionOffsetZ",
  "SLIDER",
  ["Camera Z-Position Offset When Free-Looking", "The additional distance the camera is positioned when the player is free-looking."],
  "CineCam",
  [-25, 25, -0.03, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_ProneCameraPositionOffsetX",
  "SLIDER",
  ["Camera X-Position Offset When Prone", "The additional distance the camera is positioned when the player is in the prone stance."],
  "CineCam",
  [-25, 25, -0.1, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_ProneCameraPositionOffsetY",
  "SLIDER",
  ["Camera Y-Position Offset When Prone", "The additional distance the camera is positioned when the player is in the prone stance."],
  "CineCam",
  [-25, 25, -0.3, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_ProneCameraPositionOffsetZ",
  "SLIDER",
  ["Camera Z-Position Offset When Prone", "The additional distance the camera is positioned when the player is in the prone stance."],
  "CineCam",
  [-25, 25, 0.15, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_WeaponRaisedCameraPositionOffsetX",
  "SLIDER",
  ["Camera X-Position Offset w/ Weapon Raised", "The additional distance the camera is positioned when the player's weapon is raised."],
  "CineCam",
  [-25, 25, 0.15, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_WeaponRaisedCameraPositionOffsetY",
  "SLIDER",
  ["Camera Y-Position Offset w/ Weapon Raised", "The additional distance the camera is positioned when the player's weapon is raised."],
  "CineCam",
  [-25, 25, 0.15, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_WeaponRaisedCameraPositionOffsetZ",
  "SLIDER",
  ["Camera Z-Position Offset w/ Weapon Raised", "The additional distance the camera is positioned when the player's weapon is raised."],
  "CineCam",
  [-25, 25, -0.05, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_WeaponRaisedCameraPitchOffset",
  "SLIDER",
  ["Camera Pitch Offset w/ Weapon Raised", "The additional degrees the camera is tilted forward/backward when the player's weapon is raised."],
  "CineCam",
  [-180, 180, 0, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_WeaponRaisedCameraBankOffset",
  "SLIDER",
  ["Camera Bank Offset w/ Weapon Raised", "The additional degrees the camera is tilted left/right when the player's weapon is raised."],
  "CineCam",
  [-180, 180, 0, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_CameraPositionLeanRightOffset",
  "SLIDER",
  ["Right Lean Camera Position Offset", "How far the camera should move horizontally when leaning right."],
  "CineCam",
  [-25, 25, 0, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_CameraPositionLeanLeftOffset",
  "SLIDER",
  ["Left Lean Camera Position Offset", "How far the camera should move horizontally when leaning left."],
  "CineCam",
  [-25, 25, 0, 2],
  1
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_ShouldAutoFlipShoulderCameraPositionOnLean",
  "CHECKBOX",
  ["Shoulder-Cam Follows Lean", "Will make the shoulder-cam automatically position itself based on the player's lean direction.\nNOTE: This can be manually-controlled by setting 'Toggle Camera Shoulder' in (Options > Controls > Configure Addons > CineCam)."],
  "CineCam",
  true,
  2
] call CBA_Settings_fnc_init;

[
  "ThirdPerson_ArePostProcessingEffectsEnabled",
  "CHECKBOX",
  ["Enable Post-Processing Effects", "Enables post-processing effects, such as color correction, film grain, and chromatic aberration.\nNOTE: Disabling doesn't take effect until mission restart."],
  "CineCam",
  false,
  2
] call CBA_Settings_fnc_init;

[
  "CineCam",
  "ToggleCameraShoulder",
  "Toggle Camera Shoulder",
  {
    ThirdPerson_CameraShoulder = ThirdPerson_CameraShoulder * -1;
    true;
  },
  ""
] call CBA_fnc_addKeybind;
