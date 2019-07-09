extends Area2D

const SPEED = 10
var velocity = Vector2()
var direction = 1

func _ready():
	pass # Replace with function body.

func set_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func on_body_entered(body):
		if "enemy" in body.name:
			body.dead()

func _on_Timer_timeout():
	queue_free()
