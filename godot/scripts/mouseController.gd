class_name mouseController

extends Node

signal mouse_button_pressed(curPosition)
signal mouse_button_released()
signal mouse_motion(curPosition)

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("mouse_button_pressed", event.position)
		else:
			emit_signal("mouse_button_released")
	elif event is InputEventMouseMotion:
		emit_signal("mouse_motion", event.position)
