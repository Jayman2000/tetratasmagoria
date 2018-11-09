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


## tetromino/AutoRepeat.gd
# When left or right is held, the action is automatically repreated
extends Timer

const INITIAL_DELAY = 0.3
const REPEAT_DELAY = 0.05

func _init():
	._init()
	wait_time = INITIAL_DELAY

func start_repeating():
	wait_time = REPEAT_DELAY

func start():
	wait_time = INITIAL_DELAY
	.start()
	connect("timeout", self, "start_repeating", [], CONNECT_ONESHOT)