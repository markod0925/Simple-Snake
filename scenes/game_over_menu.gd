extends CanvasLayer

signal restart

@onready var animation_player = $GameOverPanel/RestartButton/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("blink")


func _on_restart_button_button_down():
	restart.emit()
	#animation_player.stop()
