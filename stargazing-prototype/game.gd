extends Node

func _enter_tree() -> void:
	Singleton.camera = $World/Telescope/Camera3D
	Singleton.telescope = $World/Telescope
	Singleton.star_cluster = $"World/Star Clusters/Star Cluster"
	Singleton.star_clusters = $"World/Star Clusters".get_children()
	Singleton.player_controller = $"Player Controller"
	Singleton.audio_manager = $"Audio Manager"

func _ready() -> void:
	Singleton.camera.set_zoom_out_settings()

func complete_constellation():
	pass
