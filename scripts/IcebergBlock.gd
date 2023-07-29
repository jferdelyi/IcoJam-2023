extends CollisionShape2D
class_name IcebergBlock


signal destroyed
signal get(block:IcebergBlock)
signal set(block:IcebergBlock)


@export var is_floating := false

var _cracks_array := []
var _mouse_over_ice := false
var _life := 4
var _elapsed_time := 0.0
var _speed := 0.0

@onready var _cracks_lvl_1 := preload("res://assets/images/Fisure-niveau1.png")
@onready var _cracks_lvl_2 := preload("res://assets/images/Fisure-niveau2.png")
@onready var _cracks_lvl_3 := preload("res://assets/images/Fisure-niveau3.png")

@onready var _cracks_sprite := $IcebergBlockCracks
@onready var _adjacency_top := $IcebergBlockAdjacencies/Top
@onready var _adjacency_bottom := $IcebergBlockAdjacencies/Bottom
@onready var _adjacency_right := $IcebergBlockAdjacencies/Right
@onready var _adjacency_left := $IcebergBlockAdjacencies/Left


func _ready() -> void:
	_cracks_array = [_cracks_lvl_3, _cracks_lvl_2, _cracks_lvl_1]
	_speed = randi_range(50, 200)


func _physics_process(delta: float) -> void:
	_elapsed_time += delta
	if is_floating:
		position.x -= _speed * delta
		position.y -= sin(_elapsed_time) * 0.5
		
	else:
		if _elapsed_time >= 1.0:
			_elapsed_time = 0.0
			var random_number := randi_range(0, 100)
			if random_number <= 5:
				_life -= 1
		if _life > 0 and _life < 4:
			_cracks_sprite.texture = _cracks_array[_life - 1]
		if _life <= 0:
			emit_signal("destroyed")
			queue_free()


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and _mouse_over_ice:
				if Global.debug and not is_floating:
					_life -= 1
				elif is_floating and Global.block_clickable:
					emit_signal("get", self)
					visible = false
					Global.block_clickable = false


func hide_available_spots() -> void:
	_adjacency_top.hide_spot()
	_adjacency_bottom.hide_spot()
	_adjacency_right.hide_spot()
	_adjacency_left.hide_spot()


func show_available_spots() -> void:
	_adjacency_top.show_spot()
	_adjacency_bottom.show_spot()
	_adjacency_right.show_spot()
	_adjacency_left.show_spot()


func _on_iceberg_block_area_mouse_entered() -> void:
	_mouse_over_ice = true


func _on_iceberg_block_area_mouse_exited() -> void:
	_mouse_over_ice = false


func _on_block_set(new_position:Vector2) -> void:
	emit_signal("set", new_position)

