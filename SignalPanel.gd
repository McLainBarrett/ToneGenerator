class_name SignalPanel
extends PanelContainer

@onready var _EnableButton = $MarginContainer/HBoxContainer/VBoxContainer/EnableButton

@onready var _FreqSlider = $MarginContainer/HBoxContainer/GridContainer/FreqSlider
@onready var _PhaseSlider = $MarginContainer/HBoxContainer/GridContainer/PhaseSlider
@onready var _VolSlider = $MarginContainer/HBoxContainer/GridContainer/VolSlider

var Enabled : bool :
	get:
		return _EnableButton.button_pressed

var Frequency : int : 
	get:
		return _FreqSlider.value

var Phase : int :
	get:
		return _PhaseSlider.value

var Volume : int :
	get:
		if _EnableButton.button_pressed:
			return _VolSlider.value
		else:
			return 0

func Enable(enabled : bool):
	_EnableButton.button_pressed = enabled

func Destroy():
	self.queue_free()
