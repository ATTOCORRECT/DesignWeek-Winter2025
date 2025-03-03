extends Node



@onready var SCREEN_SIZE = get_viewport().get_visible_rect().size

var dragging = false
var drag_roll = false
var drag_position = Vector2.ZERO
var drag_position_offset = Vector2.ZERO
var drag_roll_position = 0.0
var drag_roll_position_offset = 0.0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _input(event):
	# Mouse pressed
	if event is InputEventMouseButton:
		# Mouse 1 pressed
		if event.pressed == true:
			var position = telescope_normalized_screen_position(event.position)
			var centered_position = position * 2 - Vector2.ONE
			var roll_position = atan2(centered_position.x,centered_position.y)
			
			dragging = true
			drag_position = position
			
			drag_roll_position = roll_position
			
			drag_roll = true
			# Mouse within telescope
			if centered_position.length() < 1024.0 / 1080.0:
				drag_roll = false
		
		if event.pressed == false:
			dragging = false
	
	if event is InputEventMouseMotion:
		if dragging:
			if drag_roll:
				var position = telescope_normalized_screen_position(event.position)
				var centered_position = position * 2 - Vector2.ONE
				var roll_position = atan2(centered_position.x,centered_position.y)
				
				drag_roll_position_offset = drag_roll_position - roll_position
				
				if drag_roll_position_offset != 0:
					drag_roll_position = roll_position
					
					Singleton.star_cluster.rotate(Vector3.FORWARD,drag_roll_position_offset)
			else:
				var position = telescope_normalized_screen_position(event.position)
				
				drag_position_offset = drag_position - position
				
				if drag_position_offset != Vector2.ZERO:
					drag_position = position

					Singleton.star_cluster.rotate(Vector3.UP,drag_position_offset.x * 2)
					Singleton.star_cluster.rotate(Vector3.RIGHT,drag_position_offset.y * 2)



func telescope_normalized_screen_position(event_position : Vector2) -> Vector2:
	var centered_event_position = event_position - Vector2.RIGHT * 0.5 * (SCREEN_SIZE.x - SCREEN_SIZE.y)
	var position = centered_event_position / SCREEN_SIZE.y
	return position
