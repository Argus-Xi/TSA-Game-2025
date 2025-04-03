extends Node

@onready var label = $Label
@onready var timer = $Timer

func _ready():
	timer.start()
	
func tim_left():
	var time_left = timer.time_left
	var second = int(time_left) % 60
	return [second]

func _process(delta):
	label.text = "%02d" % tim_left()
	
