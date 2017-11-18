/*
Assistant
*/
/datum/job/crewman
	title = "Assistant"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "all other crew members of higher rank."
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/crewman


/datum/job/crewman/get_access()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. = ..()
		. |= list(ACCESS_MAINT_TUNNELS)
	else
		return ..()

/datum/job/crewman/config_check()
	var/ac = CONFIG_GET(number/assistant_cap)
	if(ac != 0)
		total_positions = ac
		spawn_positions = ac
		return 1
	return 0


/datum/outfit/job/crewman
	name = "Crewman"
	jobtype = /datum/job/crewman

/datum/outfit/job/crewman/pre_equip(mob/living/carbon/human/H)
	..()
	if (CONFIG_GET(flag/grey_assistants))
		uniform = /obj/item/clothing/under/trek/grey
	else
		uniform = /obj/item/clothing/under/trek/grey

//ADD SPAWNS FOR THE NEW JOBS!
/*
Captain
*/
/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	department_head = list("Federation Central Command")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3 //3 is a round number, change it with testing data.
	spawn_positions = 3
	supervisors = "Federation officials and Space law"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW		//There will be multiple captains in one round

	outfit = /datum/outfit/job/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/captain/get_access()
	return get_all_accesses()

/datum/job/captain/announce(mob/living/carbon/human/H)
	..()
//	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))

/datum/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/captain

	id = /obj/item/card/id/gold
	belt = /obj/item/device/pda/captain
//	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/captain
	uniform =  /obj/item/clothing/under/trek/command/next
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
//	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/station_charter=1)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/medal/gold/captain


/datum/job/admiral
	title = "Admiral"
	flag = ADMIRAL
	department_head = list("The Federation")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3 //3 is a round number, change it with testing data.
	spawn_positions = 3
	supervisors = "The Federation"
	selection_color = "#B22222"
	req_admin_notify = 1
	minimal_player_age = 17
	exp_requirements = 280
	exp_type = EXP_TYPE_CREW		//There will be multiple captains in one round

	outfit = /datum/outfit/job/admiral

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/admiral/get_access()
	return get_all_accesses()

/datum/job/admiral/announce(mob/living/carbon/human/H)
	..()
//	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))

/datum/outfit/job/admiral
	name = "Admiral"
	jobtype = /datum/job/admiral

	id = /obj/item/card/id/gold
	belt = /obj/item/device/pda/captain
//	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/captain
	uniform =  /obj/item/clothing/under/trek/command/next
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
//	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/station_charter=1)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/medal/gold/captain


/*
Head of Personnel
*/
/datum/job/firstofficer
	title = "First Officer"
	flag = HOP
	department_head = list("Captain")
	department_flag = CIVILIAN
	head_announce = list("Supply", "Service")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SUPPLY

	outfit = /datum/outfit/job/firstofficer

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_HEADS,
			            ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
			            ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
			            ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_HEADS_VAULT, ACCESS_MINING_STATION,
			            ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_HEADS,
			            ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
			            ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
			            ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_HEADS_VAULT, ACCESS_MINING_STATION,
			            ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM)


/datum/outfit/job/firstofficer
	name = "First officer"
	jobtype = /datum/job/firstofficer

	id = /obj/item/card/id/silver
	belt = /obj/item/device/pda/heads/hop
	ears = /obj/item/device/radio/headset/heads/hop
	uniform = /obj/item/clothing/under/rank/head_of_personnel
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/storage/box/ids=1,\
		/obj/item/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced = 1)
