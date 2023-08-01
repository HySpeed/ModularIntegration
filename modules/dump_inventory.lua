-- Functions related to dump inventory

local Constants  = require( "common.constants" )
local Utils      = require( "common.utils" )
local Validators = require( "common.validators" )

local action_message = {"mi-text.dump_inventory"}
local fail_message   = {"mi-error.dump_inventory_fail"}

local DumpInventory = {}

-- =============================================================================

-- Perform the action
function DumpInventory.action( task )
  if not Validators.reValidatePlayer( task.player ) then return end -- will display error
  if Constants.DEV then Utils.showMessagesToPlayer( task.player, action_message, Constants.ACTION ) end

  local player = task.player
  local item_force = task.decon_items and player.force or nil
  local dropped_count = 0

  local inventory = player.get_inventory( defines.inventory.character_main )
  dropped_count = Utils.spillStack( player, inventory, item_force )
  dropped_count = dropped_count + Utils.spillStack( player, player.get_inventory( defines.inventory.character_trash ) )

  Utils.showMessagesToPlayer( task.player, {"mi-text.dump_inventory", dropped_count}, Constants.RESULT )
end

-- -----------------------------------------------------------------------------

-- Decides between retry, delay (add back to the on_tick queue), or perform action
function DumpInventory.choose( task )
  Utils.chooseDelayOrAction( task, fail_message, DumpInventory.action )
end

-- -----------------------------------------------------------------------------

-- External interface for action
function DumpInventory.start( player_name, delay, decon_items )
  if Constants.DEV then game.print( { "", {"mi-text.name"}, action_message, {"mi-text.start"}, player_name } ) end
  if settings.global["mi_dump_inventory"].value ~= true then return end

  -- validations (on error, most will display a message and return nil or false)
  local player = Validators.validatePlayerName( player_name )
  if not player then return end
  if type( delay )       ~= "number"  then delay = 0 end
  if type( decon_items ) ~= "boolean" then decon_items = false end

  player.play_sound( {path = "dump-inventory-drop"} )

  -- create task
  local task = {
    action  = "dump_inventory",
    player  = player,
    delay   = delay,
    retries = 0,
    decon_items = decon_items
  }
  Utils.chooseDelayOrAction( task, fail_message, DumpInventory.action )
end

-- =============================================================================

return DumpInventory

-- #############################################################################

-- testing notes / console commands:

--[[
  -- no decon
  /c remote.call( "modular_integration", "dump_inventory", "hyspeed", 0 )
  /c remote.call( "modular_integration", "dump_inventory", "hyspeed", 0, false )
  -- decon
  /c remote.call( "modular_integration", "dump_inventory", "hyspeed", 0, true )
]]

--[[ Special testing setup commands:
  /c local player = game.player;
      player.insert( {name = "rocket-launcher", count = 1} )
      player.insert( {name = "atomic-bomb", count = 10} )
]]

--[[ Error handling:
  /c remote.call( "modular_integration", "dump_inventory" )
  > Expected Result: "ERROR! Player name required"
  /c remote.call( "modular_integration", "dump_inventory", "invalid_name" )
  > Expected Result: "ERROR! Player not found: ' invalid_name '"
  /c remote.call( "modular_integration", "dump_inventory", "hyspeed", x )
  > Note: invalid values for 'delay' result in a delay of 0.
]]
