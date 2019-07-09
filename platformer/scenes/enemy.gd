extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = -1
var is_dead = false

func _physics_process(delta):
	velocity.x = SPEED * direction
	
	if is_dead == false:
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("walk")
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		if is_on_wall():
			direction = direction * -1

		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().get_name() == "Player":
			$RayCast2D.get_collider().dead()

func on_body_entered(body):
		if "Player" in body.name:
			body.dead()

func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Timer.start()
	
func _on_Timer_timeout():
	queue_free()
