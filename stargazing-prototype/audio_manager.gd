extends Node

@onready var speaker1Music = $AudioStreamPlayerBase
@onready var speaker2Music = $AudioStreamPlayerMelody
@onready var speaker3Music = $AudioStreamPlayerMelody2
@onready var speaker4Music = $AudioStreamPlayerMusicT
@onready var speaker5Music = $AudioStreamPlayerMusicT2

@onready var speaker1Twinkle = $AudioStreamPlayerTwinkle
@onready var speaker1Telescope = $AudioStreamPlayerTelescope

func _ready() -> void:
	speaker1Music.play()
	speaker2Music.play()
	speaker3Music.play()
	speaker4Music.play()
	speaker5Music.play()
	
func play_layer(i):
	match i:
		1:
			speaker4Music.volume_db = 0.0
		2:
			speaker2Music.volume_db = 0.0
		3:
			speaker2Music.volume_db = -80.0
			speaker3Music.volume_db = 0.0
		4:
			speaker2Music.volume_db = 0.0
		5:
			speaker5Music.volume_db = 0.0
	
func play_twinkle():
	speaker1Twinkle.play()
	
func play_Telescope():
	speaker1Telescope.play()
