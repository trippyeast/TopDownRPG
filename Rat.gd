extends KinematicBody2D

export var speed = 50
export var weight = 5
export var attackRange = 40
export var health = 20
export var hitDelay = 0.2
export var attackDelay = 0.5
var direction : Vector2
var impulse : Vector2
var distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	getPath()
	$HitDelayTimer.wait_time = hitDelay
	#pass
	
func init(speed):
	self.speed += speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var playerPosition = get_parent().Player.position
	if health <= 0:
		Death()
		return
		
	getPath()
	if distance > attackRange:
		$AnimatedSprite.play("Move")
		if direction.normalized().x < 0:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("Attack")
	

func _physics_process(delta):
	if distance > attackRange:
		var motion = speed * direction.normalized()
		move_and_slide(motion + impulse)
		impulse = impulse/(weight)
		if impulse.length() < 0.1:
			impulse = Vector2.ZERO
	elif distance <= attackRange:
		Attack()

func getPath():
	var playerPosition = get_parent().Player.position
	var dx = (playerPosition.x - self.position.x) as float
	var dy = (playerPosition.y - self.position.y) as float
	
	distance = sqrt(pow(dx,2)+pow(dy,2))
	direction = Vector2(dx,dy)
	
func Hit(damage, knockback):
	health -= damage
	if knockback >= weight:
		self.impulse = -1 * direction.normalized() * 100 * knockback
	$AnimatedSprite.modulate = Color(10,10,10,10)
	$HitDelayTimer.start()

func Attack():
	pass
	
func Death():
	direction = Vector2.ZERO
	$AnimatedSprite.play("Death")

func _on_Area2D_area_entered(area):
	if "areaType" in area:
		if area.areaType == "attackArea":
			if $HitDelayTimer.is_stopped():
				Hit(area.damage,area.knockback)
			
func _on_HitDelayTimer_timeout():
	$AnimatedSprite.modulate = Color(1,1,1,1)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Death":
		queue_free()
