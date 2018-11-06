extends Node

const GENERIC = 0
const I = 1
const J = 2
const L = 3
const O = 4
const S = 5
const T = 6
const Z = 7

## Random tetromino generator
var bag = []
var next_six = []

const RAND_MAX = 4294967280

func grab_from_bag():
	if bag.size() == 0:
		"""
		The following shuffles  the bag using the Fisher-Yates algorithm
		The Fisher-Yates algorithm can suffer from Modulo bias if not properly implemented
		<https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#Modulo_bias>

		The algorithm requires that a random number (inclusively) between
		0 and 1, 0 and 2, 0 and 3, etc. all the way up to 0 and n-1 (where n is the size
		of the array, which in this case is 7).

		randi() returns a random number between 0 and 2^32 - 1. This is a problem since
			2^32 - 1 % 7 != 0.
		That means that if we did
			randi() % 7
		to generate a random number between 0 and 6, certain numbers would be more
		likely(even if randi() was perfectly random).
		<https://stackoverflow.com/questions/10984974/why-do-people-say-there-is-modulo-bias-when-using-a-random-number-generator#10984975>

		If we wanted to still use randi() to generate numbers between 0 and i, we would need to
			1. Find a number, RAND_MAX, that is divisible by i+1, and less than or equal to 2^32 - 1.
			2. result = randi()
			3. If result > RAND_MAX go to 2
			4. return result
		To decrease the chance that we need to call randi() again, we should find the largest
		possible RAND_MAX that is less than or equal to 2^32 - 1.

		Since we need random numbers between 0 and 1, 0 and 2, etc. all the way up to 0 and n-1,
		we have two options:
			1. We could find a RAND_MAX for each number from 3 to 7 inclusive.
			2. We could find a RAND_MAX that is divisible by every integer between 3 and 7 inclusive.

		I decided to do #2. I used the following python program to generate such a number:

			for i in reversed(range(2**32)):
				passed = True
				for j in range (2, 7):
					if i % j != 0:
						passed = False
						break
				if passed:
					print(i)
					break

		It gave me a RAND_MAX of 4294967280. This is only 15 less than 2^32-1, so it's probaly faster
		that having individual RAND_MAXs (not to mention, it's much less code).
		"""
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
	return bag.pop_front()

func pop_next():
	next_six.push_back(grab_from_bag())
	return next_six.pop_front()

func _ready():
	## Random tetromino generator
	randomize()
	for i in range(6):
		next_six.push_back(grab_from_bag())
