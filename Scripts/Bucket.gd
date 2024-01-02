class_name GlobalBucket
extends Node


@onready var default_balloon:PackedScene = preload("res://addons/dialogue_manager/default_balloon/default_balloon.tscn")

@onready var gfs:Array[Resource] = [
	preload("res://GFs/Shiva.tres"),
	preload("res://GFs/Quetzacotl.tres"),
	preload("res://GFs/Diabolos.tres"),
	preload("res://GFs/Brothers.tres"),
	preload("res://GFs/Ifrit.tres"),
	preload("res://GFs/Siren.tres")
]

@onready var party:Array[Resource] = [
	preload("res://PlayerCharacters/Seifer.tres"),
	preload("res://PlayerCharacters/Squall.tres")
]

var in_vignette: bool = false
var root_hook:RootController

func get_UI() -> Control:
	return root_hook.UI

