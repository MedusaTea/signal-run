extends Node

@export var orbOffset = 115
@export var orbTopOffset = 20
@export var pressDelayThreshold = 0.25
@export var pressDelay = pressDelayThreshold

#@onready var SignalEffect = $Node3D/SignalEffect/CPUParticles3D
@onready var PointsLabel = $Control/PointsLabel
@onready var ObstacleSpawnTimer = $ObstacleSpawnTimer
@onready var ObstaclesScene = get_node('/root/Root/Node3D/Obstacles')
@onready var Character = get_node('/root/Root/Node3D/Character')
@onready var OrbsControl = get_node('/root/Root/Control/QueueBar/Orbs')
@onready var Obstacles = get_node('/root/Root/Node3D/Obstacles')
@onready var gameOverScreen = get_node('/root/Root/Control/GameOverScreen')
@onready var startScreen = get_node('/root/Root/Control/StartScreen')

@onready var Orb1 = $Node3D/Character/Transmitter/Orb1
@onready var Orb2 = $Node3D/Character/Transmitter/Orb2
#@onready var Orb3 = $Node3D/Character/Transmitter/Orb3

var orbQueue = []
var orbNameCounter = 0
var maxOrbCount = 2

func _ready() -> void:
	randomize()
	
	for i in maxOrbCount:
		addOrb('empty')

func GameOverMan() -> void:
	gameOverScreen.visible = true

	PointsLabel.Stop()
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

	PointsLabel.Start()
	
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
	if Input.is_action_pressed("press_climb"): addOrb('climb')
	if Input.is_action_pressed("press_left"): addOrb('left')
	if Input.is_action_pressed("press_duck"): addOrb('duck')
	if Input.is_action_pressed("press_jump"): addOrb('jump')
	if Input.is_action_pressed("press_right"): addOrb('right')
	
	if Input.is_action_pressed("enter_pressed"): GameStart()
	if Input.is_action_pressed("space_pressed"): GameStart()

func addOrb(type) -> void:
	if type != 'empty':
		pressDelay = 0
	
	Orb2.mesh.material.albedo_color = Orb1.mesh.material.albedo_color
	
	if type == 'left':
		Orb1.mesh.material.albedo_color = '#ff8bff'
	elif type == 'duck':
		Orb1.mesh.material.albedo_color = '#ffff00'
	elif type == 'jump':
		Orb1.mesh.material.albedo_color = '#618bff'
	elif type == 'right':
		Orb1.mesh.material.albedo_color = '#61ff4e'
	elif type == 'punch':
		Orb1.mesh.material.albedo_color = '#ff004e'
	elif type == 'empty':
		Orb1.mesh.material.albedo_color = '#000'
	else:
		return
		
	orbNameCounter += 1
	orbQueue.push_back('%s %d' % [type, orbNameCounter])

	if type != 'empty': popOrb()

func popOrb() -> void:
	if orbQueue.size() > 0:
		var orb = orbQueue.pop_front()
		if orb:
			Character.HandleAction(orb)
		
func _on_empty_orb_timer_timeout() -> void: 
	addOrb('empty')
func _on_pop_orb_timer_timeout() -> void: 
	popOrb()
func _on_restart_button_up() -> void: 
	GameStart()
func _on_start_button_up() -> void: 
	GameStart()
