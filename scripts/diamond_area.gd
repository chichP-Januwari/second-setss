extends Area2D

@export var enemy_scene: PackedScene

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player" and not LevelStatus.has_grabbed_diamond:
		LevelStatus.has_grabbed_diamond = true
		LevelStatus.player_ref = body

		# Spawn enemy at diamond position
		if enemy_scene:
			var enemy = enemy_scene.instantiate()
			get_parent().add_child(enemy)
			enemy.global_position = global_position

			# Pass reversed movement history
			enemy.set_playback_path(LevelStatus.player_ref.movement_history)
			LevelStatus.enemy_ref = enemy

		# Optionally, hide or disable the diamond so it disappears
		visible = false
		set_monitoring(false)
