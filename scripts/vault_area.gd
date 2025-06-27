extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		if LevelStatus.has_grabbed_diamond:
			print("You win! Vault reached with diamond.")
			win_game()
		else:
			print("You need to grab the diamond first!")

func win_game():
	print("WIN!")
	# Example: load next scene
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
