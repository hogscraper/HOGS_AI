HOGS_AI_VEH_DELETE=[];
HOGS_AI_BUI_DELETE=[];
HOGS_AI_GRP_DELETE=[];

HC1_Owner=owner player;


"ClientRequestAIHelper" addPublicVariableEventHandler
{
_Input_Array=_this select 1;

_type=_Input_Array select 0; //0=vehicle 1=building
_item=_Input_Array select 1;
_Xpos=_Input_Array select 2;
_Ypos=_Input_Array select 3;
_Dir =_Input_Array select 4;
diag_log format ["****************** xpos=%1, ypos=%2",_Xpos,_Ypos];

_1=createVehicle[_item,[_Xpos,_Ypos,0.1],[],0,"CAN_COLLIDE"];
_1 setDir _Dir;

switch (_type) do{
case 0:{
//Unmanned vehicle spawns
clearItemCargoGlobal _1;
clearMagazineCargoGlobal _1;
clearWeaponCargoGlobal _1;
clearBackpackCargoGlobal _1;

//This if statement is from Epoch server code for setting up loot in spawned vehicles.
if(_1 isKindOf "Ship")then{
[_1,["Items","Items","Equipment","Equipment","Pistols","Pistols","PistolAmmo","PistolAmmo","PistolAmmo","Scopes","Muzzles","Uniforms","Vests","Headgear","Food","Food","Generic","GenericAuto","GenericAuto","RifleBoat","RifleBoat","RifleAmmoBoat","RifleAmmoBoat","Hand","Grenades","Backpack"],4]call EPOCH_serverLootObject;
}else{
[_1,["Items","Items","Equipment","Equipment","Pistols","Pistols","PistolAmmo","PistolAmmo","PistolAmmo","Scopes","Muzzles","Uniforms","Vests","Headgear","Food","Food","Generic","GenericAuto","GenericAuto","Machinegun","MachinegunAmmo","MachinegunAmmo","Rifle","RifleAmmo","RifleAmmo","SniperRifle","SniperRifleAmmo","SniperRifleAmmo","Hand","Hand","Grenades","Backpack"],4]call EPOCH_serverLootObject;
};
_1 lock true;
_1 call EPOCH_server_setVToken;
HOGS_AI_VEH_DELETE pushBack _1;
publicVariable "HOGS_AI_VEH_DELETE";

};
case 1:{
//Manned vehicle spawns
clearItemCargoGlobal _1;
clearMagazineCargoGlobal _1;
clearWeaponCargoGlobal _1;
clearBackpackCargoGlobal _1;

//This if statement is from Epoch server code for setting up loot in spawned vehicles.
if(_1 isKindOf "Ship")then{
[_1,["Items","Items","Equipment","Equipment","Pistols","Pistols","PistolAmmo","PistolAmmo","PistolAmmo","Scopes","Muzzles","Uniforms","Vests","Headgear","Food","Food","Generic","GenericAuto","GenericAuto","RifleBoat","RifleBoat","RifleAmmoBoat","RifleAmmoBoat","Hand","Grenades","Backpack"],4]call EPOCH_serverLootObject;
}else{
[_1,["Items","Items","Equipment","Equipment","Pistols","Pistols","PistolAmmo","PistolAmmo","PistolAmmo","Scopes","Muzzles","Uniforms","Vests","Headgear","Food","Food","Generic","GenericAuto","GenericAuto","Machinegun","MachinegunAmmo","MachinegunAmmo","Rifle","RifleAmmo","RifleAmmo","SniperRifle","SniperRifleAmmo","SniperRifleAmmo","Hand","Hand","Grenades","Backpack"],4]call EPOCH_serverLootObject;
};

_1 call EPOCH_server_setVToken;

HOGS_AI_VEH_DELETE pushBack _1;
publicVariable "HOGS_AI_VEH_DELETE";
//_1 setOwner HC1_Owner;
//_1 lock true;
};
case 2:{
//Manned vehicle spawns
clearItemCargoGlobal _1;
clearMagazineCargoGlobal _1;
clearWeaponCargoGlobal _1;
clearBackpackCargoGlobal _1;


_1 call EPOCH_server_setVToken;
HOGS_AI_VEH_DELETE pushBack _1;
publicVariable "HOGS_AI_VEH_DELETE";

{
diag_log format ["vehicle = %1 ******************************************",_x];
}forEach HOGS_AI_VEH_DELETE;

diag_log format ["HC1_Owner = %1 ******************************************",HC1_Owner];
//_1 setOwner HC1_Owner;
//_1 lock true;

};
case 3:{
HOGS_AI_BUI_DELETE pushBack _1;
};
};
};

"ClientRequestMissionCleanup" addPublicVariableEventHandler
{
_switch=_this select 1;
diag_log format ["switch=%1",_switch];
switch(_switch)do{
case 0:{
{
//You can swap the comments from deleteVehicle _x to _x setdamage 1 to delete the vehicles altogether
//if you don't want the wreckages staying around.
//deleteVehicle _x;
_x setDamage 1;
}forEach HOGS_AI_VEH_DELETE;	
HOGS_AI_VEH_DELETE=[];
HC1_Owner publicVariableClient "HOGS_AI_VEH_DELETE";
};
case 1:{
{
//deleteVehicle _x;
_x setDamage 1;
}forEach HOGS_AI_BUI_DELETE;
HOGS_AI_BUI_DELETE=[];
};
};
};
