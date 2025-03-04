extends Node

enum State {CONSTELATION_ALIGNMENT, CONSTELATION_TRACING, DEFAULT}
var active_state = State.DEFAULT

var camera: Camera3D
var star_cluster: Node3D
var player_controller: Node
