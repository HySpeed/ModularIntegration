-- Valdation functions called by modules

local Constants = require( "common.constants" )

local Validators = {}

-- =============================================================================

local function incrementRetries( task )
  if task.delay > 0 then return end -- only check retries if delay is complete
  if Constants.DEV then game.print( { "", {"mi-text.name"}, {"mi-text.retry"}, task.action, ": ", task.player.name } ) end
  task.delay = task.delay + settings.global["mi_max_retries"].value
  if task.retries < settings.global["mi_max_retries"].value then
    task.retries = task.retries + 1
  else
    task.retries = -100
  end
  return task
end

-- =============================================================================

-- Player may have disconnected during delay
function Validators.reValidatePlayer( player )
  if not player or not player.connected or not player.character then 
    game.print( { "", {"mi-text.name"}, {"mi-error.player_not_available"} }, Constants.COLOR.ERROR )
    return false
  end
  return true
end

-- -----------------------------------------------------------------------------

-- Ensure the value is a number of at least the provided value
function Validators.validateAmount( value, min_amount )
  if type( value ) ~= "number" then
    game.print( { "", {"mi-text.name"}, {"mi-error.value_not_number", value} }, Constants.COLOR.ERROR )
    return false
  end
  if value < min_amount then
    game.print( { "", {"mi-text.name"}, {"mi-error.value_not_positive_number", value} }, Constants.COLOR.ERROR )
    return false
  end
  return true
end

-- -----------------------------------------------------------------------------

-- Ensure the ammo type is supported
function Validators.validateAmmoType( ammo_type )
  if not Constants.TURRETS.AMMO[ammo_type] then
    game.print( { "", {"mi-text.name"}, {"mi-error.ammo_type_not_valid", ammo_type} }, Constants.COLOR.ERROR )
    return false
  end
  return true
end

-- -----------------------------------------------------------------------------

-- Ensure the distance is supported
function Validators.validateDistance( distance )
  if not Constants.DISTANCE[distance] then
    game.print( { "", {"mi-text.name"}, {"mi-error.distance_not_valid", distance} }, Constants.COLOR.ERROR )
    return false
  end
  return true
end

-- -----------------------------------------------------------------------------

function Validators.validateMessage( message )
  if type( message ) ~= "string" then message = "" end
  if message == "" then
    game.print( { "", {"mi-text.name"}, {"mi-error.show_simple_message_fail"} }, Constants.COLOR.ERROR )
    return false
  end
  return true
end

-- -----------------------------------------------------------------------------

-- if the player does not have a character or health is 0, setup a retry
function Validators.validateCharacter( task )
  if not task.player.character then
    incrementRetries( task )
  elseif task.player.character.health == 0 then
    incrementRetries( task )
  end
end

-- -----------------------------------------------------------------------------

-- Ensure the entity name in the prototypes
function Validators.validateEntityName( entity_name )
  if not game.entity_prototypes[entity_name] then
    game.print( { "", {"mi-text.name"}, {"mi-error.entity_name_not_found", entity_name} }, Constants.COLOR.ERROR )
    return false
  end
  return true
end

-- -----------------------------------------------------------------------------

-- Ensure the item name in the prototypes
function Validators.validateItemName( item_name )
  if not game.item_prototypes[item_name] then
    game.print( { "", {"mi-text.name"}, {"mi-error.item_name_not_found", item_name} }, Constants.COLOR.ERROR )
    return false
  end
  return true
end

-- -----------------------------------------------------------------------------

-- Ensure given player name is in the game
function Validators.validatePlayerName( player_name )
  local player = nil
  if player_name then
    player = game.players[player_name]
    if not player then
      game.print( { "", {"mi-text.name"}, {"mi-error.player_not_found", player_name} }, Constants.COLOR.ERROR )
    end
    else
    game.print( { "", {"mi-text.name"}, {"mi-error.player_name_required"} }, Constants.COLOR.ERROR )
  end
return player
end

-- -----------------------------------------------------------------------------

-- Ensure surface name is valid
function Validators.validateSurfaceName( surface_name )
  local surface = nil
  if surface_name and type( surface_name ) == "string" then
    surface = game.surfaces[surface_name]
    if not surface then
      game.print( { "", {"mi-text.name"}, {"mi-error.surface_not_found", surface_name} }, Constants.COLOR.ERROR )
    end
    else
    game.print( { "", {"mi-text.name"}, {"mi-error.surface_name_required"} }, Constants.COLOR.ERROR )
  end
  return surface
end

-- =============================================================================

return Validators
