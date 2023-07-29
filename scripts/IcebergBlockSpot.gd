extends Area2D


signal block_set(position: Vector2)


@export var parent_block := IcebergBlock

var _mouse_over_block := false


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and _mouse_over_block:
				emit_signal("block_set", global_position)


func hide_spot() -> void:
	visible = false


func show_spot() -> void:
	for block in get_tree().get_nodes_in_group("Iceberg"):
		if block != parent_block:
			if Global.overlap_rect_pts(	block.global_position - Vector2(16, 16), 
										block.global_position + Vector2(16, 16), 
										global_position):
				visible = false
				return
	visible = true


func _on_mouse_entered() -> void:
	_mouse_over_block = true


func _on_mouse_exited() -> void:
	_mouse_over_block = false
