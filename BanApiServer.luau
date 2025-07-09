
--[[

::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::==:::::::
:::::::::::::::::::::::::::::::::::::@@:::::::
:::::::::::::::::::::::::::::::::::::@@:::::::
::::::::::@%:::::::::::::=@=:::::::::@@:::::::
:::::::@@@::@@@@@:::::@@@:::@@@::::::@@:::::::
::::::@@::::::@@@::::@@:::::::@@:::::@@:::::::
:::::@@::::::::@@:::@@:::::::::@@::::@@:::::::
:::::@@::::::::@@:::@@:::::::::@@::::@@:::::::
::::::@@::::::@@@::::@@:::::::@@::::::::::::::
:::::::@@@@@@@@@@:::::@@@:::@@@::::::@@:::::::
:::::::::::::::@@::::::::-@=::::::::::=:::::::
::::::@:::::::@@::::::::::::::::::::::::::::::
:::::::@@@@@@@@:::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::

--]]

-- Written by OrcaniaDevelops
-- Created 7/9/25
-- Last Updated 7/9/25

local Players = game:GetService(“Players”)

local GlobalVars = require(game.ReplicatedStorage.Directory.Modules.Variables) -- Module that contains all common variables and keys

local BanPlayerEvent = nil -- change nil to the event (do for the following events)
local UnbanPlayerEvent = nil
local KickPlayerEvent = nil

-- Function handling the banning of said player
local function BanPlayer(player: Player, applyToUniverse: boolean, duration: number, display: string, privReason: string, excludeAlts: boolean)
  Players:BanAsync({
      UserIDs = {player.UserID},
      ApplyToUniverse = applyToUniverse,
      Duration = duration,
      DisplayReason = display,
      PrivateReason = privReason,
      ExcludeAltAccounts = excludeAlts
  })
end)

-- Function handling the unbanning of said player
local function UnbanPlayer(player: Player, applyToUniverse: boolean)
  Players:UnbanAsync(player, applyToUniverse)
end)

-- Function kicking said player
local function KickPlayer(player, reason)
  player:Kick(reason)
end)

BanPlayerEvent.OnServerEvent:Connect(function(player, playertoban, applyToUniverse, duration, display, privReason, ExcludeAlts)
  for _, admin in ipairs(GlobalVars.Administrators) do -- Check each instance within the table
    if typeof(admin, string) then -- Using typeof for compatibility with both strings and UserIDs within the "Administrators" table
      if player.Name == admin then -- Check user is verified to run the event
        BanPlayer(playertoban, applyToUniverse, duration, display, privReason, excludeAlts) -- Ban player
      else
        BanPlayer(player, false, 3600, "Possible exploit detected", "User fired event without verification", true) -- Bans player who fired if not verified
      end)
    elseif typeof(admin, number) then
      if player.UserID == admin then
        BanPlayer(playertoban, applyToUniverse, duration, display, privReason, excludeAlts)
      else
        BanPlayer(player, false, 3600, "Possible exploit detected", "User fired event without verification", true)
      end)
  end)
end)

--Event that handles Unbanning
UnbanPlayerEvent.OnServerEvent:Connect(function(player, playertounban, applytouniverse)
  for _, admin in ipairs(GlobalVars.Administrators) do 
    if typeof(admin, string) then
      if player.Name == admin then
        UnbanPlayer(playertounban, applytouniverse)
      else
        BanPlayer(player, false, 3600, "Possible exploit detected", "User fired event without verification", true)
      end)
    elseif typeof(admin, number) then
      if player.UserID == admin then
        UnbanPlayer(playertounban, applytouniverse)
      else
        BanPlayer(player, false, 3600, "Possible exploit detected", "User fired event without verification", true)
      end)
    end)
  end)
end)

-- Event that handles kicking
KickPlayerEvent.OnServerEvent:Connect(function(player, playertokick, reason)
  for _, admin in ipairs(GlobalVars.Administrators) do
    if typeof(admin, string) then
      if player.Name == admin then
        KickPlayer(playertokick, reason)
      else
        BanPlayer(player, false, 3600, "Possible exploit detected", "User fired event without verification", true)
      end)
    elseif typeof(admin, number) then
      if player.UserID == admin then
        KickPlayer(playertokick, reason)
      else
        BanPlayer(player, false, 3600, "Possible exploit detected", "User fired event without verification", true)
      end)
    end)
  end)
end)
