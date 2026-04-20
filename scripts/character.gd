extends Node3D

@onready var GlobalRoot = get_node('/root/Root')
@onready var rigidBody = $RigidBody3D
@onready var dude = $RigidBody3D/CollisionShape3D/Dude
@onready var collisionAudioPlayer = get_node('/root/Root/collisionAudio')
@onready var moveAudioPlayer = get_node('/root/Root/moveAudio')
@onready var gameOverNode = get_node('/root/Root/Control/GameOverScreen')

@onready var animPlayer: AnimationPlayer = $RigidBody3D/CollisionShape3D/Dude/AnimationPlayer

@export var jumpHeight = 3
@export var sideStopRange = 6
@export var sideHop = 6

@export var duckTimerMax = 0.7
@export var isPunchingTimerMax = 0.7

@export var duckTimer = duckTimerMax
@export var isPunchingTimer = isPunchingTimerMax

@export var ducking = false
@export var isPunching = false

var firstContactFloor = true

func _ready() -> void:
	animPlayer.speed_scale = 1.5

func GameStart() -> void:
	$CrashParticles.emitting = false
	$RigidBody3D.visible = true
	rotation = Vector3(0,0,0)
	position = Vector3(0,0,0)
	
	rigidBody.position = Vector3(0,0,0)
	rigidBody.rotation = Vector3(0,0,0)
	rigidBody.linear_velocity = Vector3(0,0,0)
	rigidBody.angular_velocity = Vector3(0,0,0)
	
	StartRunning()
	
func endPunching() -> void:
	print('is punching turned off')
	isPunching = false
	isPunchingTimer = isPunchingTimerMax
	
func endDucking() -> void:
	print('is duck turned off')
	rigidBody.position.y = 0
	rigidBody.collision_mask = 7
	rigidBody.gravity_scale = 1.0
	ducking = false
	duckTimer = duckTimerMax

func _physics_process(delta: float) -> void:
	duckTimer -= delta
	isPunchingTimer -= delta
	
	if ducking:
		rigidBody.position.y = -1

	if ducking and duckTimer < 0:
		endDucking()

	if isPunching and isPunchingTimer < 0:
		endPunching()

func _on_body_entered(body: Node) -> void:
	if !body.name.contains('Floor'):
		if body.name.contains('Breakable') and isPunching:
			body.get_node('CollisionShape3D').visible = false
			body.get_node('CrashParticles').visible = true
			await get_tree().create_timer(0.5).timeout
			if body:
				body.queue_free()
		else:
			collisionAudioPlayer.play()
			$RigidBody3D.visible = false
			$CrashParticles.emitting = true
			GlobalRoot.GameOverMan()
	else:
		firstContactFloor = false

func tweenPosition(body, offset: Vector3) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(body, "position", body.position + offset, 0.1)
	moveAudioPlayer.play()
	
func HandleAction(orbName) -> void:
	if orbName.contains('empty'):
		return
		
	if orbName.contains('left'):
		if self.position.x > -sideStopRange:
			tweenPosition(self, Vector3(-sideHop, 0, 0))

	elif orbName.contains('right'):
		if self.position.x < sideStopRange:
			tweenPosition(self, Vector3(sideHop, 0, 0))

	elif !isPunching and !ducking:
		if abs(rigidBody.position.y) < 0.5:
			if orbName.contains('jump'):
				endDucking()
				Jump()
				tweenPosition(rigidBody, Vector3(0, jumpHeight, 0))
			
			elif orbName.contains('duck'):
				ducking = true
				rigidBody.collision_mask = 3
				rigidBody.gravity_scale = 0.0
				duckTimer = duckTimerMax
				Roll()
				tweenPosition(rigidBody, Vector3(0, -1, 0))
				
			elif orbName.contains('punch'):
				isPunching = true
				isPunchingTimer = isPunchingTimerMax
				Punch()
		
			elif orbName.contains('swim'):
				pass
				
			elif orbName.contains('climb'):
				pass	

func StartRunning() -> void:
	animPlayer.play('Sprint')
	
func Punch() -> void:
	animPlayer.animation_set_next('Punch_Cross', 'Sprint')
	animPlayer.play( 'Punch_Cross')
	
func Roll() -> void:
	animPlayer.play('Roll')
	# roll animation goes a little too long 
	# so hack in a play animation to cut it short
	await get_tree().create_timer(0.7).timeout
	animPlayer.play('Sprint')

func Jump() -> void:
	#animPlayer.animation_set_next('Jump_Start', 'Jump')
	animPlayer.play('Jump')
	await get_tree().create_timer(0.8).timeout
	animPlayer.play('Sprint')

func Swim() -> void:
	animPlayer.play('Swim')

func SwimIdle() -> void:
	animPlayer.play('Swim_Idle')
