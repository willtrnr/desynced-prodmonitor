---@diagnostic disable: undefined-global

return setmetatable(
   {
      ---@type integer
      CC_ACTIVATED = CC_ACTIVATED,
      ---@type integer
      CC_CHANGED_ITEMSLOT_AMOUNT = CC_CHANGED_ITEMSLOT_AMOUNT,
      ---@type integer
      CC_CHANGED_ITEMSLOT_EXTRA = CC_CHANGED_ITEMSLOT_EXTRA,
      ---@type integer
      CC_CHANGED_ITEMSLOT_ITEM = CC_CHANGED_ITEMSLOT_ITEM,
      ---@type integer
      CC_CHANGED_REGISTER_COORD = CC_CHANGED_REGISTER_COORD,
      ---@type integer
      CC_CHANGED_REGISTER_ENTITY = CC_CHANGED_REGISTER_ENTITY,
      ---@type integer
      CC_CHANGED_REGISTER_ID = CC_CHANGED_REGISTER_ID,
      ---@type integer
      CC_CHANGED_REGISTER_NUM = CC_CHANGED_REGISTER_NUM,
      ---@type integer
      CC_FINISH_MOVE = CC_FINISH_MOVE,
      ---@type integer
      CC_FINISH_SLEEP = CC_FINISH_SLEEP,
      ---@type integer
      CC_FINISH_WORK = CC_FINISH_WORK,
      ---@type integer
      CC_LOST_MOVE_CONTROL = CC_LOST_MOVE_CONTROL,
      ---@type integer
      CC_LOST_POWER = CC_LOST_POWER,
      ---@type integer
      CC_OTHER_COMP_FAIL_WORK = CC_OTHER_COMP_FAIL_WORK,
      ---@type integer
      CC_OTHER_COMP_FINISH_WORK = CC_OTHER_COMP_FINISH_WORK,
      ---@type integer
      CC_REFRESH = CC_REFRESH,
      ---@type integer
      CC_WAKEUP = CC_WAKEUP,
      ---@type integer
      CULL_DISTANCE = CULL_DISTANCE,
      ---@type integer
      FRAMEREG_COUNT = FRAMEREG_COUNT,
      ---@type integer
      FRAMEREG_GOTO = FRAMEREG_GOTO,
      ---@type integer
      FRAMEREG_SIGNAL = FRAMEREG_SIGNAL,
      ---@type integer
      FRAMEREG_STORE = FRAMEREG_STORE,
      ---@type integer
      FRAMEREG_VISUAL = FRAMEREG_VISUAL,
      ---@type integer
      REG_INFINITE = REG_INFINITE,
      ---@type integer
      TICKS_PER_SECOND = TICKS_PER_SECOND,
      ---@type integer
      TILES_PER_CHUNK = TILES_PER_CHUNK,
   },
   {
      ---@param self table
      ---@param key string
      ---@return unknown|nil
      __index = function (self, key)
         local v<const> = _ENV[key] or _G[key]
         if v ~= nil then
            -- Memoize the value to ensure idempotency
            rawset(self, key, v)
         end
         return v
      end,
   }
)
