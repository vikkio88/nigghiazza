extends Node2D

var _gates = {}

func get_gate_by_name(name: String) -> bool:
	return _gates[name] if _gates.has(name) else false

func dispose_gated_timer(name: String):
	if _gates.has(name):
		_gates.erase(name)

func gated_timer(name: String, time_sec: float, callback: Callable) -> void:
	if _gates.has(name) and _gates[name] == true:
		return
	
	_gates[name] = true
	timer(time_sec, func():
		if callback != null:
			callback.call()
		_gates[name] = false,
	)

func timer(time_sec:float,callback: Callable) -> void:
	get_tree().create_timer(time_sec).timeout.connect(callback)


func is_facing_forward(position: Vector2) -> bool:
	var mouse_pos = get_global_mouse_position()
	return mouse_pos.x > position.x
