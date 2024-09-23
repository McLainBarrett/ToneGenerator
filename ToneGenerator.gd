extends AudioStreamPlayer

#var frequency = 440

@onready var player = $"."
var playback : AudioStreamGeneratorPlayback
@onready var sample_hz = player.stream.mix_rate
var pulse_hz = 440.0

var pleasePlay = false

func _ready():
	player.play()
	playback = player.get_stream_playback()

func _process(_delta : float):
	if pleasePlay:
		fill_buffer()

var phase = 0.0
func fill_buffer():
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()
	
	for i in range(frames_available):
		playback.push_frame(Vector2.ONE * sin(phase * TAU))
		phase = fmod(phase + increment, 1.0)

func setTone(frequency : int):
	pulse_hz = frequency

func togglePlay():
	pleasePlay = not pleasePlay
