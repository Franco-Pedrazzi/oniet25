extends CharacterBody2D
var jump_speed=300
var speed=100


func _physics_process(delta: float) -> void:
	jump(delta)
	move()
	move_and_slide()
	
func jump(delta):
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y=move_toward(velocity.y,-jump_speed,jump_speed/3)
	if Input.is_action_just_released("jump") and velocity.y<0:
		velocity.y=0
	
	if not is_on_floor():
		velocity.y+=Global_values.grabity*delta

func move():
	var get_axis= Input.get_axis("left","right")
	if get_axis:
		velocity.x=move_toward(velocity.x,speed*get_axis,speed/5)
	else:
		velocity.x=move_toward(velocity.x,0,speed/5)
