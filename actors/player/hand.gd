extends Node2D

@onready var gun: Node2D = null

const HIP_X: int = 2
var hip_position: Vector2 = Vector2(HIP_X, 0)
const ADS_X: int = 8
var ads_position: Vector2 = Vector2(ADS_X, -4)
var ads_lerp: float = 10.0

func _ready() -> void:
	EventBus.gun_pickup.connect(self.pick_gun)

func _process(delta: float) -> void:
	if Input.is_action_pressed("ads") and has_gun():
		position = position.lerp(ads_position, ads_lerp * delta)
		if position.distance_to(ads_position) < 4:
			gun.ads_on()
	elif has_gun():
		position = position.lerp(hip_position, ads_lerp * delta)
		gun.ads_off()
	
	if Input.is_action_just_released("action_b") and has_gun():
		drop_gun()

func _physics_process(delta: float) -> void:
	if get_global_mouse_position().distance_to(global_position) < 70:
		return
	
	if Utils.is_facing_forward(global_position):
		ads_position.x = ADS_X
		hip_position.x = HIP_X
	else:
		ads_position.x = -ADS_X
		hip_position.x = -HIP_X
		
	
	
func has_gun() -> bool:
	return gun != null

func pick_gun(type: Enums.Weapons, ammo: int) -> void:
	if has_gun():
		drop_gun()
	
	var weapon = ItemFactory.make_weapon(type).instantiate()
	add_child(weapon)
	gun = weapon

func drop_gun():
	EventBus.gun_dropped.emit(gun.Type, global_position, 25)
	gun.queue_free()
	gun = null



func is_action_shooting() -> bool:
	if !has_gun():
		return false
 	
	if gun.BPM > 1:
		return Input.is_action_pressed("shoot")
	
	return Input.is_action_just_pressed("shoot")

func shoot() -> void:
	if !has_gun():
		return
		
	var recoil = gun.shoot()
	_apply_recoil(recoil)

func _apply_recoil(recoil: Vector2) -> void:
	if recoil != Vector2.ZERO:
#		GameState.stat_update.emit(GameState.Stats.Shots)
#		Player.emit_noise(Enums.NoiseLevel.Loud)
		var mouse_pos = get_viewport().get_mouse_position()
		get_viewport().warp_mouse(mouse_pos + recoil)
		# this is to move a bit the player with recoil
		#Player.position.x += (-1 if mouse_pos.x > Player.position.x else 1) * 1
