extends RichTextLabel

func _pitching_leaderboard():
	# Convert Dictionary to array of [name, count] pairs
	var pairs := []
	for pitch_name in Global.pitchTypeCounts:
		pairs.append([pitch_name, Global.pitchTypeCounts[pitch_name]])

	# Sort descending by count
	pairs.sort_custom(func(a, b): return a[1] > b[1])

	return pairs
	
func _process(_delta: float) -> void:
	var pairs = _pitching_leaderboard()
	var display_text = ""
	for pair in pairs:
		display_text += pair[0] + ": " + str(snapped(pair[1]*100/Global.totalPitchCoverage,.1)) + "%\n"
	self.text = display_text 
