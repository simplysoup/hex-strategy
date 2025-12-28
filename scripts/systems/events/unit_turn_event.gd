# unit_turn_event.gd
class_name UnitTurnEvent
extends ScheduledEvent

var unit

func resolve(scheduler):
	scheduler.emit_signal("unit_turn_started", unit)
