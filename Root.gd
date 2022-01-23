extends Node

onready var DISPLAY = get_viewport().size
# Declare member variables here. Examples:
onready var Player = $Player
onready var PlayerCamera = $Player/Camera2D
onready var Map = $TileMap
onready var attackTimer = $Player/Timer
onready var debugText = $CanvasLayer/GUI/Label
#
#
onready var Rat = preload("res://Rat.tscn")
var Mobs = []
var mobCount = 0
var maxMobCount = 50
var mobSpawnCD = 1
var mobSpawnReady = true
#
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	setPlayerCamera()
	
	#$CanvasLayer/GUI/VBoxContainer/MenuPanel.connect("battle_button",self,"startBattle")
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setDebugText()
	
	if mobSpawnReady:
		Spawn()
	
### Methods
func setPlayerCamera():
	var mapLimits = Map.get_used_rect()
	var cellSize = Map.cell_size.x
	PlayerCamera.limit_left = mapLimits.position.x * cellSize
	PlayerCamera.limit_top	= mapLimits.position.y * cellSize
	PlayerCamera.limit_right = mapLimits.end.x * cellSize
	PlayerCamera.limit_bottom = mapLimits.end.y * cellSize

func setDebugText():
	debugText.text = str(attackTimer.time_left)
	#debugText.text += "\n" + $Player.direction
	debugText.text += "\nPosition: <" + str($Player.position.x) + "," + str($Player.position.y) + ">"
	debugText.text += "\nMotion: <" + str($Player.Vx) + "," + str($Player.Vy) + ">"
	debugText.text += "\nDirection: <" + str($Player.lastDirection.x) + "," + str($Player.lastDirection.y) + ">"

func Spawn():
	mobCount = Mobs.size()
	if mobCount < maxMobCount:
		var newMob = Rat.instance()
		rng.randomize()
		newMob.position.x = rng.randi_range(Player.position.x - DISPLAY.x/2, Player.position.x + DISPLAY.x/2)
		newMob.position.y = rng.randi_range(Player.position.y - DISPLAY.y/2, Player.position.y + DISPLAY.y/2)
		var speed = rng.randi_range(-20,20)
		#newMob.init(speed)
		
		add_child(newMob)
		Mobs.append(newMob)
		$MobTimer.start(mobSpawnCD)
		mobSpawnReady = false

### Signals
func _on_GUI_BattleButton_pressed():
	pass


func _on_MobTimer_timeout():
	mobSpawnReady = true
