extends Control

@onready var start_button = $VBoxContainer/Start
@onready var quit_button = $VBoxContainer/Quit
@onready var options_button = $VBoxContainer/Options

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	options_button.pressed.connect(_on_options_pressed)

func _on_start_pressed():
	print("Start")
	get_tree().change_scene_to_file("res://scenes/Battlefield.tscn")

func _on_quit_pressed():
	print("Quit")
	get_tree().quit()
	
func _on_options_pressed():
	print("Options")
	
