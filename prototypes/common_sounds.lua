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
  teleport_distance_wave
})