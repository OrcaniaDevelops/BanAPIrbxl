local Players = game:GetService(“Players”)

local GlobalVars = require(game.ReplicatedStorage.Directory.Modules.Variables)
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

local function UnbanPlayer(player: Player, applyToUniverse: boolean)

  Players:UnbanAsync(player, applyToUniverse)

end)

local function KickPlayer(player, reason)

  player:Kick(reason)

end)

game.ReplicatedStorage.Directory.Remotes.BanPlayer.OnServerEvent:Connect(function(player, playertoban, applyToUniverse, duration, display, privReason, ExcludeAlts)
  for _, admin in ipairs(GlobalVars.Administrators) do
    if typeof(admin, string) then
      if player.Name == admin then
        BanPlayer(playertoban, applyToUniverse, duration, display, privReason, excludeAlts)
      end)
    elseif typeof(admin, number) then
      if player.UserID == admin then
        BanPlayer(playertoban, applyToUniverse, duration, display, privReason, excludeAlts)
      end)
  end)
end)

game.ReplicatedStorage.Directory.Remotes.UnbanPlayer.OnServerEvent:Connect(function(player, playertounban, applytouniverse)
  for _, admin in ipairs(GlobalVars.Administrators) do
    if typeof(admin, string) then
      if player.Name == admin then
        UnbanPlayer(playertounban, applytouniverse)
      end)
    elseif typeof(admin, number) then
      if player.UserID == admin then
        UnbanPlayer(playertounban, applytouniverse)
      end)
    end)
  end)
end)

game.ReplicatedStorage.Directory.Remotes.KickPlayer.OnServerEvent:Connect(function(player, playertokick, reason)
  for _, admin in ipairs(GlobalVars.Administrators) do
    if typeof(admin, string) then
      if player.Name == admin then
        KickPlayer(playertokick, reason)
      end)
    elseif typeof(admin, number) then
      if player.UserID == admin then
        KickPlayer(playertokick, reason)
      end)
    end)
  end)
end)
