extends Node

var has_grabbed_diamond = false
var is_chase_active = false
var player_ref = null
var enemy_ref = null

func reset():
	has_grabbed_diamond = false
	is_chase_active = false
	player_ref = null
	enemy_ref = null
