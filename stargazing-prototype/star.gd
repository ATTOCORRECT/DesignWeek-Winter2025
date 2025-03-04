extends Sprite3D

var select_mode
var selected = false

@onready var star_cluster = $".".get_parent().get_parent()

func _on_area_3d_mouse_entered() -> void:
	if Singleton.active_state == Singleton.State.CONSTELATION_TRACING:
		select()
		star_cluster.add_to_selection(self)

func _on_area_3d_mouse_exited() -> void:
	pass

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed == true && selected == false:
			select()
			star_cluster.start_selection(self)
			Singleton.active_state = Singleton.State.CONSTELATION_TRACING
		elif event.pressed == true && selected == true:
			star_cluster.reset_selection()

func select():
	selected = true
	$".".modulate = Color.GOLD

func deselect():
	selected = false
	$".".modulate = Color.WHITE

func toggle_selected():
	selected = !selected
	if selected:
		$".".modulate = Color.GOLD
	else:
		$".".modulate = Color.WHITE
