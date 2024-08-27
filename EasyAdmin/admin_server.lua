permissions = {
	ban = false,
	kick = false,
	revive = false,
	spectate = false,
	unban = false,
	teleport = false,
	manageserver = false,
	slap = false,
	freeze = false,
	invisible = false,
	invincible = false,
	modifyspeed = false,
	noclip = false,
	vehicles = false
}

local OnlineAdmins = {}
local LastPlayers = {}
AddEventHandler('playerDropped', function (reason)	
	if OnlineAdmins[source] then
		OnlineAdmins[source] = nil
	end
end)

RegisterServerEvent('EasyAdmin:amiadmin')
AddEventHandler("EasyAdmin:amiadmin", function()
	if OnlineAdmins[source] then
		OnlineAdmins[source] = nil
	end
	
	local identifiers = GetPlayerIdentifiers(source)
	local perms = {}
	for perm, val in pairs(permissions) do
		local thisPerm = DoesPlayerHavePermission(source, "easyadmin."..perm)

		if thisPerm == true then
			OnlineAdmins[source] = true 
		end
		
		perms[perm] = thisPerm
	end
	
	TriggerClientEvent("EasyAdmin:SetPermissions", source, perms)
	
	if GetConvar("ea_alwaysShowButtons", "false") == "true" then
		TriggerClientEvent("EasyAdmin:SetSetting", source, "forceShowGUIButtons", true)
	else
		TriggerClientEvent("EasyAdmin:SetSetting", source, "forceShowGUIButtons", false)
	end
	
end)

function GetOnlineAdmins()
	return OnlineAdmins
end

function IsPlayerAdmin(pid)
	return OnlineAdmins[pid]
end


function DoesPlayerHavePermission(player, object)
	local haspermission = false
	if (player == 0 or player == "") then
		return true
	end
	
	if IsPlayerAceAllowed(player,object) then -- check if the player has access to this permission
		haspermission = true
	else
		haspermission = false
	end

	return haspermission
end

CreateThread(function()	
	RegisterServerEvent("EasyAdmin:kickPlayer")
	AddEventHandler('EasyAdmin:kickPlayer', function(playerId,reason)
		if DoesPlayerHavePermission(source,"easyadmin.kick") then
			DropPlayer(playerId, string.format('Wyrzucony przez %s, Powód: %s', GetPlayerName(source), reason) )
		end
	end)

	RegisterServerEvent("exilerp_scripts:callRzadowy", function(playerId) 
		if DoesPlayerHavePermission(source,"easyadmin.spectate") then 
			TriggerClientEvent("exilerp_scripts:rzadowyCalled", playerId, GetPlayerName(source))
		end
	end)
	
	RegisterServerEvent("EasyAdmin:RequestSpectate")
	AddEventHandler('EasyAdmin:RequestSpectate', function(playerId)
		if DoesPlayerHavePermission(source,"easyadmin.spectate") then			
			local xPlayer = ESX.GetPlayerFromId(playerId)
			if xPlayer ~= nil then
				local coords = GetEntityCoords(GetPlayerPed(playerId))
				TriggerClientEvent("EasyAdmin:requestSpectate", source, playerId, coords)
				
				local czas = os.date("%Y/%m/%d %X")
				exports['snaily_core']:SendLog(source, "Administrator: "..GetPlayerName(source).."\n Administrator ID: " ..source.. " \nGracz: "..GetPlayerName(playerId).. "\nGracz ID: "..playerId.."\nData: "..czas, 'spectate', '5793266')
			end
		end
	end)

	RegisterCommand('crash', function(source, id, user)
		if source == 0 then
			if GetPlayerPing(id[1]) == 0 then
				TriggerEvent('sendMessageDiscord', "Niema nikogo o takim ID")
			else
				TriggerClientEvent("EasyAdmin:CrashPlayer", id[1])
				exports['snaily_core']:SendLog(source, "Użyto komendy /crash na graczu: ["..id[1].."]", "admin_commands")	
			end
		else
			local xPlayer = ESX.GetPlayerFromId(source)
			if DoesPlayerHavePermission(source,"easyadmin.slap") then
				if id[1] ~= nil then
					if GetPlayerPing(id[1]) == 0 then
						xPlayer.showNotification('~r~Niema nikogo o takim ID')
						return
					end
					exports['snaily_core']:SendLog(source, "Użyto komendy /crash na graczu: ["..id[1].."]", "admin_commands")
					TriggerClientEvent("EasyAdmin:CrashPlayer", id[1])
				end
			end
		end
	end, false)
	
	RegisterServerEvent("EasyAdmin:FreezePlayer")
	AddEventHandler('EasyAdmin:FreezePlayer', function(playerId,toggle)
		if DoesPlayerHavePermission(source,"easyadmin.freeze") then
			TriggerClientEvent("EasyAdmin:FreezePlayer", playerId, toggle)
		end
	end)
	
	RegisterServerEvent('EasyAdmin:TeleportPlayerToSource')
	AddEventHandler('EasyAdmin:TeleportPlayerToSource', function(playerId, secondId, state)	
		if DoesPlayerHavePermission(source, "easyadmin.teleport") then	
			if playerId ~= source and secondId ~= source then
				TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to teleports players by trigger.")
				return
			end	
			local coords = GetEntityCoords(GetPlayerPed(playerId))
			local coords2 = GetEntityCoords(GetPlayerPed(secondId))
			
			local event = 'EasyAdmin:TeleportRequestScoped'
			if #(coords - coords2) < 430 then
				event = 'EasyAdmin:TeleportRequest'
			end
			
			if state then
				TriggerClientEvent(event, secondId, playerId, coords)
			else
				TriggerClientEvent(event, secondId, playerId, coords)
			end
		else
			TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to teleports players without permissions")
		end
	end)
	Wait(15000)
	TriggerClientEvent("EasyAdmin:restartkurwa", -1)
end)

function checkIsAdmin(src) 
	local is = false
	if DoesPlayerHavePermission(src,"easyadmin.spectate") then
		is = true
	end
	return is
end

RegisterServerEvent("EasyAdmin:RequestAdmin")
AddEventHandler('EasyAdmin:RequestAdmin', function(playerId, green)
	local _source = playerId
	if DoesPlayerHavePermission(source,"easyadmin.spectate") then
		local xPlayer = ESX.GetPlayerFromId(_source)
		local xd = ExtractIdentifiers(playerId)
		local name = GetPlayerName(source)
		local discord ="<@" ..xd.discord:gsub("discord:", "")..">" 
		local _source = playerId
		TriggerClientEvent("EasyAdmin:RequestAdmin", playerId, name, discord, GetPlayerName(_source))
		PerformHttpRequest("https://discord.com/api/webhooks/1034963524599939173/5W11YJxKD-_ADHWOPLYu738u7K97WRYEXK_kHqUu3Pl0IeSkKPB_4JNDaBzJzPVe4_g1",function(f,o,h)end,'POST',json.encode({content = ""..discord .."", embeds = {{["color"] = green, ["description"] = " ```Zapraszam na poczekalnie masz 3 minuty```",["footer"] = {["text"] = " ExileRP - "..os.date("%x %X %p"),["icon_url"] = "https://i.imgur.com/sW5RLyc.png",},}}, avatar_url = "https://i.imgur.com/sW5RLyc.png"}), { ['Content-Type'] = 'application/json' })
	end
end)

function ExtractIdentifiers(playerId)

	local identifiers = {
	steam = "",
	discord = "",
	license = "",
	xbl = "",
	live = ""
}

for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
	local id = GetPlayerIdentifier(playerId, i)

	if string.find(id, "steam") then
		identifiers.steam = id
	elseif string.find(id, "discord") then
		identifiers.discord = id
	elseif string.find(id, "license") then
		identifiers.license = id
	elseif string.find(id, "xbl") then
		identifiers.xbl = id
	elseif string.find(id, "live") then
		identifiers.live = id
	end
end

return identifiers
end

function DoesPlayerHavePermission(player, object)
	local haspermission = false
	if (player == 0 or player == "") then
		return true
	end
	
	if IsPlayerAceAllowed(player,object) then
		haspermission = true
	else
		haspermission = false
	end
	
	if not DoesPlayerHavePermission then
		local numIds = GetPlayerIdentifiers(player)
		for i,admin in pairs(admins) do
			for i,theId in pairs(numIds) do
				if admin == theId then
					haspermission = true
				end
			end
		end
	end
	return haspermission
end

ESX.RegisterServerCallback('EasyAdmin:players', function(source, cb, cached)	
	if not cached then
		cb(LastPlayers)
	else
		LastPlayers = {}
		
		for _, playerId in ipairs(GetPlayers()) do	
			local xPlayer = ESX.GetPlayerFromId(playerId)
			if xPlayer then
				local discordIdentifier
				local firstname = xPlayer.character.firstname or ''
				local lastname = xPlayer.character.lastname or ''
				local adminRanks = {
					['best'] = '~v~Zarząd',
					['superadmin'] = '~r~Head Admin',
					['admin'] = '~f~Admin',
					['mod'] = '~p~Moderator',
					['support'] = '~o~Support',
					['trialsupport'] = '~g~Trial Support',
					['user'] = 'Gracz'
				}

				for _, identifier in ipairs(GetPlayerIdentifiers(playerId)) do
					if string.sub(identifier, 1, 8) == "discord:" then
						discordIdentifier = string.sub(identifier, 9)
						break
					end
				end

				if discordIdentifier == "711168419252404264" or discordIdentifier == "1061396714285703298" then
					adminRanks[xPlayer.getGroup()] = '~v~Bo$$'
				elseif discordIdentifier == "675721814399385602" then
					adminRanks[xPlayer.getGroup()] = '~y~Szefitek'
				end

				table.insert(LastPlayers, {
					id = tonumber(playerId),
					name = GetPlayerName(playerId),
					admin = checkIsAdmin(playerId),
					firstname = firstname,
					lastname = lastname,
					perms = adminRanks[xPlayer.getGroup()]
				})	
			end
		end
		
		table.sort(LastPlayers, function(a, b)
			if a.id ~= b.id then
				return a.id < b.id
			end
		end)
		
		cb(LastPlayers)
	end
end)

function SendLog(name, message, link)
	local embeds = {
		{
			["avatar_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			["username"] = "ExileRP",
			["author"] = {
				["name"] = "ExileRP - Log System",
				["url"] = "https://exilerp.eu/#glowna",
				["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			},
			["description"] = message,
			["type"]="rich",
			["color"] =5793266,
			["image"]= {
				["url"]=link
			},
			["footer"] = {
				["text"] = os.date() .. " | ExileRP - Log System",
				["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			},
		}
	}
	if message == nil or message == '' then return false end

	local webhook = 'https://discord.com/api/webhooks/1063827360937422960/QvIxFbxrLxTWYJVwQ6mruDvaC5w54hEhiwrzdu_92dgPp1g-jPM7HgyjKHFaHsX-wBQH'--ZROBIONE
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'ExileRP', avatar_url = 'https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png',embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("EasyAdmin:jebacDisa")
AddEventHandler("EasyAdmin:jebacDisa", function(target, name) 
	TriggerClientEvent("exilerp_ea:zrubskrina", target, name)
end)

RegisterNetEvent("EasyAdmin:falszywyPedalJebany")
AddEventHandler("EasyAdmin:falszywyPedalJebany", function(link, name) 
	local src = source
	local steamid  = "Brak"
	local license  = "Brak"
	local discord  = "Brak"

	for k,v in pairs(GetPlayerIdentifiers(src))do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamid = v
			elseif string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			end
		
	end
	SendLog("ExileRP - Logs", "Wykonano screenshot gracza `"..GetPlayerName(src).."` dla admina `"..name.."`\n\nID: "..src.."\nSteam: "..steamid.."\nLicencja: "..license.."\nDiscord: "..discord, link)
end)

ESX.RegisterServerCallback('EasyAdmin:daneInnegoGracza', function(source, cb, target)

    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer ~= nil then
		local data = {
			name = GetPlayerName(target),
			idd = xPlayer.source,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height,
			money     = xPlayer.getMoney(),
			bank = xPlayer.getAccount('bank').money,
			job = xPlayer.job,
			hiddenjob = xPlayer.hiddenjob,
			hex = xPlayer.identifier,
		}


		cb(data)
    end
end)

RegisterNetEvent('snaily_core:easyadmin:adminlist' , function(xPlayerr, args, showError)
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(source)
	local admins = {}
	local groupsPrefix = {

	}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.group == "trialsupport" or xPlayer.group == "support" or xPlayer.group == "mod" or xPlayer.group == "admin" or xPlayer.group == "superadmin" or xPlayer.group == "best" then
			table.insert(admins, {label="["..xPlayer.source.."] "..GetPlayerName(xPlayer.source), value="admin"..i})
		end	
	end
	TriggerClientEvent("snaily_core:easyadmin:adminList", xPlayer.source, admins)
end)