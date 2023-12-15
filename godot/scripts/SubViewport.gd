extends SubViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	# 기다리기: 프레임이 완료되기를 기다립니다.
	await RenderingServer.frame_post_draw
	print("testing")
	# 캡쳐 쿼리: Viewport의 내용을 캡쳐합니다.
	var img = get_texture().get_image()
	img.flip_y() # Y축을 기준으로 이미지를 뒤집습니다.
	# 이미지 파일로 저장: PNG 형식으로 저장합니다.
	var file_path = "res://captured_image.png"
	img.save_png(file_path)

	# 필요한 경우, 이미지를 텍스쳐로 변환하여 스프라이트에 적용할 수 있습니다.
	var tex = ImageTexture.create_from_image(img)
	# 여기서 $sprite는 저장하려는 스프라이트 노드의 경로입니다.
	# 예: get_node("YourSpritePath").texture = tex
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
