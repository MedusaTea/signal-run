extends Node3D

@export var sideStopRange = 5

@export var duckTimerMax = 2.0
@export var duckTimer = duckTimerMax

@export var ducking = false

func _physics_process(delta: float) -> void:
	duckTimer -= delta
	if ducking and duckTimer < 0:
		position.y = 0
		ducking = false
		duckTimer = duckTimerMax
		
	if ducking:
		position.y = -1
		
func _on_body_entered(body: Node) -> void:
	print(body.name)

func handleAction(name) -> void:
	if name.contains('left'):
		if position.x > -sideStopRange:
			position -= Vector3(3, 0, 0)

	elif name.contains('right'):
		if position.x < sideStopRange:
			position += Vector3(3, 0, 0)

	elif name.contains('jump'):
		if abs(position.y) < 2:
			position += Vector3(0, 4, 0)

	elif name.contains('duck') and !ducking:
		if abs(position.y) < 2:
			ducking = true
	
	elif name.contains('swim'):
		pass
	elif name.contains('climb'):
		pass	
	elif name.contains('punch'):
		pass
	elif name.contains('kick'):
		pass
