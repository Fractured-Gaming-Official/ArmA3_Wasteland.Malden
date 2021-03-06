// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_altisPatrol.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "moneyMissionDefines.sqf";

private ["_convoyVeh","_veh1","_veh2","_veh3","_veh4","_veh5","_createVehicle","_pos","_rad","_vehiclePosArray","_vPos1","_vPos2","_vPos3","_vehiclePos1","_vehiclePos2","_vehiclePos3","_vehiclePos4","_vehicles","_leader","_speedMode","_waypoint","_vehicleName","_numWaypoints","_cash","_drugpilerandomizer","_drugpile","_box1","_box2","_box3"];

_setupVars =
{
	_missionType = "Malden Patrol";
	_locationsArray = nil;
};

_setupObjects =
{
	_town = (call cityList) call BIS_fnc_selectRandom;
	_missionPos = markerPos (_town select 0);

	_convoyVeh = ["I_MRAP_03_hmg_F","I_MBT_03_cannon_F","O_APC_Tracked_02_AA_F","I_MBT_03_cannon_F","I_MRAP_03_gmg_F"];

	_veh1 = _convoyVeh select 0;
	_veh2 = _convoyVeh select 1;
	_veh3 = _convoyVeh select 2;
	_veh4 = _convoyVeh select 3;
	_veh5 = _convoyVeh select 4;

	_createVehicle = {
		private ["_type","_position","_direction","_vehicle","_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "None"];
		[_vehicle] call vehicleSetup;

		_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInDriver _vehicle;
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInCommander _vehicle;
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInGunner _vehicle;

		//_vehicle setVehicleLock "UNLOCKED";  // force vehicles to be unlocked
		//_vehicle setVariable ["R3F_LOG_disabled", false, true]; // force vehicles to be unlocked
		_vehicle setVariable ["R3F_LOG_disabled", true, true]; // force vehicles to be locked
		[_vehicle, _aiGroup] spawn checkMissionVehicleLock; // force vehicles to be locked

		_vehicle
	};

	_aiGroup = createGroup CIVILIAN;

	//_pos = getMarkerPos (_town select 0);
	_rad = _town select 1;
	_vehiclePosArray = [_missionPos,_rad,_rad + 50,5,0,0,0] call findSafePos;
	/*_vPos1 = _vehiclePosArray select 0;
	_vPos2 = _vehiclePosArray select 1;
	_vPos3 = _vehiclePosArray select 2;
	_vehiclePos1 = [_vPos1 + 5, _vPos2 + 5, _vPos3];
	_vehiclePos2 = [_vPos1 + 10, _vPos2 + 10, _vPos3];
	_vehiclePos3 = [_vPos1 + 15, _vPos2 + 15, _vPos3];
	_vehiclePos4 = [_vPos1 + 20, _vPos2 + 20, _vPos3];*/

	_vehicles =
	[
		[_veh1, _vehiclePosArray, 0] call _createVehicle,
		[_veh2, _vehiclePosArray, 0] call _createVehicle,
		[_veh3, _vehiclePosArray, 0] call _createVehicle,
		[_veh4, _vehiclePosArray, 0] call _createVehicle,
		[_veh5, _vehiclePosArray, 0] call _createVehicle
	];

	_leader = effectiveCommander (_vehicles select 0);
	_aiGroup selectLeader _leader;
	_leader setRank "LIEUTENANT";

	_aiGroup setCombatMode "GREEN"; // units will defend themselves
	_aiGroup setBehaviour "SAFE"; // units feel safe until they spot an enemy or get into contact
	_aiGroup setFormation "FILE";

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" };
	_aiGroup setSpeedMode _speedMode;

	{
		_waypoint = _aiGroup addWaypoint [markerPos (_x select 0), 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 50;
		_waypoint setWaypointCombatMode "GREEN";
		_waypoint setWaypointBehaviour "SAFE"; // safe is the best behaviour to make AI follow roads, as soon as they spot an enemy or go into combat they WILL leave the road for cover though!
		_waypoint setWaypointFormation "FILE";
		_waypoint setWaypointSpeed _speedMode;
	} forEach ((call cityList) call BIS_fnc_arrayShuffle);

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _veh2 >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _veh2 >> "displayName");
	_vehicleName2 = getText (configFile >> "CfgVehicles" >> _veh3 >> "displayName");
	_vehicleName3 = getText (configFile >> "CfgVehicles" >> _veh4 >> "displayName");

	_missionHintText = format ["A convoy containing at least a <t color='%4'>%1</t>, a <t color='%4'>%2</t> and a <t color='%4'>%3</t> is patrolling Malden! Stop the patrol and capture the goods and money!", _vehicleName, _vehicleName2, _vehicleName3, moneyMissionColor];

	_numWaypoints = count waypoints _aiGroup;
};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints};
_failedExec = nil;

_drop_item =
{
	private["_item", "_pos"];
	_item = _this select 0;
	_pos = _this select 1;

	if (isNil "_item" || {typeName _item != typeName [] || {count(_item) != 2}}) exitWith {};
	if (isNil "_pos" || {typeName _pos != typeName [] || {count(_pos) != 3}}) exitWith {};

	private["_id", "_class"];
	_id = _item select 0;
	_class = _item select 1;

	private["_obj"];
	_obj = createVehicle [_class, _pos, [], 5, "None"];
	_obj setPos ([_pos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
	_obj setVariable ["mf_item_id", _id, true];
};

#include "..\missionSuccessHandler.sqf"

_missionCratesSpawn = true;
_missionCrateAmount = 3;
_missionCrateSmoke = false;
_missionCrateSmokeDuration = 120;
_missionCrateChemlight = true;
_missionCrateChemlightDuration = 120;

_missionMoneySpawn = true;
_missionMoneyAmount = 100000;
_missionMoneyBundles = 10;
_missionMoneySmoke = true;
_missionMoneySmokeDuration = 120;
_missionMoneyChemlight = true;
_missionMoneyChemlightDuration = 120;

_missionSuccessMessage = "The patrol has been stopped, the money, drugs, crates and vehicles are yours to take.";

_this call moneyMissionProcessor;
