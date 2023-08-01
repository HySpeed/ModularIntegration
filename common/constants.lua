local Constants = {
  DEV_MODE = true,

  SCALE = 1,

  COLOR = {
    BAD     = {r = 0.8, g = 0.0, b = 0.0},
    NEUTRAL = {r = 0.7, g = 0.7, b = 0.0},
    GOOD    = {r = 0.0, g = 1.0, b = 0.0},
    ERROR   = {r = 0.9, g = 0.0, b = 0.0},
  },

  OFFSET = {
    ABOVE    = {0, -10},
    MIDDLE_H = {0,  -5},
    MIDDLE   = {0,   0},
    MIDDLE_L = {0,   5},
    BELOW    = {0,  10}
  },

  TIME = {
    SECONDS_1  =   60,
    SECONDS_3  =  180,
    SECONDS_5  =  300,
    SECONDS_10 =  600,
    SECONDS_20 = 1200
  },

  MAX_TP_ATTEMPTS = 5,
  CHARACTER =  "character",
  ENEMY     = "enemy",
  ACTION    = "action",
  ERROR     = "error",
  RESULT    = "result"
}

return Constants
