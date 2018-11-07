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


## tetromino/LockTimer.gd
# Allows a limited number of resets
extends Timer

var movements_or_rotations = 0

func add_movement_or_rotation():
	if not is_stopped():
		movements_or_rotations += 1
		if movements_or_rotations == 15:
			emit_signal("timeout")
			stop()
		else:
			.start()

func start():
	.start()
	movements_or_rotations = 0
