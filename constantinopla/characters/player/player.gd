extends CharacterBody2D
@onready var time_bar=$timer/Icon
@onready var time_value=$timer/Timer

var jump_speed=1000
var speed=200
var can_dash=true
var direction=1
var dashing=false
var sicking=false
var sickjump=false
var coyote_time=true

func _physics_process(delta: float) -> void:
	if GameManager.is_dialogue_active:
		return
	jump(delta)
	move()
	dash()
	sick()
	timer()
	move_and_slide()

	
func jump(delta):
	if (is_on_floor() or coyote_time) and Input.is_action_just_pressed("jump"):
		velocity.y=move_toward(velocity.y,-jump_speed,jump_speed/3)
	if Input.is_action_just_released("jump") and velocity.y<0:
		velocity.y=0
	
	if not is_on_floor() and not dashing:
		velocity.y+=GlobalValues.gravity*delta
		coyote_timer()
	else:
		can_dash=true
		coyote_time=true
		
	if sicking and Input.is_action_just_pressed("jump"):
		velocity.y=move_toward(velocity.y,-jump_speed,jump_speed/3)
		velocity.x=move_toward(velocity.y,-jump_speed/2,jump_speed/3)
		sickjump=true

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
		
func sick():
	if is_on_wall_only() and not sickjump:
		velocity.y=GlobalValues.gravity/40
		sicking=true
	else:
		sicking=false
		sickjump=false
		
func dash_timer():
	await get_tree().create_timer(0.1).timeout
	dashing=false
	if is_on_floor():
		velocity.x=0
	else:
		velocity.x=speed/5
		
func coyote_timer():
	await get_tree().create_timer(0.1).timeout
	coyote_time=false

func timer():
	pass
	
