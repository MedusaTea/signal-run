extends Node3D

@onready var animPlayer: AnimationPlayer = get_node('AnimationPlayer')

func _ready() -> void:
	animPlayer.play('Idle')
	
func StartRunning() -> void:
	animPlayer.play('Sprint')

func Roll() -> void:
	animPlayer.play('Roll')
	
func Jump() -> void:
	animPlayer.play('Jump')

func Swim() -> void:
	animPlayer.play('Swim')

func SwimIdle() -> void:
	animPlayer.play('Swim_Idle')

func PunchJab() -> void:
	animPlayer.play('Punch_Jab')
