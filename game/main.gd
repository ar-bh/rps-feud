extends Node2D

#region parallax
@onready var bg_parallax: Parallax2D = $Background
@onready var bg_parallax_image: Sprite2D = $Background/BackgroundImage
var bob_height: float = 10.0
var bob_duration: float = 0.2


const BACKGROUND_SCROLL_SPEED := 50.0


#endregion

var textures: Dictionary = {
	"right_rock": preload("res://assets/right_rock.png"),
	"right_paper": preload("res://assets/right_paper.png"),
	"right_scissors": preload("res://assets/right_scissors.png"),
	"left_rock": preload("res://assets/left_rock.png"),
	"left_paper": preload("res://assets/left_paper.png"),
	"left_scissors": preload("res://assets/left_scissors.png"),
}

@onready var right_score_label: RichTextLabel = $ScoreBox/RightScore
@onready var left_score_label: RichTextLabel = $ScoreBox/LeftScore

@onready var left_animation_player: AnimationPlayer = $LeftPlayer/LeftAnimationPlayer
@onready var right_animation_player: AnimationPlayer = $RightPlayer/RightAnimationPlayer

@onready var left_player: Node2D = $LeftPlayer
@onready var left_hand: Sprite2D = $LeftPlayer/LeftHand
@onready var right_player: Node2D = $RightPlayer
@onready var right_hand: Sprite2D = $RightPlayer/RightHand

var left_player_rest_y: float
var right_player_rest_y: float

var right_form := "rock"
var left_form := "rock"

var right_attack := false
var left_attack := false


var right_score := 0
var left_score := 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_parallax.autoscroll.x = BACKGROUND_SCROLL_SPEED


	
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	left_animation_player.animation_finished.connect(_on_left_animation_finished)
	right_animation_player.animation_finished.connect(_on_right_animation_finished)


func _on_left_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"attack":
		left_attack = !left_attack


func _on_right_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"attack":
		right_attack = !right_attack


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	#region transform inputs
	if Input.is_action_just_pressed("right_rock") and right_form != "rock":
		right_form = "rock"
		right_hand.texture = textures["right_rock"]
		_bob_hand(right_player, right_player.position.y)
	if Input.is_action_just_pressed("left_rock") and left_form != "rock":
		left_form = "rock"
		left_hand.texture = textures["left_rock"]
		_bob_hand(left_player, left_player.position.y)
	if Input.is_action_just_pressed("right_paper") and right_form != "paper":
		right_form = "paper"
		right_hand.texture = textures["right_paper"]
		_bob_hand(right_player, right_player.position.y)
	if Input.is_action_just_pressed("left_paper") and left_form != "paper":
		left_form = "paper"
		left_hand.texture = textures["left_paper"]
		_bob_hand(left_player, left_player.position.y)
	if Input.is_action_just_pressed("right_scissors") and right_form != "scissors":
		right_form = "scissors"
		right_hand.texture = textures["right_scissors"]
		_bob_hand(right_player, right_player.position.y)
	if Input.is_action_just_pressed("left_scissors") and left_form != "scissors":
		left_form = "scissors"
		left_hand.texture = textures["left_scissors"]
		_bob_hand(left_player, left_player.position.y)
#endregion
	
	#region attack inputs
	if Input.is_action_just_pressed("left_toggle"):
		if left_attack == false:
			left_animation_player.play("attack")
		elif left_attack == true:
			left_animation_player.play_backwards("attack")

	if Input.is_action_just_pressed("right_toggle"):
		if right_attack == false:
			right_animation_player.play("attack")
		elif right_attack == true:
			right_animation_player.play_backwards("attack")
#endregion
	
	
	
	left_score_label.text = str(left_score)
	right_score_label.text = str(right_score)




func _bob_hand(hand: Node2D, rest_y: float) -> void:
	hand.position.y = rest_y
	var tween := create_tween()
	tween.tween_property(hand, "position:y", rest_y - bob_height, bob_duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(hand, "position:y", rest_y, bob_duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

#region viewport changing size irrelevant
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
