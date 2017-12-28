// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_vehicleClass", "_vehicle"];

_setupVars =
{
	_vehicleClass = selectRandom
	[
		"I_SDV_01_F",
		"O_SDV_01_F",
		"B_SDV_01_F"
	];
	
	// Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle;
	_vehicle call randomCrateLoadOut;
	
	
	_missionType = "Abandoned SDV";
	_locationsArray = SunkenMissionMarkers;

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos] call createlargeDivers;

	_missionHintText = "Sunken supplies have been spotted in the ocean near the marker, and are heavily guarded. Diving gear and an underwater weapon are recommended.";
};

_this call mission_VehicleCapture;