# res://systems/scheduler.gd
extends Node
class_name Scheduler

var current_time := 0.0
var queue: Array[ScheduledEvent] = []

signal unit_turn_started(unit)

func schedule(event: ScheduledEvent):
	queue.append(event)
	queue.sort_custom(func(a, b):
		return a.execute_time < b.execute_time
	)

func run_next():
	if queue.is_empty():
		return

	var event = queue.pop_front()
	current_time = event.execute_time
	event.resolve(self)
	
func interrupt(unit, action):
	for event in queue:
		if event.source == unit or event.unit == unit:
			queue.erase(event)
		unit.last_action_time = current_time + action.target_interrupt_time
		unit.schedule_next_turn(self)
	
		
