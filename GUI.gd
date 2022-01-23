extends Control


# Declare member variables here. Examples:
signal BattleButton_pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_MenuPanel_BattleButton_pressed():
	emit_signal("BattleButton_pressed")
