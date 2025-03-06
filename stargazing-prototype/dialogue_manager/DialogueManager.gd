extends RichTextLabel
@export var dialogueLines: Array[String]
@onready var db = get_tree().get_first_node_in_group("db")
var isActive : bool

func _enter_tree() -> void:
	Singleton.dialogue = self

func _ready() -> void:
	read_lines(0, 15)

#func _ready():
	#add_child(timer)
	#timer.autostart = false
	#timer.wait_time = 0.2
	#timer.timeout.connect(func(): on_timer_timeout())
	#timer.start()
#
#func on_timer_timeout():
	#if index < 15 :
		#index += 1
		#
	#elif index >= 15 && index < 19 && starIndex == 1 :
		#index += 1
	##print(starIndex)

func next_dialogue(i):
	match i:
		1:
			read_lines(16, 19)
		2:
			read_lines(20, 27)
		3:
			read_lines(28, 32)
		4:
			read_lines(33, 38)
		5:
			read_lines(39, 55)


func read_lines(start: int, end: int):
	
	for i in (end - start + 1):
		#index = i + start
		#print(line_index)
		print(i + start)
		text = dialogueLines[i + start]
		await get_tree().create_timer(5).timeout
		
	print("done")

	
