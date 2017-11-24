/obj/structure/elevator_controller
	name = "turbolift console"
	desc = "it takes you up to different floors of whatever structure you're in, this one works."
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "elevator"
	var/list/in_elevator = list()
	var/floor_num = 1 //what floor do we occupy?
	var/list/elevator_turfs = list()
	var/obj/structure/elevator_controller/floors = list()
	var/locked = 1 //Can we move?
	var/floor_total = 0
	var/list/to_move = list()
/area/elevator
	name = "elevator"
	icon_state = "ship"
	requires_power = 0 //fix
	has_gravity = 1
	noteleport = 0
	blob_allowed = 0 //Should go without saying, no blobs should take over centcom as a win condition.

/turf/open/floor/elevator
	name = "turbolift floor"
	desc = "you're in a turbolift then."

/turf/open/floor/elevator_shaft
	name = "elevator shaft"
	desc = "AAAHHHH!!!!"
	icon_state = "plating"

/obj/structure/elevator_controller/New()
	. = ..()
	get_position()

/obj/structure/elevator_controller/proc/update_turfs(num) //Num as in, are we going up and then making the new turfs (removing the shaft)
	if(num)//we are being turned into a shaft
		for(var/turf/T in elevator_turfs)
			T.ChangeTurf(/turf/open/floor/elevator_shaft) //Elevator shaft, ie go in this and fall down
	else
		for(var/turf/T in elevator_turfs)
			T.ChangeTurf(/turf/open/floor/elevator)

/obj/structure/elevator_controller/proc/get_position(floor)
	floors = list()
	floor_total = 0
	to_chat(world,"arrrrgggg")
	var/area/thearea = get_area(src)
	for(var/obj/structure/elevator_controller/E in thearea) //In subtypes of as ship areas will vary.
		floor_total ++
		if(E != src)
			floors += E
			to_chat(world, "floor")
			return
		if(E.floor_num == floor)
			travel(E,floor)
			return

/obj/structure/elevator_controller/proc/travel(var/obj/structure/elevator_controller/target,floor)
	to_move = list()
	var/obj/structure/elevator_controller/up
	to_chat(world, "ar")
	var/area/thearea = get_area(src)
	for(var/obj/structure/elevator_controller/E in floors)
		if(E == target)
			E.locked = 0
			E.update_turfs(0)
			up = E
			to_chat(world, "this is src")
		else
			E.locked = 1 //going up
			E.update_turfs(1) //change turfs to elevator shaft.
			locked = 1
			update_turfs(1) //the current elevator tile just moved up/down, so we need to change it too
			to_chat(world, "going up")

	for(var/atom/movable/M as mob|obj in thearea)
		var/turf/up_turf = get_turf(up) //so they dont land in the console itself
		if(!istype(M, /obj/structure/elevator_controller))
			to_move += M
			return
		else
			to_move -= M

		for(var/atom/movable/A as mob|obj in to_move)
			A.forceMove(up_turf)
			to_chat(world, "forcemove") //OK! it works, now make it not teleport E V E R Y T H I N G


/obj/structure/elevator_controller/attack_hand(mob/user)
	get_position()
	var/A
	A = input(user, "Go to what floor", "you are on:[floor_num] / [floor_total]", A) as num
	if(A > floor_total)
		to_chat(user, "there are not that many floors")
		return
	if(A < 1)
		to_chat(user, "enter a valid floor number")
		return
	var/floor = A
	to_chat(world, "[floor]")
	go(user, floor)

/obj/structure/elevator_controller/proc/go(mob/user,floor)
	get_position()
	to_chat(user, "you press a button on the lift, it's also not complete kek")
	get_position(floor)
	travel(floor)
	src.say("travelling to [floor]")