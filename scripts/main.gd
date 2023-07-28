extends Node2D


func _process(delta: float) -> void:
	%Icon.rotation_degrees += (1000 * delta)
