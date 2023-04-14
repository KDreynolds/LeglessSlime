extends Node2D

onready var character = $Node2D2/KinematicBody2D
onready var camera = $Camera2D
var character_scene = preload("res://Scenes/Slime.tscn")
var screen_width = 0
var move_camera = false
var transition_speed = 500
var camera_start_position = Vector2.ZERO


func _ready():
	character.connect("moved_out_of_screen", self, "_on_character_moved_out_of_screen")
	character.connect("character_ready", self, "_on_character_ready")


func _on_character_moved_out_of_screen():
	character.velocity = Vector2.ZERO
	character.set_physics_process(false)
	move_camera = true
	screen_width = camera.get_viewport_rect().size.x
	camera_start_position = camera.position


func _process(delta):
	if move_camera:
		var distance_to_move = transition_speed * delta
		if screen_width - abs(camera.position.x - camera_start_position.x) < distance_to_move:
			distance_to_move = screen_width - abs(camera.position.x - camera_start_position.x)
			move_camera = false
			character.set_physics_process(true)
			print("Camera stopped moving")

		camera.position.x += distance_to_move

		# Stop the camera from panning if it has moved 1024 pixels to the right
		if abs(camera.position.x - camera_start_position.x) >= 1024:
			camera.position.x = camera_start_position.x + 1024
			move_camera = false
			character.set_physics_process(true)
			print("Camera stopped moving at 1024 pixels")



