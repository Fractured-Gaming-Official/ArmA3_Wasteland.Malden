//@file Version: 1.2
//@file Name: gearLevel9.sqf
private ["_player"];
_player = _this;


// _player setVariable ["cmoney", (_player getVariable "cmoney") + 1000, true];
_player setVariable ["gmoney",900];

{_player removeWeapon _x} forEach weapons _player;
{_player removeMagazine _x} forEach magazines _player;
//removeUniform _player;
//removeallitems _player;
removeVest _player;
removeBackpack _player;
//removeGoggles _player;
//removeHeadgear _player;

_player addBackpack "B_Carryall_oli"; //BackPack
//_player addUniform ""; //Uniform (must be supported by side)
_player addVest "V_PlateCarrierIA1_dgtl"; //Vest
_player linkItem "NVGoggles"; //Nightvision, "NVGoggles"
_player linkItem "ItemGPS"; //GPS, "ItemGPS"
_player addWeapon "Binocular"; //Binoculars
_player addMagazines ["HandGrenade", 2]; //Grenades
_player addItem "FirstAidKit"; //Any other stuff that goes in inventory if there is space
//_player addItem "Medikit"; //Any other stuff that goes in inventory if there is space
//_player addItem "ToolKit"; //Any other stuff that goes in inventory if there is space
//_player addItem ""; //Any other stuff that goes in inventory if there is space
//_player addItem ""; //Any other stuff that goes in inventory if there is space
//_player addGoggles ""; //Glasses or masks. Overwrites, add as item if you want it a an extra item
_player addHeadgear "H_HelmetB_light"; //Hat or helmet. Overwrites, add as item if you want it a an extra item

_player addMagazines ["9Rnd_45ACP_Mag", 2]; //Add handgun magazines first so one gets loaded
_player addWeapon "hgun_ACPC2_F"; //Handgun
//_player addhandGunItem ""; //Handgun Attachments
//_player addhandGunItem ""; //Handgun Attachments

//_player addMagazines ["30Rnd_65x39_caseless_mag", 2]; //Add primary weapon magazines first so one gets loaded
//_player addWeapon "arifle_TRG20_F"; //Primary Weapon
//_player addPrimaryWeaponItem "optic_Holosight_smg"; //Primary Weapon Attachments
//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments
//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments

//_player addMagazines ["", 0]; //Add secondary Weapon magazines first so one gets loaded
//_player addWeapon "launch_NLAW_F"; //Secondary Weapon (Launcher slot)

//_player selectWeapon "arifle_TRG20_F"; //Select Active Weapon

switch (true) do
{
	//Medic
	case (["_medic_", typeOf _player] call fn_findString != -1):
	{
		_player addItem "MediKit";
		_player removeItem "";

		_player addMagazines ["30Rnd_65x39_caseless_mag", 2]; //Add primary weapon magazines first so one gets loaded
		_player addMagazines ["3Rnd_Smoke_Grenade_shell", 1]; //Add primary weapon magazines first so one gets loaded
		_player addMagazines ["3Rnd_HE_Grenade_shell", 1]; //Add primary weapon magazines first so one gets loaded
		_player addWeapon "arifle_MX_GL_F"; //Primary Weapon
		_player addPrimaryWeaponItem "optic_Hamr"; //Primary Weapon Attachments
		//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments
		//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments

		_player addMagazines ["RPG32_F", 1]; //Add secondary Weapon magazines first so one gets loaded
		_player addWeapon "launch_RPG32_F"; //Secondary Weapon (Launcher slot)

		_player addMagazines ["SmokeShell", 2]; //Grenades

		_player selectWeapon "arifle_MX_GL_F"; //Select Active Weapon
	};
	//Engineer
	case (["_engineer_", typeOf _player] call fn_findString != -1):
	{
		_player addItem "ToolKit";
		_Player addItem "MineDetector";
		_player removeItem "";

		_player addMagazines ["30Rnd_65x39_caseless_mag", 3]; //Add primary weapon magazines first so one gets loaded
		_player addWeapon "arifle_MXC_F"; //Primary Weapon
		_player addPrimaryWeaponItem "optic_Hamr"; //Primary Weapon Attachments
		_player addPrimaryWeaponItem "muzzle_snds_H_MG_blk_F"; //Primary Weapon Attachments
		//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments

		_player addMagazines ["RPG32_F", 1]; //Add secondary Weapon magazines first so one gets loaded
		_player addWeapon "launch_RPG32_F"; //Secondary Weapon (Launcher slot)

		_player addMagazines ["MiniGrenade", 2]; //Grenades
		_player addMagazines ["SLAMDirectionalMine_Wire_Mag", 2]; //Grenades

		_player selectWeapon "arifle_MXC_F"; //Select Active Weapon
	};
	//Sniper
	case (["_sniper_", typeOf _player] call fn_findString != -1):
	{
		_player addWeapon "Rangefinder";
		_player removeItem "";

		_player addMagazines ["20Rnd_762x51_Mag", 3]; //Add primary weapon magazines first so one gets loaded
		_player addWeapon "srifle_EBR_F"; //Primary Weapon
		_player addPrimaryWeaponItem "optic_DMS"; //Primary Weapon Attachments
		_player addPrimaryWeaponItem "muzzle_snds_B"; //Primary Weapon Attachments
		//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments

		_player addMagazines ["RPG32_F", 1]; //Add secondary Weapon magazines first so one gets loaded
		_player addWeapon "launch_RPG32_F"; //Secondary Weapon (Launcher slot)

		_player addMagazines ["ClaymoreDirectionalMine_Remote_Mag", 2]; //Grenades

		_player selectWeapon "srifle_EBR_F"; //Select Active Weapon
	};
	//Diver
	case (["_diver_", typeOf _player] call fn_findString != -1):
	{
		_player addVest "V_RebreatherIA";
		_player addGoggles "G_Diving";
		_player removeItem "";

		_player addMagazines ["30Rnd_556x45_Stanag_Tracer_Green", 3];
		_player addMagazines ["20Rnd_556x45_UW_mag", 4];		//Add primary weapon magazines first so one gets loaded
		_player addWeapon "arifle_SDAR_F"; //Primary Weapon
		//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments
		//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments
		//_player addPrimaryWeaponItem ""; //Primary Weapon Attachments

		//_player addMagazines ["", 0]; //Add secondary Weapon magazines first so one gets loaded
		//_player addWeapon ""; //Secondary Weapon (Launcher slot)

		_player addMagazines ["MiniGrenade", 2]; //Grenades

		_player selectWeapon "arifle_SDAR_F"; //Select Active Weapon

	};
};
