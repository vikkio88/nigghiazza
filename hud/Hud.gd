extends CanvasLayer

# world interaction
@onready var action_key:Label = $action_key
@onready var interaction:Label = $action_key/interaction
@onready var hp_bar: ProgressBar = $hp_bar
@onready var stamina_bar: ProgressBar = $stamina_bar

var can_interact = false
var intereactable_callback: Callable = func(): pass



func _ready() -> void:
	EventBus.interactable_on.connect(self._on_interactable)
	EventBus.interactable_off.connect(self._off_interactable)
	EventBus.player_health_update.connect(self._on_player_health_update)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_a") and can_interact:
		intereactable_callback.call()


func _on_interactable(item: String, action: String, callback: Callable):
	can_interact = true
	interaction.text = "%s %s" % [action, item]
	action_key.visible = true
	intereactable_callback = callback


func _off_interactable() -> void:
	interaction.text = ""
	action_key.visible = false
	can_interact = false
	intereactable_callback = func(): pass


func _on_player_health_update(health: int, max_health: int, stamina: int, max_stamina: int) -> void:
	hp_bar.set_value(health)
	stamina_bar.set_value(stamina)

