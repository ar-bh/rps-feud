extends Node2D

@onready var bg_parallax_image: Sprite2D = $Background/BackgroundImage

@onready var play_button: Button = $CanvasLayer/VBoxContainer/PlayButton
@onready var quit_button: Button = $CanvasLayer/VBoxContainer/QuitButton
@onready var help_button: Button = $CanvasLayer/VBoxContainer/HelpButton
@onready var canvas_layer_2: CanvasLayer = $CanvasLayer2
@onready var back_button: Button = $CanvasLayer2/BackButton
func _ready() -> void:
	canvas_layer_2.visible = false
	
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()
	
	play_button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://game/main.tscn")	
	)
	quit_button.pressed.connect(func() -> void:
		get_tree().quit()
	)
	help_button.pressed.connect(func() -> void:
		canvas_layer_2.visible = true
	)
	back_button.pressed.connect(func() -> void:
		canvas_layer_2.visible = false
	)
	


func _on_viewport_size_changed() -> void:
	var parallax_texture := bg_parallax_image.texture
	if parallax_texture != null:
		var screen_size := get_viewport().get_visible_rect().size
		bg_parallax_image.scale = Vector2(
			screen_size.x / parallax_texture.get_width(),
			screen_size.y / parallax_texture.get_height()
		)
