extends Label
@export var dialogueLines: Array[String]
@onready var db = get_tree().get_first_node_in_group("db")
@onready var index = 0
var isActive : bool
var timer := Timer.new()

func _ready():
	add_child(timer)
	timer.autostart = false
	timer.wait_time = 1
	timer.timeout.connect(func(): on_timer_timeout())
	timer.start()

func on_timer_timeout():
	if index < dialogueLines.size() - 1:
		index += 1

func _process(delta):
	text = str(dialogueLines[index])
pass
