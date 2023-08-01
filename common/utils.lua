-- Utility functions called by other functions

local Constants  = require( "common.constants"   )
local Validators = require( "common.validators"  )
local on_tick_n  = require( "__flib__.on-tick-n" )

local Utils = {}

-- =============================================================================

-- Decides between retry, delay (add back to the on_tick queue), or perform action
function Utils.chooseDelayOrAction( task, fail_message, action_function )
  Validators.validateCharacter( task ) -- on error: print message, increase delay & retries
  if task.retries < 0 then
    Utils.showMessagesToPlayer( task.player, fail_message, Constants.ERROR )
    return
  end

  if task.delay >= 1 then
    task.delay = math.max( 0, task.delay - 1 )
    on_tick_n.add( game.tick + 60, task )
  else
    action_function( task )
  end
end

-- -----------------------------------------------------------------------------

function Utils.getRandomPositionInRange( position, range )
  local  x = position.x - range / 2
  local  y = position.y - range / 2
  local x2 = position.x + range / 2
  local y2 = position.y + range / 2
  return {x = math.random(x, x2), y = math.random(y, y2)}
end

-- -----------------------------------------------------------------------------

-- if driving and force evict, evict.  
-- If no force evict or still driving, error.
function Utils.isInVehicle( task, fail_message )
  local player = task.player
  if task.force_evict and player.vehicle ~= nil then
    player.driving = false
  end

  if player.vehicle ~= nil then
    game.print( { "", {"xti-text.name"}, fail_message, task.player.name } )
    Utils.showTextOnPlayer( task.player, fail_message, Constants.OFFSET.BELOW, Constants.COLOR.ERROR )
    return true
  end
  return false
end

-- -----------------------------------------------------------------------------

function Utils.spillStack( player, inventory, item_force )
  local dropped_count = 0
  local dropped = nil

  for index = 1, #inventory do
    dropped = player.surface.spill_item_stack( player.position, inventory[index], false, item_force, false )
    if dropped ~= nil then
      dropped_count = dropped_count + #dropped
    end
  end

  inventory.clear()
  return dropped_count
end

-- -----------------------------------------------------------------------------

function Utils.positionAdd( pos, vec )
  return {(pos[1] + vec[1]), (pos[2] + vec[2]) }
end

-------------------------------------------------------------------------------

function Utils.positionToChunkTileArea( position )
  local x, y = (position.x or position[1]), (position.y or position[2])
  local left_top = { x = math.floor(x), y = math.floor(y) }
  local right_bottom = { x = left_top.x + 31, y = left_top.y + 31 }
  return { left_top = left_top, right_bottom = right_bottom }
end

-- -----------------------------------------------------------------------------

-- prints action, result, or error message in chat and shows message on player
function Utils.showMessagesToPlayer( player, message, message_type )
  if message_type == Constants.ACTION then
    game.print( { "", {"mi-text.name"}, message, {"mi-text.action"}, player.name } )
    Utils.showTextOnPlayer( player, message )
  elseif message_type == Constants.RESULT then
    game.print( { "", message} )
    Utils.showTextOnPlayer( player, message, Constants.OFFSET.MIDDLE )
  else
    game.print( { "", {"mi-text.name"}, message, player.name }, Constants.COLOR.ERROR )
    Utils.showTextOnPlayer( player, message, Constants.OFFSET.BELOW, Constants.COLOR.ERROR )
  end
end

-- -----------------------------------------------------------------------------

function Utils.showTextOnPlayer( player, message, offset, color, scale, duration )
  if not player or not player.connected or not player.character or #message == 0  then return end
  if not color  then color  = Constants.COLOR.NEUTRAL end
  if not offset then offset = Constants.OFFSET.ABOVE end
  if #message > 5 then scale = 1 else scale = 1.7 end
  if not duration then duration = Constants.TIME.SECONDS_3 end

  rendering.draw_text{
    text = message, surface = player.surface, target = player.character, time_to_live = duration,
    forces = {player.force}, color = color, scale_with_zoom = true, alignment = "center",
    target_offset = offset, scale = scale
  }
end

-- -----------------------------------------------------------------------------

function Utils.skipIntro()
  if remote.interfaces["freeplay"] then -- In "sandbox" mode, freeplay is not available
    remote.call( "freeplay", "set_disable_crashsite", true ) -- removes crashsite and cutscene start
    remote.call( "freeplay", "set_skip_intro", true )        -- Skips popup message to press tab to start playing
  end
end

-- =============================================================================

return Utils
