extends KinematicBody2D

signal character_ready
signal moved_out_of_screen

var gravity = 1200
export var velocity = Vector2()
var min_jump_strength = -300
var max_jump_strength = -1000
var jump_charge_speed = -1500
var jump_charge = 0
var ground_friction = 25.0
signal update_animation(value)
var time_scale_normal = 1.0
var time_scale_slow = 0.5  # Adjust this value to control the slow-down effect


onready var camera = get_tree().get_nodes_in_group("main_camera")[0]

func _ready():
	emit_signal("character_ready", self)
	var _error2 = connect("update_animation", $AnimatedSprite/LineDrawer, "_on_character_update_animation")
	

func get_jump_charge():
	return jump_charge

func _physics_process(delta):
	velocity.y += gravity * delta
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, ground_friction * delta)
	elif is_on_wall():
		velocity.x = lerp(velocity.x, 0, ground_friction * delta)

	velocity = move_and_slide(velocity, Vector2.UP)
	check_if_out_of_screen()  

	# Check if the jump button is pressed
	if Input.is_action_pressed("jump"):
		Engine.time_scale = time_scale_slow  # Slow down time
		
		# Increase jump charge while limiting it to the maximum allowed value
		jump_charge = clamp(jump_charge + jump_charge_speed * delta, max_jump_strength, min_jump_strength)
		emit_signal("update_animation", jump_charge)
	else:
		Engine.time_scale = time_scale_normal  # Return time to normal
		
		# If the jump button is released and the character is on the ground, perform the jump
		if jump_charge < min_jump_strength:
			var jump_direction = get_arrow_direction()
			if is_on_floor() or is_on_wall():
				velocity = jump_direction * abs(jump_charge)
		# Reset jump charge
		jump_charge = min_jump_strength
	
	
		
func get_arrow_direction():
	var arrow_rotation = get_node("AnimatedSprite/LineDrawer/Arrow").rotation
	return Vector2(cos(arrow_rotation), sin(arrow_rotation)) * -1

func check_if_out_of_screen():
	var viewport_size = get_viewport().size
	var viewport_rect = Rect2(camera.global_position - viewport_size / 2, viewport_size)
	var player_global_position = global_position
	if not viewport_rect.has_point(player_global_position) and player_global_position.x > camera.global_position.x + viewport_size.x:
		print("Emitting moved_out_of_screen signal")
		emit_signal("moved_out_of_screen")






