extends MeshInstance3D

var is_rotating : bool = false
var click_position : Vector2
var is_horizontal_rotation : bool = false

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if Input.is_key_pressed(KEY_CTRL):
				is_horizontal_rotation = true
			# 마우스 왼쪽 버튼이 눌린 경우
			is_rotating = true
			click_position = event.position
			print("Drag Start: ", click_position, " Horizontal Rotation: ", is_horizontal_rotation)
		else:
			# 마우스 왼쪽 버튼이 떼어진 경우
			is_rotating = false
			print("Drag End")
	elif event is InputEventMouseMotion and is_rotating:
		# 마우스 이동 중인 경우
		var delta = event.position - click_position
		if is_horizontal_rotation:
			rotate_object(delta.x, 0)
		else:
			rotate_object(0, delta.y)
		click_position = event.position

func rotate_object(delta_x, delta_y):
	if delta_x != 0:
		# 수평 회전 (delta_x를 사용)
		rotate(Vector3(0, 1, 0), delta_x * PI / 180)

	if delta_y != 0:
		# 수직 회전 (delta_y를 사용)
		rotate(Vector3(1, 0, 0), delta_y * PI / 180)
