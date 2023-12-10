class_name keyController

extends Node

signal ctrl_pressed()
signal ctrl_released()

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_CTRL:
		if event.is_pressed():
			emit_signal("ctrl_pressed")
		else:
			emit_signal("ctrl_released")
