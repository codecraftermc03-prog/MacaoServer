extends SceneTree

const PUERTO: int = 8080
var peer := WebSocketMultiplayerPeer.new()

func _init() -> void:
	var err := peer.create_server(PUERTO)
	if err == OK:
		get_multiplayer().multiplayer_peer = peer
		print("Servidor Relay WebSocket escuchando en el puerto: ", PUERTO)
	else:
		print("Error al iniciar el servidor WebSocket: ", err)

	get_multiplayer().peer_connected.connect(_on_peer_connected)
	get_multiplayer().peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int) -> void:
	print("Cliente conectado. Peer ID: ", id)

func _on_peer_disconnected(id: int) -> void:
	print("Cliente desconectado. Peer ID: ", id)
