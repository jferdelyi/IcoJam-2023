extends RigidBody2D
class_name Pingu


signal dead


var on_the_cloud := true

var _mouse_over_pingu := false
var _mouse_clicked_pingu := false
var _pingu_shape_array := []
var _pingu_sound_array := []

@onready var _square := preload("res://assets/images/pingu-CUBE.png")
@onready var _triangle := preload("res://assets/images/pingu-TRIANGLE.png")
@onready var _rectangle := preload("res://assets/images/pingu-RECTANGLE.png")

@onready var _pingu_sound_1 := preload("res://assets/sound/FX pingus 1.mp3")
@onready var _pingu_sound_2 := preload("res://assets/sound/FX pingus 2.mp3")
@onready var _pingu_sound_3 := preload("res://assets/sound/FX pingus 3.mp3")

@onready var _pingu_collision := $PinguCollision
@onready var _pingu_collision_triangle := $PinguCollisionTriangle
@onready var _pingu_sprite := $PinguSprite
@onready var _pingu_sound := $PinguSound


func _ready() -> void:
	_pingu_shape_array = [_square, _triangle, _rectangle]
	_pingu_sound_array = [_pingu_sound_1, _pingu_sound_2, _pingu_sound_3]
	var random_number := randi_range(0, 2)
	_pingu_sprite.texture = _pingu_shape_array[random_number]
	if random_number == 0:
		_pingu_collision.shape = RectangleShape2D.new()
		_pingu_collision.shape.size.x = 32
		_pingu_collision.shape.size.y = 32
		mass = 2
	elif random_number == 1:
		_pingu_collision.disabled = true
		_pingu_collision_triangle.disabled = false
		mass = 1
	else:
		_pingu_collision.shape = RectangleShape2D.new()
		_pingu_collision.shape.size.x = 32
		_pingu_collision.shape.size.y = 64
		mass = 3


func _unhandled_input(event: InputEvent):
	if on_the_cloud:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and _mouse_over_pingu:
				_mouse_clicked_pingu = true
				rotation = 0.0
				freeze = true
				_pingu_collision.disabled = true
				_pingu_collision_triangle.disabled = true
			elif not event.pressed:
				_mouse_clicked_pingu = false
				freeze = false
				_pingu_collision.disabled = false
				_pingu_collision_triangle.disabled = false


func _physics_process(_delta: float) -> void:
	if _mouse_clicked_pingu:
		global_position = get_viewport().get_mouse_position()
	if global_position.y > 1000:
		emit_signal("dead")
		queue_free()


func _on_clickable_area_mouse_entered() -> void:
	_mouse_over_pingu = true


func _on_clickable_area_mouse_exited() -> void:
	_mouse_over_pingu = false


func _on_body_entered(body: Node) -> void:
	if body is Blocks:
		if not _pingu_sound.playing:
			_pingu_sound.stream = _pingu_sound_array[randi_range(0, 2)]
			_pingu_sound.play()
