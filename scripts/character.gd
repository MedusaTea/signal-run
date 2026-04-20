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

@export var duckTimerMax = 3
@export var isPunchingTimerMax = 3

@export var duckTimer = duckTimerMax
@export var isPunchingTimer = isPunchingTimerMax

@export var ducking = false
@export var isPunching = false

var firstContactFloor = true

func _ready() -> void:
	animPlayer.speed_scale = 1.25

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
	
func _physics_process(delta: float) -> void:
	duckTimer -= delta
	isPunchingTimer -= delta
	if ducking and duckTimer < 0:
		print('is duck turned off')
		rigidBody.position.y = 0
		rigidBody.collision_mask = 7
		rigidBody.gravity_scale = 1.0
		ducking = false
		duckTimer = duckTimerMax
		
	if ducking:
		rigidBody.position.y = -1
		
	if isPunching and isPunchingTimer < 0:
		print('is punching turned off')
		isPunching = false
		isPunchingTimer = isPunchingTimerMax

func _on_body_entered(body: Node) -> void:
	print(body.name)
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
	elif !firstContactFloor: # hit the floor, start runnin
		StartRunning()
	else:
		firstContactFloor = false

func tweenPosition(body, offset: Vector3) -> void:
	print('tweenPosition %v' % offset)
	var tween = get_tree().create_tween()
	tween.tween_property(body, "position", body.position + offset, 0.1)
	moveAudioPlayer.play()
	
func HandleAction(orbName) -> void:
	if orbName.contains('empty'):
		return
		
	if orbName.contains('left'):
		if self.position.x > -sideStopRange:
			#self.position.x += -2
			tweenPosition(self, Vector3(-sideHop, 0, 0))

	elif orbName.contains('right'):
		if self.position.x < sideStopRange:
			#self.position.x += 2
			tweenPosition(self, Vector3(sideHop, 0, 0))

	elif orbName.contains('jump') and !ducking and abs(rigidBody.position.y) < 1.5:
		Jump()
		await get_tree().create_timer(0.1).timeout
		tweenPosition(rigidBody, Vector3(0, jumpHeight, 0))
	
	elif orbName.contains('punch'):
		isPunching = true
		isPunchingTimer = isPunchingTimerMax
		print('is punching turned on')
		Punch()
	
	elif orbName.contains('duck') and abs(rigidBody.position.y) < 1.5:
		rigidBody.collision_mask = 3
		rigidBody.gravity_scale = 0.0
		ducking = true
		duckTimer = duckTimerMax
		
		Roll()
		tweenPosition(rigidBody, Vector3(0, -1, 0))
	
	elif orbName.contains('swim'):
		pass
	elif orbName.contains('climb'):
		pass	
	elif orbName.contains('kick'):
		pass

func StartRunning() -> void:
	animPlayer.play('Sprint')
	
func Punch() -> void:
	animPlayer.animation_set_next('Punch_Cross', 'Sprint')
	animPlayer.play( 'Punch_Cross')
	
func Roll() -> void:
	animPlayer.play('Roll')
	await get_tree().create_timer(0.9).timeout
	animPlayer.play('Sprint')

func Jump() -> void:
	animPlayer.animation_set_next('Jump_Start', 'Jump')
	animPlayer.play('Jump_Start')

func Swim() -> void:
	animPlayer.play('Swim')

func SwimIdle() -> void:
	animPlayer.play('Swim_Idle')
