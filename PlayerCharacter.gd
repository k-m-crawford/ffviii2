class_name PlayerCharacter extends Resource

@export var name:String
@export var portrait:Texture2D
@export var max_hp:int
@export var hp:int
@export var stn:int
@export var vit:int
@export var mag:int
@export var spr:int
@export var spd:int
@export var eva:int
@export var hit:int
@export var luck:int

@export var junctioned_gfs:Array[Resource]
@export var max_gfs:int = 4

var hp_bonus:int
var stn_bonus:int
var vit_bonus:int
var mag_bonus:int
var spr_bonus:int
var spd_bonus:int
var eva_bonus:int
var hit_bonus:int
var luck_bonus:int


func junction_gf(gf:GF) -> void:
	if gf in junctioned_gfs:
		junctioned_gfs.erase(gf)
		gf.junctioned = false
	elif junctioned_gfs.size() < max_gfs:
		junctioned_gfs.append(gf)
		gf.junctioned = true
