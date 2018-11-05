ThirdPerson_IsToggleCameraShoulderKeybindingDefined = {
  _keybinding = ["CineCam", "ToggleCameraShoulder"] call CBA_fnc_getKeybind;
  _keybinds = _keybinding select 8;
  count _keybinds > 0;
};

ThirdPerson_IsWeaponLowered = {
  _unit = param [0];
  _unitAnimationState = animationState _unit;
  _isWeaponLowered =
    weaponLowered _unit ||
    _unitAnimationState find "slow" >= 0; // Lowered weapon sprint animation states look like they have this in common with their names.
  _isWeaponLowered;
};

ThirdPerson_IsUnitInLeftCombatStance = {
  _unit = param [0];
  _unitAnimationState = animationState _unit;
  _isUnitInLeftCombatStance = _unitAnimationState find "left" >= 0;
  _isUnitInLeftCombatStance;
};

ThirdPerson_IsUnitInRightCombatStance = {
  _unit = param [0];
  _unitAnimationState = animationState _unit;
  _isUnitInRightCombatStance = _unitAnimationState find "right" >= 0;
  _isUnitInRightCombatStance;
};

ThirdPerson_ClampValue = {
  _value = param [0];
  _min = param [1];
  _max = param [2];
  (_value max _max) min _min;
};
