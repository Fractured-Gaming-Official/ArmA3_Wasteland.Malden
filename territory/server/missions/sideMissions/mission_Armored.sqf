// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_MBT.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits"];

_setupVars =
{
	_vehicleClass =
	[
		"B_APC_Wheeled_01_cannon_F",
		"O_APC_Wheeled_02_rcws_F",
		"O_T_APC_Wheeled_02_rcws_ghex_F",
		"I_MRAP_03_hmg_F",
		"I_MRAP_03_gmg_F",
		"I_APC_Wheeled_03_cannon_F"
	] call BIS_fnc_selectRandom;

	_missionType = "Armored Personel Carrier";
	_locationsArray = IslandMissionMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_VehicleCapture;
