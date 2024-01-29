import numpy as np
from scipy.spatial.transform import Rotation as R

def find_rotation_axis(basis_a, basis_b):
    # 두 Basis 객체 사이의 회전 행렬 계산
    rotation_matrix = np.linalg.inv(basis_a) @ basis_b

    # 회전 행렬에서 쿼터니언 변환
    quat = R.from_matrix(rotation_matrix).as_quat()

    # 쿼터니언에서 회전축 추출
    # 쿼터니언은 [x, y, z, w] 형태로, 여기서 [x, y, z]는 축을 나타냄
    return quat[:3]

def parse_basis_string(basis_string):
    # GDScript에서 전달받은 문자열을 파싱하여 numpy 배열로 변환
    values = basis_string.split('|')
    matrix_values = [value.split(',') for value in values]
    return np.array(matrix_values, dtype=float)

basis_a = "0.9390224814415,-0.33727020025253,0.06697604805231|0.33857774734497,0.94089645147324,-0.00889581348747|-0.06001722812653,0.03102996572852,0.99771499633789"
basis_b = "-0.20577777922153,0.95441889762878,-0.21619455516338|0.97470963001251,0.18021918833256,-0.13214485347271|-0.08715914189816,-0.23791936039925,-0.96736633777618"

basis_a_matrix = parse_basis_string(basis_a)
basis_b_matrix = parse_basis_string(basis_b)
result = find_rotation_axis(basis_b_matrix, basis_a_matrix)
print(result)
