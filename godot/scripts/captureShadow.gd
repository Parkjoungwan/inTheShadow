extends SubViewport

func _ready():
	# await을 통해서 frame이 모두 그려질 때까지 기다리기
	await RenderingServer.frame_post_draw
	# viewport에서 그림을 가져와 img로 저장
	var img = get_texture().get_image()
	var file_path = "res://captured_image.png"
	img.save_png(file_path)
	var tex = ImageTexture.create_from_image(img)
	
func _process(delta):
	pass
