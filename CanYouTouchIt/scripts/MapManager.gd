extends Node2D

var ID_to_give
var List_Cubes = []
var Screen_size = Vector2()
var start_X = 10
var start_Y = 40
var Cube_Height = 70
var List_Pos_X = []
var Waves = 1

func _ready():
	Connect_WaveFinish_with_Player()
	Add_Cubes_First_Row()

func CubeGenerator(pos_X, pos_Y):
	var INVADER = preload("res://scenes/Cubes.tscn")
	var CubePosition = Vector2(pos_X, pos_Y)
	var SpawnIt = INVADER.instance()
	List_Cubes.append(SpawnIt)
	ID_to_give = SpawnIt.get_instance_id()
	SpawnIt.position = CubePosition
	add_child(SpawnIt)

func Remove_Destroyed_Cube2List(ID):
	for item in List_Cubes:
		if item.get_instance_id() + 1 == ID:
			List_Cubes.erase(item)
	
func Connect_WaveFinish_with_Player():
	$Player.connect("WaveFinish", self, "WaveFinish_received")
	
func WaveFinish_received():
	var You_Lose = false
	for item in List_Cubes:
		var Item_pos = item.get_position()
		if Item_pos.y > 350:
			You_Lose = true
			break
	if You_Lose == true:
		$Lose_message.visible = true
	else:
		for item in List_Cubes:
			var Item_pos = item.get_position()
			var y = Item_pos.y + Cube_Height
			item.position = Vector2(Item_pos.x, y)
		Waves += 1
		$Wave.text = "Wave: " + str(Waves)
		Add_Cubes_First_Row()

func Add_Cubes_First_Row():
	List_Pos_X.clear()
	var stop = false
	for i in range(5):
		List_Pos_X.sort()
		var position_X = randi() % 10
		position_X *=  Cube_Height
		position_X += start_X
		for j in List_Pos_X:
			if j == position_X:
				stop = true
				break
		
		if stop == false:
			List_Pos_X.append(position_X)
			CubeGenerator(position_X, start_Y)
		else:
			stop = false