extends Control



func _on_StartGame_pressed():
	get_tree().change_scene("res://scenes/Level1.tscn")


func _on_QuitGame_pressed():
	get_tree().quit()


func _on_Follow_me_on_Twitter_pressed():
	OS.shell_open("https://twitter.com/themikebrave") 
