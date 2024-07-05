-- sickle_manager.lua

SickleManager = {}
SickleManager.__index = SickleManager



local DIRECTIONS = {
    DOWN = { 0, 1 },
    LEFT = { -1, 0 },
    UP = { 0, -1 },
    RIGHT = { 0, 1 }
}


local function make_sickle(_x, _y, _dir, _speed)
    local new_sickle = Sickle:new(_x, _y, _dir, _speed)
    return new_sickle
end

local WAVES = {
    top_left = {
        { 50,  -10, DIRECTIONS.DOWN },
        { 60,  -10, { 0, 1 } },
        { 70,  -10, { 0, 1 } },
        { 100, -10, { 0, 1 } },
    },
    left_low = {
        { -10,  110, { 1, 0 } },
        { -80,  110, { 1, 0 } },
        { -150, 110, { 1, 0 } },
        { -190, 110, { 1, 0 } },
    },
    right_low_single = {
        { 250, 114, { -1, 0 } },
    },
    left_high_single = {
        { 50, -10, { 0, 1 } },
    },
    left_full = {
        { -20,  110, { 1, 0 } },
        { -62,  80,  { 1, 0 } },
        { -130, 110, { 1, 0 } },
        { -150, 110, { 1, 0 } },
        { -170, 110, { 1, 0 } },
    },
    top_right = {
        { 121, -21,  DIRECTIONS.DOWN },
        { 184, -21,  DIRECTIONS.DOWN },
        { 121, -80,  DIRECTIONS.DOWN },
        { 184, -80,  DIRECTIONS.DOWN },
        { 121, -136, DIRECTIONS.DOWN },
        { 187, -136, DIRECTIONS.DOWN },
    },
    top_full_a = {
        { 87,  -17,  { 0, 1 } },
        { 56,  -133, { 0, 1 } },
        { 141, -132, { 0, 1 } },
        { 173, -17,  { 0, 1 } },
        { 56,  -58,  { 0, 1 } },
        { 85,  -185, { 0, 1 } },
        { 170, -184, { 0, 1 } },
        { 142, -58,  { 0, 1 } },
    },
    top_full_b = {
        { 59,  -99,  { 0, 1 } },
        { 117, -47,  { 0, 1 } },
        { 119, -155, { 0, 1 } },
        { 182, -97,  { 0, 1 } },
        { 60,  -13,  { 0, 1 } },
        { 183, -14,  { 0, 1 } },
    },
    right_high = {
        { 347, 106, { -1, 0 } },
        { 538, 78,  { -1, 0 } },
        { 254, 77,  { -1, 0 } },
        { 345, 52,  { -1, 0 } },
        { 436, 81,  { -1, 0 } },
    },
    right_low = {
        { 271, 102, { -1, 0 } },
        { 288, 59,  { -1, 0 } },
        { 346, 59,  { -1, 0 } },
        { 360, 101, { -1, 0 } },
        { 458, 102, { -1, 0 } },
        { 473, 59,  { -1, 0 } },
    },
    left_high = {
        { -200, 90,  { 1, 0 } },
        { -150, 100, { 1, 0 } },
        { -80,  90,  { 1, 0 } },
        { -10,  100, { 1, 0 } },
    },
    final_wave = {
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
    }
}

function SickleManager:new()
    local _sickle_manager = setmetatable({}, SickleManager)
    _sickle_manager.active_sickles = {}
    _sickle_manager.timers = {}
    _sickle_manager.tmr_every_2s = Timer:new(60 * 2,
        function() _sickle_manager:spawn_sickles(WAVES.right_low_single, 180) end, true)

    table.insert(_sickle_manager.timers, _sickle_manager.tmr_every_2s)
    --TODO: Make left side timer for sickle
    _sickle_manager.update_actions = {
        [30] = nil,
        [29] = function() _sickle_manager:spawn_sickles(WAVES.top_left, 100) end,
        [28] = nil,
        [27] = function() _sickle_manager:spawn_sickles(WAVES.top_right, 100) end,
        [26] = function() _sickle_manager.tmr_every_2s:start() end,
        [25] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 130) end,
        [24] = nil,
        [23] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 170) end,
        [22] = nil,
        [21] = function() _sickle_manager:spawn_sickles(WAVES.left_high, 100) end,
        [20] = nil,
        [19] = nil,
        [18] = function() _sickle_manager:spawn_sickles(WAVES.left_full, 150) end,
        [17] = nil,
        [16] = nil,
        [15] = function() _sickle_manager:spawn_sickles(WAVES.top_right, 120) end,
        [14] = nil,
        [13] = function() _sickle_manager:spawn_sickles(WAVES.top_full_a, 120) end,
        [12] = nil,
        [11] = function() _sickle_manager:spawn_sickles(WAVES.top_left, 150) end,
        [10] = nil,
        [9] = nil,
        [8] = nil,
        [7] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 120) end,
        [6] = nil,
        [5] = function() _sickle_manager:spawn_sickles(WAVES.top_full_a, 200) end,
        [4] = nil,
        [3] = function() _sickle_manager:spawn_sickles(WAVES.right_high, 130) end,
        [2] = function() _sickle_manager:spawn_sickles(WAVES.left_full, 150) end,
        [1] = on_player_win,
    }
    _sickle_manager.debug_key_functions = {
        ["1"] = function() _sickle_manager:spawn_sickles(WAVES.top_full_a, 90) end,
        ["2"] = function() _sickle_manager:spawn_sickles(WAVES.top_full_b, 90) end,
        ["3"] = function() _sickle_manager:spawn_sickles(WAVES.top_left, 90) end,
        ["4"] = function() _sickle_manager:spawn_sickles(WAVES.top_right, 90) end,
        ["5"] = function() _sickle_manager:spawn_sickles(WAVES.left_full, 90) end,
        ["6"] = function() _sickle_manager:spawn_sickles(WAVES.left_high, 90) end,
        ["7"] = function() _sickle_manager:spawn_sickles(WAVES.left_low, 90) end,
        ["8"] = function() _sickle_manager:spawn_sickles(WAVES.right_high, 90) end,
        ["9"] = function() _sickle_manager:spawn_sickles(WAVES.right_low, 90) end,
    }

    return _sickle_manager
end

function SickleManager:reset()
    self.tmr_every_2s:stop()

    for k in pairs(self.active_sickles) do
        self.active_sickles[k].body:destroy()
        self.active_sickles[k] = nil
    end
end

function SickleManager:update(dt)
    for t in all(self.timers) do
        t:update()
    end

    for s in all(self.active_sickles) do
        s:update(dt)
        if s.life_timer <= 0 then
            s.body:destroy()
            del(self.active_sickles, s)
        else

        end
    end
end

function SickleManager:draw()
    for s in all(self.active_sickles) do
        s:draw()
    end
end

function SickleManager:on_every_second(seconds_in)
    local action = self.update_actions[seconds_in]
    if action then
        action()
    else
        return
    end
end

function SickleManager:spawn_sickles(pattern, speed)
    for p in all(pattern) do
        local n_s = make_sickle(p[1], p[2], { p[3][1], p[3][2] }, speed)
        table.insert(self.active_sickles, n_s)
    end
end
