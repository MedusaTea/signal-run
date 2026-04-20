extends Node3D

@onready var GlobalRoot = get_node('/root/Root')
@onready var rigidBody = $RigidBody3D
@onready var dude = $RigidBody3D/CollisionShape3D/Dude
@onready var collisionAudioPlayer = get_node('/root/Root/collisionAudio')
@onready var moveAudioPlayer = get_node('/root/Root/moveAudio')
@onready var gameOverNode = get_node('/root/Root/Control/GameOverScreen')

@export var jumpHeight = 5
@export var sideStopRange = 6
@export var sideHop = 4
@export var duckTimerMax = 2.0
@export var duckTimer = duckTimerMax

@export var ducking = false

var firstContactFloor = true

func _ready() -> void:
	pass

func GameStart() -> void:
	rotation = Vector3(0,0,0)
	position = Vector3(0,0,0)
	
	rigidBody.position = Vector3(0,0,0)
	rigidBody.rotation = Vector3(0,0,0)
	rigidBody.linear_velocity = Vector3(0,0,0)
	rigidBody.angular_velocity = Vector3(0,0,0)
	
	dude.StartRunning()
	
func _physics_process(delta: float) -> void:
	duckTimer -= delta
	if ducking and duckTimer < 0:
		rigidBody.position.y = 0
		rigidBody.collision_mask = 7
		rigidBody.gravity_scale = 1.0
		ducking = false
		duckTimer = duckTimerMax
		dude.StartRunning()
		
	if ducking:
		rigidBody.position.y = -1

func _on_body_entered(body: Node) -> void:
	if !body.name.contains('Floor'):
		collisionAudioPlayer.play()
		GlobalRoot.GameOverMan()
	elif !firstContactFloor: # hit the floor, start runnin
		dude.StartRunning()
	else:
		firstContactFloor = false
	print(body.name)

func tweenPosition(body, offset: Vector3) -> void:
	print('tweenPosition %v' % offset)
	var tween = get_tree().create_tween()
	tween.tween_property(body, "position", body.position + offset, 0.1)
	moveAudioPlayer.play()
	
func HandleAction(orbName) -> void:
	if orbName.contains('empty'):
		return
		
	print('handle action %s', orbName)
	if orbName.contains('left'):
		if self.position.x > -sideStopRange:
			#self.position.x += -2
			tweenPosition(self, Vector3(-sideHop, 0, 0))

	elif orbName.contains('right'):
		if self.position.x < sideStopRange:
			#self.position.x += 2
			tweenPosition(self, Vector3(sideHop, 0, 0))

	elif orbName.contains('jump') and !ducking and abs(rigidBody.position.y) < 1.5:
		tweenPosition(rigidBody, Vector3(0, jumpHeight, 0))
		dude.Jump()
	
	elif orbName.contains('duck') and !ducking and abs(rigidBody.position.y) < 1.5:
		rigidBody.collision_mask = 3
		rigidBody.gravity_scale = 0.0
		ducking = true
		
		dude.Roll()
		tweenPosition(rigidBody, Vector3(0, -1, 0))
	
	elif orbName.contains('swim'):
		pass
	elif orbName.contains('climb'):
		pass	
	elif orbName.contains('punch'):
		pass
	elif orbName.contains('kick'):
		pass
