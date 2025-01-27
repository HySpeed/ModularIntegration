# Modular Integration

A Factorio mod that accepts external commands to perform actions in the game.

This mod requires an external source to call the remote commands.

## Table of Contents

- [Available Functions](#available-functions)
  - [dump_inventory](#dump_inventory)
  - [fill_inventory](#fill_inventory)
  - [teleport_distance](#teleport_distance)

## Available Functions

Bold parameters are mandatory.  Optional parameters that are not provided will use default values.

---

### **dump_inventory**

Empties the player's inventory onto the ground around the player.
Option for delay before event.  
Option to mark items for deconstruction.

#### Checks / Limits

- Player is not dead.

#### Parameters

- **player** : The **name** of the player.
- **delay**  : The time in seconds to delay this action. 
- decon_items: Whether to mark the items for deconstruction.  Default is "false".

#### Examples

- Dump the player's inventory, after a 0 second delay, not marking them for deconstruction.

> `remote.call( "modular_integration", "dump_inventory", "hyspeed", 0, false )`

---

### **fill_inventory**

Fill the player's inventory with the specified item.
Option for delay before event.
Items that cannot be added are ignored (e.g. not enough space).

#### Checks / Limits

- Player is not dead.

#### Parameters

- **player**: The **name** of the player.
- **delay**: The time in seconds to delay this action.
- **item**: The name of the item to be added to the player's inventory

#### Examples

- Fill player's inventory with pistols after a delay of 0 seconds.

> `remote.call( "modular_integration", "fill_inventory", "hyspeed", 0, "pistol" )`

### **teleport_distance**

Moves the player a distance (in game tiles) from their current posision.
Options for evict from vehicle, delay before event.

#### Checks / Limits

- Player is not dead.
- Ensure teleport destination position is valid for the player.

#### Parameters

- **player**: The **name** of the player.
- **delay**: The time in seconds to delay this action.  Default is 0.  (no delay)
- **distance**: The distance (in game tiles) of the teleport.
- force_exit: Whether to force the player out of current vehicle (if any).  Default is "true".  The teleport will fail if the player is in a vehicle and cannot be evicted.

#### Examples

- Teleport the player, after a delay of 0 seconds, a distance of 50  tiles on their current surface, forcing an exit from a vehicle:

> `remote.call( "modular_integration", "teleport_distance", "hyspeed", 0, 50, true )`

---

### **spawn_turret**

Spawn Enemy turrets around the player.  Specify quantity, turret type, ammo, and distance.
Option for delay before event.

#### Checks / Limits

- The spawned turrets will not destroy existing structures when created.  They will not attack non-military buildings.

#### Parameters

- **player**     : The **name** of the player.
- **delay**      : The time in seconds to delay this action.
- **quantity**   : The number of turrets to create.
- **turret_type**: They type of turret.  One of 'gun-turret', ~~'laser-turret'~~, 'flamethrower-turret', 'artillery-turret'.
- **ammo_type**  : The ammunition type to load into the turret.  Only used for 'gun turret.  One of 'firearm-magazine', 'piercing-rounds-magazine', 'uranium-rounds-magazine'.
- **distance**   : The number of tiles from the player.  The turrets are placed randomly in rough circle around the player. One of 'close' (5 tiles), 'near' (10 tiles), 'medium' (20 tiles), 'distant' (40 tiles), 'far' (80 tiles).


#### Examples

- Spawn 4 Gun Turret with Yellow near the player with no delay:

> `remote.call( "mi", "spawn_turret", "hyspeed", 0, 4, "gun-turret", "firearm-magazine", "near" )`

- Spawn 6 Flamethrower Turrets medium distance with no delay:

> `remote.call( "mi", "spawn_turret", "hyspeed", 0, 6, "flamethrower-turret", nil, "medium" )`

- Spawn 2 Artillery Turrets far from the player with no delay:

> `remote.call( "mi", "spawn_turret", "hyspeed", 0, 2, "artillery-turret", nil, "far" )`

---
---

### **_template_**

(description)
Option for delay.

#### Checks / Limits

- <c/l>

#### Parameters

- **player**:  The **name** of the player.
- **delay**:   The time in seconds to delay this action.
- **message**: The message to display.
- parm4:       parameter #4

#### Examples

- example

> `remote.call( "modular_integration", "<function>", "player_name", 0, "<message>", parm4 )`

/sc local player = game.players[1]; player.zoom_to_world( player.position, 0.3 )

---
