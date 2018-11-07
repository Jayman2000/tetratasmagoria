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


## tetromino/FallTimer.gd
# Custom timer (needed for proper handling of soft droping)
extends Node

signal timeout
export(float) var wait_time = 1.0

var time_passed = 0.0

func _process(delta):
	time_passed += delta
	if time_passed >= wait_time:
		emit_signal("timeout")
		time_passed -= wait_time

func stop():
	set_process(false)
	time_passed = 0.0

func start():
	set_process(true)