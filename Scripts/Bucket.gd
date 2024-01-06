class_name GlobalBucket
extends Node


enum Stat {
	HP,
	STR,
	VIT,
	MAG,
	SPR,
	SPD,
	EVA,
	HIT,
	LUCK
}


@onready var default_balloon:PackedScene = preload("res://addons/dialogue_manager/default_balloon/default_balloon.tscn")

@onready var gfs:Array[Resource] = [
	preload("res://GFs/Shiva.tres"),
	preload("res://GFs/Quetzacotl.tres"),
	preload("res://GFs/Ifrit.tres"),
	preload("res://GFs/Siren.tres"),
	preload("res://GFs/Brothers.tres"),
	preload("res://GFs/Leviathan.tres"),
	preload("res://GFs/Pandemona.tres"),
	preload("res://GFs/Diabolos.tres"),
	preload("res://GFs/Alexander.tres"),
	preload("res://GFs/Carbuncle.tres"),
	preload("res://GFs/Cerberus.tres"),
	preload("res://GFs/Doomtrain.tres"),
	preload("res://GFs/Bahamut.tres"),
	preload("res://GFs/Cactuar.tres"),
	preload("res://GFs/Tonberry.tres")
	
]


@onready var spell_inventory:Array[Array] = [ 
	["Fire", 20],
	["Demi", 10]
]


@onready var party:Array[Resource] = [
	preload("res://PlayerCharacters/Squall.tres"),
	preload("res://PlayerCharacters/Seifer.tres")
]


var in_vignette: bool = false
var root_hook:RootController


var party_update:Array[WeakRef]


func _ready() -> void:
	for pc:PlayerCharacter in party:
		pc.setup()


func get_UI() -> Control:
	return root_hook.UI


func subscribe_party_update(to_ref:Node) -> void:
	party_update.append(weakref(to_ref))


func alert_party_update(updated:Resource) -> void:
	for s:WeakRef in party_update:
		if s.get_ref():
			print("Alerting ", s)
			(s.get_ref() as Node).emit_signal("propogate_view", updated)
		else:
			party_update.erase(s)
