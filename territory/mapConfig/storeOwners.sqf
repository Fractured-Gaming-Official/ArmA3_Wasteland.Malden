// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: storeOwners.sqf
//	@file Author: AgentRev, JoSchaap, His_Shadow

// Notes: Gun and general stores have position of spawned crate, vehicle stores have an extra air spawn direction
//
// Array contents are as follows:
// Name, Building Position, Desk Direction (or [Desk Direction, Front Offset]), Excluded Buttons
storeOwnerConfig = compileFinal str
[
	["GenStore1", -1, [], []],		//Radio Station
	["GenStore2", -1, [], []],		//Goisse
	["GenStore3", -1, [], []],		//Pegasus Air Co.
	["GenStore4", -1, [], []],		//La Riviere
	["GenStore5", -1, [], []],		//Chapoi
	["GenStore6", -1, [], []],		//Power Plant
	["GenStore7", -1, [], []],		//Military Isle
	["GenStore8", -1, [], []],		//La Trinite
	["GenStore9", -1, [], []],		//Arudy

	["GunStore1", -1, [], ["LMGS", "Rifles"]],		//Military Base
	["GunStore2", -1, [], []],		//La Pessagne
	["GunStore3", -1, [], []],		//Saint Jean
	["GunStore4", -1, [], []],		//La Riviere
	["GunStore5", -1, [], []],		//Cancon
	["GunStore6", -1, [], []],		//Houdan
	["GunStore7", -1, [], []],		//La Trinite
	["GunStore8", -1, [], []],		//Le Port
	["GunStore9", -1, [], []],		//Military Isle
	["GunStore10", -1, [], []],		//Cimetiere Du RF

	// Buttons you can disable: "Land", "Armored", "Tanks", "Helicopters", "Boats", "Planes"
	["VehStore1", -1, [], ["Boats"]],						//Airport
	["VehStore2", -1, [], ["Land", "Armored", "Tanks"]],	//Aircraft Carrier
	["VehStore3", -1, [], ["Boats", "Tanks"]],				//Pegasus Air Co.
	["VehStore4", -1, [], ["Planes"]],						//Lolisse Harbour
	["VehStore5", -1, [], ["Boats", "Planes"]],				//Larche
	["VehStore6", -1, [], ["Planes", "Boats"]],				//Arette
    ["VehStore7", -1, [], ["Boats", "Planes"]],				//Vigny
	["VehStore8", -1, [], ["Planes"]],						//Faro
	["VehStore9", -1, [], ["Planes"]],					//Le Port Harbor
	["VehStore10", -1, [], ["Planes", "Tanks"]]				//Military Isle
	
];

// Outfits for store owners
storeOwnerConfigAppearance = compileFinal str
[
	["GenStore1", [["weapon", ""], ["uniform", "U_IG_Guerilla2_2"]]],
	["GenStore2", [["weapon", ""], ["uniform", "U_IG_Guerilla2_3"]]],
	["GenStore3", [["weapon", ""], ["uniform", "U_IG_Guerilla3_1"]]],
	["GenStore4", [["weapon", ""], ["uniform", "U_IG_Guerilla3_1"]]],
	["GenStore5", [["weapon", ""], ["uniform", "U_IG_Guerilla3_1"]]],
	["GenStore6", [["weapon", ""], ["uniform", "U_IG_Guerilla3_1"]]],
	["GenStore7", [["weapon", ""], ["uniform", "U_IG_Guerilla3_1"]]],
	["GenStore8", [["weapon", ""], ["uniform", "U_IG_Guerilla3_1"]]],
	["GenStore9", [["weapon", ""], ["uniform", "U_IG_Guerilla3_1"]]],

	["GunStore1", [["weapon", ""], ["uniform", "U_B_SpecopsUniform_sgg"]]],
	["GunStore2", [["weapon", ""], ["uniform", "U_O_SpecopsUniform_blk"]]],
	["GunStore3", [["weapon", ""], ["uniform", "U_I_CombatUniform_tshirt"]]],
	["GunStore4", [["weapon", ""], ["uniform", "U_B_SpecopsUniform_sgg"]]],
	["GunStore5", [["weapon", ""], ["uniform", "U_O_SpecopsUniform_blk"]]],
	["GunStore6", [["weapon", ""], ["uniform", "U_I_CombatUniform_tshirt"]]],
	["GunStore7", [["weapon", ""], ["uniform", "U_B_SpecopsUniform_sgg"]]],
	["GunStore8", [["weapon", ""], ["uniform", "U_O_SpecopsUniform_blk"]]],
	["GunStore9", [["weapon", ""], ["uniform", "U_I_CombatUniform_tshirt"]]],
	["GunStore10", [["weapon", ""], ["uniform", "U_B_SpecopsUniform_sgg"]]],
	

	["VehStore1", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore2", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore3", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore4", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore5", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore6", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore7", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore8", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore9", [["weapon", ""], ["uniform", "U_Competitor"]]],
	["VehStore10", [["weapon", ""], ["uniform", "U_Competitor"]]]
];
