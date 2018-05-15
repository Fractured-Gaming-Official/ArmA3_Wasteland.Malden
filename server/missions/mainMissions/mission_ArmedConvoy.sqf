// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 2.1
//	@file Name: mission_ArmedPatrol.sqf
//	@file Author: JoSchaap / routes by Del1te - (original idea by Sanjo), AgentRev
//	@file Created: 31/08/2013 18:19

if (!isServer) exitwith {};
#include "MainMissionDefines.sqf";

private ["_Patrol", "_convoys", "_vehChoices", "_vehClasses", "_createVehicle", "_vehicles", "_veh2", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_numWaypoints", "_box1", "_box2", "_Mortar"];

_setupVars =
{
	// _locationsArray = nil;

	// Patrol settings
	// Difficulties : Min = 1, Max = infinite
	// Convoys per difficulty : Min = 1, Max = infinite
	// Vehicles per convoy : Min = 1, Max = infinite
	// Choices per vehicle : Min = 1, Max = infinite
	_Patrol =
	[
		// Medium
		[
			"CSAT Convoy", // Marker text
			[
				[ // Basic convoy 1
					["O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F", "O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_gmg_ghex_F"], // Veh 1
					["O_MRAP_02_F", "O_T_MRAP_02_ghex_F"], // Veh 2
					["O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F", "O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_gmg_ghex_F"] // Veh 3
				],
				[ // Quick
					["O_T_LSV_02_armed_F", "O_LSV_02_armed_F", "O_LSV_02_armed_arid_F", "O_LSV_02_armed_ghex_F"], // Veh 1
					["O_LSV_02_unarmed_F", "O_T_LSV_02_unarmed_F", "O_LSV_02_unarmed_black_F", "O_T_LSV_02_unarmed_arid_F"], // Veh 2
					["O_T_LSV_02_armed_F", "O_LSV_02_armed_F", "O_LSV_02_armed_arid_F", "O_LSV_02_armed_ghex_F"] // Veh 4
				]
			]
		],
		// Hard
		[
			"NATO Convoy", // Marker text
			[
				[ // Basic convoy 1
					["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F", "B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F"], // Veh 1
					["B_MRAP_01_F", "B_T_MRAP_01_F"], // Veh 2
					["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F", "B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F"] // Veh 3
				],
				[ // Quick
					["B_T_LSV_01_armed_F", "B_LSV_01_armed_F", "B_LSV_01_armed_black_F", "B_LSV_01_armed_olive_F", "B_LSV_01_armed_sand_F"], // Veh 1
					["B_LSV_01_unarmed_F", "B_CTRG_LSV_01_light_F", "B_LSV_01_unarmed_black_F", "B_LSV_01_unarmed_olive_F", "B_LSV_01_unarmed_sand_F"], // Veh 2
					["B_T_LSV_01_armed_F", "B_LSV_01_armed_F", "B_LSV_01_armed_black_F", "B_LSV_01_armed_olive_F", "B_LSV_01_armed_sand_F"] // Veh 4
				]
			]
		],
		// Extreme
		[
			"Guerilla Convoy", // Marker text
			[
				[ // Basic convoy 1
					["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F", "I_G_Offroad_01_armed_F"], // Veh 1
					["I_MRAP_03_F", "B_T_MRAP_01_F"], // Veh 2
					["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F", "I_G_Offroad_01_armed_F"] // Veh 3
				],
				[ // Quick
					["B_T_LSV_01_armed_F", "B_LSV_01_armed_F", "O_T_LSV_02_armed_F", "O_LSV_02_armed_F", "B_LSV_01_armed_sand_F"], // Veh 1
					["B_LSV_01_unarmed_F", "B_CTRG_LSV_01_light_F", "B_LSV_01_unarmed_black_F", "B_LSV_01_unarmed_olive_F", "B_LSV_01_unarmed_sand_F""O_LSV_02_unarmed_F", "O_T_LSV_02_unarmed_F", "O_LSV_02_unarmed_black_F", "O_T_LSV_02_unarmed_arid_F"], // Veh 2
					["B_T_LSV_01_armed_F", "B_LSV_01_armed_F", "O_T_LSV_02_armed_F", "O_LSV_02_armed_F", "B_LSV_01_armed_sand_F"] // Veh 4
				]
			]
		]
	]
	call BIS_fnc_selectRandom;

	_missionType = _Patrol select 0;
	_convoys = _Patrol select 1;
	_vehChoices = _convoys call BIS_fnc_selectRandom;


	_vehClasses = [];
	{ _vehClasses pushBack (_x call BIS_fnc_selectRandom) } forEach _vehChoices;
};

_setupObjects =
{
	private ["_starts", "_startDirs", "_waypoints"];
	// call compile preprocessFileLineNumbers format ["mapConfig\convoys\%1.sqf", _missionLocation];

	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_vehicle", "_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "None"];
		_vehicle setVariable ["R3F_LOG_disabled", true, true];
		[_vehicle] call vehicleSetup;

		_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInDriver _vehicle;

		_soldier = [_aiGroup, _position] call createRandomSoldier;
		_soldier moveInCargo [_vehicle, 0];

		if !(_type isKindOf "Truck_F") then
		{
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
		};

		[_vehicle, _aiGroup] spawn checkMissionVehicleLock;
		_vehicle
	};


    // SKIP TOWN AND PLAYER PROXIMITY CHECK

    _skippedTowns = // get the list from -> \mapConfig\towns.sqf
    [
		"Town_20",
		"Town_21",
		"Town_22"
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
	} forEach _vehClasses;

	_veh2 = _vehClasses select (1 min (count _vehClasses - 1));

	_leader = effectiveCommander (_vehicles select 0);
	_aiGroup selectLeader _leader;

	_aiGroup setCombatMode "GREEN"; // units will defend themselves
	_aiGroup setBehaviour "SAFE"; // units feel safe until they spot an enemy or get into contact
	_aiGroup setFormation "COLUMN";

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" };

	_aiGroup setSpeedMode _speedMode;

	{
		_waypoint = _aiGroup addWaypoint [markerPos (_x select 0), 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 100;
		_waypoint setWaypointCombatMode "GREEN";
		_waypoint setWaypointBehaviour "SAFE"; // safe is the best behaviour to make AI follow roads, as soon as they spot an enemy or go into combat they WILL leave the road for cover though!
		_waypoint setWaypointFormation "COLUMN";
		_waypoint setWaypointSpeed _speedMode;
	} forEach ((call cityList) call BIS_fnc_arrayShuffle);

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> (_veh2 param [0,""]) >> "picture");
 	_vehicleName = getText (configFile >> "CfgVehicles" >> (_veh2 param [0,""]) >> "displayName");

	_missionHintText = format ["A Supply Convoy containing a <t color='%3'>%1</t> is Traversing the island. Destroy them and recover their cargo!", _vehicleName, mainMissionColor];

	_numWaypoints = count waypoints _aiGroup;
};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints};

_failedExec = nil;

// _vehicles are automatically deleted or unlocked in missionProcessor depending on the outcome

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

	_successHintMessage = "The Convoy has been stopped! Ammo crates and a Mortar have fallen nearby.";
};

_this call MainMissionProcessor;
