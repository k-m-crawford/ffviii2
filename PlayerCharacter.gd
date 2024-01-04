class_name PlayerCharacter extends Resource

@export var name:String
@export var portrait:Texture2D
@export var max_hp:int
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

var stat_dict:Dictionary
var bonus_stat_dict:Dictionary
var junctionable_stats:Array[Bucket.Stat]

func setup() -> void:
	stat_dict[Bucket.Stat.HP] = max_hp
	stat_dict[Bucket.Stat.STR] = stn
	stat_dict[Bucket.Stat.VIT] = vit
	stat_dict[Bucket.Stat.MAG] = mag
	stat_dict[Bucket.Stat.SPR] = spr
	stat_dict[Bucket.Stat.SPD] = spd
	stat_dict[Bucket.Stat.EVA] = eva
	stat_dict[Bucket.Stat.HIT] = hit
	stat_dict[Bucket.Stat.LUCK] = luck
	
	bonus_stat_dict[Bucket.Stat.STR] = 0
	bonus_stat_dict[Bucket.Stat.VIT] = 0
	bonus_stat_dict[Bucket.Stat.MAG] = 0
	bonus_stat_dict[Bucket.Stat.SPR] = 0
	bonus_stat_dict[Bucket.Stat.SPD] = 0
	bonus_stat_dict[Bucket.Stat.EVA] = 0
	bonus_stat_dict[Bucket.Stat.HIT] = 0
	bonus_stat_dict[Bucket.Stat.LUCK] = 0
	
	for gf:GF in junctioned_gfs:
		junctionable_stats.append_array(gf.junctionable_stats)


func junction_gf(gf:GF) -> void:
	if gf in junctioned_gfs:
		junctioned_gfs.erase(gf)
		for stat:int in gf.junctionable_stats:
			junctionable_stats.erase(stat)
		gf.junctioned = false
	elif junctioned_gfs.size() < max_gfs:
		junctioned_gfs.append(gf)
		junctionable_stats.append_array(gf.junctionable_stats)
		gf.junctioned = true
	
	print("ALERT", junctionable_stats)
	Bucket.alert_party_update(self)
