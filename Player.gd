extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 200
var attackSpeed = 2
var attackDelay = 1/attackSpeed
var attackRange = 20
var attackArea = 1
var moving = false
var attacking = false
var attackReady = true
export var direction : Vector2
var lastDirection : Vector2
var rotate = 0

#debug
export var Vx = 0
export var Vy = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite_Effects/SlashArea.damage = 10
	$AnimatedSprite_Effects/SlashArea.knockback = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ATTACK
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if attackReady:
			attacking = true
	
	if direction == Vector2(0,0):
		moving = false
	else:
		moving = true
	
	# ANIMATION
	if attacking:
		attacking = false
		attackReady = false
		#$AnimatedSprite.play("Attack")
		#$AnimatedSprite.speed_scale = 2*attackSpeed
		$AnimatedSprite_Effects.visible = true
		$AnimatedSprite_Effects.play("Slash")
		$AnimatedSprite_Effects.scale.x = attackArea
		$AnimatedSprite_Effects.scale.y = attackArea
		$AnimatedSprite_Effects/SlashArea/AttackCollisionShape2D.set_deferred("disabled", false)
		$AttackSound.play()
		
		direction = lastDirection
		if direction == Vector2(0,-1):
			#N
			rotate = 0
			$AnimatedSprite_Effects.position.x = 0
			$AnimatedSprite_Effects.position.y = -attackRange
		elif direction == Vector2(0,1):
			#S
			rotate = 180			
			$AnimatedSprite_Effects.position.x = 0
			$AnimatedSprite_Effects.position.y = attackRange
		elif direction == Vector2(-1,0):
			#W
			rotate = 270			
			$AnimatedSprite_Effects.position.x = -attackRange
			$AnimatedSprite_Effects.position.y = 0
		elif direction == Vector2(1,0):
			#E
			rotate = 90			
			$AnimatedSprite_Effects.position.x = attackRange
			$AnimatedSprite_Effects.position.y = 0
		elif direction == Vector2(-1,-1):
			#NW
			rotate = 315			
			$AnimatedSprite_Effects.position.x = -sqrt(2*attackRange^2)
			$AnimatedSprite_Effects.position.y = -sqrt(2*attackRange^2)
		elif direction == Vector2(1,-1):
			#NE
			rotate = 45			
			$AnimatedSprite_Effects.position.x = sqrt(2*attackRange^2)
			$AnimatedSprite_Effects.position.y = -sqrt(2*attackRange^2)
		elif direction == Vector2(-1,1):
			#SW
			rotate = 225			
			$AnimatedSprite_Effects.position.x = -sqrt(2*attackRange^2)
			$AnimatedSprite_Effects.position.y = sqrt(2*attackRange^2)
		elif direction == Vector2(1,1):
			#SE
			rotate = 135			
			$AnimatedSprite_Effects.position.x = sqrt(2*attackRange^2)
			$AnimatedSprite_Effects.position.y = sqrt(2*attackRange^2)
		
		$AnimatedSprite_Effects.rotation_degrees = rotate
		#$SlashArea/AttackCollisionShape2D.rotation_degrees = rotate	
	elif moving:
		$AnimatedSprite.play("Moving")
		if direction.x == 1:
			$AnimatedSprite.flip_h = false
		elif direction.x == -1:
			$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("Idle")
		
func _physics_process(delta):
	# MOVEMENT
	#moving = false
	direction = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0,-1)
		#self.position.y -= speed*delta
	if Input.is_action_pressed("ui_down"):
		direction += Vector2(0,1)
		#self.position.y += speed*delta
	if Input.is_action_pressed("ui_right"):
		direction += Vector2(1,0)
		#self.position.x -= speed*delta
	if Input.is_action_pressed("ui_left"):
		direction += Vector2(-1,0)
		#self.position.x += speed*delta	
	#direction = direction.normalized()
	if direction != Vector2.ZERO:
		lastDirection = direction
	Vx = direction.x
	Vy = direction.y
	var motion = speed * direction.normalized() * delta
	move_and_collide(motion)

func _on_AnimatedSprite_animation_finished():
		pass

func _on_AnimatedSprite_Effects_animation_finished():
	$AnimatedSprite_Effects.visible = false
	$AnimatedSprite_Effects.stop()
	$AnimatedSprite_Effects/SlashArea/AttackCollisionShape2D.set_deferred("disabled", true)
	attacking = false
	$Timer.start(attackDelay)

func _on_Timer_timeout():
	attackReady = true

func _on_AttackSound_finished():
	$AttackSound.stop()


func _on_PlayerArea_area_entered(area):
	pass # Replace with function body.
