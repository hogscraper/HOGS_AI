//DO NOT EDIT ANYTHING INSIDE THIS TOP SECTION*****************************
HeadlessVariable = true;
publicVariable "HeadlessVariable";
  
VAS_fnc_fetchCfgDetails= compileFinal preprocessFileLineNumbers "custom\Hogs_AI\fn_fetchCfgDetails.sqf";
//Absolutely great function from Virtual Ammo System by Tophe
//http://www.assaultmissionstudio.de/forums/index.php?action=downloads;sa=view;down=134

Bounce_Mission=false;

HOGS_AI_VEH_DELETE=[];
HOGS_AI_BUI_DELETE=[];
HOGS_AI_GRP_DELETE=[];

AI_to_be_Killed=0;

//**********************************************DO NOT EDIT ABOVE THIS LINE


/*
This file contains all of the relevant variables for the HOGS_AI Mission System. It also contains
short tutorials/hints on how to utilize each variable to maximize your users' AI experience.
*/


//Static_Missions is used to determine whether or not each mission that spawns has its own unique number of spawns, (AI, vehicles, buildings), and unique messages
//If Static_Missions=true; then every mission will spawn with whatever is in HOGS_AI_Mission_Sets select 0.
Static_Missions=false;

//This is the mission timer code. 1800 seconds = 30 minutes
AI_Timer={_HAI_TIMER=time;waitUntil{(time-_HAI_TIMER)>3600};Bounce_Mission=true;};
Prize_Timer = 600;  //Number of seconds before the prize box is deleted. Prize_Timer = 0; will leave boxes until server restart.
Mission_Delay = 20; //This is the time, (in seconds), to delay between the end of one mission and the start of the next.
Mission_Marker_X = 600; //Mission markers will be circles with width and height equal to these values.
Mission_Marker_Y = 600; //Keep both values the same or it could cause problems with the end mission code.
Special_Mission_01=1; //Number of Building Materials missions to allow per reset
Special_Mission_02=0; //Number of Water based missions to allow per restart


//These values are generic for Altis. You can add/subtract/edit positions here but there must be at least one set for the mission system to work
AO_Locations_Main=[
[11568.8,7094.85,0.1],
[9233.5,7990.47,0.1],
[11716.9,9154.39,0.1],
[10098.3,10197.9,0.1],
[7449.38,11152.4,0.1],
[5043.86,11039.3,0.1],
[3730.19,10640.5,0.1],
[4076.73,11590.3,0.1],
[3830.87,13195.1,0.1],
[7299.74,12105.9,0.1],
[9232.45,12056,0.1],
[10543.9,12170.1,0.1],
[12388.8,13286.5,0.1],
[10907.8,13336.8,0.1],
[9175.78,13760,0.1],
[5475.5,14998.2,0.1],
[4623.14,15516.3,0.1],
[7001.43,16426.9,0.1],
[9387.95,15839.9,0.1],
[12823.3,14945.6,0.1],
[12804.3,16661.2,0.1],
[11743,18375.5,0.1],
[10211.7,19075.8,0.1],
[3989.77,19258.1,0.1],
[4659.19,21340,0.1],
[7413.9,21573.1,0.1],
[11668.6,21508.3,0.1],
[14276.2,22058,0.1],
[14685.5,20761,0.1],
[14151.9,18658.9,0.1],
[14283.4,16270.2,0.1],
[15467.2,16168.2,0.1],
[17411.5,13176.5,0.1],
[16664.1,12762.6,0.1],
[19862,6120.49,0.1],
[21592.4,7620.39,0.1],
[20390.3,8774.25,0.1],
[18347.3,10194.5,0.1],
[20417,11745,0.1],
[19339.8,13125.3,0.1],
[18501.1,14294.6,0.1],
[19432.1,15451.1,0.1],
[16072.9,17011.8,0.1],
[16744.7,16141.7,0.1],
[18823.6,16633.6,0.1],
[18245,15448.9,0.1],
[21286.6,16280.7,0.1],
[20824.4,16969,0.1],
[20943.7,19262.6,0.1],
[22059.3,21290.8,0.1],
[23513.3,21134.9,0.1],
[25619.2,21403.3,0.1],
[26876,23081,0.1]
];
AO_Locations_Water=[
[2705.86,9077.17,0.1],//water west south
[2518.97,16159.5,0.1],//water west mid
[8638.1,24245.7,0.1],//water west north
[23851.7,5093.93,0.1],//water east south
[23150.4,14693.8,0.1],//water east mid
[27949.8,24230.9,0.1],//water east north
[14666.3,8340.09,0.1],//water mid south
[15414.3,14609.2,0.1],//water mid mid
[18184.2,20919.4,0.1]//water mid north
];


//If any of these 4 variables are set to true, the appropriate arrays will be used when filling prize crates.

Prize_Add_Items=true; 
Prize_Add_Weapons=true; 
Prize_Add_Backpacks=true;
Prize_Add_Magazines=true;

Randomize_Prize = 0; //Choices are 0,1,2 or 3

Prize_Number = 10; 
Prize_Quantity_Min = 2;
Prize_Quantity_Max = 20;

Weapon_Number = 10; 
Weapon_Quantity_Min = 1;
Weapon_Quantity_Max = 5;

Bacpack_Number = 10; 
Backpack_Quantity_Min = 1;
Backpack_Quantity_Max = 2;

Magazine_Number = 5; 
Magazine_Quantity_Min = 2;
Magazine_Quantity_Max = 10;

//Choice 0 - Will spawn each item in the four Prize_Pool arrays in the quantities specified below.
//Choice 1 - Prize_Number values can be utilized to pare down the list and only spawn a randomized
//choice of items from the Prize_Pool instead of all of them. Quantity of each is the same as choice 0.
//Choice 2 - Utilize Prize_Quantity values only and ignore Prize_Number. This will spawn a random
//number of every item in Prize_Pool using the Min and Max values above.
//Choice 3 - Utilize both Prize_Number and Prize_Quantity values. With Choice 3 you now override all 
//of the quantities below and spawn a random number of items from a Number sized Prize_Pool.

//These options also apply to the ALT_Prize_Pools when using the override line in the Mission_Set settings below.

//If editing the Prize_Pools, ensure that you are noting whether the "classname" is a weapon,
//item, magazine or backpack and double check that you placed the "classname" into the correct array.

//Please be advised that Epoch will kick for cargo restriction if you add certain combo weapons
//instead of the plain versions listed in the AI equip lists, (like a katiba variant that already
//has the scope in the name). Instead add both the gun and the attachments you want separately.

Prize_Pool=[
["ItemTopaz",1],["ItemOnyx",1],["ItemSapphire",1],["ItemAmethyst",1],["ItemEmerald",1],["ItemCitrine",1],["ItemRuby",1],["ItemQuartz",1],["ItemJade",1],["ItemGarnet",1],
["lighter_epoch",1],["JackKit",1],  //
["ItemLockbox",1],["ItemCoolerE",1],
["ItemSilverBar",1],["ItemGoldBar",1],["ItemGoldBar10oz",1],["PartOre",1],["PartOreSilver",1],["PartOreGold",1],["ItemKiloHemp",1],
["VehicleRepair",1],["VehicleRepairLg",1],["EnergyPack",1],["EnergyPackLg",1],["FAK",1],["Heal_EPOCH",1],["Defib_EPOCH",1],["Repair_EPOCH",1],
["ItemDocument",1],["ItemMixOil",1],["emptyjar_epoch",1],["jerrycan_epoch",1],["CircuitParts",1],["ItemScraps",1],["Pelt_EPOCH",1],["Venom_EPOCH",1],["WoodLog_EPOCH",1],
["PaintCanBlk",1],["PaintCanBlu",1],["PaintCanBrn",1],["PaintCanGrn",1],["PaintCanOra",1],["PaintCanPur",1],["PaintCanRed",1],["PaintCanTeal",1],["PaintCanYel",1],
["CinderBlocks",1],["MortarBucket",1],["PartPlankPack",1],["ItemCorrugated",1],["ItemCorrugatedLg",1],
["KitStudWall",1],["KitWoodFloor",1],["KitWoodStairs",1],["KitWoodRamp",1],["KitFirePlace",1],["KitTiPi",1],["KitShelf",1],["KitFoundation",1],["KitPlotPole",1],["KitCinderWall",1],
["WhiskeyNoodle",1],["ItemSodaOrangeSherbet",1],["ItemSodaPurple",1],["ItemSodaMocha",1],["ItemSodaBurst",1],["ItemSodaRbull",1],
["FoodMeeps",1],["FoodSnooter",1],["FoodWalkNSons",1],["sardines_epoch",1],["meatballs_epoch",1],["scam_epoch",1],["sweetcorn_epoch",1],["honey_epoch",1],
["SnakeMeat_EPOCH",1],["CookedRabbit_EPOCH",1],["CookedChicken_EPOCH",1],["CookedGoat_EPOCH",1],["CookedSheep_EPOCH",1],["ItemTrout",1],["ItemSeaBass",1],["ItemTuna",1],
["Towelette",1],["HeatPack",1],["ColdPack",1]
];
Prize_Pool_Weapons=[["ChainSaw",1],["Hatchet",1],["MeleeSledge",1],["srifle_DMR_01_F",1],["srifle_EBR_F",1],["srifle_GM6_F",1],["srifle_GM6_camo_F",1],["srifle_LRR_F",1],["srifle_LRR_camo_F",1],["LMG_Mk200_F",1],["LMG_Zafir_F",1],["arifle_Katiba_F",1],["arifle_Katiba_C_F",1],["arifle_Katiba_GL_F",1],["arifle_Mk20_F",1],["arifle_Mk20_plain_F",1],["arifle_Mk20C_F",1],["arifle_Mk20C_plain_F",1],["arifle_Mk20_GL_F",1],["arifle_Mk20_GL_plain_F",1],["arifle_MXC_F",1],["arifle_MX_F",1],["arifle_MX_GL_F",1],["arifle_MX_SW_F",1],["arifle_MXM_F",1],["arifle_MXC_Black_F",1],["arifle_MX_Black_F",1],["arifle_MX_GL_Black_F",1],["arifle_MX_SW_Black_F",1],["arifle_MXM_Black_F",1],["arifle_TRG21_F",1],["arifle_TRG20_F",1],["arifle_TRG21_GL_F",1],["hgun_PDW2000_F",1],["SMG_01_F",1],["SMG_02_F",1],["launch_NLAW_F",1],["launch_RPG32_F",1],["launch_O_Titan_F",1],["launch_O_Titan_short_F",1],["hgun_ACPC2_F",1],["hgun_P07_F",1],["hgun_Pistol_heavy_01_F",1],["hgun_Pistol_heavy_02_F",1],["hgun_Rook40_F",1],["hgun_Pistol_Signal_F",1]];
Prize_Pool_Backpacks=[["B_AssaultPack_khk",1],["B_AssaultPack_dgtl",1],["B_AssaultPack_rgr",1],["B_AssaultPack_sgg",1],["B_AssaultPack_blk",1],["B_AssaultPack_cbr",1],["B_AssaultPack_mcamo",1],["B_Kitbag_rgr",1],["B_Kitbag_mcamo",1],["B_Kitbag_sgg",1],["B_Kitbag_cbr",1],["B_Bergen_sgg",1],["B_Bergen_mcamo",1],["B_Bergen_rgr",1],["B_Bergen_blk",1],["B_FieldPack_blk",1],["B_FieldPack_ocamo",1],["B_FieldPack_oucamo",1],["B_FieldPack_cbr",1],["B_FieldPack_oli",1],["B_FieldPack_khk",1],["B_Carryall_ocamo",1],["B_Carryall_oucamo",1],["B_Carryall_mcamo",1],["B_Carryall_oli",1],["B_Carryall_khk",1],["B_Carryall_cbr",1],["B_OutdoorPack_blk",1],["B_OutdoorPack_tan",1],["B_OutdoorPack_blu",1],["B_HuntingBackpack",1],["smallbackpack_red_epoch",1],["smallbackpack_green_epoch",1],["smallbackpack_teal_epoch",1],["smallbackpack_pink_epoch",1]];
Prize_Pool_Magazines=[["20Rnd_762x51_Mag",1],["10Rnd_762x51_Mag",1],["30Rnd_762x39_Mag",1],["150Rnd_762x51_Box",1],["150Rnd_762x51_Box_Tracer",1],["5Rnd_127x108_Mag",1],["5Rnd_127x108_APDS_Mag",1],["30Rnd_65x39_caseless_green",1],["30Rnd_65x39_caseless_green_mag_Tracer",1],["30Rnd_65x39_caseless_mag",1],["30Rnd_65x39_caseless_mag_Tracer",1],["200Rnd_65x39_cased_Box",1],["100Rnd_65x39_caseless_mag",1],["200Rnd_65x39_cased_Box_Tracer",1],["100Rnd_65x39_caseless_mag_Tracer",1],["20Rnd_556x45_UW_mag",1],["30Rnd_556x45_Stanag",1],["30Rnd_556x45_Stanag_Tracer_Red",1],["30Rnd_556x45_Stanag_Tracer_Green",1],["30Rnd_556x45_Stanag_Tracer_Yellow",1],["200Rnd_556x45_M249",1],["7Rnd_408_Mag",1],["spear_magazine",1],["5Rnd_rollins_mag",1],["30Rnd_45ACP_Mag_SMG_01",1],["30Rnd_45ACP_Mag_SMG_01_Tracer_Green",1],["9Rnd_45ACP_Mag",1],["11Rnd_45ACP_Mag",1],["6Rnd_45ACP_Cylinder",1],["16Rnd_9x21_Mag",1],["30Rnd_9x21_Mag",1],["10rnd_22X44_magazine",1],["9rnd_45X88_magazine",1],["B_IR_Grenade",1],["O_IR_Grenade",1],["I_IR_Grenade",1],["HandGrenade",1],["MiniGrenade",1],["HandGrenade_Stone",1],["SmokeShell",1],["SmokeShellRed",1],["SmokeShellGreen",1],["SmokeShellYellow",1],["SmokeShellPurple",1],["SmokeShellBlue",1],["SmokeShellOrange",1],["Chemlight_green",1],["Chemlight_red",1],["Chemlight_yellow",1],["Chemlight_blue",1]];

Alt_Prize_Pool_01=[];
Alt_Prize_Pool_01_Weapons=[];
Alt_Prize_Pool_01_Backpacks=[];
Alt_Prize_Pool_01_Magazines=[];

Alt_Prize_Pool_02=[];
Alt_Prize_Pool_02_Weapons=[];
Alt_Prize_Pool_02_Backpacks=[];
Alt_Prize_Pool_02_Magazines=[];

Alt_Prize_Pool_03=[  //Massive Incursion Prize pool
["ItemTopaz",3],["ItemOnyx",3],["ItemSapphire",3],["ItemAmethyst",3],["ItemEmerald",3],["ItemCitrine",3],["ItemRuby",3],["ItemQuartz",3],["ItemJade",3],["ItemGarnet",3],["CinderBlocks",40],["MortarBucket",10]];
Alt_Prize_Pool_03_Weapons=[["ChainSaw",3],["Hatchet",3],["MeleeSledge",3],["srifle_DMR_01_F",5],["srifle_EBR_F",5],["srifle_GM6_F",5],["srifle_GM6_camo_F",5],["srifle_LRR_F",5],["srifle_LRR_camo_F",5],["LMG_Mk200_F",5],["LMG_Zafir_F",5],["arifle_Katiba_F",5],["arifle_Katiba_C_F",5],["arifle_Katiba_GL_F",5]];
Alt_Prize_Pool_03_Backpacks=[["B_Carryall_ocamo",3],["B_Carryall_oucamo",3],["B_Carryall_mcamo",3],["B_Carryall_oli",3],["B_Carryall_khk",3],["B_Carryall_cbr",3]];
Alt_Prize_Pool_03_Magazines=[["20Rnd_762x51_Mag",10],["10Rnd_762x51_Mag",10],["30Rnd_762x39_Mag",10],["150Rnd_762x51_Box",10],["150Rnd_762x51_Box_Tracer",10],["5Rnd_127x108_Mag",10],["5Rnd_127x108_APDS_Mag",10],["30Rnd_65x39_caseless_green",10],["30Rnd_65x39_caseless_green_mag_Tracer",10]];

Alt_Prize_Pool_04=[ //Building supply mission prize pool
["lighter_epoch",2],["ItemMixOil",2],["JackKit",2],["jerrycan_epoch",1],
["CinderBlocks",20],["MortarBucket",6],["PartPlankPack",10],["ItemCorrugated",5],["ItemCorrugatedLg",5],["KitFirePlace",1],
["KitStudWall",4],["KitWoodFloor",4],["KitWoodStairs",4],["KitWoodRamp",1]
];
Alt_Prize_Pool_04_Weapons=[["ChainSaw",1],["Hatchet",1],["MeleeSledge",1]];
Alt_Prize_Pool_04_Backpacks=[["smallbackpack_red_epoch",1],["smallbackpack_green_epoch",1],["smallbackpack_teal_epoch",1],["smallbackpack_pink_epoch",1]];
Alt_Prize_Pool_04_Magazines=[["Chemlight_green",1],["Chemlight_red",1],["Chemlight_yellow",1],["Chemlight_blue",1]];



//This section defines pools of items that will be drawn from if random gear=true in the current mission.
//The true values determine whether or not to randomly assign an available attachment to that slot. 
//Does nothing if item not available for that weapon/slot or if set to false. Items with numbers dictate
//the amount of that item to add to the AI from the available pool of items. If, for example, you didn't
//want your AI to have any deployable explosives you would set that value to 0 instead of 2. These values 
//only affect randomized gear selections. 

AI_Give_Uniform=true;
AI_Give_Vest=true;
AI_Give_Backpack=true;
AI_Give_HeadGear=true;
AI_Give_Goggles=true;
AI_Nightvision=true; //will equip "NVGoggles" to each AI
AI_Give_Primary_Weapon=true;
AI_Primary_Attachments_Muzzles=true; 
AI_Primary_Attachments_Optics=true;
AI_Primary_Attachments_Pointers=true;
AI_Primary_Magazines=5;
AI_Give_Secondary_Weapon=true;
AI_Secondary_Magazines=1;
AI_Give_Handgun=true;
AI_Handgun_Attachments_Muzzles=true;
AI_Handgun_Attachments_Optics=true;
AI_Handgun_Attachments_Pointers=true;
AI_Handgun_Magazines=5;
AI_Number_Of_Throwable_Items=2;
AI_Number_Of_Deployable_Weapons=2;
AI_Number_Of_Assigned_Items = 3; 
AI_Number_Of_Inventory_Items = 2;

//Two options in the below mission sets effect your AI gear. You must have
//a gear set defined in your mission and whether or not you want the gear to be randomized. 
//There are two types of gear sets below. The first type is Gear Set 0 and is to be used when
//random gear is set to true in your mission. These types of gear sets do not show things like
//weapon attachments and are bound by the variables above. The other type of gear set is like 
//Set 1 and is only to be used when random gear=false in your mission. These types of gear sets
//will load whatever is shown on all the AI for that mission. An example loadout is provided if
//you wanted to make an underwater mission. The only variables in the above list that Set 1 and 
//random gear=false use are the magazine variables. Please note that if you place more than one
//Primary Weapon into a Gear Set like Set 1, only the first one listed will be used.

AI_GEAR_SETS=[
//Gear Set 0 - Type = Randomized gear set
[
//Uniforms
["U_O_SpecopsUniform_blk","U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt","U_B_CombatUniform_mcam_vest","U_B_GhillieSuit","U_B_HeliPilotCoveralls","U_B_Wetsuit","U_O_CombatUniform_ocamo","U_O_GhillieSuit","U_O_PilotCoveralls","U_O_Wetsuit","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_Rangemaster","U_NikosBody","U_OrestesBody","U_B_CombatUniform_mcam_worn","U_B_CombatUniform_wdl","U_B_CombatUniform_wdl_tshirt","U_B_CombatUniform_wdl_vest","U_B_CombatUniform_sgg","U_B_CombatUniform_sgg_tshirt","U_B_CombatUniform_sgg_vest","U_B_SpecopsUniform_sgg","U_B_PilotCoveralls","U_O_CombatUniform_oucamo","U_O_SpecopsUniform_ocamo","U_O_OfficerUniform_ocamo","U_I_CombatUniform","U_I_CombatUniform_tshirt","U_I_CombatUniform_shortsleeve","U_I_pilotCoveralls","U_I_HeliPilotCoveralls","U_I_GhillieSuit","U_I_OfficerUniform","U_I_Wetsuit","U_Competitor","U_MillerBody","U_KerryBody","U_AttisBody","U_AntigonaBody","U_IG_Menelaos","U_C_Novak","U_OI_Scientist","U_IG_Guerilla1_1","U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla2_3","U_IG_Guerilla3_1","U_IG_Guerilla3_2","U_IG_leader","U_BG_Guerilla1_1","U_BG_Guerilla2_1","U_BG_Guerilla2_2","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_BG_Guerilla3_2","U_BG_leader","U_OG_Guerilla1_1","U_OG_Guerilla2_1","U_OG_Guerilla2_2","U_OG_Guerilla2_3","U_OG_Guerilla3_1","U_OG_Guerilla3_2","U_OG_leader","U_C_Poor_1","U_C_Poor_2","U_C_Scavenger_1","U_C_Scavenger_2","U_C_Farmer","U_C_Fisherman","U_C_WorkerOveralls","U_C_FishermanOveralls","U_C_WorkerCoveralls","U_C_HunterBody_grn","U_C_HunterBody_brn","U_C_Commoner2_1","U_C_Commoner2_2","U_C_Commoner2_3","U_C_PriestBody","U_C_Poor_shorts_1","U_C_Poor_shorts_2","U_C_Commoner_shorts","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2","U_B_CTRG_1","U_B_CTRG_2","U_B_CTRG_3","U_B_survival_uniform","U_I_G_Story_Protagonist_F","U_I_G_resistanceLeader_F","U_C_Journalist","U_C_Scientist","U_NikosAgedBody","U_C_Driver_1","U_C_Driver_2","U_C_Driver_3","U_C_Driver_4","U_C_Driver_1_black","U_C_Driver_1_blue","U_C_Driver_1_green","U_C_Driver_1_red","U_C_Driver_1_white","U_C_Driver_1_yellow","U_C_Driver_1_orange","U_Marshal","U_B_Protagonist_VR","U_O_Protagonist_VR","U_I_Protagonist_VR","U_IG_Guerrilla_6_1","U_BG_Guerrilla_6_1","U_OG_Guerrilla_6_1","U_B_Soldier_VR","U_O_Soldier_VR","U_I_Soldier_VR","U_C_Soldier_VR"],
//Vests
["V_1_EPOCH","V_2_EPOCH","V_3_EPOCH","V_4_EPOCH","V_5_EPOCH","V_6_EPOCH","V_7_EPOCH","V_8_EPOCH","V_9_EPOCH","V_10_EPOCH","V_11_EPOCH","V_12_EPOCH","V_13_EPOCH","V_14_EPOCH","V_15_EPOCH","V_16_EPOCH","V_17_EPOCH","V_18_EPOCH","V_19_EPOCH","V_20_EPOCH","V_21_EPOCH","V_22_EPOCH","V_23_EPOCH","V_24_EPOCH","V_25_EPOCH","V_26_EPOCH","V_27_EPOCH","V_28_EPOCH","V_29_EPOCH","V_30_EPOCH","V_31_EPOCH","V_32_EPOCH","V_33_EPOCH","V_34_EPOCH","V_35_EPOCH","V_36_EPOCH","V_37_EPOCH","V_38_EPOCH","V_39_EPOCH","V_40_EPOCH"],
//Backpacks
["B_AssaultPack_khk","B_AssaultPack_dgtl","B_AssaultPack_rgr","B_AssaultPack_sgg","B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_mcamo","B_Kitbag_rgr","B_Kitbag_mcamo","B_Kitbag_sgg","B_Kitbag_cbr","B_Bergen_sgg","B_Bergen_mcamo","B_Bergen_rgr","B_Bergen_blk","B_FieldPack_blk","B_FieldPack_ocamo","B_FieldPack_oucamo","B_FieldPack_cbr","B_FieldPack_oli","B_FieldPack_khk","B_Carryall_ocamo","B_Carryall_oucamo","B_Carryall_mcamo","B_Carryall_oli","B_Carryall_khk","B_Carryall_cbr","B_OutdoorPack_blk","B_OutdoorPack_tan","B_OutdoorPack_blu","B_HuntingBackpack","smallbackpack_red_epoch","smallbackpack_green_epoch","smallbackpack_teal_epoch","smallbackpack_pink_epoch"],
//HeadGears
["H_1_EPOCH","H_2_EPOCH","H_3_EPOCH","H_4_EPOCH","H_5_EPOCH","H_6_EPOCH","H_7_EPOCH","H_8_EPOCH","H_9_EPOCH","H_10_EPOCH","H_11_EPOCH","H_12_EPOCH","H_13_EPOCH","H_14_EPOCH","H_15_EPOCH","H_16_EPOCH","H_17_EPOCH","H_18_EPOCH","H_19_EPOCH","H_20_EPOCH","H_21_EPOCH","H_22_EPOCH","H_23_EPOCH","H_24_EPOCH","H_25_EPOCH","H_26_EPOCH","H_27_EPOCH","H_28_EPOCH","H_29_EPOCH","H_30_EPOCH","H_31_EPOCH","H_32_EPOCH","H_33_EPOCH","H_34_EPOCH","H_35_EPOCH","H_36_EPOCH","H_37_EPOCH","H_38_EPOCH","H_39_EPOCH","H_40_EPOCH","H_41_EPOCH","H_42_EPOCH","H_43_EPOCH","H_44_EPOCH","H_45_EPOCH","H_46_EPOCH","H_47_EPOCH","H_48_EPOCH","H_49_EPOCH","H_50_EPOCH","H_51_EPOCH","H_52_EPOCH","H_53_EPOCH","H_54_EPOCH","H_55_EPOCH","H_56_EPOCH","H_57_EPOCH","H_58_EPOCH","H_59_EPOCH","H_60_EPOCH","H_61_EPOCH","H_62_EPOCH","H_63_EPOCH","H_64_EPOCH","H_65_EPOCH","H_66_EPOCH","H_67_EPOCH","H_68_EPOCH","H_69_EPOCH","H_70_EPOCH","H_71_EPOCH","H_72_EPOCH","H_73_EPOCH","H_74_EPOCH","H_75_EPOCH","H_76_EPOCH","H_77_EPOCH","H_78_EPOCH","H_79_EPOCH","H_80_EPOCH","H_81_EPOCH","H_82_EPOCH","H_83_EPOCH","H_84_EPOCH","H_85_EPOCH","H_86_EPOCH","H_87_EPOCH","H_88_EPOCH","H_89_EPOCH","H_90_EPOCH","H_91_EPOCH","H_92_EPOCH","H_93_EPOCH","H_94_EPOCH","H_95_EPOCH","H_96_EPOCH","H_97_EPOCH","H_98_EPOCH","H_99_EPOCH","H_100_EPOCH","H_101_EPOCH","H_102_EPOCH","H_103_EPOCH","H_104_EPOCH","wolf_mask_epoch","pkin_mask_epoch"],
//Goggles
["G_Spectacles","G_Spectacles_Tinted","G_Combat","G_Lowprofile","G_Shades_Black","G_Shades_Green","G_Shades_Red","G_Squares","G_Squares_Tinted","G_Sport_BlackWhite","G_Sport_Blackyellow","G_Sport_Greenblack","G_Sport_Checkered","G_Sport_Red","G_Tactical_Black","G_Aviator","G_Lady_Mirror","G_Lady_Dark","G_Lady_Red","G_Lady_Blue","G_Diving","G_B_Diving","G_O_Diving","G_I_Diving","G_Goggles_VR","G_Balaclava_blk","G_Balaclava_oli","G_Balaclava_combat","G_Balaclava_lowprofile","G_Bandanna_blk","G_Bandanna_oli","G_Bandanna_khk","G_Bandanna_tan","G_Bandanna_beast","G_Bandanna_shades","G_Bandanna_sport","G_Bandanna_aviator","G_Shades_Blue","G_Sport_Blackred","G_Tactical_Clear"],
//Primary Weapons
["srifle_DMR_01_F","srifle_EBR_F","srifle_GM6_F","srifle_GM6_camo_F","srifle_LRR_F","srifle_LRR_camo_F","LMG_Mk200_F","LMG_Zafir_F","arifle_Katiba_F","arifle_Katiba_C_F","arifle_Katiba_GL_F","arifle_Mk20_F","arifle_Mk20_plain_F","arifle_Mk20C_F","arifle_Mk20C_plain_F","arifle_Mk20_GL_F","arifle_Mk20_GL_plain_F","arifle_MXC_F","arifle_MX_F","arifle_MX_GL_F","arifle_MX_SW_F","arifle_MXM_F","arifle_MXC_Black_F","arifle_MX_Black_F","arifle_MX_GL_Black_F","arifle_MX_SW_Black_F","arifle_MXM_Black_F","arifle_TRG21_F","arifle_TRG20_F","arifle_TRG21_GL_F","hgun_PDW2000_F","SMG_01_F","SMG_02_F"],
//Secondary Weapons
["launch_NLAW_F","launch_RPG32_F","launch_O_Titan_F","launch_O_Titan_short_F"],
//Handguns
["hgun_ACPC2_F","hgun_P07_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_02_F","hgun_Rook40_F","hgun_Pistol_Signal_F"],
//Throwable Items
["B_IR_Grenade","O_IR_Grenade","I_IR_Grenade","HandGrenade","MiniGrenade","HandGrenade_Stone","SmokeShell","SmokeShellRed","SmokeShellGreen","SmokeShellYellow","SmokeShellPurple","SmokeShellBlue","SmokeShellOrange","Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"],
//Deployable Weapons
["ATMine_Range_Mag","APERSMine_Range_Mag","APERSBoundingMine_Range_Mag","SLAMDirectionalMine_Wire_Mag","APERSTripMine_Wire_Mag","ClaymoreDirectionalMine_Remote_Mag","SatchelCharge_Remote_Mag","DemoCharge_Remote_Mag","IEDUrbanBig_Remote_Mag","IEDLandBig_Remote_Mag","IEDUrbanSmall_Remote_Mag","IEDLandSmall_Remote_Mag"],
//Assigned Items
["ItemWatch","ItemCompass","ItemMap","MineDetector","ItemGPS"], //,"Binocular",-"Rangefinder",
//Inventory Items
["ItemSodaPurple","ItemSodaMocha","ItemSodaBurst","ItemTrout","FoodSnooter","FoodWalkNSons","WhiskeyNoodle","FAK","Pelt_EPOCH","Venom_EPOCH","SnakeMeat_EPOCH","CookedRabbit_EPOCH","CookedChicken_EPOCH","CookedGoat_EPOCH","CookedSheep_EPOCH","Towelette","HeatPack","ColdPack"]
],

//Gear Set 1 - Type = Strict gear set - Underwater Gear Set
[
//Uniform
"U_B_Wetsuit",
//Vest
"V_RebreatherB",
//Backpack
"smallbackpack_pink_epoch",
//HeadGear
"H_7_EPOCH",
//Goggles
"G_Diving",
//Primary Weapon
"arifle_SDAR_F",
//Primary Weapon Attachment - Muzzle
"",
//Primary Weapon Attachment - Optic
"",
//Primary Weapon Attachment - Pointer
"",
//Secondary Weapon
"",
//Handgun
"",
//Handgun Attachment - Muzzle
"",
//Handgun Attachment - Optic
"",
//Handgun Attachment - Pointer
"",
//Assigned Items
["ItemGPS","ItemCompass"],
//Inventory Items
["ItemSodaBurst","FoodWalkNSons","ItemGoldBar10oz"]
],

//Gear Set 2 - Type = Strict gear set - Sniper Gear Set
[
//Uniform
"U_I_GhillieSuit",
//Vest
"",
//Backpack
"B_OutdoorPack_blk",
//HeadGear
"",
//Goggles
"",
//Primary Weapon
"srifle_DMR_01_F",
//Primary Weapon Attachment - Muzzle
"muzzle_snds_B",
//Primary Weapon Attachment - Optic
"optic_SOS",
//Primary Weapon Attachment - Pointer
"acc_pointer_IR",
//Secondary Weapon
"",
//Handgun
"hgun_Rook40_F",
//Handgun Attachment - Muzzle
"",
//Handgun Attachment - Optic
"",
//Handgun Attachment - Pointer
"",
//Assigned Items
["ItemGPS","ItemCompass"],
//Inventory Items
["ItemSodaBurst","FoodWalkNSons","ItemGoldBar10oz"]
]
];


//These are lists of Epoch vehicles from the config. You can use any vehicle you wish
//in your custom missions but I have not investigated whether or not these have had
//custom inventory slots or custom armor values so use vehicles not in these lists at your own risk.
//Mission_Vehicles_Air=["B_Heli_Light_01_EPOCH","B_Heli_Transport_03_unarmed_EPOCH","I_Heli_light_03_unarmed_EPOCH","I_Heli_Transport_02_EPOCH","O_Heli_Light_02_unarmed_EPOCH","O_Heli_Transport_04_bench_EPOCH","O_Heli_Transport_04_box_EPOCH","O_Heli_Transport_04_covered_EPOCH","O_Heli_Transport_04_EPOCH"];
//Mission_Vehicles_Land=["B_MRAP_01_EPOCH","B_SDV_01_EPOCH","B_Truck_01_box_EPOCH","B_Truck_01_covered_EPOCH","B_Truck_01_mover_EPOCH","B_Truck_01_transport_EPOCH","C_Hatchback_01_EPOCH","C_Hatchback_02_EPOCH","C_Offroad_01_EPOCH","C_Quadbike_01_EPOCH","C_SUV_01_EPOCH","C_Van_01_box_EPOCH","C_Van_01_transport_EPOCH","ebike_epoch","K01","K02","K03","K04","O_Truck_02_box_EPOCH","O_Truck_02_covered_EPOCH","O_Truck_02_transport_EPOCH","O_Truck_03_covered_EPOCH"];
//Mission_Vehicles_Sea=["C_Rubberboat_02_EPOCH","C_Rubberboat_03_EPOCH","C_Rubberboat_04_EPOCH","C_Rubberboat_EPOCH","C_Boat_Civil_01_EPOCH","C_Boat_Civil_01_police_EPOCH","C_Boat_Civil_01_rescue_EPOCH","jetski_epoch"];

HOGS_AI_Mission_Sets=[
//Format for sets is 
//[
//[Alert message, ai eliminated message, ai got away message],
//[[# of ai to spawn, x offset, y offset, type, radius(optional), skill], [# of ai to spawn,x offset, y offset,type,radius(optional),skill]],
//[[un-manned vehicle class name to spawn, x offset, y offset, direction],[un-manned vehicle class name to spawn, x offset, y offset, direction]],
//[[manned vehicle class name to spawn, x offset, y offset, direction],[manned vehicle class name to spawn, x offset, y offset, direction]],
//[[static weapon class name to spawn, x offset, y offset, direction],[static weapon class name to spawn, x offset, y offset, direction]],
//[[building class name to spawn, x offset, y offset, direction],[building class name to spawn, x offset, y offset, direction]],

//true/false (Use Randomized Gear)
//0,1,2,3,... (Gear Set to Use)
//(-1,1,2,3,4) Prize_Pool Override / Use 1-4 to load what's listed in one of the four ALT_Prize_Pool's as if that alt pool were Prize_Pool and will work with Randomize_Prize=0,1,2 or 3 / -1 is no override
//[0,0,0] (optional) Forced AO position that will override whatever AO coords that were randomly chosen
//]

//SET 1 GENERIC/4 GROUPS DEFENDING THEIR SPAWNS/2 UN-MANNED VEHICLE SPAWNS
[

//First Message to broadcast to server so everyone knows a new AO has been chosen. <br/> creates a new line in your hint
["<t align='center' size='2.0'>Hogscorp<br/>Defense Alert!</t><br/>______________<br/><br/>
		Our radar has picked up terrorist activity and marked it on your map!<br/>
		You have our permission to confiscate any property you find as payment for eliminating the threat!",
//Message to broadcast to server if the AI are all killed or they all leave the AO
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		Good work citizens.<br/>
		The threat has been eliminated!<br/>
		Stand by while our radar makes another pass.",
//Message to broadcast to server if time runs out on the mission		
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		The terrorists have slipped out of the area!<br/>
		We will attempt to find their new location.<br/>
		Stand by while our radar makes another pass."],

//You can have as many groups as you want.
//Group format is: [[15, 0, 0, 1, 100,.7],[5, 20, 10, 1,220,.8],[10,-15,30,0,.5],[# to spawn, x offset, y offset,type of group,(optional)radius,skill level]]

//X and Y offsets are number of meters from AO center to start spawning units
//If a value for X or Y is above 300 it will use those values as strict positions to start spawning AI. 
//If the AO center is 8000,8000 the first group of AI will start spawning at 8050,8050 using the first example grou below.
//[5,50,50,1,225,.1] 
//If it instead was [5,8250,8250,1,225,.1] the group would spawn in at 8250,8250. This same idea applies to the
//unmanned vehicles, manned vehicles, buildings and mounted weapons as well and can be used to build a bandit base 
//and have things go exactly where you want them. Offsets are used when you only want them spread out relative to the 
//AO center and have nothing specific in mind.

//Type of group can either be 0 or 1. 
//0=defending their spawn location or 1=patrolling. If 1 is chosen, (patrolling as group type), a radius for the area 
//they will patrol must be entered and must be: 
//radius > 0
//radius < (Mission_Marker_X - your XOffset)
//radius < (Mission_Marker_Y - your YOffset)
//Not following those three rules can result in your AI pathing outside of the mission area which will prematurely end the mission.

//Skill level is between .1 and 1(1 is best skilled) and must be your last number in each section
 
[[7,50,50,0,1],[7,-50,-50,0,1],[7,150,-150,0,1],[7,150,-150,0,1]], 
//Unmanned Vehicle Class, X and Y Offsets from mission center, Direction
[["C_SUV_01_EPOCH",10,10,0],["C_Offroad_01_EPOCH",-10,-10,0]],
//Manned Vehicle Class, X and Y Offsets from mission center, Direction
[["",0,0,0],["",0,0,0]],
//Static Weapon Class, X and Y Offsets from mission center, Direction
[["",0,0,0],["",0,0,0]],
//Type of and offsets of mission buildings to spawn
[["",0,0,0],["",0,0,0]],
//Use Randomized gear for AI (true or false)-true= random gear/false=AI_OVERRIDES usage
true,
//Gear Set to use
0,
//Prize pool override / -1 = no override
-1,
//Forced AO position - leave as [0,0,0] to use random value from AO_Locations_Main
[0,0,0],
//select 10 is reserved for SPECIAL missions
""
],
//SET 2 GENERIC / 4 GROUPS PATROLLING / 2 UN-MANNED VEHICLE SPAWNS
[
["<t align='center' size='2.0'>Hogscorp<br/>Defense Alert!</t><br/>______________<br/><br/>
		Our radar has picked up multiple bandit patrols and marked them on your map!<br/>
		You have our permission to confiscate any property you find as payment for eliminating the threat!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		Good work citizens.<br/>
		The threat has been eliminated!<br/>
		Stand by while our radar makes another pass.",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		The bandits have slipped out of the area!<br/>
		We will attempt to find their new location.<br/>
		Stand by while our radar makes another pass."],
[[5,200,200,1,150,1],[5,-200,-200,1,150,1],[5,200,-200,1,150,1],[5,-200,200,1,150,1]], 
[["C_SUV_01_EPOCH",4,4,0],["C_Offroad_01_EPOCH",-9,-9,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
true,
0,
-1,
[0,0,0],
""
],
//SET 3 GENERIC / 4 GROUPS 2 DEFENDING, 2 PATROLLING / 2 MANNED VEHICLE SPAWNS / 2 BUILDINGS
[
["<t align='center' size='2.0'>Hogscorp<br/>Defense Alert!</t><br/>______________<br/><br/>
		Terrorists have established a base on Altis!<br/>
		We've marked your map where we think the stash is!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		Excellent work citizens.<br/>
		The terrorist cell has been destroyed!<br/>
		Stand by while our radar makes another pass.",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		The terrorists were warned and went underground!
		We will attempt to find their new location.<br/>
		Stand by while our radar makes another pass."],
[[6,50,50,0,1],[6,-50,-50,1,225,1],[6,150,-150,1,125,1],[6,-150,150,0,1]], 
[["",0,0,0],["",0,0,0]],
[["O_G_Offroad_01_armed_F",-110,25,0],["B_MRAP_01_gmg_F",100,25,0]],
[["",0,0,0],["",0,0,0]],
[["Land_i_House_Big_01_V1_F",6,6,0],["Land_Wreck_Car_F",-7,-7,0],["Land_Wreck_Car2_F",12,12,0],["Land_Wreck_Offroad2_F",-10,-10,0]],
true,
0,
3,
[0,0,0],
""
],
//SET 4 GENERIC / 6 GROUPS 3 DEFENDING, 3 PATROLLING / 2 UN-MANNED VEHICLE SPAWNS / 2 MANNED VEHICLE SPAWNS
[
["<t align='center' size='2.0'>Hogscorp<br/>Defense Alert!</t><br/>______________<br/><br/>
		A massive group of terrorists are guarding a shipment of sniper rifles!<br/>
		We've marked your map where we think the stash is!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		Good work citizens.<br/>
		The terrorists have been wiped out!<br/>
		Stand by while our radar makes another pass.",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		The terrorists have handed off the rifles and moved out!<br/>
		We will attempt to find their new location.<br/>
		Stand by while our radar makes another pass."],
[[5,50,50,1,225,1],[5,-50,-50,1,225,1],[5,225,150,1,125,1],[5,-150,-150,0,1],[5,-175,50,0,1],[5,175,50,0,1]], 
[["C_SUV_01_EPOCH",4,4,0],["C_Offroad_01_EPOCH",-9,-9,0]],
[["O_G_Offroad_01_armed_F",-100,25,0],["I_MBT_03_cannon_F",100,25,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
true,
0,
3,
[0,0,0],
""
],
//SET 5 GENERIC / 6 GROUPS OF 3 DEFENDING / SNIPERS
[
["<t align='center' size='2.0'>Hogscorp<br/>Defense Alert!</t><br/>______________<br/><br/>
		Terrorist snipers have been spotted taking up positions in Altis!<br/>
		We've marked the area on your map!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		Good work citizens.<br/>
		The terrorists have been wiped out!<br/>
		Stand by while our radar makes another pass.",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		The terrorists have moved on to other targets!<br/>
		We will attempt to find their new location.<br/>
		Stand by while our radar makes another pass."],
[[3,250,0,0,1],[3,-250,0,0,1],[3,0,250,0,1],[3,0,-250,0,1],[3,0,50,0,1],[3,50,0,0,1]], 
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
false,
2,
-1,
[0,0,0],
""
],
//SET 6 - SPECIAL BUILDING MATERIALS MISSION/ 6 GROUPS 3 DEFENDING, 3 PATROLLING / 
//2 UN-MANNED VEHICLE SPAWNS / 2 MANNED VEHICLE SPAWNS / 2 STATIC WEAPON SPAWNS / 2 BUILDING SPAWNS
[
["<t align='center' size='2.0'>Hogscorp<br/>Defense Alert!</t><br/>______________<br/><br/>
		Terrorists are stockpiling building supplies!<br/>
		Wipe them out to keep their base from being built!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		Message two.<br/>
		The terrorists have been stopped from building their base!<br/>
		Stand by while our radar makes another pass.",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		The terrorists have sneaked out of the area!<br/>
		Their new base could be anywhere...<br/>
		Stand by while our radar makes another pass."],
[[10,50,50,0,1],[10,-50,-50,0,1],[5,150,150,1,125,1],[5,-150,-150,0,1],[5,100,100,0,1],[5,-100,-100,0,1]], 
[["C_SUV_01_EPOCH",4837.46,21977.5,27.69],["O_Heli_Transport_04_EPOCH",4840.13,21914,131.38]],
[["O_G_Offroad_01_armed_F",4884.49,21881.8,118.33],["I_MBT_03_cannon_F",4924.39,21908.7,136.73]],
[["O_HMG_01_high_F",-40,-40,0],["I_Mortar_01_F",45,45,0],["O_GMG_01_high_F",150,150,0]],
[["Land_HighVoltageTower_F",4873.4,21894.6,0],["Land_Unfinished_Building_01_F",4826.09,21961,187.68]], 
true,
0,
4,
[9999,9999,0.1],
"BUILDING_MATERIALS"
],

//SET 7 / SPECIAL / WATER BASED MISSION / 2 GROUPS 1 DEFENDING 1 PATROLLING
[
["<t align='center' size='2.0'>Hogscorp<br/>Defense Alert!</t><br/>______________<br/><br/>
		Bandits may have found a long lost gold shipment!<br/>
		Check it out and get rid of those scumbags!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		Message two.<br/>
		Excellent work on killing those bandits!<br/>
		Maybe they will think twice before coming back!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		The bandits got away with the gold!<br/>
		Too bad...<br/>
		Stand by while our radar makes another pass."],
 
[[10,0,0,1,250,1],[10,-50,50,0,1],[0,0,0,0,1],[0,0,0,0,1]], 
[["jetski_epoch",50,50,0],["C_Rubberboat_02_EPOCH",-50,-50,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
false,
1,
2,
[9999,9999,0.1],
"WATER"
],

//SET 8 / GENERIC MISSION TO BE CHANGED
[
["<t align='center' size='2.0'>Hogscorp<br/>Defense Alert!</t><br/>______________<br/><br/>
		This is a generic mission!<br/>
		Your admin didn't bother to look through the code!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		Message two.<br/>
		You managed to kill all five bandits!<br/>
		Wow!",
"<t align='center' size='2.0'>Mission Status</t><br/>
		______________<br/><br/>
		There were only five of them and they still got away...<br/>
		Maybe next time you will succeed."],
 
[[5,50,50,1,150,1],[0,0,0,0,0.1],[0,0,0,0,0.1],[0,0,0,0,0.1]], 
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
[["",0,0,0],["",0,0,0]],
true,
0,
-1,
[0,0,0],
""
]

//,
//SET 6
//[],
//SET 7
//[],
//SET 8
//[]
];


