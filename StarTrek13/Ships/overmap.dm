
//Movement system and upgraded ship combat!


#define TORPEDO_MODE 1//1309

/obj/structure/overmap
	name = "generic structure"
//	var/linked_ship = /area/ship //change me
	var/datum/beam/current_beam = null //stations will be able to fire back, too!
	var/health = 20000 //pending balance, 20k for now
	var/obj/machinery/space_battle/shield_generator/generator
	var/obj/structure/fluff/helm/desk/tactical/weapons
	var/shield_health = 1050 //How much health do the shields have left, for UI type stuff and icon_states
	var/mob/living/carbon/human/pilot
	var/view_range = 7 //change the view range for looking at a long range.
	anchored = 0
	can_be_unanchored = 0 //Don't anchor a ship with a wrench, these are going to be people sized
	density = 1
	var/list/interactables_near_ship = list()
	var/area/linked_ship = /area/ship //CHANGE ME WITH THE DIFFERENT TYPES!
	var/max_shield_health = 20000 //default max shield health, changes on process
	var/shields_active = 0
	pixel_y = -32
	var/next_vehicle_move = 0 //used for move delays
	var/vehicle_move_delay = 4 //tick delay between movements, lower = faster, higher = slower
	var/mode = 0 //add in two modes ty
	var/damage = 600 //standard damage for phasers, this will tank shields really quickly though so be warned!
	var/atom/targetmeme = null //for testing
	var/weapons_charge_time = 60 //6 seconds inbetween shots.
	var/in_use1 = 0 //firing weapons?

/obj/structure/overmap/away/station
	name = "space station 13"
	var/list/areaslist = list() //teleport to the station with this one, override this with custom areas to allow the transporter to beam people down!

/obj/structure/overmap/away/station/New()
	. = ..()
	for(var/area/thearea in GLOB.teleportlocs)
		if(!thearea in areaslist)
			areaslist += thearea


/obj/structure/overmap/ship
	name = "a space ship"
	icon = 'StarTrek13/icons/trek/overmap_ships.dmi'
	icon_state = "generic"


/obj/structure/overmap/ship/target //dummy for testing woo
	name = "Ohno"
	linked_ship = /area/ship/target
	icon_state = "destroyer"

//So basically we're going to have ships that fly around in a box and shoot each other, i'll probably have the pilot mob possess the objects to fly them or something like that, otherwise I'll use cameras.

/obj/structure/overmap/ship/relaymove(mob/user,direction)
	if(user.incapacitated())
		return //add things here!
	if(!Process_Spacemove(direction) || world.time < next_vehicle_move || !isturf(loc))
		return
	step(src, direction)
	next_vehicle_move = world.time + vehicle_move_delay
	//use_power

//obj/structure/overmap/ship/Move(atom/newloc, direct)
//	. = ..()
//	if(.)
	//	events.fireEvent("onMove",get_turf(src))

/obj/structure/overmap/ship/Process_Spacemove(movement_dir = 0)
	return 1 //add engines later

/obj/structure/overmap/ship/attack_hand(mob/user)
	to_chat(user, "you climb into [src]...somehow" )
	user.loc = src
	pilot = user

/obj/structure/overmap/New()
	. = ..()
	START_PROCESSING(SSobj,src)
	linkto()
	linked_ship = get_area(src)
	for(var/obj/effect/landmark/A in GLOB.landmarks_list)
		if(A.name == "ship_spawn")
			forceMove(A.loc)

//obj/structure/overmap/ship/GrantActions(mob/living/user, human_occupant = 0)
//	internals_action.Grant(user, src)
//	var/datum/action/innate/mecha/strafe/strafing_action = new

/obj/structure/overmap/proc/linkto()	//weapons etc. don't link!
	for(var/obj/structure/fluff/helm/desk/tactical/T in linked_ship)
		weapons = T
	for(var/obj/machinery/space_battle/shield_generator/G in linked_ship)
		generator = G

/obj/structure/overmap/take_damage(amount,turf/target)
	if(has_shields())
		generator.take_damage(amount)//shields now handle the hit
		say("ow fuck you")
		return
	else//no shields are up! take the hit
		var/turf/theturf = get_turf(target)
		explosion(theturf,2,5,11)
		var/datum/effect_system/spark_spread/s = new
		s.set_up(2, 1, src)
		s.start() //make a better overlay effect or something, this is for testing
		health -= amount
		playsound(src.loc, 'StarTrek13/sound/borg/machines/shiphit.ogg',100,0) //clang
		return

/obj/structure/overmap/process()
	linkto()
	var/obj/effect/adv_shield/theshield = pick(generator.shields) //sample a random shield for health and stats.
	shield_health = theshield.health
	max_shield_health = theshield.maxhealth
//	if(!generator || !generator.shields.len)
	if(!theshield.density)
		shields_active = 0
	else
		shields_active = 1
	if(health <= 0)
		destroy(1)
	if(location())
		to_chat(pilot, "New visitable object near you")

/obj/structure/overmap/proc/destroy(severity)
	STOP_PROCESSING(SSobj,src)
	switch(severity)
		if(1)
			//Here we will blow up the ship map as well, 0 is if you dont want to lag the server.
			qdel(src)
			//make explosion in ship
		if(0)
			qdel(src)

/obj/structure/overmap/proc/has_shields()
	if(shield_health > 1000 && shields_active)
		return 1
	else//no
		return 0

/obj/structure/overmap/bullet_act(var/obj/item/projectile/P)
	. = ..()
	take_damage(P.damage)

/obj/structure/overmap/proc/location() //OK we're using areas for this so that we can have the ship be within an N tile range of an object
	var/area/thearea = get_area(src)
	for(var/obj/structure/overmap/away/A in thearea)
		if(!istype(A))
			return
		interactables_near_ship += A
	if(interactables_near_ship.len > 0)
		return 1
	else//nope
		return 0

/obj/structure/overmap/ship/starfleet
	name = "USS Cadaver"
	icon_state = "cadaver"
//obj/structure/fluff/ship/helm do me later

/obj/structure/overmap/proc/click_action(atom/target,mob/user)
//add in TORPEDO MODE and PHASER MODE TO A MODE SELECT UI THING
	targetmeme = target
	if(user.incapacitated())
		return
//	if(!get_charge())
//		return
	if(istype(target, /obj/structure/overmap))
		var/obj/structure/overmap/thetarget = target
		target = thetarget
		if(target == src)
			return
		switch(mode)
			if(TORPEDO_MODE)
				fire_torpedo(thetarget,user)
			else
				fire(thetarget,user)
	else
		to_chat(user, "Unable to lock phasers, this weapon mode only targets large objects")
		return


/obj/structure/overmap/proc/fire(atom/target,mob/user)
	if(!in_use1)
		to_chat(user, "charging phasers")
		in_use1 = 1
		if(do_after(user, weapons_charge_time, target = target))
			in_use1 = 1
			var/source = get_turf(src)
			targetmeme = target
			var/obj/structure/overmap/S = target
			current_beam = new(source, target,time=30,beam_icon_state="phaserbeam",maxdistance=5000,btype=/obj/effect/ebeam/phaser)
			var/list/L = list()
			var/area/thearea = S.linked_ship
			for(var/turf/T in get_area_turfs(thearea.type))
				L+=T
			var/location = pick(L)
			var/turf/theturf = get_turf(location)
			S.take_damage(damage,theturf)
			in_use1 = 0
			INVOKE_ASYNC(current_beam, /datum/beam.proc/Start)
			return
	else
		to_chat(user, "weapons still charging")
		return

/obj/structure/overmap/proc/fire_torpedo(atom/target,mob/user)
	var/obj/structure/overmap/S = target
	weapons.target = S.linked_ship
	weapons.fire_phasers(target,user)


#undef TORPEDO_MODE
