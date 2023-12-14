extends Node

@onready var ar_scene = preload("res://actors/items/weapons/m4.tscn")
@onready var ar_pickable_scene = preload("res://actors/items/pickables/m4_pickable.tscn")
@onready var pistol_scene = preload("res://actors/items/weapons/pistol.tscn")
@onready var pistol_pickable_scene = preload("res://actors/items/pickables/pistol_pickable.tscn")


func make_weapon(type: Enums.Weapons) -> Resource:
	match type:
#		Enums.Weapons.Rifle:
#			return rifle_scene
		Enums.Weapons.Pistol:
			return pistol_scene
		Enums.Weapons.AR:
			return ar_scene
		_:
			return ar_scene
#			return rifle_scene


func make_pickable_weapon(type: Enums.Weapons) -> Resource:
	match type:
#		Enums.Weapons.Rifle:
#			return rifle_pickable_scene
		Enums.Weapons.Pistol:
			return pistol_pickable_scene
		Enums.Weapons.AR:
			return ar_pickable_scene
		_:
			return ar_pickable_scene
#			return rifle_pickable_scene
