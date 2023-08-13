---Settings

local Constants = require( "common.constants" )

-- runtime-global settings (can be changed in game)
data:extend {
  {
    name          = "mi_max_retries",
    setting_type  = "runtime-global",
    type          = "int-setting",
    default_value = 5,
    order         = "mi-a-mr"
  },
  {
    name          = "mi_retry_delay",
    setting_type  = "runtime-global",
    type          = "int-setting",
    default_value = 3,
    order         = "mi-a-rd"
  },
  {
    name          = "mi_dump_inventory",
    type          = "bool-setting",
    setting_type  = "runtime-global",
    default_value = true,
    order         = "mi-di"
  },
  {
    name          = "mi_fill_inventory",
    setting_type  = "runtime-global",
    type          = "bool-setting",
    default_value = true,
    order         = "mi-fi"
  },
  {
    name          = "mi_spawn_turret",
    setting_type  = "runtime-global",
    type          = "bool-setting",
    default_value = true,
    order         = "mi-st"
  },
  {
    name          = "mi_teleport_distance",
    setting_type  = "runtime-global",
    type          = "bool-setting",
    default_value = true,
    order         = "mi-td"
  }
}
