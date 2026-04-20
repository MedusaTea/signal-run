extends Node

@export var orbOffset = 115
@export var orbTopOffset = 20
@export var pressDelayThreshold = 0.25
@export var pressDelay = pressDelayThreshold

@onready var ObstacleSpawnTimer = $ObstacleSpawnTimer
@onready var ObstaclesScene = get_node('/root/Root/Node3D/Obstacles')
@onready var Character = get_node('/root/Root/Node3D/Character')
@onready var OrbsControl = get_node('/root/Root/Control/QueueBar/Orbs')
@onready var Obstacles = get_node('/root/Root/Node3D/Obstacles')
@onready var gameOverScreen = get_node('/root/Root/Control/GameOverScreen')
@onready var startScreen = get_node('/root/Root/Control/StartScreen')

@onready var punchOrbScene = preload("res://scenes/orbs/punch.tscn")
@onready var leftOrbScene = preload("res://scenes/orbs/left.tscn")
@onready var rightOrbScene = preload("res://scenes/orbs/right.tscn")
@onready var duckOrbScene = preload("res://scenes/orbs/duck.tscn")
@onready var jumpOrbScene = preload("res://scenes/orbs/jump.tscn")
@onready var emptyOrbScene = preload("res://scenes/orbs/empty.tscn")

var orbQueue = []
var orbNameCounter = 0
var maxOrbCount = 2

func _ready() -> void:
	randomize()
	
	for i in maxOrbCount:
		addOrb('empty')

func GameOverMan() -> void:
	gameOverScreen.visible = true
	
	ObstacleSpawnTimer.stop()
	
	var rigidBody
	for obstacle in Obstacles.get_children():
		# not sure why this is happening but no biggie rn
		if obstacle.get_child_count():
			rigidBody = obstacle.get_child(0)
			if rigidBody: 
				rigidBody.linear_velocity = Vector3(0,0,0)

func GameStart() -> void:
	gameOverScreen.visible = false
	startScreen.visible = false

	ObstaclesScene.SpawnNewObstacle()

	for i in maxOrbCount:
		popOrb()
		addOrb('empty')
	
	for obstacle in Obstacles.get_children():
		obstacle.queue_free()

	ObstacleSpawnTimer.start()
	Character.GameStart()
	
func _process(delta: float) -> void:
	pressDelay += delta
	if pressDelay < pressDelayThreshold:
		return
	if Input.is_action_pressed("press_punch"): addOrb('punch')
	if Input.is_action_pressed("press_swim"): addOrb('swim')
	if Input.is_action_pressed("press_kick"): addOrb('kick')
	if Input.is_action_pressed("press_climb"): addOrb('climb')
	if Input.is_action_pressed("press_left"): addOrb('left')
	if Input.is_action_pressed("press_duck"): addOrb('duck')
	if Input.is_action_pressed("press_jump"): addOrb('jump')
	if Input.is_action_pressed("press_right"): addOrb('right')
	
	if Input.is_action_pressed("enter_pressed"): GameStart()
	if Input.is_action_pressed("space_pressed"): GameStart()

func addOrb(type) -> void:
	var orbCount = orbQueue.size()
	
	if type != 'empty':
		pressDelay = 0
		
	var orb 
	if type == 'left':
		orb = leftOrbScene.instantiate()
	elif type == 'duck':
		orb = duckOrbScene.instantiate()
	elif type == 'jump':
		orb = jumpOrbScene.instantiate()
	elif type == 'right':
		orb = rightOrbScene.instantiate()
	elif type == 'punch':
		orb = punchOrbScene.instantiate()
	elif type == 'empty':
		orb = emptyOrbScene.instantiate()
	else:
		return
	
	var viewport = orb.get_node('SubViewportContainer/SubViewport')
	viewport.get_node('Node3D').position = Vector3(-100, orbCount * 100, 0)

	orb.name = '%s %d' % [type, orbNameCounter]
	orbNameCounter += 1
	OrbsControl.add_child(orb)
	orb.position = Vector2(50+ orbCount * orbOffset, orbTopOffset)

	orbQueue.push_back(orb)
	
	if type != 'empty': popOrb()

func updateAllOrbPositions() -> void:
	for orb in orbQueue:
		orb.position = orb.position - Vector2(orbOffset, 0)
	
func popOrb() -> void:
	if orbQueue.size() > 0:
		var orb = orbQueue.pop_front()
		orb.queue_free()
		updateAllOrbPositions()
		if orb:
			Character.HandleAction(orb.name)
		
func _on_empty_orb_timer_timeout() -> void: 
	addOrb('empty')
func _on_pop_orb_timer_timeout() -> void: 
	popOrb()
func _on_restart_button_up() -> void: 
	GameStart()
func _on_start_button_up() -> void: 
	GameStart()
