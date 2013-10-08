Annoyed Tree's Real-Time Strategy

Factions/Teams = HUMANOIDS, CREATURES

Creatures:
	Characters:
		Antlion
		Antlion Guard
		Zombie
		Zombine
		Vortiguant
	
	Buildings:
		Something: (models/props_wasteland/antlionhill.mdl)
			-Make this about 4x smaller
		
		
Humanoids:
	Characters:
		Soldier
		Medic
		DOG
	
	Buildings:
		Resourcer: (models/props_combine/combinethumper002.mdl), Gets resource
			-Make the model 2x or 4x smaller (Big model) also animate
			-ACT_IDLE, idle
		Turrerts: (models/combine_turrets/floor_turret.mdl), Shoots enemies within X radius
			-Can make an upgrade for "rate of fire"
		Barriacde: (models/props_combine/combine_barricade_short01a.mdl), Stops enemies from going through
			-Teammates can walk through these?
		Detection: (models/props_mining/antlion_detector.mdl), Detects nearby enemies
			-Advance to detect high units?
		Resupplies: (models/Items/ammocrate_smg1.mdl), Give ammo
			-Can be put anywhere on the level
		Mine: (models/props_combine/combine_mine01.mdl), Tends to go boom
		Fence: (models/props_combine/combine_fence01a.mdl), Vaporizes anything that touches it
			-This includes teammates, this is meant to block an entrance/exit
		Commanding Station: (models/props_combine/combine_booth_med01a.mdl), Needed to command
			-Player dies inside
			- <0 team loses game.
		-Spawner: (models/combine_advisor_pod/combine_advisor_pod.mdl), Spawns humans
			-idle, opening01, opening02, open, idle
		
Entities:
	ent_point_combase //Commander base, for both teams
	ent_building //Building for both sides. Set health and stuff with functions