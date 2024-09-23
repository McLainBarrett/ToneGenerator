extends Control

@onready var generators = $Panel/MarginContainer/ScrollContainer/VBoxContainer/Generators
var generatorTemplate = load("res://SignalGenerator.tscn")

func newGenerator():
	if generators.get_children().size() < 10:
		var generator = generatorTemplate.instantiate()
		generators.add_child(generator)

func toggleGenerators():
	var gens = generators.get_children()
	#Check if every single generator is disabled
	var allDisabled := true
	for g in gens:
		if g.Enabled:
			allDisabled = false
			break
	
	#if not, disable every generator, else enable every generator
	for g in gens:
		g.Enable(allDisabled)



@onready var player = $AudioStreamPlayer
var playback : AudioStreamGeneratorPlayback
@onready var sample_hz = player.stream.mix_rate

func _ready():
	player.play()
	playback = player.get_stream_playback()

func _process(_delta : float):
	getSignals()
	fill_buffer()
	if Input.is_key_pressed(KEY_K):
		for s in signals:
			s[1] = 0

var signals = []#freq, phase, volume, offset, increment
func getSignals():
	for i in range(generators.get_child_count()):
		var gen = generators.get_child(i)
		if signals.size() > i:
			signals[i] = [gen.Frequency, signals[i][1], gen.Volume, gen.Phase, gen.Frequency / sample_hz]
		else:
			signals.append([gen.Frequency, 0, gen.Volume, gen.Phase, gen.Frequency / sample_hz])
	signals.resize(generators.get_child_count())

func fill_buffer():
	var frames_available := playback.get_frames_available()
	
	for i in range(frames_available):
		var frameValue = 0
		for s in signals:
			frameValue += sin((s[1] + s[3]/360.0) * TAU) * s[2] / 100.0
			s[1] = fmod(s[1] + s[4], 1.0)
		var masterVol = $Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/HSlider.value / 100.0
		playback.push_frame(Vector2.ONE * frameValue * masterVol)
