-- sounds for actions

local dump_inventory_whistle = {
  type = "sound",
  name = "dump-inventory-drop",
  variations =
  {
    {
      filename = "__ModularIntegration__/sounds/Dump_Inventory-Drop.ogg",
      volume = 1.00
    },
  }
}

local fill_inventory_full = {
  type = "sound",
  name = "fill-inventory-full",
  variations =
  {
    {
      filename = "__ModularIntegration__/sounds/Fill_Inventory-Full.ogg",
      volume = 1.00
    },
  }
}

local spawn_turret_thunk = {
  type = "sound",
  name = "spawn-turret-thunk",
  variations = 
  {
    {
      filename = "__ModularIntegration__/sounds/Spawn_Turret-Thunk.ogg",
      volume = 1.00
    }
  }
}

local teleport_distance_wave = {
  type = "sound",
  name = "teleport-distance-wave",
  variations =
  {
    {
      filename = "__ModularIntegration__/sounds/Teleport_Distance-Wave.ogg",
      volume = 1.00
    },
  }
}


data:extend({
  dump_inventory_whistle,
  fill_inventory_full,
  spawn_turret_thunk,
  teleport_distance_wave
})