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

#region node variables
@onready var time_left_label: RichTextLabel = $ScoreBox/TimeLeftLabel
@onready var right_score_label: RichTextLabel = $ScoreBox/RightScore
@onready var left_score_label: RichTextLabel = $ScoreBox/LeftScore

@onready var left_animation_player: AnimationPlayer = $LeftPlayer/LeftAnimationPlayer
@onready var right_animation_player: AnimationPlayer = $RightPlayer/RightAnimationPlayer

@onready var left_player: Node2D = $LeftPlayer
@onready var left_hand: Sprite2D = $LeftPlayer/LeftHand
@onready var right_player: Node2D = $RightPlayer
@onready var right_hand: Sprite2D = $RightPlayer/RightHand

@onready var game_timer: Timer = $GameTimer
@onready var round_timer: Timer = $RoundTimer

@onready var popup: Panel = $Popup
@onready var winner_label: RichTextLabel = $Popup/PopupVBox/WinnerLabel
@onready var next_round_in_label: RichTextLabel = $Popup/PopupVBox/NextRoundInLabel
@onready var timer_label: RichTextLabel = $Popup/PopupVBox/TimerLabel

@onready var winner_popup: Panel = $WinnerPopup
@onready var game_winner_label: RichTextLabel = $WinnerPopup/PopupVBox/GameWinnerLabel

@onready var play_again_button: Button = $WinnerPopup/PopupVBox/PlayAgainButton
@onready var quit_button: Button = $WinnerPopup/PopupVBox/QuitButton
@onready var menu_button: Button = $WinnerPopup/PopupVBox/MenuButton

#endregion

#region animation variables
var left_player_rest_y: float
var right_player_rest_y: float
var _left_bob_tween: Tween
var _right_bob_tween: Tween
#endregion

var right_form := "rock"
var left_form := "rock"
var right_attack := false
var left_attack := false
var right_score := 0
var left_score := 0

const POINTS_TO_WIN = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	bg_parallax.autoscroll.x = BACKGROUND_SCROLL_SPEED

	#region animation and stuff#
	left_player_rest_y = left_player.position.y
	right_player_rest_y = right_player.position.y
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	left_animation_player.animation_finished.connect(_on_left_animation_finished)
	right_animation_player.animation_finished.connect(_on_right_animation_finished)
	#endregion

	game_timer.timeout.connect(_on_game_timer_timeout)
	round_timer.timeout.connect(_start_game)
	
	play_again_button.pressed.connect(_on_play_again_pressed)
	quit_button.pressed.connect(func() -> void:
		get_tree().quit()
	)
	menu_button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://game/start_screen.tscn")	
	)
	
	popup.visible = false
	_start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if round_active:
		#region transform inputs
		if Input.is_action_just_pressed("right_rock") and right_form != "rock":
			right_form = "rock"
			right_hand.texture = textures["right_rock"]
			_bob_hand(right_player, right_player_rest_y, right_attack)
		if Input.is_action_just_pressed("left_rock") and left_form != "rock":
			left_form = "rock"
			left_hand.texture = textures["left_rock"]
			_bob_hand(left_player, left_player_rest_y, left_attack)
		if Input.is_action_just_pressed("right_paper") and right_form != "paper":
			right_form = "paper"
			right_hand.texture = textures["right_paper"]
			_bob_hand(right_player, right_player_rest_y, right_attack)
		if Input.is_action_just_pressed("left_paper") and left_form != "paper":
			left_form = "paper"
			left_hand.texture = textures["left_paper"]
			_bob_hand(left_player, left_player_rest_y, left_attack)
		if Input.is_action_just_pressed("right_scissors") and right_form != "scissors":
			right_form = "scissors"
			right_hand.texture = textures["right_scissors"]
			_bob_hand(right_player, right_player_rest_y, right_attack)
		if Input.is_action_just_pressed("left_scissors") and left_form != "scissors":
			left_form = "scissors"
			left_hand.texture = textures["left_scissors"]
			_bob_hand(left_player, left_player_rest_y, left_attack)
		#endregion
	
		#region attack inputs
		if Input.is_action_just_pressed("left_toggle"):
			if left_attack == false:
				_stop_bob(left_player, _left_bob_tween, left_player_rest_y)
				left_animation_player.play("attack")
			else:
				_kill_bob_tween(_left_bob_tween)
				left_animation_player.play_backwards("attack")

		if Input.is_action_just_pressed("right_toggle"):
			if right_attack == false:
				_stop_bob(right_player, _right_bob_tween, right_player_rest_y)
				right_animation_player.play("attack")
			else:
				_kill_bob_tween(_right_bob_tween)
				right_animation_player.play_backwards("attack")
#endregion
	
	#region labels
	left_score_label.text = str(left_score)
	right_score_label.text = str(right_score)
	#endregion
	
	#region decide win
	if left_attack and right_attack and round_active:
		if left_form == "rock" and right_form == "paper":
			_end_round("right")
		elif left_form == "rock" and right_form == "scissors":
			_end_round("left")
		elif left_form == "paper" and right_form == "rock":
			_end_round("left")
		elif left_form == "paper" and right_form == "scissors":
			_end_round("right")
		elif left_form == "scissors" and right_form == "rock":
			_end_round("right")
		elif left_form == "scissors" and right_form == "paper":
			_end_round("left")
		#elif left_form == right_form:
			#_end_round("draw")
	#endregion
	if round_active:
		time_left_label.visible = true
		time_left_label.text = "[center]"+str(int(round(game_timer.time_left)))+"[/center]"
	else:
		time_left_label.text = ""
		
	if wait_active:
		timer_label.text = "[center]"+str(int(round(round_timer.time_left)))+"[/center]"
	else:
		timer_label.text = ""
	
		
		
	right_score_label.text = "[center]"+str(right_score)+"[/center]"
	left_score_label.text = "[center]"+str(left_score)+"[/center]"
		

var round_active := false
var wait_active := false

func _start_game() -> void:
	round_active = true
	wait_active = false
	
	popup.visible = false
	winner_popup.visible = false
	
	left_attack = false
	right_attack = false
	
	left_animation_player.current_animation = "attack"
	right_animation_player.current_animation = "attack"
	
	left_animation_player.seek(0.0, true)
	right_animation_player.seek(0.0, true)
	left_animation_player.stop()
	right_animation_player.stop()
	
	game_timer.start()

func _on_game_timer_timeout() -> void:
	_end_round()


func _end_round(winner: String = "") -> void:
	round_active = false
	wait_active = true
	
	

	
	game_timer.stop()
	
	if winner == "":
		if left_attack == true and right_attack != true:
			winner = "left"
		elif left_attack != true and right_attack == true:
			#right wins
			winner = "right"
		elif left_attack != true and right_attack != true:
			# draw
			winner = "draw"
			
	if winner == "left":
		winner_label.text = "[center]Left wins! Left's " + left_form + " beats Right's " + right_form+"[/center]"
		left_score += 1
	elif winner == "right":
		winner_label.text = "[center]Right wins! Right's " + right_form + " beats Left's " + left_form+"[/center]"
		right_score += 1
	elif winner == "draw":
		winner_label.text = "[center]Round ends in draw!"+"[/center]"
	
	if left_score < POINTS_TO_WIN and right_score < POINTS_TO_WIN:
		popup.visible = true
		round_timer.start()
	elif left_score >= POINTS_TO_WIN and right_score < POINTS_TO_WIN:
		winner_popup.visible = true
		game_winner_label.text = "[center]Left has won![/center]"
	elif left_score < POINTS_TO_WIN and right_score >= POINTS_TO_WIN:
		winner_popup.visible = true
		game_winner_label.text = "[center]Right has won![/center]"
	
	
func _on_play_again_pressed() -> void:
	left_score = 0
	right_score = 0
	_start_game()
		

#region animations finished
func _on_left_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"attack":
		left_attack = !left_attack
		if left_attack:
			_kill_bob_tween(_left_bob_tween)
func _on_right_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"attack":
		right_attack = !right_attack
		if right_attack:
			_kill_bob_tween(_right_bob_tween)
#endregion

#region bob tween
func _kill_bob_tween(tween: Tween) -> void:
	if tween and tween.is_running():
		tween.kill()
func _stop_bob(player: Node2D, tween: Tween, rest_y: float) -> void:
	_kill_bob_tween(tween)
	player.position.y = rest_y
func _bob_hand(player: Node2D, rest_y: float, attack_active: bool) -> void:
	var tween := _left_bob_tween if player == left_player else _right_bob_tween
	if attack_active:
		_kill_bob_tween(tween)
		return

	_stop_bob(player, tween, rest_y)

	tween = create_tween()
	if player == left_player:
		_left_bob_tween = tween
	else:
		_right_bob_tween = tween

	tween.tween_property(player, "position:y", rest_y - bob_height, bob_duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "position:y", rest_y, bob_duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
#endregion

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
