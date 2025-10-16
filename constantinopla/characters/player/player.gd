extends CharacterBody2D
@onready var time_bar=$timer/Icon
@onready var death_timer=$timer/Timer

var jump_speed=1000
var speed=200
var can_dash=true
var direction=1
var dashing=false
var sicking=false
var sickjump=false
var coyote_time=true



func _physics_process(delta: float) -> void:
	if GlobalValues.is_dialogue_active:
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
		velocity.y=move_toward(velocity.y,-jump_speed*2,jump_speed/3)
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
	time_bar.scale.x=(death_timer.time_left)/45
	if death_timer.time_left==0:
		get_tree().reload_current_scene()
	
func inmunity():
	pass

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(3):
		var time=death_timer.time_left
		death_timer.stop()
		if time-10<=0:
			get_tree().reload_current_scene()
		death_timer.start(time-10)
		
		var enemy=area.get_parent()
		velocity.x=sign(enemy.position.x-position.x)*-jump_speed/2
		velocity.y=sign(enemy.position.y-position.y)*jump_speed/4


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(4):
		get_tree().reload_current_scene()
