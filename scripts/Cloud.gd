extends Sprite2D


signal new_pingu(new_pingu:Pingu, pingu_position:Vector2)
signal end


var _tuto := true
@onready var _tuto_label := $Tuto

var active := false:
	set(new_value):
		if new_value:
			_sound.play()
			active = true
			_elapsed_time = 0.0
			visible = true
			_create_new_pingu()
			_tuto_label.visible = _tuto
			_tuto = false
		else:
			_sound.stop()
			active = false
			_elapsed_time = 0.0
			visible = false
			if _next_pingu:
				remove_child(_next_pingu)
			_next_pingu = null
	get:
		return active

var _elapsed_time := 0.0
var _next_pingu:Pingu = null

@onready var _pingu_class = preload("res://scenes/Pingu.tscn")

@onready var _three_two_one := $ThreeTwoOne
@onready var _sound := $Sound


func _ready() -> void:
	active = false
	_elapsed_time = 0.0
	visible = false
	_next_pingu = null


func _process(delta: float) -> void:
	if active:
		_elapsed_time += delta
		if _elapsed_time <= 1.0:
			_three_two_one.text = "3..."
		elif _elapsed_time <= 2.0:
			_three_two_one.text = "3...2.."
		elif _elapsed_time <= 3.0:
			_three_two_one.text = "3...2..1."
		elif _elapsed_time <= 4.0:
			active = false
			emit_signal("end")


func _create_new_pingu() -> void:
	_next_pingu = null
	_next_pingu = _pingu_class.instantiate()
	_next_pingu.freeze = true
	add_child(_next_pingu)
	_next_pingu.position = Vector2(-390, -225)


func _unhandled_input(event: InputEvent):
	if active:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.pressed:
					remove_child(_next_pingu)
					var pingu_position = event.position
					pingu_position.y = 150
					emit_signal("new_pingu", _next_pingu, pingu_position)
					_create_new_pingu()

