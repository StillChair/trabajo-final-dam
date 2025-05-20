extends Node
signal startup_finish

const data_path = "res://Data/savedata.db"
var database : SQLite
var firstTime = true

# Saved data variable
var partidas = []
var niveles = []

# Loaded save data
var datos_partida = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func startup():
	# Check if database exists
	#var checkfile = FileAccess.new()
	if FileAccess.file_exists(data_path):
		firstTime = false
	
	database = SQLite.new()
	database.path = data_path
	database.open_db()
	
	if firstTime == true:
		database.query("PRAGMA foreign_keys = ON;")
		print("DEBUG | FIRST TIME -> CREATING DATABASE...")
		
		database.create_table("partidas", {
			"idPartida":{"data_type":"int", "primary_key":true, "not_null":true},
			"nueva":{"data_type":"int"}, # Bool number to determine if save is fresh
			"prog":{"data_type":"int"} # Int number between 0 and 100
		})
		database.create_table("niveles", {
			"idNivel":{"data_type":"int", "primary_key":true, "not_null":true},
			"nombre":{"data_type":"text"}
		})
		database.query("""
			CREATE TABLE IF NOT EXISTS partida_niveles (
				idPartida INTEGER NOT NULL,
				idNivel INTEGER NOT NULL,
				desbloqueado INTEGER,
				completado INTEGER,
				tiempo REAL,
				PRIMARY KEY (idPartida, idNivel),
				FOREIGN KEY (idPartida) REFERENCES partidas(idPartida) ON DELETE CASCADE,
				FOREIGN KEY (idNivel) REFERENCES niveles(idNivel) ON DELETE CASCADE
			);
			""")
		#database.create_table("partida-niveles", {
			#"idPart":{},
			#"idNivel":{},
			#"desbloqueado":{},
			#"completado":{},
			#"tiempo":{}
		#})
		
		# Insert empty saves
		database.insert_rows("partidas", [{"idPartida":1,"nueva":1}, {"idPartida":2,"nueva":1}, {"idPartida":3,"nueva":1}])
		
		# Insert all present level scenes into table levels
		var dir := DirAccess.open("res://Scenes/Levels")
		if dir == null: printerr("DEBUG | Could not open folder"); return
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var counter = 0
		var level_ids = []
		while file_name != "":
			# Ignorar carpetas y archivos que no sean escenas .tscn
			if not dir.current_is_dir() and file_name.ends_with(".tscn") and not (file_name.contains("testroom") or file_name.contains("template")):
				file_name = file_name.trim_prefix("lvl_")
				file_name = file_name.replace("_", " ")
				print(" DEBUG | Procesando archivo:", file_name)
				database.insert_row("niveles", {"idNivel":counter, "nombre":file_name})
				level_ids.append(counter)
				counter += 1
			file_name = dir.get_next()
			
		dir.list_dir_end()
		
		print("DEBUG | STORED LEVELS: " + str(level_ids))
		# Insertar filas en la tabla partida_niveles para cada combinación de partida y nivel
		for level_id in level_ids:
			for partida_id in [1, 2, 3]:
				database.insert_row("partida_niveles", {
					"idPartida": partida_id,
					"idNivel": level_id,
					"desbloqueado": 0,
					"completado": 0,
					"tiempo": 0.0
				})
		
		partidas = database.select_rows("partidas", "", ["*"])
		niveles = database.select_rows("niveles", "", ["*"])
	
	if firstTime == false:
		print("DEBUG | DATABASE EXISTS -> LOADING DATA...")
		#print(database.select_rows("partidas", "", ["*"]))
		partidas = database.select_rows("partidas", "", ["*"])
		print("DEBUG | PARTIDAS:")
		print("DEBUG | "+str(partidas))
	
	startup_finish.emit()
	#database.close_db()




func load_save(saveId):
	print("DEBUG | LOADING DATA FROM SLOT " + str(saveId) + "...")
	datos_partida = database.select_rows("partida_niveles", "idPartida = "+str(saveId), ["*"])
	print("DEBUG | DATA IN SLOT " + str(saveId) + ":")
	print("DEBUG | " + str(database.select_rows("partida_niveles", "idPartida = "+str(saveId), ["*"])))

func create_save(saveId):
	print("DEBUG | CREATING SAVE DATA IN SLOT " + str(saveId) + "...")
	database.update_rows("partidas", "idPartida = "+str(saveId), {"nueva":0})

func save_data(table:String, where:String, data, operation:String = "update"):
	match operation:
		"update":
			database.update_rows(table, where, data)

func save_level_beat(idNivel:int):
	print("DEBUG | SAVING LEVEL BEAT")
	var cur_partida = datos_partida[0]["idPartida"] 
	if partidas[cur_partida-1]["nueva"] == 1:
		create_save(cur_partida)
	database.update_rows("partida_niveles", "idPartida = "+str(cur_partida)+" and idNivel = " + str(idNivel), {"completado":1})
	if idNivel+1 == len(niveles):
		print("DEBUG | UNLOCKING NEXT LEVEL")
		database.update_rows("partida_niveles", "idPartida = "+str(cur_partida)+"and idNivel = " + str(idNivel+1), {"desbloqueado":1})
	else:
		print("DEBUG | NO MORE LEVELS TO UNLOCK")
