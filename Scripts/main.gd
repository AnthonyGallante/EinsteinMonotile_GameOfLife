@tool
extends Node2D

@export_file_path("*.json") var tilePlacements: String = "res://TilePlacements/tile_pose_generation_3.json"

@onready var tile_manager: Node2D = $TileManager

const COLOR_DEAD      := Color("#222323")
const COLOR_ALIVE     := Color("#5a9e6f")
const COLOR_OUTLINE   := Color("#f0f6f0")
const COLOR_HOVER     := Color("e8c547f2")
const SPAWN_PER_FRAME := 80  # Tune this to balance load time vs. frame rate
const TILE             = preload("uid://d4b6fpj3r6i6a")

var tiles = []
var _load_thread := Thread.new()
var _spawn_index := 0


func _ready() -> void:
	_load_thread.start(_load_tiles_threaded)
	PlayState.is_playing = false


func _process(_delta: float) -> void:
	var end := mini(_spawn_index + SPAWN_PER_FRAME, tiles.size())
	for i in range(_spawn_index, end):
		_spawn_tile(tiles[i])
	_spawn_index = end
	if _spawn_index >= tiles.size():
		set_process(false)


func _load_tiles_threaded() -> void:
	var file = FileAccess.open(tilePlacements, FileAccess.READ)
	if not file:
		push_error("Could not open tilePlacements.json")
		return
	var json = JSON.new()
	var err  = json.parse(file.get_as_text())
	file.close()
	if err != OK:
		push_error("JSON parse error")
		return
	tiles = json.get_data()["tiles"]
	call_deferred("_begin_spawning")


func _begin_spawning() -> void:
	_load_thread.wait_to_finish()
	set_process(true)


func _spawn_tile(tile: Dictionary) -> void:
	var new_tile = TILE.instantiate()
	new_tile.position = Vector2(tile["center_pixel"]["x"], tile["center_pixel"]["y"])
	new_tile.scale.x = -0.5
	if tile["chirality"] == -1:
		new_tile.scale.y = -0.5
		new_tile.rotation_degrees = (-tile["rotation_degrees"] * tile["chirality"]) - 30
	else:
		new_tile.rotation_degrees = (-tile["rotation_degrees"] * tile["chirality"]) + 30
	tile_manager.add_child(new_tile)
	
	if not Engine.is_editor_hint():
		tile_manager.register(new_tile.get_node("tileControllerArea"))
