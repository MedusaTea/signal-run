extends Node

@onready var RootNode = get_node('/root/Root')
@onready var OrbsControl = get_node('/root/Root/Control/QueueBar/Orbs')

@onready var orbScene = preload("res://scenes/orb.tscn")

@export var orbOffset = 115
@export var orbTopOffset = 20
@export var pressDelayThreshold = 0.2
@export var pressDelay = pressDelayThreshold

func _process(delta: float) -> void:
	pressDelay += delta
	if pressDelay < pressDelayThreshold:
		return
		
	if Input.is_action_pressed("press_punch"):
		addOrb('punch')
	
	if Input.is_action_pressed("press_swim"):
		addOrb('swim')
	
	if Input.is_action_pressed("press_kick"):
		addOrb('kick')
	
	if Input.is_action_pressed("press_climb"):
		addOrb('climb')

	if Input.is_action_pressed("press_left"):
		addOrb('left')

	if Input.is_action_pressed("press_duck"):
		addOrb('duck')

	if Input.is_action_pressed("press_jump"):
		addOrb('jump')

	if Input.is_action_pressed("press_right"):
		addOrb('right')

func addOrb(type) -> void:
	if type != 'empty':
		pressDelay = 0
		
	var orbCount = OrbsControl.get_child_count()
	
	var orb = orbScene.instantiate()
	OrbsControl.add_child(orb)
	orb.position = Vector2(100 + orbCount * orbOffset, orbTopOffset)

func _on_timer_timeout() -> void:
	addOrb('empty')
