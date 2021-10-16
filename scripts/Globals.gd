extends Node

const TutorialWindow = preload("res://scenes/TutorialWindow.tscn")
const OverlayLabel = preload("res://scenes/OverlayLabel.tscn")

const ITEMS = [ preload("res://assets/items/f.png"),
				preload("res://assets/items/p.png"),
				preload("res://assets/items/cresc.png"),
				preload("res://assets/items/decresc.png"),
				preload("res://assets/items/ff.png"),
				preload("res://assets/items/fff.png"),
				preload("res://assets/items/pp.png"),
				preload("res://assets/items/sf.png"),
				preload("res://assets/items/accel.png"),
				preload("res://assets/items/pizz.png"),
				preload("res://assets/items/staccato.png")]

const ITEM_DESC_TITLES = [  "Forte",
							"Piano",
							"Crescendo",
							"Decrescendo",
							"Fortissimo",
							"Forte fortissimo",
							"Pianissimo",
							"Sforzando",
							"Accelerando",
							"Pizzicato",
							"Staccato"]

const ITEM_DESC = ["translates as \"loud or strong\" and is used to signal to the musicians to play their instruments loudly.",
					"translates as \"quiet\" and is used to signal to the musicians to play their instruments in a quiet way.",
					"translates as \"increasing\" and is used to signal to the musicians to increase their volume over time.",
					"translates as \"decreasing\" and is used to signal to the musicians to decrease their volume over time.",
					"translates as \"loudest\" and stands for playing louder than loud.",
					"translates as \"loud loudest\" and is used to signal to the musicians to player louder than the loudest. (It's a bit weired, but just take it)",
					"translates as \"quietest\" and stands for playing more quiet than piano.",
					"translates as \"Striving\" and advises the musician to play loudly accentuated.",
					"translates as \"accelerating\" and signals the musician to accelerate over time.",
					"translates as \"plucking\" and is used to signal to the string players not to use their bow, but to pluck the strings with their fingers.",
					"is used to describe musical notes that are short and separate when played.",]

var show_tutorial = true
var use_camera = false
var use_post_process = true

var toolbar_node : Node
var conductor_node : Node
var cLayer : Node
var scoreLabel : Node

var used_item_IDs = []

var draggingItem : Node

var score = 0 setget set_score

func checkForUsed(_id : int):
	for id in used_item_IDs:
		if id == _id:
			return
	add_to_toolbar(_id)
	used_item_IDs.append(_id)
	if show_tutorial:
		yield(get_tree().create_timer(0.5), "timeout")
		run_tutorial(_id)

func add_to_toolbar(id : int):
	toolbar_node.add_item(id)

func run_tutorial(id : int):
	var tw = TutorialWindow.instance()
	cLayer.add_child(tw)
	tw.setItem(id)
	tw.global_position = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height")) / 2

func send_overlay(text : String, vec : Vector2):
	var ol : Label = OverlayLabel.instance()
	cLayer.add_child(ol)
	ol.rect_global_position = lerp(vec, conductor_node.global_position, 0.4)
	ol.setText(text)

func set_score(val):
	if val >= 0:
		score = val
		scoreLabel.setScore(val)
	else:
		scoreLabel.setScore(0)

func reset():
	show_tutorial = true
	use_camera = false
	use_post_process = true

	toolbar_node = null
	conductor_node = null
	cLayer = null
	scoreLabel = null

	used_item_IDs = []

	draggingItem = null

	score = 0
