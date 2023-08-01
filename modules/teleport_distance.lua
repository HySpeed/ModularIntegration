-- Functions related to teleport distance

local Constants  = require( "common.constants" )
local Utils      = require( "common.utils" )
local Validators = require( "common.validators" )

local action_message = {"mi-text.teleport_distance"}
local fail_message   = {"mi-error.teleport_distance_fail"}

local TeleportDistance = {}

-- =============================================================================

-- Perform the action
function TeleportDistance.action( task )
  if not Validators.reValidatePlayer( task.player ) then return end -- will display error
  if Constants.DEV then Utils.showMessagesToPlayer( task.player, action_message, Constants.ACTION ) end

  local player  = task.player
  local surface = task.player.surface
  local current_attempt = 0

  if not Utils.isInVehicle( task, fail_message ) then
    while current_attempt < Constants.MAX_TP_ATTEMPTS do
      local destination = Utils.getRandomPositionInRange( player.position, task.distance )
      current_attempt = current_attempt + 1
      local target = surface.find_non_colliding_position( Constants.CHARACTER, destination, 8, .25)
      if target and player.teleport( target, surface ) then
        player.force.chart( surface, Utils.positionToChunkTileArea( target ) )
        Utils.showMessagesToPlayer( task.player, {"mi-text.teleport_distance", task.distance}, Constants.RESULT )
        return -- If we get here we have teleported and we can return out of the function
      end
    end

    -- If here then the teleport has failed more than MAX_TP_ATTEMPTS times
    Utils.showMessagesToPlayer( task.player, fail_message, Constants.ERROR )
  end
end

-- -----------------------------------------------------------------------------

-- Decides between retry, delay (add back to the on_tick queue), or perform action
function TeleportDistance.choose( task )
  Utils.chooseDelayOrAction( task, fail_message, TeleportDistance.action )
end

-- -----------------------------------------------------------------------------

-- External interface for action
function TeleportDistance.start( player_name, delay, distance, force_evict )
  if Constants.DEV then game.print( { "", {"mi-text.name"}, action_message, {"mi-text.start"}, player_name } ) end
  if settings.global["mi_teleport_distance"].value ~= true then return end

  -- validations (on error, most will display a message and return nil or false)
  local player = Validators.validatePlayerName( player_name )
  if not player then return end
  if type( delay ) ~= "number" then delay = 0 end
  if not Validators.validateAmount( distance, 0 ) then return end
  if type( force_evict ) ~= "boolean" then force_evict = true end

  player.play_sound( {path = "teleport-distance-wave"} )

  -- create task
  local task = {
    action  = "teleport_distance",
    player  = player,
    delay   = delay,
    retries = 0,
    distance = distance,
    force_evict = force_evict
  }
  Utils.chooseDelayOrAction( task, fail_message, TeleportDistance.action )
end

-- =============================================================================

return TeleportDistance

-- #############################################################################

-- testing notes / console commands:

--[[ Special testing setup commands:
  /c remote.call( "modular_integration", "teleport_distance", "hyspeed", 0, 50 )
  /c game.player.insert( { name="car", count = 1 } )
  /c remote.call( "modular_integration", "teleport_distance", "hyspeed", 0, 50, false ) -- no evict
  /c remote.call( "modular_integration", "teleport_distance", "hyspeed", 0, 50, true  )  -- evict
]]

--[[ Error handling: 
  /c remote.call( "modular_integration", "teleport_distance" )
  > Expected Result: "ERROR! Player name required"
  /c remote.call( "modular_integration", "teleport_distance", "invalid_name" )
  > Expected Result: "ERROR! Player not found: ' invalid_name '"
  /c remote.call( "modular_integration", "teleport_distance", "hyspeed", x )
    Note: invalid values for 'delay' result in a delay of 0.
  > Expected Result: "ERROR! Teleport distance required"
  /c remote.call( "modular_integration", "teleport_distance", "hyspeed", 0, x )
  > Expected Result: "ERROR! Teleport distance required"
  /c remote.call( "modular_integration", "teleport_distance", "hyspeed", 0, "x" )
  > Expected Result: "ERROR! Teleport distance is not valid"
  /c remote.call( "modular_integration", "teleport_distance", "hyspeed", 0, -3 )
  > Expected Result: "ERROR! Teleport distance is not valid"
  /c remote.call( "modular_integration", "teleport_distance", "hyspeed", 0, 50, x )
  > Expected Result: Evict from vehicle is fale
]]
