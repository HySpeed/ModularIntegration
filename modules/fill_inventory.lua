-- Functions related to fill inventory

local Constants  = require( "common.constants" )
local Utils      = require( "common.utils" )
local Validators = require( "common.validators" )

local action_message = {"mi-text.fill_inventory"}
local fail_message   = {"mi-error.fill_inventory_fail"}

local FillInventory = {}

-- =============================================================================

-- Perform the action
function FillInventory.action( task )
  if not Validators.reValidatePlayer( task.player ) then return end -- will display error
  if Constants.DEV then Utils.showMessagesToPlayer( task.player, action_message, Constants.ACTION ) end

  local player    = task.player
  local item_name = task.item_name

  local inventory = player.get_main_inventory()
  local number_to_insert = inventory.get_insertable_count( item_name )
  local inserted_count = 0
  if ( number_to_insert > 0 ) then
    inserted_count = inventory.insert( {name=item_name, count=number_to_insert} )
  end
  -- FUTURE if logistics enabled, also fill trash slots

  Utils.showMessagesToPlayer( task.player, {"mi-text.fill_inventory", inserted_count, item_name}, Constants.RESULT )
end

-- -----------------------------------------------------------------------------

-- Decides between retry, delay (add back to the on_tick queue), or perform action
function FillInventory.choose( task )
  Utils.chooseDelayOrAction( task, fail_message, FillInventory.action )
end

-- -----------------------------------------------------------------------------

-- External interface for action
function FillInventory.start( player_name, delay, item_name )
  if Constants.DEV then game.print( { "", {"mi-text.name"}, action_message, {"mi-text.start"}, player_name } ) end
  if settings.global["mi_fill_inventory"].value ~= true then return end

  -- validations (on error, most will display a message and return nil or false)
  local player = Validators.validatePlayerName( player_name )
  if not player then return end
  if type( delay ) ~= "number" then delay = 0 end
  if not Validators.validateItemName( item_name ) then return end

  player.play_sound( {path = "fill-inventory-full"} )

  -- create task
  local task = {
  action  = "fill_inventory",
  player  = player,
  delay   = delay,
  retries = 0,
  item_name = item_name
  }
  Utils.chooseDelayOrAction( task, fail_message, FillInventory.action )
end

-- =============================================================================

return FillInventory

-- #############################################################################

-- testing notes / console commands:

--[[
  /c remote.call( "modular_integration", "fill_inventory", "hyspeed", 0, "pistol" )
]]

--[[ Special testing setup commands:
  /c local player = game.player;
     <command>
]]

--[[ Error handling:
]]
