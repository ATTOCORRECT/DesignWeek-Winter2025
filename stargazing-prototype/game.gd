extends Node

func _enter_tree() -> void:
	Singleton.camera = $World/Telescope/Camera3D
	Singleton.star_cluster = $"World/Star Cluster"
	Singleton.player_controller = $"Player Controller"
