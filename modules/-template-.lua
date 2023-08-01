-- Functions related to xTEMPLATEx

--[[
  These changes are needed to other files:

# control.lua:
local XtemplateX = require( "modules.xTEMPLATEx" )

## task_functions
  xtemplateX = XtemplateX.choose,

## onLoad
    xTemplateX=XtemplateX.start,

# locale.en.cfg:
[mi-text]:
xTEMPLATEx=<action label> 

[mi-error]:
xTEMPLATEx_required=ERROR! <parameter> required
xTEMPLATEx_fail=Unable to <action>

# settings.lua
  {
    type = "bool-setting",
    name = "mi_xTEMPLATEx",
    setting_type = "runtime-global",
    default_value = true,
    order = "mi-XtX"
  },
]]

local Constants  = require( "common.constants" )
local Utils      = require( "common.utils" )
local Validators = require( "common.validators" )

local action_message = {"mi-text.xTEMPLATEx"}
local fail_message   = {"mi-error.xTEMPLATEx_fail"}

local XtemplateX = {}

-- =============================================================================

-- Perform the action
function XtemplateX.action( task )
  if not Validators.reValidatePlayer( task.player ) then return end -- will display error
  Utils.showMessagesToPlayer( task.player, action_message, Constants.ACTION )

  local player = task.player

  -- TODO: Implement action function here

end

-- -----------------------------------------------------------------------------

-- Decides between retry, delay (add back to the on_tick queue), or perform action
function XtemplateX.choose( task )
  Utils.chooseDelayOrAction( task, fail_message, XtemplateX.action )
end

-- -----------------------------------------------------------------------------

-- External interface for action
function XtemplateX.start( player_name, delay ) -- TODO add additional parameters here
  if Constants.DEV then game.print( { "", {"mi-text.name"}, action_message, {"mi-text.start"}, player_name } ) end
  if settings.global["mi_xTEMPLATEx"].value ~= true then return end

  -- validations (on error, most will display a message and return nil or false)
  local player = Validators.validatePlayerName( player_name )
  if not player then return end
  if type( delay ) ~= "number" then delay = 0 end
  -- TODO add validations for additional parameters here

  -- create task
  local task = {
    action  = "xTEMPLATEx",
    player  = player,
    delay   = delay,
    retries = 0
  -- TODO add additional parameters to task here
  }
  Utils.chooseDelayOrAction( task, fail_message, XtemplateX.action )
end

-- =============================================================================

return XtemplateX

-- =============================================================================

-- testing notes / console commands:

-- /c remote.call( "modular_integration", "xTEMPLATEx", "PLAYER_NAME", 0, "<message>" )

--[[ Special testing setup commands:
  /c local player = game.player;
     <command>
]]

--[[ Error handling:
  /c remote.call( "modular_integration", "xTEMPLATEx" )
]]
