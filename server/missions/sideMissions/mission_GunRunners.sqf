//	@file Name: mission_GunRunners.sqf
//	@file Author: ShineDwarf

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_vehChoice", "_veh1", "_createvehicle", "_vehicle","_vehicles", "_leader", "_speedmode", "_waypoint", "_vehicleName", "_numWaypoints","_box1" ];

_setupVars =
{
	_missionType = "Gun Runners"
	//_locationsArray = nil; // locations are generated on the fly from towns
};

_setupObjects =
{
	private ["_starts", "_startDirs", "_waypoints"];

	_vehChoice = selectRandom
	[
		"C_Offroad_01_F",
		"C_Hatchback_01_sport_F",
		"C_SUV_01_F",
		"SUV_01_base_grey_F",
		"C_Van_01_box_F",
		"C_Van_01_fuel_F"
	];

	_veh1 = _vehChoice;

	_createvehicle =
	{
		private ["_type", "_position", "_direction", "_vehicle", "_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "none"];
		_vehicle setVariable ["R3F_LOG_disabled", true, true];

		[_vehicle] call vehicleSetup;

		_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;

		// add a driver to the vehicle
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInDriver _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInCargo [_vehicle, 0];

		[_vehicle, _aiGroup] spawn checkMissionVehicleLock;
		_vehicle
	};

	// SKIP TOWN AND PLAYER PROXIMITY CHECK

	_skippedTowns = // get the list from -> \mapConfig\towns.sqf
	[
		"Town_14"
	];

	_town = ""; _missionPos = [0,0,0]; _radius = 0;
	_townOK = false;
	while {!_townOK} do
	{
		_town = selectRandom (call cityList); // initially select a random town for the mission.
		_missionPos = markerPos (_town select 0); // the town position.
		_radius = (_town select 1); // the town radius.
		_anyPlayersAround = (nearestObjects [_missionPos,["MAN"],_radius]) select {isPlayer _x}; // search the area for players only.
		if (((count _anyPlayersAround) isEqualTo 0) && !((_town select 0) in _skippedTowns)) exitWith // if there are no players around and the town marker is not in the skip list, set _townOK to true (exit loop).
		{
			_townOK = true;
		};
		sleep 0.1; // sleep between loops.
    };

	_aiGroup = createGroup CIVILIAN;

	//_town = selectRandom (call cityList);
	//_missionPos = markerPos (_town select 0);
	//_radius = (_town select 1);
	// _vehiclePosArray = [_missionPos,(_radius / 2),_radius,5,0,0,0] call findSafePos;

	// _vehicles = [];
	// {
		// _vehicles pushBack ([_x, _vehiclePosArray, 0, _aiGroup] call _createVehicle);
	_vehicles = [];

	_vehiclePosArray = nil;
	{
		_vehiclePosArray = getPos ((_missionPos nearRoads _radius) select _forEachIndex);
		if (isNil "_vehiclePosArray") then
		{
			_vehiclePosArray = [_missionPos,(_radius / 2),_radius,5,0,0,0] call findSafePos;
		};
		_vehicles pushBack ([_x, _vehiclePosArray, 0, _aiGroup] call _createVehicle);
		_vehiclePosArray = nil;
	}; _vehChoice

	_leader = effectiveCommander ;
	_aiGroup selectLeader _leader;
	_leader setRank "LIEUTENANT";
	_aiGroup setCombatMode "GREEN"; // units will defend themselves
	_aiGroup setBehaviour "CARELESS"; // units feel safe until they spot an enemy or get into contact
	_aiGroup setFormation "COLUMN";

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" };

	_aiGroup setSpeedMode _speedMode;

	// behaviour on waypoints
	{
		_waypoint = _aiGroup addWaypoint [markerPos (_x select 0), 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 100;
		_waypoint setWaypointCombatMode "GREEN";
		_waypoint setWaypointBehaviour "CARELESS";
		_waypoint setWaypointFormation "COLUMN";
		_waypoint setWaypointSpeed _speedMode;
	} forEach ((call cityList) call BIS_fnc_arrayShuffle);

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> (_veh1 param [0,""]) >> "picture");
 	_vehicleName = getText (configFile >> "CfgVehicles" >> (_veh1 param [0,""]) >> "displayName");


	_missionHintText = format ["A Gun Runner has been spotted in a <t color='%3'>%1</t> transporting weapons around Malden. Destroy them and recover their cargo!", _vehicleName, sideMissionColor];

	_numWaypoints = count waypoints _aiGroup;

};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints, !alive _vehicle};

_failedExec =
{
	// Mission failed
	deleteVehicle _vehicle;
};

#include "..\missionSuccessHandler.sqf"

_missionCratesSpawn = true;
_missionCrateAmount = 2;
_missionCrateSmoke = true;
_missionCrateSmokeDuration = 120;
_missionCrateChemlight = true;
_missionCrateChemlightDuration = 120;

_missionMoneySpawn = false;
_missionMoneyAmount = 100000;
_missionMoneyBundles = 10;
_missionMoneySmoke = true;
_missionMoneySmokeDuration = 120;
_missionMoneyChemlight = true;
_missionMoneyChemlightDuration = 120;

_missionSuccessMessage = "The Runners have been taken out and vehicle has been captured, well done.";

_this call sideMissionProcessor;
