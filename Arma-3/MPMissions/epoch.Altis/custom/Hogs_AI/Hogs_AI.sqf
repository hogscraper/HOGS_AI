/*
The only thing you should change in this file is the Marker Text below.
*/
sleep 30;
diag_log "HOGS_AI STARTING!***************************************";
_AO_Pos=[0,0,0];
_AO_Locations_tmp=AO_Locations_Main;
_AO_Locations_Water_tmp=AO_Locations_Water;
while{true}do{
Bounce_Mission=false;
AI_to_be_Killed=0;
_loop_timer_01=[] spawn AI_Timer;

if(Static_Missions)then{
Mission_Set=0;
}else{
_mission_count = count HOGS_AI_Mission_Sets;
Mission_Set = floor (random _mission_count);
};


_forced_AO=((HOGS_AI_Mission_Sets select Mission_Set) select 9);

if(((_forced_AO select 0)!=0) && ((_forced_AO select 0)!=9999)) then {
_AO_Pos=_forced_AO;

}else{
_isSpecial=((HOGS_AI_Mission_Sets select Mission_Set) select 10);
if(_isSpecial!="")then{
switch(_isSpecial)do{
case "BUILDING_MATERIALS":{
if(Special_Mission_01>0)then{
Special_Mission_01 = Special_Mission_01 - 1;
_AO_Pos = [4825.16,21942.9,0];
}else{
if (count _AO_Locations_tmp == 0) then
{
_AO_Locations_tmp = AO_Locations_Main;
};
_AO_Pos = _AO_Locations_tmp select (floor random count _AO_Locations_tmp);
_AO_Locations_tmp = _AO_Locations_tmp - [_AO_Pos];	
Mission_Set=0;
};
};
case "WATER":{
if(Special_Mission_02>0)then{
Special_Mission_02 = Special_Mission_02 - 1;
if(count _AO_Locations_Water_tmp==0)then{
_AO_Locations_Water_tmp = AO_Locations_Water;
};
_AO_Pos = _AO_Locations_Water_tmp select (floor random count _AO_Locations_Water_tmp);
_AO_Locations_Water_tmp=_AO_Locations_Water_tmp-[_AO_Pos];
}else{
if (count _AO_Locations_tmp == 0) then
{
_AO_Locations_tmp = AO_Locations_Main;
};
_AO_Pos = _AO_Locations_tmp select (floor random count _AO_Locations_tmp);
_AO_Locations_tmp = _AO_Locations_tmp - [_AO_Pos];	
Mission_Set=0;
};
};
};
}else{
if (count _AO_Locations_tmp == 0) then
{
_AO_Locations_tmp = AO_Locations_Main;
};
_AO_Pos = _AO_Locations_tmp select (floor random count _AO_Locations_tmp);
_AO_Locations_tmp = _AO_Locations_tmp - [_AO_Pos];	
};
};

	
currentAO = createMarker ["Inc_Zone_One", _AO_Pos];
"Inc_Zone_One" setMarkerShape "ELLIPSE";
"Inc_Zone_One" setMarkerSize [Mission_Marker_X,Mission_Marker_Y];
"Inc_Zone_One" setMarkerColor "ColorRed";
"Inc_Zone_One" setMarkerBrush "DIAGGRID";
"Inc_Zone_One" setMarkerAlpha 1;
currentAO2 = createMarker ["Inc_Zone_Two", _AO_Pos];
"Inc_Zone_Two" setMarkerType "mil_dot";
"Inc_Zone_Two" setMarkerText "Hogscorp Defense Alert";


//This spawner code will continue to pull AI groups from the current Mission_Set until
//there aren't any more left or until it finds one with zero AI.
_Spawn_Counter=0;
_Spawn_Bounce=true;
_AI_Spawn_Pos=[0,0,0.1];
_AI_Groups=count ((HOGS_AI_Mission_Sets select Mission_Set) select 1);
_AO_Pos_X=_AO_Pos select 0;
_AO_Pos_Y=_AO_Pos select 1;
_AO_Pos_Z=_AO_Pos select 2;


while{_Spawn_Bounce and (_AI_Groups>_Spawn_Counter)}do{
_Spawn=(((HOGS_AI_Mission_Sets select Mission_Set) select 1) select _Spawn_Counter) select 0;
if(_Spawn>0)then{
_XOffset=(((HOGS_AI_Mission_Sets select Mission_Set) select 1) select _Spawn_Counter) select 1;
_YOffset=(((HOGS_AI_Mission_Sets select Mission_Set) select 1) select _Spawn_Counter) select 2;

if((_XOffset > 300)or(_YOffset > 300))then{
_AI_Spawn_Pos=[_XOffset,_YOffset,0.1];

}else{

_AI_Spawn_Pos set [0,(_AO_Pos_X + _XOffset)];
_AI_Spawn_Pos set [1,(_AO_Pos_Y + _YOffset)];
};


_Type=(((HOGS_AI_Mission_Sets select Mission_Set) select 1) select _Spawn_Counter) select 3;
if(_Type==1)then{
_Radius=(((HOGS_AI_Mission_Sets select Mission_Set) select 1) select _Spawn_Counter) select 4;
_skill=(((HOGS_AI_Mission_Sets select Mission_Set) select 1) select _Spawn_Counter) select 5;

[_AI_Spawn_Pos,_Spawn,_Radius,_skill,1] call HOGS_AI_Spawner;
}else{
_skill=(((HOGS_AI_Mission_Sets select Mission_Set) select 1) select _Spawn_Counter) select 4;
[_AI_Spawn_Pos,_Spawn,0,_skill,_Spawn_Counter] call HOGS_AI_Spawner;
};
_Spawn_Counter = _Spawn_Counter + 1;
}else{
_Spawn_Bounce=false;
};
};

_Mission_Unmanned_Vehicle_Spawner=((HOGS_AI_Mission_Sets select Mission_Set) select 2);
{
if((_x select 0)!="")then{
_vehicle=_x select 0;
_XO = _x select 1;
_YO = _x select 2;

if((_XO > 300)or(_YO > 300))then{
}else{
_XO = _AO_Pos_X + (_x select 1);
_YO = _AO_Pos_Y + (_x select 2);
};


ClientRequestAIHelper=[0,_vehicle,_XO,_YO,_x select 3];
publicVariableServer "ClientRequestAIHelper";
};
}foreach _Mission_Unmanned_Vehicle_Spawner;

_Mission_Manned_Vehicle_Spawner=((HOGS_AI_Mission_Sets select Mission_Set) select 3);
{

if((_x select 0)!="")then{
_vehicle=_x select 0;
_XO = _x select 1;
_YO = _x select 2;

if((_XO > 300)or(_YO > 300))then{
}else{
_XO = _AO_Pos_X + (_x select 1);
_YO = _AO_Pos_Y + (_x select 2);
};

_group = createGroup RESISTANCE;
HOGS_AI_GRP_DELETE pushback _group;

_AI_Driver_01 = _group createUnit["I_Soldier_EPOCH", [_XO, _YO, 0.1], [], 50, "CAN_COLLIDE"];
_AI_Gunner_01 = _group createUnit["I_Soldier_EPOCH", [_XO, _YO, 0.1], [], 50, "CAN_COLLIDE"];

ClientRequestAIHelper=[1,_vehicle,_XO,_YO,_x select 3];
publicVariableServer "ClientRequestAIHelper";
sleep 3;

_count4=count HOGS_AI_VEH_DELETE;
_count4 = _count4 -1;

_AI_Driver_01 moveInDriver (HOGS_AI_VEH_DELETE select _count4);

_AI_Gunner_01 moveInGunner (HOGS_AI_VEH_DELETE select _count4);
(HOGS_AI_VEH_DELETE select _count4) lock true;

};
}foreach _Mission_Manned_Vehicle_Spawner;


_Mission_Static_Weapon_Spawner=((HOGS_AI_Mission_Sets select Mission_Set) select 4);
{

if((_x select 0)!="")then{
_vehicle=_x select 0;
_XO = _x select 1;
_YO = _x select 2;

if((_XO > 300)or(_YO > 300))then{
}else{
_XO = _AO_Pos_X + (_x select 1);
_YO = _AO_Pos_Y + (_x select 2);
};


_group = createGroup RESISTANCE;
HOGS_AI_GRP_DELETE pushback _group;

_AI_Gunner_01 = _group createUnit["I_Soldier_EPOCH", [_XO, _YO, 0.1], [], 50, "CAN_COLLIDE"];

ClientRequestAIHelper=[2,_vehicle,_XO,_YO,_x select 3];
publicVariableServer "ClientRequestAIHelper";
sleep 3;

_count4=count HOGS_AI_VEH_DELETE;
_count4 = _count4 -1;

_AI_Gunner_01 moveInGunner (HOGS_AI_VEH_DELETE select _count4);
(HOGS_AI_VEH_DELETE select _count4) lock true;
};
}foreach _Mission_Static_Weapon_Spawner;


_Mission_Building_Spawner=((HOGS_AI_Mission_Sets select Mission_Set) select 5);
{
if((_x select 0)!="")then{
_building=_x select 0;
_XO = _x select 1;
_YO = _x select 2;

if((_XO > 300)or(_YO > 300))then{
}else{
_XO = _AO_Pos_X + (_x select 1);
_YO = _AO_Pos_Y + (_x select 2);
};



ClientRequestAIHelper=[3,_building,_XO,_YO,_x select 3];
publicVariableServer "ClientRequestAIHelper";
};

}foreach _Mission_Building_Spawner;

_HOGS_AI_str = ((HOGS_AI_Mission_Sets select Mission_Set) select 0) select 0;
GlobalHint = _HOGS_AI_str;
publicVariable "GlobalHint";

// Wait until all groups of AI are dead, the mission runs out of time or all alive AI have wandered outside of the AO
_Stop_the_Presses = true;

while{_Stop_the_Presses}do{
_NumberAlive=0;
_NumberOutside=0;
{
{
if(alive _x) then{
_NumberAlive=_NumberAlive + 1;
}else{

};
_AIDis= _x distance [_AO_Pos_X,_AO_Pos_Y,_AO_Pos_Z];
_AIPosition=getPos _x;
if((_AIDis>Mission_Marker_X)||(_AIDis>Mission_Marker_Y)) then{
_NumberOutside=_NumberOutside+1;
};

}forEach (units _x);
}forEach HOGS_AI_GRP_DELETE;

//If all bandit AI are dead=win
if(_NumberAlive==0)exitWith{};
//If all alive AI are outside the AO but more than half have been killed=win Takes care of cases where a couple AI run outside of the AO
if((_NumberOutside==_NumberAlive)&&(_NumberAlive<(AI_to_be_Killed/2)))exitWith{};
//If all alive AI are outside the AO but less than half have been killed=fail Exit with message about AI getting away
if((_NumberOutside==_NumberAlive)&&(_NumberAlive>(AI_to_be_Killed/2)))exitWith{Bounce_Mission=true;};
//If time runs out=fail with same message about bandits getting away
if(Bounce_Mission)exitWith{};

sleep 0.3;
};

terminate _loop_timer_01;

if(!Bounce_Mission)then{
_Prize_Pool_Override=((HOGS_AI_Mission_Sets select Mission_Set) select 7);
_P_N = -1;
_P_Q_Min = -1;
_P_Q_Max = -1;

switch(Randomize_Prize)do{
case 1:{
_P_N = Prize_Number;
};
case 2:{
_P_Q_Min = Prize_Quantity_Min;
_P_Q_Max = Prize_Quantity_Max;
};
case 3:{
_P_N = Prize_Number;
_P_Q_Min = Prize_Quantity_Min;
_P_Q_Max = Prize_Quantity_Max;
};
};

_Prize_Pool_Temp = Prize_Pool;
_Prize_Pool_Temp_Weapons = Prize_Pool_Weapons;
_Prize_Pool_Temp_Backpacks = Prize_Pool_Backpacks;
_Prize_Pool_Temp_Magazines = Prize_Pool_Magazines;

if(_Prize_Pool_Override < 1)then{
}else{
switch(_Prize_Pool_Override)do{
case 1:{
_Prize_Pool_Temp=Alt_Prize_Pool_01;
_Prize_Pool_Temp_Weapons = Alt_Prize_Pool_01_Weapons;
_Prize_Pool_Temp_Backpacks = Alt_Prize_Pool_01_Backpacks;
_Prize_Pool_Temp_Magazines = Alt_Prize_Pool_01_Magazines;
};
case 2:{
_Prize_Pool_Temp=Alt_Prize_Pool_02;
_Prize_Pool_Temp_Weapons = Alt_Prize_Pool_02_Weapons;
_Prize_Pool_Temp_Backpacks = Alt_Prize_Pool_02_Backpacks;
_Prize_Pool_Temp_Magazines = Alt_Prize_Pool_02_Magazines;
};
case 3:{
_Prize_Pool_Temp=Alt_Prize_Pool_03;
_Prize_Pool_Temp_Weapons = Alt_Prize_Pool_03_Weapons;
_Prize_Pool_Temp_Backpacks = Alt_Prize_Pool_03_Backpacks;
_Prize_Pool_Temp_Magazines = Alt_Prize_Pool_03_Magazines;
};
case 4:{
_Prize_Pool_Temp=Alt_Prize_Pool_04;
_Prize_Pool_Temp_Weapons = Alt_Prize_Pool_04_Weapons;
_Prize_Pool_Temp_Backpacks = Alt_Prize_Pool_04_Backpacks;
_Prize_Pool_Temp_Magazines = Alt_Prize_Pool_04_Magazines;
};

};
};

[[_AO_Pos_X, _AO_Pos_Y, _AO_Pos_Z],_Prize_Pool_Temp,_Prize_Pool_Temp_Weapons,_Prize_Pool_Temp_Backpacks,_Prize_Pool_Temp_Magazines, Randomize_Prize, _P_N, _P_Q_Min,_P_Q_Max] call HOGS_AI_PRIZE_SPAWNER;

//Change the marker to green, inform players of their success
"Inc_Zone_One" setMarkerColor "ColorGreen";
publicVariable "currentAO";

_HOGS_AI_str = ((HOGS_AI_Mission_Sets select Mission_Set) select 0) select 1;
GlobalHint = _HOGS_AI_str;
publicVariable "GlobalHint";

{_x lock false;}forEach HOGS_AI_VEH_DELETE;	
HOGS_AI_VEH_DELETE=[];
publicVariableServer "HOGS_AI_VEH_DELETE";

}else{
//Change the marker to yellow, inform players that the bandits got away
"Inc_Zone_One" setMarkerColor "ColorYellow";
publicVariable "currentAO";
	
_HOGS_AI_str = ((HOGS_AI_Mission_Sets select Mission_Set) select 0) select 2;
GlobalHint = _HOGS_AI_str;
publicVariable "GlobalHint";

//If time runs out or the AI all leave the AO we need to delete all of the unmanned vehicles
//spawned during the current mission.
ClientRequestMissionCleanup = 0;
publicVariableServer "ClientRequestMissionCleanup";
};	


//Clean up - delete any left over enemies and groups that have broken ranks and left the AO
{
_y=_x;
{if(alive _x) then{deleteVehicle _x};} forEach (units _y);
deleteGroup _y;

}forEach HOGS_AI_GRP_DELETE;

sleep Mission_Delay; //This is the time before the next AO will spawn
	
ClientRequestMissionCleanup = 1;
publicVariableServer "ClientRequestMissionCleanup";
		
deleteMarker "Inc_Zone_One"; 
deleteMarker "Inc_Zone_Two";	


diag_log "END OF AI ROUTINE!***************************************";	
};

