extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$End/Button.visible = false
	
	
func _on_video_stream_player_finished() -> void:
	$Video/VideoStreamPlayer.visible = false
	$Video/Background.visible = false
	

func _on_timer_timeout() -> void:
	$End/Button.visible = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func connect_signal(set_time: Signal) -> void:
	set_time.connect(_on_set_time)
	
	
func _on_set_time(ftime: String) -> void:
	$End/Time.text = ftime
