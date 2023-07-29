extends RigidBody2D


func _integrate_forces(state: PhysicsDirectBodyState2D):
	var vel = state.get_linear_velocity()
	state.set_linear_velocity (Vector2 (-vel.x, -vel.y))


