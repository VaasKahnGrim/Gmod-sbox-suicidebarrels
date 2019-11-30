SuicideBarrels.current_round = 1
SuicideBarrels.lastround = ''
local function SetupTeams()
	team.SetUp(1,'Combine',Color(0,0,240))
	team.SetSpawnPoint(1,{'combine_spawn'})
	team.SetUp(2,'Barrels',Color(240,0,0))
	team.SetSpawnPoint(2,{'barrel_spawn'})
end
function GM:Initialize()
	SetupTeams()
end
function GM:PlayerInitialSpawn(pl)
end
function GM:PlayerSpawn(pl)
	
end
function GM:PlayerSelectSpawn(pl)
	if(pl:Team() == 1)then
		local spawns = ents.FindByClass'combine_spawn'
		local point = math.random(#spawns)
		return spawns[point]
	elseif(pl:Team() == 2)then
		local spawns = ents.FindByClass'barrel_spawn'
		local point = math.random(#spawns)
		return spawns[point]
	else
		print'handle spectator'
	end
end
function GM:RoundOver(c)
	PrintMessage(HUD_PRINTCENTER,c)
	if(SuicideBarrels.lastround == 'warmup')then
		SuicideBarrels.lastround = ''
	end
	timer.Simple(10,function()
		hook.Call('NewRound',self)
	end)
end
local function CheckIfAllDead(t)
	if(team.NumPlayers(t))then
		hook.Call('RoundOver',self,'The Barrels have won!')
	end
end
local function Explosion()
end
local combine_chatter = {
	'',
	''
}
local barrel_death_sounds = {
	'',
	''
}
function GM:PlayerDeath(pl)
	if(pl:Team() == 1)then
		pl:EmitSound(table.Random(combine_chatter))
		pl:SetTeam(2)
		CheckIfAllDead(1)
	elseif(pl:Team() == 2)then
		pl:EmitSound(table.Random(barrel_death_sounds))
		Explosion()
	else
		print'Somehow a spectator was killed? wtf?'
	end
end
function GM:NewRound()--I already know this is probably a shitty way of handling rounds, I just need to have a visual reference of flow and this helped me make sense of things
	if(SuicideBarrels.lastround == '')then
		if(math.random(0,100) > 50)then
			timer.simple(SuicideBarrels.Config.WarmupTime,function()
				SuicideBarrels.lastround = 'warmup'
				RoundOver('Warmup is over!')
			end)
		else
			SuicideBarrels.current_round = SuicideBarrels.current_round + 1
			timer.Simple(SuicideBarrels.Config.RoundTimer,function()
				RoundOver('Humans team has won!')
			end)
		end
	else
		SuicideBarrels.current_round = SuicideBarrels.current_round + 1
		timer.Simple(SuicideBarrels.Config.RoundTimer,function()
			RoundOver('Humans team has won!')
		end)
	end
end
function GM:Think()
end
function GM:Tick()
end
