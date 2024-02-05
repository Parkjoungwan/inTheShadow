extends Camera3D

var click_position : Vector2
var is_rotating : bool = false
var is_horizontal_rotation : bool = false

var raycast: RayCast3D
var answer_check_instance
var key_event_class_instance
var mouse_event_class_instance
var SelectedObject: MeshInstance3D = null
var AnsObject: MeshInstance3D = null
var keyController = preload("./keyController.gd")
var mouseController = preload("./mouseController.gd")
var answerCheck = preload("./getAnswerAndCompare.gd")
var counter = 0
var AnsCurrQuat: Quaternion
var AnsTargetQuat: Quaternion
var Duration: float
var ElapsedTime: float = 0.0
var IsInterpolating: bool = false
var IsFinish: bool = false

func _ready():
	# raycast 초기 설정
	raycast = get_node("RayCast3D")
	if raycast:
		raycast.enabled = true
	else:
		print("RayCast3D 노드를 찾을 수 없습니다.")

	# key press & mouse press 이벤트 클래스 및 초기 설정
	key_event_class_instance = keyController.new()
	mouse_event_class_instance = mouseController.new()
	add_child(key_event_class_instance)
	add_child(mouse_event_class_instance)
	key_event_class_instance.ctrl_pressed.connect(_ctrl_pressed)
	key_event_class_instance.ctrl_released.connect(_ctrl_released)
	mouse_event_class_instance.mouse_button_pressed.connect(_mouse_pressed)
	mouse_event_class_instance.mouse_button_released.connect(_mouse_released)
	mouse_event_class_instance.mouse_motion.connect(_mouse_motion)

	# 정답 인식 클래스 설정
	answer_check_instance = answerCheck.new()
	set_process(true)

# 정답 보간 회전 애니메이션
func _process(delta):
	if IsInterpolating and AnsObject:
		ElapsedTime += (delta / Duration)
		if ElapsedTime >= 1.0:
			ElapsedTime = 1.0
			IsInterpolating = false
			print("done roatating.")
			IsFinish = true
		# slerp 함수를 통해 사이를 보간해 타겟과 현재 사이에 존재하는 쿼터니언 구하기
		var slerpQuat : Quaternion = AnsCurrQuat.slerp(AnsTargetQuat, ElapsedTime)
		AnsObject.transform.basis = Basis(slerpQuat)
		
	if IsFinish:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func startSlerpToTarget( fromQuat: Quaternion, toQuat: Quaternion, duration: float):
	# SelectedObject가 있다면, 정답으로 보간 회전 애니메이션 트리거
	if SelectedObject:
		AnsCurrQuat = fromQuat.normalized()
		AnsTargetQuat = toQuat.normalized()
		Duration = duration
		AnsObject = SelectedObject
		ElapsedTime = 0.0
		IsInterpolating = true

func _mouse_pressed (curPosition):
	is_rotating = true
	select_object_under_mouse()
	click_position = curPosition

func select_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = project_ray_origin(mouse_pos)
	var ray_end = ray_origin + project_ray_normal(mouse_pos) * 10000000

	raycast.set_target_position(ray_end)
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is StaticBody3D:
			SelectedObject = collider.get_parent()

func _mouse_released ():
	is_rotating = false
	# SelectedObject의 회전율 출력
	if SelectedObject:
		var quat = SelectedObject.transform.basis.orthonormalized().get_rotation_quaternion()
		var targetQuat = Quaternion(-0.02847227268233425, -0.08957701039559815, -0.9955728445959591, 12.54891732183923)
		# 정답일 경우, 보다 명확한 쿼터니언으로 보간
		if (answer_check_instance.answer_check(quat)):
			startSlerpToTarget( quat, targetQuat, 1.0)
		# 현재 quat값을 출력
		# print(quat)
		# 특정 quat값으로 객체 회전
		# SelectedObject.transform.basis = Basis(Quaternion(0.029674, 0.002826, 0.017487, 0.999403).normalized())
		# 정답으로 적어둔 quat 값을 순회
		# answer_check_instance.answer_test(SelectedObject)
		# 현재 쿼터니언이 정답인지 아닌지 출력
		print(answer_check_instance.answer_check(quat))
	SelectedObject = null

func _mouse_motion (curPosition):
	if is_rotating:
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
	if delta_x != 0 and SelectedObject:
		# 수평 회전 (delta_x를 사용)
		SelectedObject.rotate(Vector3(0, 1, 0), delta_x * PI / 180)
	if delta_y != 0 and SelectedObject:
		# 수직 회전 (delta_y를 사용)
		SelectedObject.rotate(Vector3(1, 0, 0), delta_y * PI / 180)
