extends Node

const PUERTO: int = 8080
var peer := WebSocketMultiplayerPeer.new()

func _ready() -> void:
	var err := peer.create_server(PUERTO)
	if err == OK:
		multiplayer.multiplayer_peer = peer
		print("Servidor Relay WebSocket escuchando en el puerto: ", PUERTO)
	else:
		print("Error al iniciar el servidor WebSocket: ", err)

	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int) -> void:
	print("Cliente conectado. Peer ID: ", id)

func _on_peer_disconnected(id: int) -> void:
	print("Cliente desconectado. Peer ID: ", id)

# --- REENVIAR AUDIO DE VOZ ENTRE JUGADORES ---
@rpc("any_peer", "call_remote", "unreliable")
func transmitir_audio_remoto(buffer_audio: PackedFloat32Array) -> void:
	var remitente_id := multiplayer.get_remote_sender_id()
	# Reenviar los paquetes de micrófono a todos los demás participantes
	for peer_id in multiplayer.get_peers():
		if peer_id != remitente_id:
			rpc_id(peer_id, "recibir_audio_remoto", remitente_id, buffer_audio)

@rpc("any_peer", "call_remote", "unreliable")
func recibir_audio_remoto(_remitente_id: int, _buffer_audio: PackedFloat32Array) -> void:
	pass

# --- REENVIAR PRESENCIA Y ESTADO DE LLAMADA ---
@rpc("any_peer", "call_remote", "reliable")
func actualizar_estado_usuario(nombre: String, hablando: bool, en_llamada: bool) -> void:
	var remitente_id := multiplayer.get_remote_sender_id()
	for peer_id in multiplayer.get_peers():
		if peer_id != remitente_id:
			rpc_id(peer_id, "recibir_estado_usuario", remitente_id, nombre, hablando, en_llamada)

@rpc("any_peer", "call_remote", "reliable")
func recibir_estado_usuario(_remitente_id: int, _nombre: String, _hablando: bool, _en_llamada: bool) -> void:
	pass
