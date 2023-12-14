extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://hud/img/cross.png"))
	EventBus.gun_dropped.connect(self.spawn_gun)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func spawn_gun(type: Enums.Weapons, position:Vector2, ammo:  int):
	var pickable = ItemFactory.make_pickable_weapon(type).instantiate()
	pickable.init(position,true, ammo)
	add_child(pickable)
