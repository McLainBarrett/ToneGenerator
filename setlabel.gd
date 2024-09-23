extends Label

@export var format = "%s"
@export var defaultValue = 0

func setText(value):
	$".".text = format % value
