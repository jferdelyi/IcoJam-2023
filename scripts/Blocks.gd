extends RigidBody2D
class_name Blocks

const _max_angle := 40.0

var _direction_right := true


func _physics_process(delta: float) -> void:
	if Global.game_over:
		return
		
	if _direction_right:
		rotation_degrees += 10 * delta
		if rotation_degrees >= _max_angle:
			_direction_right = !_direction_right
	else:
		rotation_degrees -= 10 * delta
		if rotation_degrees <= -_max_angle:
			_direction_right = !_direction_right
		


func _integrate_forces(state: PhysicsDirectBodyState2D):
	var vel_linear = state.get_linear_velocity()
	state.set_linear_velocity (Vector2 (-vel_linear.x, -vel_linear.y))
	if rotation_degrees >= _max_angle or rotation_degrees <= -_max_angle:
		var vel_angular = state.get_angular_velocity()
		state.set_angular_velocity(-vel_angular / 4.0)


