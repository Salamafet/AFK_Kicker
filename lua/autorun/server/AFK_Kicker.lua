-- AFK Kicker by Salamafet
-- modified by Luiggi33

--------------------------------------------------
AFK_WARN_TIME = 300

AFK_TIME = 900 
--------------------------------------------------

AFK_TABLE = AFK_TABLE or {}
AFK_TABLE.NextAFK = AFK_TABLE.NextAFK or {}
AFK_TABLE.Warning = AFK_TABLE.Warning or {}

hook.Add("PlayerInitialSpawn", "MakeAFKVar", function(ply)
	AFK_TABLE.NextAFK[ply] = CurTime() + AFK_TIME
end)

timer.Create("AFK_Check_Timer", 5, 0, function()
	for _, ply in ipairs(player.GetAll()) do
		local afktime = AFK_TABLE.NextAFK[ply]
		if (!afktime) then
			afktime = CurTime() + AFK_TIME
			AFK_TABLE.NextAFK[ply] = afktime
		end

		if (CurTime() >= afktime - AFK_WARN_TIME and !AFK_TABLE.Warning[ply]) then
			ply:ChatPrint("Warning! You are now AFK!")
			ply:ChatPrint("You will be disconnected in 10 minutes if you do not give any sign of life.")
			AFK_TABLE.Warning[ply] = true
		elseif (CurTime() >= afktime) and (ply.Warning) then
			ply:Kick("\nKicked for AFK since 15 minutes!")
		end
	end
end)

hook.Add("KeyPress", "AFK_PlayerMoved", function(ply, key)
	AFK_TABLE.NextAFK[ply] = CurTime() + AFK_TIME
	if AFK_TABLE.Warning[ply] then
		AFK_TABLE.Warning[ply] = false
		ply:ChatPrint("You are no longer AFK!")
	end
end)

hook.Add("PlayerDisconnected", "AFK_CleanTable", function(ply)
	AFK_TABLE.NextAFK[ply] = nil
	AFK_TABLE.Warning[ply] = nil
end)
