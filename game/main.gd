extends Node2D

@onready var bg_parallax: Parallax2D = $Background
@onready var bg_parallax_image: Sprite2D = $Background/BackgroundImage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_viewport_size_changed()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_viewport_size_changed() -> void:
	var parallax_texture = bg_parallax_image.texture
	if parallax_texture == null:
		return
		
	var screen_width: float = get_viewport().size.x
	var texture_width: float = parallax_texture.get_width()
	
	var screen_height: float = get_viewport().size.y
	var texture_height: float = parallax_texture.get_height()
	
	var scale_ratio_x: float = screen_width / texture_width
	var scale_ratio_y: float = screen_height / texture_height
	
	bg_parallax_image.scale.x = scale_ratio_x
	bg_parallax_image.scale.y = scale_ratio_y
