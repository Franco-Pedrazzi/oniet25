extends CharacterBody2D
var jump_speed=1000
var speed=200
var can_dash=true
var direction=1
var dashing=false
var sicking=false

func _physics_process(delta: float) -> void:
	jump(delta)
	move()
	dash()
	sick()
	move_and_slide()

	
func jump(delta):
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y=move_toward(velocity.y,-jump_speed,jump_speed/3)
	if Input.is_action_just_released("jump") and velocity.y<0:
		velocity.y=0
	
	if not is_on_floor() and not dashing:
		velocity.y+=GlobalValues.gravity*delta
	else:
		can_dash=true
	if sicking and Input.is_action_just_pressed("jump"):
		velocity.y=move_toward(velocity.y,-jump_speed,jump_speed/3)
		velocity.x=move_toward(velocity.y,-jump_speed/3,jump_speed/3)
		sicking=false
func move():
	var get_axis= Input.get_axis("left","right")
	if get_axis:
		velocity.x=move_toward(velocity.x,speed*get_axis,speed/5)
		direction=get_axis
	elif not dashing:
		velocity.x=move_toward(velocity.x,0,speed/5)

func dash():
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing=true
		dash_timer()
		if sicking:
			direction*=-1
	
	if dashing:
		velocity.x=move_toward(velocity.x,speed*6*direction,speed)
		
func dash_timer():
	await get_tree().create_timer(0.1).timeout
	dashing=false
	if is_on_floor():
		velocity.x=0
	else:
		velocity.x=speed/5
	
func sick():
	if is_on_wall_only():
		velocity.y=GlobalValues.gravity/40
		sicking=true
	else:
		sicking=false
		
		
