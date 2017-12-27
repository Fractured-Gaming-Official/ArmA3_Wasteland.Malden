// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_findPilot.sqf
//	@file Author: AgentRev




A3W_incomingMissileCode =
{
 	_vehicle = _this select 0;
 	if (player in (crew _vehicle) && (alive player)) then { playsound "alarm"};
};