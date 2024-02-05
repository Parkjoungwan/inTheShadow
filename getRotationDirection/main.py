common_axis = (-0.02847227268233425, -0.08957701039559815, -0.9955728445959591)

# 1도부터 360도까지 스칼라 부분의 값을 변경하면서 쿼터니언 생성
# 각도는 라디안으로 변환해야 합니다 (도 * π / 180)
from math import radians

quaternions = []
for degree in range(-720, 720):
    radian = radians(degree)
    quaternions.append(common_axis + (radian,))

for oneQuat in quaternions:
    print("Quaternion" + str(oneQuat) + ",")
