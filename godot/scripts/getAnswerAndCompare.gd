
class_name GetAnswerCompare

extends Node

const loadQuaternions = preload("./answerQuternions/teapot.gd")
var answerQuaternions = loadQuaternions.teapotQuat
var counter = 0

func answer_test (selected_object):
	counter = counter + 60
	if counter >= 1440:
		counter = 0
	print(counter)
	selected_object.transform.basis = Basis(answerQuaternions[counter])

func answer_check (curr_quat):
	var normal_curr_quat = curr_quat.normalized()
	var result = false
	for oneQuat in answerQuaternions:
		var normal_one_quat = oneQuat.normalized()
		var angle_diff = normal_curr_quat.angle_to(normal_one_quat)
		if angle_diff < 0.2 :
			result = true
			break
	return result
