# action_event.gd
class_name ActionEvent
extends ScheduledEvent

var source
var target
var action

func resolve(scheduler):
	if source.is_alive():
		action.apply(source, target)
