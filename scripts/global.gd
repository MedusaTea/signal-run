extends Node

@onready var RootNode = get_node('/root/Root')
@onready var OrbsControl = get_node('/root/Root/Control/QueueBar/Orbs')

@onready var leftOrbScene = preload("res://scenes/orbs/left.tscn")
@onready var rightOrbScene = preload("res://scenes/orbs/right.tscn")
@onready var duckOrbScene = preload("res://scenes/orbs/duck.tscn")
@onready var jumpOrbScene = preload("res://scenes/orbs/jump.tscn")
@onready var emptyOrbScene = preload("res://scenes/orbs/empty.tscn")

@export var orbOffset = 115
@export var orbTopOffset = 20
@export var pressDelayThreshold = 0.2
@export var pressDelay = pressDelayThreshold

var orbQueue = []

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
		
	var orbCount = orbQueue.size()
	
	if orbCount > 6:
		return
		
	var orb 
	if type == 'left':
		orb = leftOrbScene.instantiate()
	elif type == 'duck':
		orb = duckOrbScene.instantiate()
	elif type == 'jump':
		orb = jumpOrbScene.instantiate()
	elif type == 'right':
		orb = rightOrbScene.instantiate()
	elif type == 'empty':
		orb = emptyOrbScene.instantiate()
	else:
		return
	
	var viewport = orb.get_node('SubViewportContainer').get_node('SubViewport')
	viewport.get_node('Node3D').position = Vector3(-100, orbCount * 100, 0)
	
	OrbsControl.add_child(orb)
	orb.position = Vector2(100 + orbCount * orbOffset, orbTopOffset)

	orbQueue.push_back(orb)

func updateAllOrbPositions() -> void:
	for orb in orbQueue:
		orb.position = orb.position - Vector2(orbOffset, 0)
	
func popOrb() -> void:
	if orbQueue.size() > 0:
		var orb = orbQueue.pop_front()
		orb.queue_free()
		updateAllOrbPositions()
		
func _on_empty_orb_timer_timeout() -> void:
	addOrb('empty')

func _on_pop_orb_timer_timeout() -> void:
	popOrb()
