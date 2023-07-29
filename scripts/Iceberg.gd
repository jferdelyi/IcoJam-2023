extends Node2D


signal game_over


var _block_to_set :IcebergBlock
var _elapsed_time := 0.0


@onready var _blocks := $Blocks
@onready var _destruction_sound := $DestructionSound
@onready var _block_class := preload("res://scenes/IcebergBlock.tscn")


func _ready() -> void:
	Global.game_over = false


func _process(delta: float) -> void:
	if Global.game_over:
		return
	
	if _blocks.get_child_count() <= 0:
		Global.game_over = true
		emit_signal("game_over")
	
	_elapsed_time += delta
	if _elapsed_time >= 1.0:
		_elapsed_time = 0.0
		var random_number := randi_range(0, 100)
		if random_number <= 10:
			var floating_block := _block_class.instantiate()
			floating_block.is_floating = true
			floating_block.position.x = 500
			floating_block.position.y = randi_range(100, 130)
			floating_block.connect("set", _on_block_set)
			floating_block.connect("get", _on_block_get)
			floating_block.connect("destroyed", _on_block_destroyed)
			add_child(floating_block)
			


func show_available_spots() -> void:
	for block in _blocks.get_children():
		if not block.is_floating:
			block.show_available_spots()


func hide_available_spots() -> void:
	for block in _blocks.get_children():
		block.hide_available_spots()


func _on_block_get(block:IcebergBlock) -> void:
	_block_to_set = block
	if block.is_floating:
		show_available_spots()


func _on_block_destroyed() -> void:
	_destruction_sound.play()


func _on_block_set(new_position:Vector2) -> void:
	_block_to_set.is_floating = false
	_block_to_set.visible = true
	_block_to_set.get_parent().remove_child(_block_to_set)
	_blocks.add_child(_block_to_set)
	_block_to_set.global_position = new_position
	_block_to_set.add_to_group("Iceberg")
	hide_available_spots()
	Global.block_clickable = true




func _on_blocks_body_entered(body: Node) -> void:
	print("PAT2")
