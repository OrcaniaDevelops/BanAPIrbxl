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

game.ReplicatedStorage.Directory.Remotes.BanPlayer.OnServerEvent:Connect(function(player, playertoban, applyToUniverse, duration, display, privReason, ExcludeAlts)
  for _, admin in ipairs(GlobalVars.Administrators) do
    if player.Name == admin then
      BanPlayer(playertoban, applyToUniverse, duration, display, privReason, excludeAlts)
    end)
  end)
end)
