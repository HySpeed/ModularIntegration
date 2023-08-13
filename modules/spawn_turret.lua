-- Functions related to spawn_turret

local Constants  = require( "common.constants" )
local Utils      = require( "common.utils" )
local Validators = require( "common.validators" )

local action_message = {"mi-text.spawn_turret"}
local fail_message   = {"mi-error.spawn_turret_fail"}

local SpawnTurret = {}

-- =============================================================================

local function fill_turret( task, turret )
  local turret_type = task.turret_type

  if     turret_type == Constants.TURRETS.TYPE["gun-turret"] then
    turret.insert( {name = task.ammo_type, count = 200} )
  elseif turret_type == Constants.TURRETS.TYPE["flamethrower-turret"] then
    turret.insert_fluid( {name = game.fluid_prototypes["crude-oil"].name, amount = 100} )
  elseif turret_type == Constants.TURRETS.TYPE["laser-turret"] then
    -- need power  - would need to spawn substation & accumulators with charge
  elseif turret_type == Constants.TURRETS.TYPE["artillery-turret"] then
    turret.insert( {name = "artillery-shell", count = 10} )
  else
    game.print( { "", {"mi-text.name"}, {"mi-error.turret_type_invalid", turret_type} }, Constants.COLOR.ERROR )
    return
  end

end

-- -----------------------------------------------------------------------------

local function spawn_turret( task )
  local player      = task.player
  local surface     = player.surface
  local turret_type = task.turret_type
  local distance    = task.distance

  local target_position = Utils.RandomLocationInRadius( player.position, Constants.DISTANCES[distance] )

  local spawn_position = surface.find_non_colliding_position( turret_type, target_position, 5, 0.1 )
  if spawn_position == nil then
    game.print( { "", {"mi-text.name"}, {"mi-error.turret_spawn_not_valid"} }, Constants.COLOR.ERROR )
    return
  end

  local turret = surface.create_entity({
    name     = turret_type,
    position = spawn_position,
    direction = math.random( 0, 3 ) * 2,
    force    = Constants.ENEMY,
    create_build_effect_smoke = false,
    raise_built = true
  })
  if turret == nil then
    game.print( { "", {"mi-text.name"}, {"mi-error.turret_spawn_failed"} }, Constants.COLOR.ERROR )
    return
  end

  fill_turret( task, turret )

end

-- =============================================================================

-- Perform the action
function SpawnTurret.action( task )
  if not Validators.reValidatePlayer( task.player ) then return end -- will display error
  Utils.showMessagesToPlayer( task.player, action_message, Constants.ACTION )

  local quantity = task.quantity

  for _ = 1, quantity do
    spawn_turret( task )
  end

end

-- -----------------------------------------------------------------------------

-- Decides between retry, delay (add back to the on_tick queue), or perform action
function SpawnTurret.choose( task )
  Utils.chooseDelayOrAction( task, fail_message, SpawnTurret.action )
end

-- -----------------------------------------------------------------------------

-- External interface for action
function SpawnTurret.start( player_name, delay, quantity, turret_type, ammo_type, distance )
  if Constants.DEV then game.print( { "", {"mi-text.name"}, action_message, {"mi-text.start"}, player_name } ) end
  if settings.global["mi_spawn_turret"].value ~= true then return end

  -- validations (on error, most will display a message and return nil or false)
  local player = Validators.validatePlayerName( player_name )
  if not player then return end
  if type( delay ) ~= "number" then delay = 0 end
  if type( quantity ) ~= "number" then quantity = 1 end
  if Validators.validateEntityName( turret_type ) then
    if turret_type == "gun-turret" then
      if not Validators.validateAmmoType( ammo_type ) then return end
    end
  else
    return
  end
  if not Validators.validateDistance( distance ) then return end

  player.play_sound( {path = "spawn-turret-thunk"} )

  -- create task
  local task = {
    action  = "spawn_turret",
    player  = player,
    delay   = delay,
    retries = 0,
    quantity = quantity,
    turret_type = turret_type,
    ammo_type = ammo_type,
    distance = distance
  }
  Utils.chooseDelayOrAction( task, fail_message, SpawnTurret.action )
end

-- =============================================================================

return SpawnTurret

-- =============================================================================

-- testing notes / console commands:

-- /c remote.call( "modular_integration", "spawn_turret", "hyspeed",     0, 2, "gun-turret", "firearm-magazine", "near" )
-- /c remote.call( "modular_integration", "spawn_turret", "hyspeed",     0, 3, "flamethrower-turret", nil, "medium" )
-- /c remote.call( "modular_integration", "spawn_turret", "hyspeed",     0, 1, "artillery-turret", nil, "far" )

--[[ Special testing setup commands:
  /c local player = game.player;
     <command>
]]

--[[ Error handling:
  /c remote.call( "mi", "spawn_turret" )
]]
