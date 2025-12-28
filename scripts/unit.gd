# res://scripts/unit.gd
extends Node2D
class_name Unit

@export var tile_pos: Vector3i
@export var allegiance := Enums.Allegiance.NEUTRAL
@export var movement_speed: float = 3.0
@export var base_delay: float = 1.0
@export var max_health: int = 5
@export var max_stamina: int = 5
@export var max_mana: int = 5

var last_action_time: float = 0.0
var allegiance_name: String = "Neutral"
var skills = []
var current_health: int
var current_stamina: int
var current_mana: int

func schedule_next_turn(scheduler):
	var e := UnitTurnEvent.new()
	e.unit = self
	e.execute_time = last_action_time + base_delay
	scheduler.schedule(e)

func end_turn(scheduler):
	last_action_time = scheduler.current_time
	schedule_next_turn(scheduler)
	scheduler.run_next()

func _ready():
	update_allegiance()
	current_health = max_health
	current_stamina = max_stamina
	current_mana = max_mana
	
func is_alive():
	return current_health > 0

func update_allegiance():
	match allegiance:
		Enums.Allegiance.PLAYER:
			modulate = Color.DODGER_BLUE
			allegiance_name = "Player"
		Enums.Allegiance.ENEMY:
			modulate = Color.RED
			allegiance_name = "Enemy"
		Enums.Allegiance.FRIENDLY:
			modulate = Color.GREEN
			allegiance_name = "Friendly"
		Enums.Allegiance.NEUTRAL:
			modulate = Color.GRAY
			allegiance_name = "Neutral"
