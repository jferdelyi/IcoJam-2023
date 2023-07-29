extends Node


const game_over_sound = preload("res://assets/sound/Game over.mp3")
const menu_sound = preload("res://assets/sound/Iceberg Panic - Menu.mp3")
const intro_sound = preload("res://assets/sound/Iceberg Panic - Intro.mp3")

var debug := true
var block_clickable := true
var game_over := false

func overlap_two_rect_vect(l1:Vector2, r1:Vector2, l2:Vector2, r2:Vector2) -> bool:

	if l1 == l2 and r1 == r2:
		return true
	
	# if rectangle has area 0, no overlap
	if l1.x == r1.x or l1.y == r1.y or r2.x == l2.x or l2.y == r2.y:
		return false
		
	# If one rectangle is on left side of other
	if l1.x > r2.x or l2.x > r1.x:
		return false
		
	# If one rectangle is above other
	if r1.y > l2.y or r2.y > l1.y:
		return false
	
	return true


func overlap_rect_pts(a1:Vector2, a2:Vector2, pts:Vector2) -> bool:
	return pts.x >= a1.x and pts.x <= a2.x and pts.y >= a1.y and pts.y <= a2.y
