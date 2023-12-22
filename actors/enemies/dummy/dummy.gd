extends RigidBody2D

@onready var body: CollisionShape2D = $body
@onready var head: CollisionShape2D = $head
@onready var dmg_ph: Node2D = $dmg
@onready var sprite: Sprite2D = $sprite

const HEADSHOT_THRESHOLD: float = 23.0
const BODYSHOT_THRESHOLD: float = 60.0


#region HitLogic
func hit(point: Vector2, base_dmg: float) -> void:
	var head_d = head.global_position.distance_to(point)
	var body_d = body.global_position.distance_to(point)
	var type = "body shot"
	var damage = base_dmg
	if head_d < HEADSHOT_THRESHOLD or head_d < body_d:
		type = "Headshot!"
		damage *= 2
	HudFactory.add_floating_critical("%s - %d" % [type, damage], dmg_ph)
#endregion
