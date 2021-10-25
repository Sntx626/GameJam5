extends AnimatedSprite

var toCampfire = false
var t = Timer.new()


func goToCampfire():
	toCampfire = true
	
	t.set_one_shot(true)
	self.add_child(t)
	play("standUp")
	t.start(1.25)
	yield(t, "timeout")
	t.set_wait_time(0.25)
	play("walkingSide")
	for _i in range(195):
		translate(Vector2(-1.5, 0))
		t.start()
		yield(t, "timeout")
	play("walkingBack")
	for _i in range(15):
		translate(Vector2(0, -1.5))
		t.start()
		yield(t, "timeout")
	flip_h = false
	play("sitDown")
	t.start(1.25)
	yield(t, "timeout")
	play("playing")
