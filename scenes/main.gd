extends Node

@export var snake_scene : PackedScene
@onready var hud = $HUD
@onready var snake_container = $Snake
@onready var move_timer = $MoveTimer

var score : int
var game_started : bool = false

#grid variables
var cells : int = 20
var cell_size : int = 50

#food variables
var food_pos : Vector2
var regen_food : bool = true

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

#movements variables
var start_pos : Vector2 = Vector2(9, 9)
var move_dir : Vector2
var can_move : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_snake()


func new_game() -> void:
	score = 0
	hud.get_node("ScoreLabel").text = "SCORE: " + str(score)
	move_dir = Vector2.UP
	can_move = true
	generate_snake()
	
	
func generate_snake() -> void:
	old_data.clear()
	snake_data.clear()
	snake.clear()
	# starting with start_pos, create tail serpents vertically down
	for i in range(3):
		add_segment(start_pos + Vector2.DOWN * i)
		
		
func add_segment(pos: Vector2) -> void:
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)


func move_snake() -> void:
	if can_move:
		if Input.is_action_just_pressed("down") and move_dir != Vector2.UP:
			move_dir = Vector2.DOWN
			can_move = false
			if not game_started:
				start_game()
		elif Input.is_action_just_pressed("up") and move_dir != Vector2.DOWN:
			move_dir = Vector2.UP
			can_move = false
			if not game_started:
				start_game()
		elif Input.is_action_just_pressed("left") and move_dir != Vector2.RIGHT:
			move_dir = Vector2.LEFT
			can_move = false
			if not game_started:
				start_game()
		elif Input.is_action_just_pressed("right") and move_dir != Vector2.LEFT:
			move_dir = Vector2.RIGHT
			can_move = false
			if not game_started:
				start_game()


func start_game() -> void:
	game_started = true
	move_timer.start()


func _on_move_timer_timeout():
	can_move = true
	old_data = [] + snake_data
	snake_data[0] += move_dir
	for i in range(len(snake_data)):
		if i > 0:
			snake_data[i] = old_data[i-1]
		snake[i].position = (snake_data[i] * cell_size) + Vector2(0, cell_size)
	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()

func check_out_of_bounds() -> void:
	if snake_data[0].x < 0 or snake_data[0].x > cells-1 or snake_data[0].y < 0 or snake_data[0].y > cells-1:
		end_game() 


func check_self_eaten() -> void:
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()


func check_food_eaten() -> void:
	pass


func end_game() -> void:
	print("end game")
