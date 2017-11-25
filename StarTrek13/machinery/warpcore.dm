/obj/machinery/warpcore
    name = "warpcore dummy"
    icon = 'StarTrek13/icons/borg/borg.dmi'
    icon_state = "warp"
    desc = "magic adminbus tool to make our lives easier"
    density = 1
    var/matter = 0
    var/antimatter = 0
    var/inbalance = 0
    var/stabcore = 100
    var/dilithiumcount = 5
    var/crystaleff = 100
    var/wattsgen = 0
    var/stabwarpfield = 100
    var/stabengine = 100
    var/maxwarp = 9.8
    var/currentwarpspeed = 0

/obj/machinery/warpcore/attack_hand()
	to_chat(world, "oi you fucking cunt, stop that!")
	calculateCore()

/obj/machinery/warpcore/proc/calculateCore()
    to_chat(world, "calculating!")
    inbalance = antimatter - matter
    stabcore = max_integrity - inbalance
    crystaleff = (dilithiumcount * 100) - 0 // 0 represents the dilithium crystal damages
    wattsgen = antimatter * 100000 - stabcore + crystaleff
    maxwarp = 9.8 / stabcore / (crystaleff / dilithiumcount * 100)
    stabwarpfield = 100 - ((currentwarpspeed + 0.2) * 10)
    stabengine = (stabcore + stabwarpfield) / 2

/obj/machinery/warpcore/CtrlClick()
    to_chat(world, "reset!")
    matter = 0
    antimatter = 0
    inbalance = 0
    stabcore = 100
    dilithiumcount = 5
    crystaleff = 100
    wattsgen = 0
    stabwarpfield = 100
    stabengine = 100
    maxwarp = 9.8
    currentwarpspeed = 0

