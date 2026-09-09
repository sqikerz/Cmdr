return function(_, fromPlayers: { Player }, destination: Player | Vector3): string
	const cFrame = if typeof(destination) == "Instance"
		then (destination.Character :: Model):GetPivot()
		else CFrame.new(destination)

	local teleported = 0

	for _, player: Player in ipairs(fromPlayers) do
		const character = player.Character
		const humanoid = character and character:FindFirstChildWhichIsA("Humanoid") :: Humanoid?
		if not humanoid then
			continue
		end

		teleported += 1

		task.spawn(function()
			if humanoid.SeatPart then
				humanoid.Sit = false
				humanoid:GetPropertyChangedSignal("SeatPart"):Wait()
			end

			if character:IsDescendantOf(workspace) then
				character:PivotTo(cFrame)
			end
		end)
	end

	if teleported == #fromPlayers then
		return `Teleported {teleported} players.`
	end

	return `Teleported {teleported} of {#fromPlayers} players. The rest had no character.`
end
