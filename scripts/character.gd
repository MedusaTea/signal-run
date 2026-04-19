extends Node3D

@onready var GlobalRoot = get_node('/root/Root')
@onready var rigidBody = $RigidBody3D
@onready var collisionAudioPlayer = get_node('/root/Root/collisionAudio')
@onready var moveAudioPlayer = get_node('/root/Root/moveAudio')
@onready var gameOverNode = get_node('/root/Root/Control/GameOverScreen')

@export var sideStopRange = 6

@export var duckTimerMax = 2.0
@export var duckTimer = duckTimerMax

@export var ducking = false

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	duckTimer -= delta
	if ducking and duckTimer < 0:
		rigidBody.position.y = 0
		rigidBody.collision_mask = 7
		rigidBody.gravity_scale = 1.0
		ducking = false
		duckTimer = duckTimerMax
		
	if ducking:
		rigidBody.position.y = -1

func _on_body_entered(body: Node) -> void:
	if !body.name.contains('Floor'):
		collisionAudioPlayer.play()
		GlobalRoot.GameOverMan()
		
	print(body.name)

func tweenPosition(newPosition: Vector3) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(rigidBody, "position", newPosition, 0.1)
	moveAudioPlayer.play()
	
func handleAction(name) -> void:
	if name.contains('left'):
		if rigidBody.position.x > -sideStopRange:
			tweenPosition(rigidBody.position - Vector3(2, 0, 0))

	elif name.contains('right'):
		if rigidBody.position.x < sideStopRange:
			tweenPosition(rigidBody.position + Vector3(2, 0, 0))

	elif name.contains('jump') and !ducking and abs(rigidBody.position.y) < 1.5:
		tweenPosition(rigidBody.position + Vector3(0, 4, 0))
	
	elif name.contains('duck') and !ducking and abs(rigidBody.position.y) < 1.5:
		rigidBody.collision_mask = 3
		rigidBody.gravity_scale = 0.0
		ducking = true
		
		var newPosition = rigidBody.position 
		newPosition.y = -1 
		tweenPosition(newPosition)
	
	elif name.contains('swim'):
		pass
	elif name.contains('climb'):
		pass	
	elif name.contains('punch'):
		pass
	elif name.contains('kick'):
		pass
