extends Label

@onready var GlobalRoot = get_node('/root/Root')
var fpsString
func _process(_delta: float) -> void:
	fpsString = "FPS: %d" % Engine.get_frames_per_second()
	set_text(fpsString)

	if Input.is_action_pressed("action_esc"):
		GlobalRoot.GameOverMan()
