//HOGS_AI helper functions
HOGS_AI_Spawner={
_type=0;

_AO_Pos = _this select 0;
_Number_To_Spawn=_this select 1;
_radius=_this select 2;
_skill=_this select 3;
_group_suffix=_this select 4;

_counter1=1;

if(_radius>0)then{
_type=1;
};

_XVal=_AO_Pos select 0;
_YVal=_AO_Pos select 1;
_ZVal=_AO_Pos select 2;

//Seeds allow the first spawned AI unit to be placed at our AO pos and all subsequent AI
//will extend out in a staggered line away from the first one.
_XSeed=0;
_YSeed=0;
_counter1=0;

_group = createGroup RESISTANCE;
HOGS_AI_GRP_DELETE pushback _group;

while{_Number_To_Spawn>0}do{
_unit = _group createUnit["I_Soldier_EPOCH", [_XVal+_XSeed,_YVal+_Yseed,_ZVal], [], 50, "CAN_COLLIDE"];
_unit addEventHandler["killed", {[_this select 0, _this select 1] spawn HOGS_AI_SPECIAL_DELETE}];
AI_to_be_Killed=AI_to_be_Killed+1;
if(_counter1==0)then{
_XSeed=_XSeed+1;
_counter1=1;
}else{
_YSeed=_YSeed+1;
_counter1=0;
};
_Number_To_Spawn=_Number_To_Spawn-1;
if((count units _group)==1)then{
_group selectLeader _unit;
};
[_unit] call HOGS_AI_LOADOUT_CREATOR;

_unit setCombatMode "RED";
_unit setBehaviour "COMBAT";

_unit setSkill _skill;
};

_group setCombatMode "RED";
_group setBehaviour "COMBAT";

if(_type==0)then{
[_group,_AO_Pos] call BIS_fnc_taskDefend;
}else{
[_group, [_XVal,_YVal],_radius] call bis_fnc_taskPatrol;
};	

};

HOGS_AI_LOADOUT_CREATOR={
_soldier=_this select 0;
removeUniform _soldier;
removeHeadgear _soldier;

_Random_Gear=((HOGS_AI_Mission_Sets select Mission_Set) select 6);
_Gear_Set_Number = ((HOGS_AI_Mission_Sets select Mission_Set) select 7);
_Gear_Set = (AI_GEAR_SETS select _Gear_Set_Number);

if(_Random_Gear)then{

if(AI_Give_Uniform)then{
_uniform= (_Gear_Set select 0) select (floor random count (_Gear_Set select 0));
_soldier forceAddUniform _uniform;
//diag_log format ["Uniform given to AI: %1",_uniform];
};
if(AI_Give_Vest)then{
_vest=(_Gear_Set select 1) select (floor random count (_Gear_Set select 1));
_soldier addVest _vest;
//diag_log format ["Vest given to AI: %1",_vest];
};
if(AI_Give_Backpack)then{
_backpack= (_Gear_Set select 2) select (floor random count (_Gear_Set select 2));
_soldier addBackpackGlobal _backpack;
//diag_log format ["Backpack given to AI: %1",_backpack];
};
if(AI_Give_HeadGear)then{
_headgear= (_Gear_Set select 3) select (floor random count (_Gear_Set select 3));
_soldier addHeadgear _headgear;
//diag_log format ["Headgear given to AI: %1",_headgear];
};
if(AI_Give_Goggles)then{
_goggles= (_Gear_Set select 4) select (floor random count (_Gear_Set select 4));
_soldier addGoggles _goggles;
//diag_log format ["Goggles given to AI: %1",_goggles];
};
if(AI_Nightvision)then{
_soldier linkItem "NVGoggles";
};
if(AI_Give_Primary_Weapon)then{
_primary_weapon= (_Gear_Set select 5) select (floor random count (_Gear_Set select 5));
_returns=[_primary_weapon] call VAS_fnc_fetchCfgDetails;
//diag_log format ["Primary Weapon given to AI: %1",_primary_weapon];
_mags =_returns select 7;
if(count _mags > 0)then{
_mag=_mags select floor random count _mags;
//diag_log format ["Mag given to AI: %1",_mag];
for "_x" from 1 to AI_Primary_Magazines do{
_soldier addMagazineGlobal _mag;
};
};

_soldier addWeaponGlobal _primary_weapon;

if(AI_Primary_Attachments_Pointers)then{
_PrimaryWPointersTemp =_returns select 10;
if(count _PrimaryWPointersTemp>0)then{
_item_to_add=_PrimaryWPointersTemp select floor random count _PrimaryWPointersTemp;
_soldier addPrimaryWeaponItem _item_to_add;
//diag_log format ["Primary Weapon Pointer given to AI: %1",_item_to_add];
};
};

if(AI_Primary_Attachments_Optics)then{
_PrimaryWOpticsTemp =_returns select 11;
if(count _PrimaryWOpticsTemp>0)then{
_item_to_add=_PrimaryWOpticsTemp select floor random count _PrimaryWOpticsTemp;
_soldier addPrimaryWeaponItem _item_to_add;
//diag_log format ["Primary Weapon Optic given to AI: %1",_item_to_add];
};
};

if(AI_Primary_Attachments_Muzzles)then{
_PrimaryWMuzzlesTemp =_returns select 12;
if(count _PrimaryWMuzzlesTemp>0)then{
_item_to_add=_PrimaryWMuzzlesTemp select floor random count _PrimaryWMuzzlesTemp;
_soldier addPrimaryWeaponItem _item_to_add;
//diag_log format ["Primary Weapon Muzzle given to AI: %1",_item_to_add];
};
};

};

if(AI_Give_Secondary_Weapon)then{
_secondary_weapon= (_Gear_Set select 6) select (floor random count (_Gear_Set select 6));
_returns=[_secondary_weapon] call VAS_fnc_fetchCfgDetails;
//diag_log format ["Secondary Weapon given to AI: %1",_secondary_weapon];
_mags =_returns select 7;
_mag=_mags select 0;
//diag_log format ["Magazine given to AI: %1",_mag];

for "_x" from 1 to AI_Secondary_Magazines do{
_soldier addMagazineGlobal _mag;
};
_soldier addWeaponGlobal _secondary_weapon;
};

if(AI_Give_Handgun)then{
_handgun=(_Gear_Set select 7) select (floor random count (_Gear_Set select 7));
_returns=[_handgun] call VAS_fnc_fetchCfgDetails;
//diag_log format ["Handgun given to AI: %1",_handgun];
_mags =_returns select 7;
if(count _mags > 0)then{
_mag=_mags select floor random count _mags;
//diag_log format ["Magazine given to AI: %1",_mag];
for "_x" from 1 to AI_Handgun_Magazines do{
_soldier addMagazineGlobal _mag;
};
};

_soldier addWeaponGlobal _handgun;

if(AI_Handgun_Attachments_Pointers)then{
_HandgunPointersTemp =_returns select 10;
if(count _HandgunPointersTemp>0)then{
_item_to_add=_HandgunPointersTemp select floor random count _HandgunPointersTemp;
_soldier addHandgunItem _item_to_add;
//diag_log format ["Handgun Pointer given to AI: %1",_item_to_add];
};
};

if(AI_Handgun_Attachments_Optics)then{
_HandgunOpticsTemp =_returns select 11;
if(count _HandgunOpticsTemp>0)then{
_item_to_add=_HandgunOpticsTemp select floor random count _HandgunOpticsTemp;
_soldier addHandgunItem _item_to_add;
//diag_log format ["Handgun Optic given to AI: %1",_item_to_add];
};
};

if(AI_Handgun_Attachments_Muzzles)then{
_HandgunMuzzlesTemp =_returns select 12;
if(count _HandgunMuzzlesTemp>0)then{
_item_to_add=_HandgunMuzzlesTemp select floor random count _HandgunMuzzlesTemp;
_soldier addHandgunItem _item_to_add;
//diag_log format ["Handgun Muzzle given to AI: %1",_item_to_add];
};
};

};

if(AI_Number_Of_Throwable_Items > 0)then{
_throwable_item = (_Gear_Set select 8) select (floor random count (_Gear_Set select 8));
//diag_log format ["Throwable Item given to AI: %1",_throwable_item];
for "_x" from 1 to AI_Number_Of_Throwable_Items do
{
_soldier addMagazineGlobal _throwable_item;
};
};

if(AI_Number_Of_Deployable_Weapons > 0)then{
_deployable_weapon = (_Gear_Set select 9) select (floor random count (_Gear_Set select 9));
//diag_log format ["Deployable Item given to AI: %1",_deployable_weapon];
for "_x" from 1 to AI_Number_Of_Deployable_Weapons do
{
_soldier addMagazineGlobal _deployable_weapon;
};
};

if(AI_Number_Of_Assigned_Items > 0)then{
_assigned_items=_Gear_Set select 10;

//diag_log format ["Throwable Item given to AI: %1",_throwable_item];
for "_x" from 1 to AI_Number_Of_Assigned_Items do
{
_assigned_item = _assigned_items select (floor random count _assigned_items);
_assigned_items=_assigned_items - [_assigned_item];
_soldier linkItem _assigned_item;

};
};

if(AI_Number_Of_Inventory_Items > 0)then{
_inventory_items=_Gear_Set select 11;

//diag_log format ["Deployable Item given to AI: %1",_deployable_weapon];
for "_x" from 1 to AI_Number_Of_Inventory_Items do
{
_inventory_item = _inventory_items select (floor random count _inventory_items);
_soldier addItem _inventory_item;
};
};

}else{


if(_Gear_Set select 0!="")then{
_soldier forceAddUniform (_Gear_Set select 0);
};
if(_Gear_Set select 1!="")then{
_soldier addVest (_Gear_Set select 1);
};
if(_Gear_Set select 2!="")then{
_soldier addBackpack (_Gear_Set select 2);
};
if(_Gear_Set select 3!="")then{
_soldier addHeadgear (_Gear_Set select 3);
};
if(_Gear_Set select 4!="")then{
_soldier addGoggles (_Gear_Set select 4);
};
if(AI_Nightvision)then{
_soldier addItem "NVGoggles";
_soldier assignItem "NVGoggles";
_soldier action["NVGoggles", _soldier];
};

//Primary Weapon Section
if(_Gear_Set select 5!="")then{
_primary_weapon = (_Gear_Set select 5);
_returns=[_primary_weapon] call VAS_fnc_fetchCfgDetails;
//diag_log format ["Primary Weapon given to AI: %1",_primary_weapon];
_mags =_returns select 7;
if(count _mags > 0)then{
_mag=_mags select floor random count _mags;
//diag_log format ["Mag given to AI: %1",_mag];
for "_x" from 1 to AI_Primary_Magazines do{
_soldier addMagazineGlobal _mag;
};
};
_soldier addWeaponGlobal _primary_weapon;

if(_Gear_Set select 6!="")then{
_soldier addPrimaryWeaponItem (_Gear_Set select 6);
};
if(_Gear_Set select 7!="")then{
_soldier addPrimaryWeaponItem (_Gear_Set select 7);
};
if(_Gear_Set select 8!="")then{
_soldier addPrimaryWeaponItem (_Gear_Set select 8);
};
};

//Secondary Weapon Section
if(_Gear_Set select 9!="")then{
_soldier addWeaponGlobal (_Gear_Set select 9);
};

//Handgun Section
if(_Gear_Set select 10!="")then{
_handgun = (_Gear_Set select 10);
_returns=[_handgun] call VAS_fnc_fetchCfgDetails;
//diag_log format ["Primary Weapon given to AI: %1",_primary_weapon];
_mags =_returns select 7;
if(count _mags > 0)then{
_mag=_mags select floor random count _mags;
//diag_log format ["Mag given to AI: %1",_mag];
for "_x" from 1 to AI_Handgun_Magazines do{
_soldier addMagazineGlobal _mag;
};
};

_soldier addWeaponGlobal (_Gear_Set select 10);
if(_Gear_Set select 11!="")then{
_soldier addHandgunItem (_Gear_Set select 11);
};
if(_Gear_Set select 12!="")then{
_soldier addHandgunItem (_Gear_Set select 12);
};
if(_Gear_Set select 13!="")then{
_soldier addHandgunItem (_Gear_Set select 13);
};
};




if((_Gear_Set select 14) select 0!="")then{
{
_soldier addItem _x;
_soldier assignItem _x;
}foreach (_Gear_Set select 14);
};

if((_Gear_Set select 15) select 0!="")then{
{
_soldier addItem _x;
}foreach (_Gear_Set select 15);
};
};


};




HOGS_AI_PRIZE_SPAWNER={
_AO_Pos=_this select 0;
_Prize_Pool= _this select 1;
_Prize_Pool_Temp_Weapons = _this select 2;
_Prize_Pool_Temp_Backpacks = _this select 3;
_Prize_Pool_Temp_Magazines = _this select 4;
_Temp_Pool=[];
_Temp_Prize=[];
_counter2 = count _Prize_Pool;
_R_P=_this select 5;
_P_N=_this select 6;
_P_Q_Min=_this select 7;
_P_Q_Max=_this select 8;

_prize = createVehicle ["Box_East_Ammo_F",_AO_Pos,[], 0, "CAN_COLLIDE"];
clearItemCargoGlobal _prize;
clearMagazineCargoGlobal _prize;
clearWeaponCargoGlobal _prize;
clearBackpackCargoGlobal _prize;


//This switch block takes care of Randomize_Prize 1 or 3 needing a smaller prize pool and/or quantity

switch(_R_P)do{
case 1:{
for "_x" from 0 to (_P_N - 1) do {
_counter2 = count _Prize_Pool;
_Temp_Prize = _Prize_Pool select (floor (random _counter2));
_Prize_Pool=_Prize_Pool-[_Temp_Prize];
_Temp_Pool pushback _Temp_Prize;
};
_Prize_Pool=_Temp_Pool;
};
case 2:{
for "_x" from 0 to (_counter2 - 1) do {
_Temp_Prize = _Prize_Pool select _x;
_P_Q_tmp = _P_Q_Min + random (_P_Q_Max - _P_Q_Min);
_Temp_Prize set [1,_P_Q_tmp];
_Prize_Pool set [_x,_Temp_Prize];
};
};
case 3:{
for "_x" from 0 to (_P_N - 1) do {
_counter2 = count _Prize_Pool;
_Temp_Prize = _Prize_Pool select (floor (random _counter2));
_Prize_Pool=_Prize_Pool-[_Temp_Prize];
_P_Q_tmp = _P_Q_Min + random (_P_Q_Max - _P_Q_Min);
_Temp_Prize set [1,_P_Q_tmp];
_Temp_Pool pushback _Temp_Prize;
};
_Prize_Pool=_Temp_Pool;
};
};


{
_p_i=_x select 0;
_qty=_x select 1;
_prize addItemCargoGlobal [_p_i,_qty];
}forEach _Prize_Pool;

{
_p_i=_x select 0;
_qty=_x select 1;
_prize addWeaponCargoGlobal [_p_i,_qty];
}forEach _Prize_Pool_Temp_Weapons;

{
_p_i=_x select 0;
_qty=_x select 1;
_prize addBackpackCargoGlobal [_p_i,_qty];
}forEach _Prize_Pool_Temp_Backpacks;

{
_p_i=_x select 0;
_qty=_x select 1;
_prize addMagazineCargoGlobal [_p_i,_qty];
}forEach _Prize_Pool_Temp_Magazines;


if(Prize_Timer>0)then{
HAI2Prize_Timer=time;
[_prize]spawn{_prize=_this select 0;waitUntil{(time-HAI2Prize_Timer)>Prize_Timer}; deleteVehicle _prize;};

};
};	

HOGS_AI_SPECIAL_DELETE={
_deadAI=_this select 0;
_killer=_this select 1;
if(_killer isKindOf "Ship" or _killer isKindOf "Air" or _killer isKindOf "LandVehicle") then {
_WeaponHolders=nearestObjects [_deadAI, ["WeaponHolder","WeaponHolderSimulated"],15];
{
deleteVehicle _x
}forEach _WeaponHolders;
deleteVehicle _deadAI;
};
};
