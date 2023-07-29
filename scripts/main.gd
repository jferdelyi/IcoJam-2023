extends Node2D

@onready var _pingu_class = preload("res://scenes/Pingu.tscn")

@onready var _game_over_label = $GameOverMenu
@onready var _animation_ocean_1 = $AnimationOcean1
@onready var _animation_ocean_2 = $AnimationOcean2
@onready var _animation_ocean_3 = $AnimationOcean3
@onready var _ocean_game_over = $"Vague-game-over"
@onready var _sound_player := $SoundPlayer
@onready var _restart_sound := $ButtonSound


func _ready() -> void:
	_sound_player.stream = Global.intro_sound
	_sound_player.playing = true
	get_tree().create_tween().tween_property(_ocean_game_over, "position", Vector2(640, 1280), 1)
	_animation_ocean_1.play("move1")
	_animation_ocean_2.play("move2")
	_animation_ocean_3.play("move3")


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var _pingu = _pingu_class.instantiate()
				_pingu.global_position = event.position
				add_child(_pingu)
				_pingu.global_position.y = 150


func _on_iceberg_game_over() -> void:
	_game_over_label.visible = true
	get_tree().create_tween().tween_property(_ocean_game_over, "position", Vector2(640, 400), 1)
	_sound_player.stream = Global.game_over_sound
	_sound_player.playing = true


func _on_restart_pressed() -> void:
	_restart_sound.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


