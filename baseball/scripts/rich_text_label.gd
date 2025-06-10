extends RichTextLabel

func _pitching_leaderboard():
	# Convert Dictionary to array of [name, count] pairs
	var pairs := []
	for name in Global.pitchTypeCounts:
		pairs.append([name, Global.pitchTypeCounts[name]])

	# Sort descending by count
	pairs.sort_custom(func(a, b): return a[1] > b[1])

	return pairs
	
func _process(delta: float) -> void:
	var pairs = _pitching_leaderboard()
	var text = ""
	for pair in pairs:
		text += pair[0] + ": " + str(snapped(pair[1]*100/Global.totalPitchCoverage,.1)) + "%\n"
	self.text = text 
