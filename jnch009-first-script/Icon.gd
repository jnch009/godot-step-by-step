extends Sprite2D

signal change_direction
signal have_stopped

var speed = 450
var angular_speed = PI
var forward = true
var stopped = false

#Move node manually
#func _process(delta):
#	var direction = 0
#	if Input.is_action_pressed("ui_left"):
#		direction = -1
#	if Input.is_action_pressed("ui_right"):
#		direction = 1
#
#	rotation += angular_speed * direction * delta
#	var velocity = Vector2.ZERO
#	if Input.is_action_pressed("ui_up"):
#		velocity = Vector2.UP.rotated(rotation) * speed
#	if Input.is_action_pressed("ui_down"):
#		velocity = Vector2.DOWN.rotated(rotation) * speed
#	position += velocity * delta

# Move node automatically
func _process(delta):
	rotation = rotation + angular_speed * delta if forward else rotation - angular_speed * delta
	var velocity = Vector2.UP.rotated(rotation) * speed
	position = position + velocity * delta if forward else position - velocity * delta

# on_node_name_signal_name convention
func _on_button_pressed():
	set_process(not is_processing())
	stopped = true if !is_processing() else false
	have_stopped.emit()

func _ready():
	change_direction.emit()
	var timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
#	visible = not visible
	forward = not forward
	change_direction.emit()


func _on_change_direction():
	if (!stopped):
		print("You are moving ", "forward" if forward else "backward")


func _on_have_stopped():
	if (stopped):
		print("You have now stopped")
	else:
		print("You are now moving")
		change_direction.emit()
		var timer = get_node("Timer")
		timer.start()
