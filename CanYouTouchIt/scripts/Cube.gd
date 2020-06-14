extends RigidBody2D
var Life = 1
var node_Player
var node_Cube
var node_MapManager
var My_ID
signal Cube_destroyed

func _ready():
	Get_Nodes()
	if node_MapManager.Waves >= 1:
		var calcWaves = int(node_MapManager.Waves / 5)
		if calcWaves < 1:
			calcWaves = 1
		$Label.text = str(calcWaves)
	Connect_Collision_with_Player()
	Distribute_ID()
	
func hurt_signal_received():
	if node_Player.ennemy_hit_id  == My_ID:
		Life = str2var($Label.text)
		Life -= 1
		if(Life < 1):
			node_MapManager.Remove_Destroyed_Cube2List(My_ID)
			get_parent().remove_child(self) 
			queue_free()
		$Label.text = str(Life)

func Distribute_ID():
	My_ID = node_MapManager.ID_to_give + 1

func Connect_Collision_with_Player():
	node_Player.connect("hurt_enemy", self, "hurt_signal_received")

func Get_Nodes():
	node_Cube = $Background.get_parent()
	node_Player = get_tree().get_root().get_node("MainNode/Player")
	node_MapManager = get_tree().get_root().get_node("MainNode")
	