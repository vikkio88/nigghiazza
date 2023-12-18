extends Node2D

@export var Weapon: Enums.Weapons
@export_range(0,30) var Ammo: int

const DROP_LERP: int = 5
const DROP_RANGE: int = 150

var _is_dropping: bool = false
var _to_pos: Vector2 = Vector2.ZERO

@onready var Sprite: Sprite2D = $sprite
@onready var Anim: AnimationPlayer = $Anim
@onready var pickable_shader = preload("res://actors/items/pickables/pickable.gdshader")


func _ready() -> void:
	Sprite.material = ShaderMaterial.new()
	Sprite.material.shader = pickable_shader
	Anim.play("glow")

func init(position: Vector2, dropping:bool = false, ammo: int = 0) -> void:
	_is_dropping = dropping
	Ammo = ammo
	global_position = position
	if dropping:
		_is_dropping = dropping
		_to_pos = position + Vector2(randi_range(DROP_RANGE / 2 , DROP_RANGE), randi_range(DROP_RANGE / 2 , DROP_RANGE))
	

func _physics_process(delta: float) -> void:
	if _is_dropping:
		position = position.lerp(_to_pos, DROP_LERP * delta)
	
	if position.distance_to(_to_pos) <= 3:
		_is_dropping = false
 


func _on_playerdetector_area_entered(area: Area2D) -> void:
	if _is_dropping:
		return
		
	EventBus.interactable_on.emit(
		Enums.weapon_to_string(self.Weapon), 
		"pickup",
		func ():
			EventBus.gun_pickup.emit(self.Weapon, self.Ammo)
			queue_free())


func _on_playerdetector_area_exited(area: Area2D) -> void:
	if _is_dropping:
		return
		
	EventBus.interactable_off.emit()
	
func glow_on():
	Sprite.material.set_shader_parameter("active", false)
	
func glow_off():
	Sprite.material.set_shader_parameter("active", true)
