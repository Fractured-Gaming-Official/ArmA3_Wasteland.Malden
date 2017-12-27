A3W_incomingMissileCode =
{
 	_vehicle = _this select 0;
 	if (player in (crew _vehicle) && (alive player)) then { playsound "alarm";};
} call mf_compile;
 