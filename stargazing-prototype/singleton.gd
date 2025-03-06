extends Node

enum State {CONSTELLATION_ALIGNMENT, CONSTELLATION_TRACING, CONSTELLATION_DEFAULT, GAZING, NO_TARGET}
var active_state = State.GAZING

var camera: Camera3D
var star_cluster: Node3D
var star_clusters: Array[Node]
var index = 0
var player_controller: Node
var telescope: Node3D

func _physics_process(delta: float) -> void:
	#print(active_state)
	pass

func _ready() -> void:
	for clusters in star_clusters:
		clusters.process_mode = Node.PROCESS_MODE_DISABLED
	
	star_cluster.process_mode = Node.PROCESS_MODE_INHERIT
	pass

func next_constellation():
	index += 1
	if index <= star_clusters.size() - 1:
		star_cluster = star_clusters[index]
		star_cluster.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		star_cluster = null
		print("done")
