// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_ArmedTransport.sqf
//	@file Author: JoSchaap, AgentRev

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf"

private ["_vehChoices", "_convoyVeh", "_veh1", "_veh2", "_veh3", "_createVehicle", "_vehicles", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_vehicleName2", "_numWaypoints", "_box1", "_box2", "_box3", "_mortar"];

_setupVars =
{
	_missionType = "Military Transport";
	//_locationsArray = nil; // locations are generated on the fly from towns
};

_setupObjects =
{
	private ["_starts", "_startDirs", "_waypoints"];

	_vehChoices =
	[
		["B_MBT_01_TUSK_F", "B_APC_Tracked_01_rcws_F"],
 		["I_MBT_03_cannon_F", "I_APC_tracked_03_cannon_F"],
 		["O_MBT_02_cannon_F", "O_APC_Tracked_02_cannon_F"]
	];

	if (missionDifficultyHard) then
	{
		(_vehChoices select 0) set [0, "B_MBT_01_TUSK_F"];
 		(_vehChoices select 1) set [0, "I_MBT_03_cannon_F"];
 		(_vehChoices select 2) set [0, "O_MBT_02_cannon_F"];
	};

	_convoyVeh = _vehChoices call BIS_fnc_selectRandom;

	_veh1 = _convoyVeh select 0;
	_veh2 = _convoyVeh select 1;
	_veh3 = _convoyVeh select 1;

	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_variant", "_vehicle", "_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;
		_variant = _type param [1,"",[""]];

		_vehicle = createVehicle [_type, _position, [], 0, "none"];
		_vehicle setVariable ["R3F_LOG_disabled", true, true];

 		if (_variant != "") then
 		{
 			_vehicle setVariable ["A3W_vehicleVariant", _variant, true];
 		};

		[_vehicle] call vehicleSetup;

		_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;

		// add a driver/pilot/captain to the vehicle
		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInDriver _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInCargo [_vehicle, 0];

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInGunner _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;

		if (_vehicle emptyPositions "commander" > 0) then
		{
			_soldier moveInCommander _vehicle;
		}
		else
		{
			_soldier moveInCargo [_vehicle, 1];
		};

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
	} forEach _convoyVeh;

	_leader = effectiveCommander (_vehicles select 0);
	_aiGroup selectLeader _leader;
	_leader setRank "LIEUTENANT";
	_aiGroup setCombatMode "GREEN"; // units will defend themselves
	_aiGroup setBehaviour "SAFE"; // units feel safe until they spot an enemy or get into contact
	_aiGroup setFormation "COLUMN";

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" };

	_aiGroup setSpeedMode _speedMode;

	// behaviour on waypoints
	{
		_waypoint = _aiGroup addWaypoint [markerPos (_x select 0), 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 100;
		_waypoint setWaypointCombatMode "GREEN";
		_waypoint setWaypointBehaviour "SAFE";
		_waypoint setWaypointFormation "COLUMN";
		_waypoint setWaypointSpeed _speedMode;
	} forEach ((call cityList) call BIS_fnc_arrayShuffle);

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> (_veh1 param [0,""]) >> "picture");
 	_vehicleName = getText (configFile >> "CfgVehicles" >> (_veh1 param [0,""]) >> "displayName");
 	_vehicleName2 = getText (configFile >> "CfgVehicles" >> (_veh2 param [0,""]) >> "displayName");

	_missionHintText = format ["A Military Patrol containing a <t color='%3'>%1</t> and two <t color='%3'>%2</t> are patrolling the island. Destroy them and recover their cargo!", _vehicleName, _vehicleName2, mainMissionColor];

	_numWaypoints = count waypoints _aiGroup;

};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints};

_failedExec = nil;

// _vehicles are automatically deleted or unlocked in missionProcessor depending on the outcome

_successExec =
_successExec =
{
	_numCratesToSpawn = 2; // edit this value to how many crates are to be spawned!
	_lastPos = _this;
	_i = 0;
	while {_i < _numCratesToSpawn} do
	{
		_lastPos spawn
		{
			_lastPos = _this;
	     		_crate = createVehicle ["Box_East_Wps_F", _lastPos, [], 5, "None"];
	     		_crate setDir random 360;
	     		_crate allowDamage false;
	     		waitUntil {!isNull _crate};
	     		if ((_lastPos select 2) > 5) then
			{
		 		_crateParachute = createVehicle ["O_Parachute_02_F", (getPosATL _crate), [], 0, "CAN_COLLIDE" ];
		 		_crateParachute allowDamage false;
		 		_crate attachTo [_crateParachute, [0,0,0]];
		 		_crate call randomCrateLoadOut;
		 		waitUntil {getPosATL _crate select 2 < 5};
		 		detach _crate;
		 		deleteVehicle _crateParachute;
			};
	     		_smokeSignalTop = createVehicle  ["SmokeShellRed_infinite", getPosATL _crate, [], 0, "CAN_COLLIDE" ];
	     		_lightSignalTop = createVehicle  ["Chemlight_red", getPosATL _crate, [], 0, "CAN_COLLIDE" ];
	     		_smokeSignalTop attachTo [_crate, [0,0,0.5]];
	     		_lightSignalTop attachTo [_crate, [0,0,0.25]];
			_timer = time + 120;
			waitUntil {sleep 1; time > _timer};
			_crate allowDamage true;
			deleteVehicle _smokeSignalTop;
			deleteVehicle _lightSignalTop;
	 	};
	        _i = _i + 1;
	};
	_mortar = createVehicle ["I_Mortar_01_F", _lastPos, [], 5, "None"];
	_mortar setVariable ["R3F_LOG_Disabled", false, true];
	_mortar setDir random 360;

	_successHintMessage = "The Patrol has been stopped! Ammo crates and a Mortar have fallen nearby.";
};

_this call mainMissionProcessor;
