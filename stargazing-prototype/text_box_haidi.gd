extends CanvasLayer

@onready var textbox_container = $textBox_Haidi_Container
@onready var start_symbol = $textBox_Haidi_Container/Panel/MarginContainer/HBoxContainer/startTextEdge
@onready var end_symbol = $textBox_Haidi_Container/Panel/MarginContainer/HBoxContainer/endTextEdge
@onready var label = $textBox_Haidi_Container/Panel/MarginContainer/HBoxContainer/text

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	print("Starting in READY State")
	hide_textbox()
	queue_text("Heidi: “Hey stop running around, I finished setting it up”")
	queue_text("Kole: “Finally! That took you forever!”")
	queue_text("Heidi: “Oh calm down. It was only 10 minutes. Come look through it”")
	queue_text("Kole: “Wow! I can see the stars up close!”")
	queue_text("Heidi: “Try looking around”")
	queue_text("Kole: “This is so cool! It’s like millions and millions of Christmas lights!”")
	queue_text("Heidi: “In the first page of Grandpa’s book he wrote something about the moon, do you see it?”")
	
	

func _process(delta):
	match current_state:
		State.READY:
			if!(text_queue.size() == 0):
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.percent_visible = 1.0
				end_symbol.text = "-"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "-"
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state(State.READING)
	show_textbox()
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("changing to READY state")
		State.READING:
			print("changing to READING state")
		State.FINISHED:
			print("changing to FINISHED state")
		
