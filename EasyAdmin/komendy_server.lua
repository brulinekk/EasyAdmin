ESX.RegisterCommand('goto', {'partner', 'trialsupport', 'support', 'mod', 'starszymod', 'admin', 'starszyadmin', 'superadmin'}, function(xPlayer, args, showError)
    if args.id then
        local xTarget = ESX.GetPlayerFromId(args.id)
		if xPlayer and xTarget then
			local targetCoords = xTarget.coords
			xPlayer.setCoords(targetCoords)
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /goto do gracza: " .. args.id, "admin_commands2")
        end
    end
end, true, {help = "Teleportuj się do gracza", validate = true, arguments = {
    {name = 'id', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('bring', {'partner', 'trialsupport', 'support', 'mod', 'starszymod', 'admin', 'starszyadmin', 'superadmin'}, function(xPlayer, args, showError)
    if args.id then
        local xTarget = ESX.GetPlayerFromId(args.id)
        if xPlayer and xTarget then
            local targetCoords = xPlayer.coords
			xTarget.setCoords(targetCoords)
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /bring na graczu: ["..args.id.."]", "admin_commands2")
        end
    end
end, true, {help = "Teleportuj gracza do siebie", validate = true, arguments = {
    {name = 'id', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('slap', {'best'}, function(xPlayer, args, showError)
    if args.id then
        local xTarget = ESX.GetPlayerFromId(args.id)
        if xPlayer and xTarget then
			local xTarget = ESX.GetPlayerFromId(args.id)
			TriggerClientEvent('EasyAdmin:Slap', xTarget.source)
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /slap na graczu: ["..xTarget.source.."]", "admin_commands")
        end
    end
end, true, {help = "Wyjeb gracza w kosmos", validate = true, arguments = {
    {name = 'id', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('slay', {'best'}, function(xPlayer, args, showError)
    if args.id then
        local xTarget = ESX.GetPlayerFromId(args.id)
        if xPlayer and xTarget then
			local xTarget = ESX.GetPlayerFromId(args.id)
            TriggerClientEvent('EasyAdmin:Slay', xTarget.source)
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /slay na graczu: ["..xTarget.source.."]", "admin_commands")
        end
    end
end, true, {help = "Zabij gracza", validate = true, arguments = {
    {name = 'id', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('tpp', {'partner', 'support', 'mod', 'starszymod', 'admin', 'starszyadmin', 'superadmin'}, function(xPlayer, args, showError)
    if args.steamid and args.targetid then
        local xPlayer = ESX.GetPlayerFromId(args.steamid)
        local xPlayerTarget = ESX.GetPlayerFromId(args.targetid)
        if xPlayer and xPlayerTarget then
            TriggerClientEvent('EasyAdmin:Teleport', xPlayer.source, xPlayerTarget.source)
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /tpp gracza: " .. args.steamid .. " do gracza: " .. args.targetid, "admin_commands2")
        end
    end
end, true, {help = "Teleportuj gracza do gracza", validate = true, arguments = {
    {name = 'steamid', help = "ID gracza 1", type = 'number'},
    {name = 'targetid', help = "ID gracza 2", type = 'number'}
}})

ESX.RegisterCommand('updateplayer', {'best'}, function(xPlayer, args, showError)
	if args.license ~= nil and args.var ~= nil and args.newVar then
		MySQL.update('UPDATE users SET ' .. args.var .. ' = @newVar WHERE identifier = @identifier',{ 
			['@identifier'] = args.license,
			['@newVar'] = args.newVar
		})

		MySQL.query('SELECT digit FROM users WHERE identifier = @identifier', {
			['@identifier'] = args.license
		}, function(result)
			if result then
				MySQL.update('UPDATE characters SET ' .. args.var .. ' = @newVar WHERE identifier = @identifier AND digit = @digit',{ 
					['@identifier'] = args.license,
					['@newVar'] = args.newVar,
					['@digit'] = result[1].digit
				})
			end
		end)
	end
end, true, {help = "Zmień dane gracza", validate = true, arguments = {
	{name = 'license', help = "Licencja steam", type = 'string'},
    {name = 'var', help = "Zmienna do zmiany w bazie", type = 'string'},
    {name = 'newVar', help = "Na jaką zmienną zmieniamy (np. nowe imię)", type = 'string'}
}})

ESX.RegisterCommand('updateplate', {'best'}, function(xPlayer, args, showError)
	if args.oldPlate ~= nil and args.newPlate ~= nil then
		local oldPlate = string.upper(args.oldPlate)
		local newPlate = string.upper(args.newPlate)
		MySQL.update('UPDATE owned_vehicles SET plate = @newPlate, vehicle = JSON_SET(vehicle, "$.plate", @newPlate) WHERE plate = @plate',{ 
			['@plate'] = oldPlate,
			['@newPlate'] = newPlate
		})
		if xPlayer then
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /updateplate " .. oldPlate .. " " .. newPlate, "car")
		end
	end
end, true, {help = "Zmień rejestrację auta", validate = true, arguments = {
    {name = 'oldPlate', help = "Stara rejestracja w cudzysłowiu", type = 'string'},
    {name = 'newPlate', help = "Nowa rejestracja w cudzysłowiu", type = 'string'}
}})


ESX.RegisterCommand('delcar', {'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.Plate ~= nil then
		if xPlayer then
			local Plate = string.upper(args.Plate)
			MySQL.update('DELETE FROM owned_vehicles WHERE plate = @plate',{ 
				['@plate'] = Plate
			})
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /delcar "..Plate, "car")
		else
			local Plate = string.upper(args.Plate)
			MySQL.update('DELETE FROM owned_vehicles WHERE plate = @plate',{ 
				['@plate'] = Plate
			})
		end
	end
end, true, {help = "Usun auto", validate = true, arguments = {
    {name = 'Plate', help = "Rejestracja pojazdu", type = 'string'},
}})


ESX.RegisterCommand('givecar', {'superadmin', 'best'}, function(xPlayer, args, showError)
    if args.steamid and args.targetid then
		local xPlayer = ESX.GetPlayerFromId(args.steamid)
		if xPlayer then
			TriggerClientEvent('esx:spawnVehicle', args.steamid, args.targetid)
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /givecar o modelu: " .. args.targetid .. " dla gracza o id: " .. args.steamid, "car")
		end
	end
end, true, {help = "Daj auto", validate = true, arguments = {
    {name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'},
    {name = 'targetid', help = "SteamID zaczynające się od steam:11", type = 'string'}
}})

ESX.RegisterCommand('cleareq', {'mod', 'starszymod', 'admin', 'starszyadmin', 'superadmin', 'best'}, function(xPlayer, args, showError)
    if args.steamid then
		MySQL.update("UPDATE users SET inventory = '[]', accounts = JSON_SET(accounts, '$.money', 0) WHERE identifier = @identifier",{
			['@identifier'] = args.steamid
		})
		MySQL.update("UPDATE users SET accounts = JSON_SET(accounts, '$.black_money', 0) WHERE identifier = @identifier",{
			['@identifier'] = args.steamid
		})
	end
end, true, {help = "Wyczyść ekwipunek", validate = true, arguments = {
    {name = 'steamid', help = "Licencja gracza (działa tylko na aktywną postać!)", type = 'string'},
}})

--- KOMENDA NA USUWANIE POSTACI - WSZYSTKO PONIŻEJ
local delchartables = { -- Z TABELĄ DIGIT
    { "users", "identifier" },
    { "characters", "identifier" },
    { "owned_properties", "owner" },
    { "owned_vehicles", "owner" },
	{ "user_licenses", "owner" },
}

local delchartables2 = { -- BEZ TABELI DIGIT
	{ "jail", "identifier" },
	{ "lspd_user_judgments", "userId" }, 
}

ESX.RegisterCommand('delchar', {'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.steamid and args.digitid then
		MySQL.query('SELECT digit FROM characters WHERE identifier = @identifier', {
			['@identifier'] = args.steamid
		}, function(result)
			if result[1] then
				if tonumber(result[1].digit) == tonumber(args.digitid) then
					for i in pairs(delchartables) do
						MySQL.update('DELETE FROM ' .. delchartables[i][1] .. ' WHERE ' .. delchartables[i][2] .. ' = "' .. args.steamid .. '" AND digit = ' .. args.digitid .. ';',{ 
						})
					end
					for i in pairs(delchartables2) do
						MySQL.update('DELETE FROM ' .. delchartables2[i][1] .. ' WHERE ' .. delchartables2[i][2] .. ' = "' .. args.steamid .. '";',{ 
						})
					end
					MySQL.query('SELECT digit, accounts, inventory, skin, job, job_level, job_grade, job_id, hiddenjob, hiddenjob_grade, position, firstname, lastname, dateofbirth, sex, height, status, isDead, phone_number, tattoos FROM characters WHERE identifier = @identifier', {
						['@identifier'] = args.steamid
					}, function(swap)
						if swap[1] then
							MySQL.update("UPDATE users SET digit = @digit, accounts = @accounts, inventory = @inventory, skin = @skin, job = @job, job_grade = @job_grade, job_level = @job_level, job_id = @job_id, hiddenjob = @hiddenjob, hiddenjob_grade = @hiddenjob_grade, position = @position, firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height, status = @status, isDead = @isDead, phone_number = @phone_number, tattoos = @tattoos WHERE identifier = @identifier", {
								['@identifier'] = args.steamid,
								['@digit'] = swap[1].digit,
								['@accounts'] = swap[1].accounts,
								['@inventory'] = swap[1].inventory,
								['@skin'] = swap[1].skin,
								['@job'] = swap[1].job,
								['@job_level'] = swap[1].job_level,
								['@job_grade'] = swap[1].job_grade,
								['@job_id'] = swap[1].job_id,
								['@hiddenjob'] = swap[1].hiddenjob,
								['@hiddenjob_grade'] = swap[1].hiddenjob_grade,
								['@position'] = swap[1].position,
								['@firstname'] = swap[1].firstname,
								['@lastname'] = swap[1].lastname,
								['@dateofbirth'] = swap[1].dateofbirth,
								['@sex'] = swap[1].sex,
								['@height'] = swap[1].height,
								['@status'] = swap[1].status,
								['@isDead'] = swap[1].isDead,
								['@phone_number'] = swap[1].phone_number,
								['@tattoos'] = swap[1].tattoos
							})
						end
					end)
				elseif tonumber(result[1].digit) ~= tonumber(args.digitid) then
					for i in pairs(delchartables) do
						MySQL.update('DELETE FROM ' .. delchartables[i][1] .. ' WHERE ' .. delchartables[i][2] .. ' = "' .. args.steamid .. '" AND digit = ' .. args.digitid .. ';',{ 
						})
					end
				end
			end
		end)
	end
end, true, {help = "Usun postac", validate = true, arguments = {
    {name = 'steamid', help = "Licencja steam", type = 'string'},
    {name = 'digitid', help = "Numer postaci", type = 'number'}
}})

ESX.RegisterCommand('przywrocpostac', {'best'}, function(xPlayer, args, showError)
	if args.newlicense ~= nil and args.oldlicense ~= nil then
		MySQL.update('UPDATE users SET identifier = @newlicense WHERE identifier = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE addon_account_data SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE addon_inventory_items SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE characters SET identifier = @newlicense WHERE identifier = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE datastore_data SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE owned_properties SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE owned_properties SET co_owner1 = @newlicense WHERE co_owner1 = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE owned_properties SET co_owner2 = @newlicense WHERE co_owner2 = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE owned_vehicles SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE owned_vehicles SET co_owner = @newlicense WHERE co_owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE owned_vehicles SET co_owner2 = @newlicense WHERE co_owner2 = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE user_licenses SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE lspd_mdc_user_notes SET userId = @newlicense WHERE userId = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.update('UPDATE lspd_user_judgments SET userId = @newlicense WHERE userId = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
	end
end, true, {help = "Przywróć postać gracza", validate = true, arguments = {
	{name = 'newlicense', help = "Nowa licencja", type = 'string'},
    {name = 'oldlicense', help = "Stara licencja", type = 'string'}
}})

ESX.RegisterCommand('revivedist', {'partner', 'trialsupport', 'support', 'mod', 'starszymod', 'admin', 'starszyadmin', 'superadmin', 'best'}, function(xPlayer, args, showError)
    if args.dist then
		if args.dist <= 500 then
			local cache = {}
			for k, xPlayers in pairs(ESX.GetExtendedPlayers()) do 
				cache = xPlayers
				local admincoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
				local distance = #(admincoords - GetEntityCoords(GetPlayerPed(xPlayers.source)))
				if distance < args.dist then
					TriggerClientEvent('esx_ambulancejob:reviveblack', xPlayers.source)
					xPlayers.showNotification("~g~Zostałeś ożywiony przez administratora ~b~"..GetPlayerName(xPlayer.source).."~g~!")
				end
			end
			exports['snaily_core']:SendLog(xPlayer.source, "Użyto komendy /revivedist " .. tonumber(args.dist), "admin_commands")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Za duży dystans :v (>500)")
		end
    end
end, true, {help = "Ożywia graczy w danym dystansie", validate = true, arguments = {
    {name = 'dist', help = "Odległość do reva", type = 'number'},
}})

ESX.RegisterCommand('bitkiaddorg', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.query('SELECT wins,loses FROM bitki WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.update('UPDATE bitki SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins + args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' winy dla organizacji '..args.job, 'bitkimanage', '5793266')
				elseif args.what == 'lose' then
					MySQL.update('UPDATE bitki SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses + args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' lose dla organizacji '..args.job, 'bitkimanage', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj bitki", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile dodac", type = 'string'}
}})

ESX.RegisterCommand('bitkiaddgang', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.query('SELECT wins,loses FROM bitkigang WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.update('UPDATE bitkigang SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins + args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' winy dla gangu '..args.job, 'bitkimanage', '5793266')
				elseif args.what == 'lose' then
					MySQL.update('UPDATE bitkigang SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses + args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' lose dla gangu '..args.job, 'bitkimanage', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj bitki", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile dodac", type = 'string'}
}})


ESX.RegisterCommand('bitkiremoveorg', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.query('SELECT wins,loses FROM bitki WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.update('UPDATE bitki SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins - args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' winow dla organizacji '..args.job, 'bitkimanage', '5793266')
				elseif args.what == 'lose' then
					MySQL.update('UPDATE bitki SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses - args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' lose dla organizacji '..args.job, 'bitkimanage', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj bitki", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile odjac", type = 'string'}
}})

ESX.RegisterCommand('bitkiremovegang', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.query('SELECT wins,loses FROM bitkigang WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.update('UPDATE bitkigang SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins - args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' winow dla gangu '..args.job, 'bitkimanage', '5793266')
				elseif args.what == 'lose' then
					MySQL.update('UPDATE bitkigang SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses - args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' lose dla gangu '..args.job, 'bitkimanage', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj bitki", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile odjac", type = 'string'}
}})

ESX.RegisterCommand('updateorgname', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.label ~= nil and args.number ~= nil then
		MySQL.update('UPDATE bitki SET org_label = @org_label WHERE org_name = @org_name',{ 
			['@org_label'] = '#'..args.number..' '..args.label,
			['@org_name'] = args.job
		})
		MySQL.update('UPDATE jobs SET label = @org_label WHERE name = @org_name',{ 
			['@org_label'] = '#'..args.number..' '..args.label,
			['@org_name'] = args.job
		})
	end
end, true, {help = "Zaktualizuj nazwe organizacji", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'number', help = "Numer z # organizacji (Podaj bez #)", type = 'string'},
	{name = 'label', help = "win/lose", type = 'string'}
}})

ESX.RegisterCommand('spawn', {'partner', 'trialsupport', 'support', 'mod', 'starszymod', 'admin', 'starszyadmin', 'superadmin'}, function(xPlayer, args, showError)
    if args.targetid then
        local xPlayerTarget = ESX.GetPlayerFromId(args.targetid)
        if xPlayerTarget then
			xPlayerTarget.setCoords({x = 196.61701965332, y = -934.19409179688, z = 30.686809539795})
			if xPlayer then
				xPlayerTarget.showNotification('~g~Zostałeś przeteleportowany na urząd przez administratora ~b~'..GetPlayerName(xPlayer.source)..'~g~!')
				exports['snaily_core']:SendLog(xPlayer.source, "Użył komendy /spawn na graczu: ["..args.targetid.."]", 'admin_commands', '5793266')
			end
        end
    end
end, true, {help = "Teleportuj gracza na urząd", validate = true, arguments = {
    {name = 'targetid', help = "ID gracza", type = 'number'}
}})

ESX.RegisterCommand('strefyaddorg', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.query('SELECT wins,loses FROM strefy WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.update('UPDATE strefy SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins + args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' wygrane strefy dla organizacji '..args.job, 'admin_strefy', '5793266')
				elseif args.what == 'lose' then
					MySQL.update('UPDATE strefy SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses + args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' przegrane strefy dla organizacji '..args.job, 'admin_strefy', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj bitki", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile dodac", type = 'string'}
}})

ESX.RegisterCommand('strefyremoveorg', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.query('SELECT wins,loses FROM strefy WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.update('UPDATE strefy SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins - args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' wygrane strefy dla organizacji '..args.job, 'admin_strefy', '5793266')
				elseif args.what == 'lose' then
					MySQL.update('UPDATE strefy SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses - args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' przegrane strefy dla organizacji '..args.job, 'admin_strefy', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj bitki", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile odjac", type = 'string'}
}})

ESX.RegisterCommand('strefyaddgang', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.query('SELECT wins,loses FROM strefy_gangi WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.update('UPDATE strefy_gangi SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins + args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' wygrane strefy dla gangu '..args.job, 'admin_strefy', '5793266')
				elseif args.what == 'lose' then
					MySQL.update('UPDATE strefy_gangi SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses + args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' przegrane strefy dla gangu '..args.job, 'admin_strefy', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj strefy", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile dodac", type = 'string'}
}})

ESX.RegisterCommand('strefyremovegang', {'best', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.query('SELECT wins,loses FROM strefy_gangi WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.update('UPDATE strefy_gangi SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins - args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' wygrane strefy dla gangu '..args.job, 'admin_strefy', '5793266')
				elseif args.what == 'lose' then
					MySQL.update('UPDATE strefy_gangi SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses - args.wartosc,
						['@org_name'] = args.job
					})
					exports['snaily_core']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' przegrane strefy dla gangu '..args.job, 'admin_strefy', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj strefy", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile odjac", type = 'string'}
}})