extends KinematicBody2D

var Player_Direction = Vector2()
var Jump_force = 1200
var Start_moving = false
var velocity = Vector2()
signal hurt_enemy
signal WaveFinish
var ennemy_hit_id
var Button_Play_Node
var Bounce_Start = 10
var Bounce_amount = Bounce_Start
var Start_Position


# Execution lors du chargement
func _ready():
	Start_Position = position
	Button_Play_Node = get_tree().get_root().get_node("MainNode/Launch_button")
	set_process(true)

# Update le dessin de la ligne
func _process(delta):
		update()

# Mouvement du personnage
func _physics_process(delta):
	if Start_moving:
		var collision = move_and_collide(velocity * delta)
		Collision_Manager(collision)

func Collision_Manager(collision):
	if collision:
			velocity = velocity.bounce(collision.normal)
			if collision.collider.name == "Cube":
				ennemy_hit_id = collision.collider.get_instance_id()
				emit_signal("hurt_enemy")
			if Button_Play_Node.disabled:
				Bounce_amount -=1
				if Bounce_amount < 1:
					rotation = 0
					velocity.x = 0
					velocity.y = 0
					position = Start_Position
					Button_Play_Node.disabled = false
					Button_Play_Node.text = str("Play")
					Player_Direction = Vector2(0,0)
					Bounce_Start += 1
					Bounce_amount = Bounce_Start
					Start_moving = false
					emit_signal("WaveFinish")
				else:
					rotation = collision.normal.angle()
					Button_Play_Node.text = str(Bounce_amount)

# Écran appuyer
func _input(event):
	if event is InputEventScreenDrag:
		Player_Direction = get_local_mouse_position ( )
	elif event is InputEventScreenTouch:
		var Verify_Position = get_local_mouse_position ( )
		if(Verify_Position.y < 0):
			Player_Direction = Verify_Position

# Dessine une ligne
func _draw():
	if(Start_moving):
	    draw_line(Vector2(0,0), Vector2(0,0), Color(255, 0, 0), 1)
	else:
    	draw_line(Vector2(0,0), Player_Direction, Color(255, 0, 0), 1)

func _on_Launch_button_button_down():
	Button_Play_Node.disabled = true
	Button_Play_Node.text = str(Bounce_amount)
	Set_launch_Force()
	Start_moving = true

func Set_launch_Force():
	velocity = Vector2(Player_Direction.x, -Player_Direction.y)
	var Direction_Length = velocity.length()
	if Direction_Length != 0:
		velocity *= Jump_force / Direction_Length