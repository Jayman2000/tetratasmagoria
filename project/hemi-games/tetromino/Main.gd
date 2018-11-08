#   Copyright 2018 Jason A. Yundt
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


## tetromino/Main.gd
# Main code for the tetromino hemi-game
extends Node
const Location = preload("res://hemi-games/tetromino/Location.gd")


const GENERIC = 0
const I = preload("res://hemi-games/tetromino/I.tscn")
const J = preload("res://hemi-games/tetromino/J.tscn")
const L = preload("res://hemi-games/tetromino/L.tscn")
const O = preload("res://hemi-games/tetromino/O.tscn")
const S = preload("res://hemi-games/tetromino/S.tscn")
const T = preload("res://hemi-games/tetromino/T.tscn")
const Z = preload("res://hemi-games/tetromino/Z.tscn")


## Random tetromino generator
var bag = []
var next_six = []

const RAND_MAX = 4294967280

func grab_from_bag():
	# Refill the bag if necessary
	if bag.size() == 0:
#		The following shuffles  the bag using the Fisher-Yates algorithm
#		The Fisher-Yates algorithm can suffer from Modulo bias if not properly implemented
#		<https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#Modulo_bias>
#
#		The algorithm requires that a random number (inclusively) between
#		0 and 1, 0 and 2, 0 and 3, etc. all the way up to 0 and n-1 (where n is the size
#		of the array, which in this case is 7).
#
#		randi() returns a random number between 0 and 2^32 - 1. This is a problem since
#			2^32 - 1 % 7 != 0.
#		That means that if we did
#			randi() % 7
#		to generate a random number between 0 and 6, certain numbers would be more
#		likely(even if randi() was perfectly random).
#		<https://stackoverflow.com/questions/10984974/why-do-people-say-there-is-modulo-bias-when-using-a-random-number-generator#10984975>
#
#		If we wanted to still use randi() to generate numbers between 0 and i, we would need to
#			1. Find a number, RAND_MAX, that is divisible by i+1, and less than or equal to 2^32 - 1.
#			2. result = randi()
#			3. If result > RAND_MAX go to 2
#			4. return result
#		To decrease the chance that we need to call randi() again, we should find the largest
#		possible RAND_MAX that is less than or equal to 2^32 - 1.
#
#		Since we need random numbers between 0 and 1, 0 and 2, etc. all the way up to 0 and n-1,
#		we have two options:
#			1. We could find a RAND_MAX for each number from 3 to 7 inclusive.
#			2. We could find a RAND_MAX that is divisible by every integer between 3 and 7 inclusive.
#
#		I decided to do #2. I used the following python program to generate such a number:
#
#			for i in reversed(range(2**32)):
#				passed = True
#				for j in range (2, 7):
#					if i % j != 0:
#						passed = False
#						break
#				if passed:
#					print(i)
#					break
#
#		It gave me a RAND_MAX of 4294967280. This is only 15 less than 2^32-1, so it's probaly faster
#		that having individual RAND_MAXs (not to mention, it's much less code).
		
		bag = [I, J, L, O, S, T, Z]
		var i = bag.size()-1
		while i >= 1:
			var j = RAND_MAX + 1
			while j > RAND_MAX:
				j = randi()
			j = j % (i + 1)
			
			# swap bag[i] and bag[j]
			var tmp = bag[i]
			bag[i] = bag[j]
			bag[j] = tmp
			
			i -= 1
	var return_value = bag.pop_front().instance()
	add_child(return_value)
	return return_value

func pop_next():
	next_six.push_back(grab_from_bag())
	
	var return_value = next_six.pop_front()
	remove_child(return_value) # No longer needs to be drawn directly
	for i in range(6):
		next_six[i].position = get_node("Next%s" % [i]).position
	
	return return_value

func spawn_tetromino():
	current_tetromino.queue_free()
	current_tetromino = pop_next()
	set_current_tetromino_visibility(true)
	$FallTimer.start()
	lowest_row = current_tetromino.location.r


## Movement
var current_tetromino 
var moving_left

# set_current_tetromino_visibility(false) should be called before a tetromino moves/rotates, and
# set_current_tetromino_visibility(true) should be called afterwords
func set_current_tetromino_visibility(visible):
	var frame = current_tetromino.get_node("Square").frame
	
	for location in current_tetromino.get_square_locations():
		$Grid.squares[location.r][location.c].frame = frame
		$Grid.squares[location.r][location.c].visible = visible

func move():
	if moving_left:
		movement_queue.c -= 1
	else:
		movement_queue.c += 1


## Falling
func _on_FallTimer_timeout():
	movement_queue.r -= 1


## Locking
var marked_for_lock = false
var lowest_row

func mark_for_lock():
	marked_for_lock = true

func lock():
	for location in current_tetromino.get_square_locations():
		$Grid.get_square(location).active = true
	$FallTimer.stop()
	$SpawnDelay.start()
	marked_for_lock = false


var movement_queue = Location.new(0, 0) # r should never be positive

func _ready():
	## Random tetromino generator
	randomize()
	for i in range(6):
		next_six.push_back(grab_from_bag())
	current_tetromino = pop_next()

func _process(delta):
	$FallTimer.is_soft_droping = Input.is_action_pressed("ui_down")
	if $SpawnDelay.is_stopped():
		if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
			$AutoRepeat.stop()
		else:
			# Set moving_left and start timer
			pass
	
		## Movement/Falling
		if movement_queue.r != 0 or movement_queue.c != 0:
			set_current_tetromino_visibility(false)
		
			handle_left_right_movement()
			handle_down_movement()
		
			set_current_tetromino_visibility(true)
		
			## Locking
			var on_surface = false
			for location in current_tetromino.get_square_locations():
				var location_below = location.sub(1, 0)
				if location_below.r < 0 or $Grid.get_square(location_below).active:
					on_surface = true
					break
		
			if not on_surface:
				if $FallTimer.is_stopped():
					$FallTimer.start()
				if current_tetromino.location.c < lowest_row:
					$LockTimer.stop()
					marked_for_lock = false
			else:
				if marked_for_lock:
					lock()
				else:
					if $LockTimer.is_stopped():
						$LockTimer.start()
			lowest_row = min(lowest_row, current_tetromino.location.r)

# Both handle_left_right_movement and handle_down movement return the number of squares the tetromino was actually moved
func handle_left_right_movement():
	var direction # -1 for left, and +1 for right
	if movement_queue.c < 0:
		direction = -1
	else:
		direction = 1
	while movement_queue.c != 0:
		for location in current_tetromino.get_square_locations():
			var new_location = location.add(0, direction)
			if new_location.c < 0 or new_location.c >= $Grid.WIDTH or $Grid.get_square(new_location).active:
				# Can't move anymore, so stop
				movement_queue.c = 0
				return
		$LockTimer.add_movement_or_rotation()
		current_tetromino.location.c += direction
		movement_queue.c -= direction

func handle_down_movement():
	while movement_queue.r != 0:
		for location in current_tetromino.get_square_locations():
			var new_location = location.sub(1, 0)
			if new_location.r < 0 or $Grid.get_square(new_location).active:
				movement_queue.r = 0
				return
		current_tetromino.location.r -= 1
		movement_queue.r += 1


## Tests
var swap

func _on_SwapTest_timeout():
	var pieces = [I, J, L, O, S, T, Z]
	if swap != null:
		remove_child(swap)
		swap.queue_free()
	swap = pieces[randi() % pieces.size()].instance()
	swap.position = $Swap.position
	add_child(swap)

func set_grid(locations):
	for location in locations:
		var square = $Grid.get_square(location)
		square.show()
		square.active = true