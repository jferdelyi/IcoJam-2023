extends Node2D

var _elapsed_time := 0.0
var _next_cloud := 7.0
var _score := 0
var _time_remaining := 180
var _tuto := false
var _dead_pingus := 0

@onready var _game_over_container = $GameOverMenu
@onready var _animation_ocean_1 = $AnimationOcean1
@onready var _animation_ocean_2 = $AnimationOcean2
@onready var _animation_ocean_3 = $AnimationOcean3
@onready var _ocean_game_over = $"Vague-game-over"
@onready var _pause_player = $PauseSound
@onready var _sound_player := $SoundPlayer
@onready var _restart_sound := $ButtonSound
@onready var _goeland_sound := $GoelandSound
@onready var _cloud := $Cloud
@onready var _score_label := $Score
@onready var _time_remaining_label := $TimeRemaining
@onready var _next_cloud_label := $NextCloud
@onready var _message_label := $GameOverMenu/Panel/Message
@onready var _continue_button := $GameOverMenu/Continue
@onready var _tuto_label := $Tuto
@onready var _fallen_pingus_label := $PinguFallen
@onready var _goeland := $Goeland


func _ready() -> void:
	get_tree().paused = false
	_sound_player.stream = Global.intro_sound
	_sound_player.playing = true
	get_tree().create_tween().tween_property(_ocean_game_over, "position", Vector2(640, 1280), 1)
	_animation_ocean_1.play("move1")
	_animation_ocean_2.play("move2")
	_animation_ocean_3.play("move3")


func _process(delta: float) -> void:
	if Global.game_over:
		return
	_elapsed_time += delta
	if _elapsed_time >= 1.0:
		for pingu in get_tree().get_nodes_in_group("Pingus"):
			if not pingu.on_the_cloud:
				_score += 100
		_time_remaining -= 1
		_elapsed_time = 0.0

		var goeland_animation = randi_range(0, 100)
		if goeland_animation <= 5:
			_goeland_sound.play()
			_goeland.position = Vector2(1450, 90)
			get_tree().create_tween().tween_property(_goeland, "position", Vector2(-100, 200), 2)
		
		if not _cloud.active:
			_next_cloud -= 1
			if _next_cloud <= 0.0:
				_next_cloud = randi_range(5, 20)
				_cloud.active = true
				_tuto_label.visible = false
			
		if _time_remaining <= 0:
			game_win()
	_score_label.text = "Score: " + str(_score)
	_time_remaining_label.text = "Time Remaining: " + str(int(_time_remaining / 60.0)) + ":" + str(_time_remaining % 60)
	_next_cloud_label.text = "Next Cloud: " + str(_next_cloud) + "s"


func _input(_event:InputEvent):
	if Input.is_action_pressed("pause"):
		get_tree().paused = true
		_game_over_container.visible = true
		_message_label.text = "Pause"
		_continue_button.visible = true
		_pause_player.play()


func game_win() -> void:
	_message_label.text = "Victory"
	Global.game_over = true
	_game_over_container.visible = true
	_sound_player.stream = Global.vistory_sound
	_sound_player.playing = true
	var pingus = get_tree().get_nodes_in_group("Pingus")
	_score += pingus.size() * 2000
	_score_label.text = "Score: " + str(_score)


func _on_iceberg_game_over() -> void:
	_message_label.text = "Game Over"
	Global.game_over = true
	_game_over_container.visible = true
	get_tree().create_tween().tween_property(_ocean_game_over, "position", Vector2(640, 400), 1)
	_sound_player.stream = Global.game_over_sound
	_sound_player.playing = true


func _on_restart_pressed() -> void:
	get_tree().paused = false
	_pause_player.stop()
	_restart_sound.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_cloud_new_pingu(new_pingu: Pingu, pingu_position: Vector2) -> void:
	new_pingu.freeze = false
	new_pingu.on_the_cloud = false
	new_pingu.connect("dead", _on_pingu_dead)
	add_child(new_pingu)
	new_pingu.global_position = pingu_position


func _on_pingu_dead() -> void:
	_score -= 1000
	_dead_pingus += 1
	_fallen_pingus_label.text = "Fallen Pingus: " + str(_dead_pingus) + "/20"
	if _dead_pingus == 20:
		_on_iceberg_game_over()


func _on_continue_pressed() -> void:
	get_tree().paused = false
	_pause_player.stop()
	_restart_sound.play()
	_game_over_container.visible = false
	_continue_button.visible = false


func _on_cloud_end() -> void:
	if _tuto:
		_tuto_label.visible = true
		_tuto_label.text = "Left-click on the Pingus to move them!"
		await get_tree().create_timer(3.0).timeout
		_tuto_label.visible = false
		_tuto = false
