extends Node

@onready var speaker1 = $AudioStreamPlayer

func play_layer():
	speaker1.play()
	pass
