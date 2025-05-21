extends Node
signal startup_finish

const data_path = "res://Data/savedata.db"
var database : SQLite
var firstTime = true

# Saved data variable
var partidas = []
var niveles = []

# Loaded save data
var datos_partida = []
var cur_partida

# Check played time
var start_time = 0.0
var end_time
var session_time
var total_time
var playing = false

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
			"tiempo_total":{"data_type":"int"} # Int number between 0 and 100
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
				if level_id == 0:
					database.insert_row("partida_niveles", {
					"idPartida": partida_id,
					"idNivel": level_id,
					"desbloqueado": 1,
					"completado": 0,
					"tiempo": 0.0
				})
				else:
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
		niveles = database.select_rows("niveles", "", ["*"])
		print("DEBUG | PARTIDAS:")
		print("DEBUG | "+str(partidas))
	
	startup_finish.emit()
	#database.close_db()




func load_save(saveId):
	playing = true
	# Get time player started playing
	start_time = Time.get_unix_time_from_system()
	
	
	print("DEBUG | LOADING DATA FROM SLOT " + str(saveId) + "...")
	datos_partida = database.select_rows("partida_niveles", "idPartida = "+str(saveId), ["*"])
	print("DEBUG | DATA IN SLOT " + str(saveId) + ":")
	print("DEBUG | " + str(database.select_rows("partida_niveles", "idPartida = "+str(saveId), ["*"])))
	print("DEBUG | DATA RETRIEVED:")
	print("DEBUG | " + str(datos_partida))
	
	# Load played time
	total_time = partidas[saveId-1]["tiempo_total"]
	if total_time == null:
		total_time = 0
	
	print("DEBUG | LOADED PLAY TIME: " + str(total_time))

func create_save(saveId):
	print("DEBUG | CREATING SAVE DATA IN SLOT " + str(saveId) + "...")
	database.update_rows("partidas", "idPartida = "+str(saveId), {"nueva":0})

func save_data(table:String, where:String, data, operation:String = "update"):
	match operation:
		"update":
			database.update_rows(table, where, data)

func save_level_beat(idNivel:int):
	print("DEBUG | SAVING LEVEL BEAT")
	print(str(datos_partida))
	cur_partida = datos_partida[0]["idPartida"] 
	if partidas[cur_partida-1]["nueva"] == 1:
		create_save(cur_partida)
	database.update_rows("partida_niveles", "idPartida = "+str(cur_partida)+" and idNivel = " + str(idNivel), {"completado":1})
	if idNivel+2 == len(niveles):
		print("DEBUG | UNLOCKING NEXT LEVEL")
		database.update_rows("partida_niveles", "idPartida = "+str(cur_partida)+" and idNivel = " + str(idNivel+1), {"desbloqueado":1})
	else:
		print("DEBUG | NO MORE LEVELS TO UNLOCK OR NOT NEW LEVEL")
	
	refresh_data()

func end_game():
	end_time = Time.get_unix_time_from_system()  # Guarda el tiempo de finalización
	session_time = end_time - start_time     # Duración de la sesión en segundos
	print("DEBUG | SESSION TIME PLAYED: ", session_time, " SECONDS")
	add_to_total_play_time(session_time)

func add_to_total_play_time(session_time):
	total_time += session_time
	print("DEBUG | TOTAL TIME PLAYED: ", total_time, " SECONDS")
	database.update_rows("partidas", "idPartida = "+ str(cur_partida), {"tiempo_total":total_time})

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if playing == true:
			await end_game()
		get_tree().quit() # default behavior

func refresh_data():
	print("DEBUG | LOADING DATA FROM SLOT " + str(cur_partida) + "...")
	datos_partida = database.select_rows("partida_niveles", "idPartida = "+str(cur_partida), ["*"])
	print("DEBUG | REFRESHED DATA:")
	print("DEBUG | " + str(datos_partida))
