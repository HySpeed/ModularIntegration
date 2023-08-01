-- Modular Integration
--- Integration mod to interact with the game.

-- Credits:
-- - SilentStorm for Integration Mod to source from (silent-integration-helper)

local Utils     = require( "common.utils" )
local on_tick_n = require( "__flib__.on-tick-n" )

local DumpInventory          = require( "modules.dump_inventory" )
local FillInventory          = require( "modules.fill_inventory" )
local TeleportDistance       = require( "modules.teleport_distance" )


-- =============================================================================

local taskFunctions = {
  dumpInventory    = DumpInventory.choose,
  fillInventory    = FillInventory.choose,
  teleportDistance = TeleportDistance.choose
}

-- -----------------------------------------------------------------------------

local function onTick( event )
  local tasks = on_tick_n.retrieve( event.tick )
  if not tasks then return end
  for _, task in pairs( tasks ) do
    taskFunctions[task.action]( task )
  end
end

-- -----------------------------------------------------------------------------

local function onLoad()
  remote.remove_interface( "modular_integration" )
  remote.add_interface( "modular_integration", {
    dump_inventory=DumpInventory.start,
    fill_inventory=FillInventory.start,
    teleport_distance=TeleportDistance.start
  } )
end

-- =============================================================================

script.on_init( function()
  Utils.skipIntro()
  on_tick_n.init()
  onLoad()
end )

-- -----------------------------------------------------------------------------

script.on_configuration_changed( function()
  game.print( {"mi-text.init"} )
end )

-- -----------------------------------------------------------------------------

script.on_load( onLoad )

-- -----------------------------------------------------------------------------

script.on_event( defines.events.on_tick, onTick )

-- -----------------------------------------------------------------------------

script.on_event( {
    defines.events.on_player_created,
    defines.events.on_player_joined_game
  },
  function( event )
    local player = game.get_player( event.player_index )
    if player and player.connected then
      game.print( {"mi-text.init"} )
    end
end )

-- =============================================================================
