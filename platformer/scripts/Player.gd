extends KinematicBody2D

#make it so it recognizes floors instead of walls
const UP = Vector2(0, -1)

#normal variables
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -500
const CHOP = preload("res://scenes/attack.tscn")
var is_dead = false
var ON_GROUND

#variable to hold inputs for moving
var motion = Vector2()

func dead():
	is_dead = true
	motion = Vector2(0,0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.call_deferred("set_disabled", true)
	queue_free()
	$Timer.start()

func _physics_process(delta):
	#gravity
	motion.y += GRAVITY
	var friction = false
	
	#move right
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = false
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED) #caps out at max speed
		$AnimatedSprite.play("walk")
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		
	#move left
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite.flip_h = true
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$AnimatedSprite.play("walk")
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		
	#don't move if nothing pressed
	elif Input.is_action_just_pressed("ui_accept"):
		$AnimatedSprite.play("attack")
		var attack = CHOP.instance()
#		if sign($Position2D.position.x) == 1:
#			var k = attack.set_direction(1)
#		else:
#			var k = attack.set_direction(-1)
		get_parent().add_child(attack)
		attack.position = $Position2D.global_position
		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().get_name() == "enemy":
			$RayCast2D.get_collider().dead()
			
			
			
	else:
		friction = true
		if $AnimatedSprite.is_playing():
			print('isplaying')
		else:
			$AnimatedSprite.play("idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2) #friction 20%
		ON_GROUND = true

	else:
		if motion.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
			
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.5) #friction 20%
		ON_GROUND = false

	#sets motion to zero when collides with floor, so gravity doesn't increase
	motion = move_and_slide(motion, UP)

func _on_Timer_timeout():
	get_tree().reload_current_scene()

	pass
	