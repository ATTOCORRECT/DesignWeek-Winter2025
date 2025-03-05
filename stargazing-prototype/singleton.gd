extends Node

enum State {CONSTELLATION_ALIGNMENT, CONSTELLATION_TRACING, CONSTELLATION_DEFAULT, GAZING, NO_TARGET}
var active_state = State.GAZING

var camera: Camera3D
var star_cluster: Node3D
var player_controller: Node
var telescope: Node3D

func _physics_process(delta: float) -> void:
	#print(active_state)
	pass
