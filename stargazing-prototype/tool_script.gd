@tool
extends EditorScript

var star_prefab = preload("res://simlpe_star.tscn")
var medium_sprite = preload("res://assets/star_medium.png")
var big_sprite = preload("res://assets/star_big.png")

#ctrl + shift + x
func _run():
	
	#var parent = get_scene().get_node("World/Sky Stars")
	#
	#
	#for i in 400:
		#var new_star = star_prefab.instantiate()
		#parent.add_child(new_star)
	#
		#new_star.owner = get_scene()
		#new_star.position = Vector3( randf_range(-1, 1), randf_range(0, 1), randf_range(-1, 1)).normalized() * randf_range(7,9)
	#
	#for i in 100:
		#var new_star = star_prefab.instantiate()
		#parent.add_child(new_star)
	#
		#new_star.owner = get_scene()
		#new_star.position = Vector3( randf_range(-1, 1), randf_range(0, 1), randf_range(-1, 1)).normalized() * randf_range(7,9)
		#new_star.texture = medium_sprite
	#
	#for i in 50:
		#var new_star = star_prefab.instantiate()
		#parent.add_child(new_star)
	#
		#new_star.owner = get_scene()
		#new_star.position = Vector3( randf_range(-1, 1), randf_range(0, 1), randf_range(-1, 1)).normalized() * randf_range(7,9)
		#new_star.texture = big_sprite
	
	print(int("10") + int("10"))
	
	pass
