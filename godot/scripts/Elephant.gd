extends MeshInstance3D

var is_rotating : bool = false
var click_position : Vector2
var is_horizontal_rotation : bool = false

var key_event_class_instance
var mouse_event_class_instance
var keyController = preload("./keyController.gd")
var mouseController = preload("./mouseController.gd")

func _ready():
	key_event_class_instance = keyController.new()
	mouse_event_class_instance = mouseController.new()
	add_child(key_event_class_instance)
	add_child(mouse_event_class_instance)
	key_event_class_instance.ctrl_pressed.connect(_ctrl_pressed)
	key_event_class_instance.ctrl_released.connect(_ctrl_released)
	mouse_event_class_instance.mouse_button_pressed.connect(_mouse_pressed)
	mouse_event_class_instance.mouse_button_released.connect(_mouse_released)
	mouse_event_class_instance.mouse_motion.connect(_mouse_motion)

func _mouse_pressed (curPosition):
	is_rotating = true
	click_position = curPosition

func _mouse_released ():
	is_rotating = false

func _mouse_motion (curPosition):
	if (is_rotating):
		var delta = curPosition - click_position
		if is_horizontal_rotation:
			rotate_object(delta.x, 0)
		else:
			rotate_object(0, delta.y)
		click_position = curPosition

func _ctrl_pressed ():
	is_horizontal_rotation = true

func _ctrl_released ():
	is_horizontal_rotation = false

func rotate_object(delta_x, delta_y):
	if delta_x != 0:
		# 수평 회전 (delta_x를 사용)
		rotate(Vector3(0, 1, 0), delta_x * PI / 180)

	if delta_y != 0:
		# 수직 회전 (delta_y를 사용)
		rotate(Vector3(1, 0, 0), delta_y * PI / 180)
