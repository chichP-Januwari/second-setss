extends CharacterBody2D

@onready var animsprite: AnimatedSprite2D = $AnimatedSprite2D

var playback_path: Array = []
var current_index: int = 0
var is_playing: bool = false

func set_playback_path(path: Array) -> void:
	# Copy and reverse the recorded path
	playback_path = path.duplicate()
	playback_path.reverse()
	current_index = 0
	is_playing = true
	if playback_path.size() > 0:
		global_position = playback_path[0]["position"]

func _physics_process(delta: float) -> void:
	if not is_playing:
		return

	if current_index >= playback_path.size():
		# Reached the end of playback - stop or do something else (like attack or idle)
		is_playing = false
		return

	var frame = playback_path[current_index]

	# Set position
	global_position = frame["position"]

	# Set animation and flip, mirrored horizontally (flip_h inverted)
	animsprite.animation = frame["animation"]
	animsprite.flip_h = !frame["animation_flip"]

	current_index += 1
