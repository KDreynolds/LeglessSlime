extends Node2D

onready var arrow = $Arrow
var character_node = null
const OFFSET_DISTANCE = 40
var gravity = 1200
var velocity = Vector2()
var min_jump_strength = -300
var max_jump_strength = -1000
var jump_charge_speed = -1500



func _ready():
	var _error = get_node("../../../KinematicBody2D").connect("character_ready", self, "_on_character_ready")

func _on_character_ready(node):
	character_node = node

func _process(_delta):
	if not character_node:
		return

	var camera = get_tree().get_nodes_in_group("main_camera")[0]
	var screen_center = camera.get_camera_screen_center()
	var mouse_position = screen_center + (get_viewport().get_mouse_position() - get_viewport().size / 2)
	var global_character_position = character_node.global_position + Vector2(0, 5)

	arrow.global_position = global_character_position
	arrow.look_at(mouse_position)
	arrow.rotation += PI

	var direction = (mouse_position - global_character_position).normalized()
	arrow.global_position += direction * OFFSET_DISTANCE

	if Input.is_action_pressed("jump"):
		arrow.show()
	else:
		arrow.hide()

		
func _on_character_update_animation(jump_charge):
	# Normalize the jump_charge value to a range between 0 and 1
	var normalized_charge = (jump_charge - min_jump_strength) / (max_jump_strength - min_jump_strength)
	
	# Calculate the target frame of the animation based on the normalized value
	var frame_count = $Arrow.frames.get_frame_count("charge")
	var target_frame = int(normalized_charge * (frame_count - 1))
	
	# Set the current frame of the animation to the target frame
	$Arrow.frame = target_frame

func get_adjusted_mouse_position():
	var camera = get_tree().get_nodes_in_group("main_camera")[0]
	var camera_offset = camera.global_position - camera.global_position.floor()
	return get_viewport().get_mouse_position() + camera_offset


