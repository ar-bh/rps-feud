extends Node2D

#region parallax
@onready var bg_parallax: Parallax2D = $Background
@onready var bg_parallax_image: Sprite2D = $Background/BackgroundImage
var bob_height: float = 10.0
var bob_duration: float = 0.2


const BACKGROUND_SCROLL_SPEED := 50.0


#endregion



@onready var left_player: Area2D = $LeftPlayer
@onready var right_player: Area2D = $RightPlayer

@onready var left_hand: Sprite2D = $LeftPlayer/LeftHand
@onready var right_hand: Sprite2D = $RightPlayer/RightHand


var textures: Dictionary = {
	"right_rock": preload("res://assets/right_rock.png"),
	"right_paper": preload("res://assets/right_paper.png"),
	"right_scissors": preload("res://assets/right_scissors.png"),
	"left_rock": preload("res://assets/left_rock.png"),
	"left_paper": preload("res://assets/left_paper.png"),
	"left_scissors": preload("res://assets/left_scissors.png"),
}



var right_form = "rock"
var left_form = "rock"




var left_hand_rest_y: float
var right_hand_rest_y: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_parallax.autoscroll.x = BACKGROUND_SCROLL_SPEED
	
	left_hand_rest_y = left_hand.position.y
	right_hand_rest_y = right_hand.position.y
	
	get_viewport().size_changed.connect(_on_viewport_size_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("right_rock") and right_form != "rock":
		right_form = "rock"
		right_hand.texture = textures["right_rock"]
		_bob_hand(right_hand, right_hand_rest_y)
	
	if Input.is_action_just_pressed("left_rock") and left_form != "rock":
		left_form = "rock"
		left_hand.texture = textures["left_rock"]
		_bob_hand(left_hand, left_hand_rest_y)
		
	if Input.is_action_just_pressed("right_paper") and right_form != "paper":
		right_form = "paper"
		right_hand.texture = textures["right_paper"]
		_bob_hand(right_hand, right_hand_rest_y)
		
	if Input.is_action_just_pressed("left_paper") and left_form != "paper":
		left_form = "paper"
		left_hand.texture = textures["left_paper"]
		_bob_hand(left_hand, left_hand_rest_y)
		
	if Input.is_action_just_pressed("right_scissors") and right_form != "scissors":
		right_form = "scissors"
		right_hand.texture = textures["right_scissors"]
		_bob_hand(right_hand, right_hand_rest_y)
	
	if Input.is_action_just_pressed("left_scissors") and left_form != "scissorsw":
		left_form = "scissors"
		left_hand.texture = textures["left_scissors"]
		_bob_hand(left_hand, left_hand_rest_y)
	
	


func _bob_hand(hand: Sprite2D, rest_y: float) -> void:
	hand.position.y = rest_y
	var tween := create_tween()
	tween.tween_property(hand, "position:y", rest_y - bob_height, bob_duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(hand, "position:y", rest_y, bob_duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


#region viewport
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
#endregion
