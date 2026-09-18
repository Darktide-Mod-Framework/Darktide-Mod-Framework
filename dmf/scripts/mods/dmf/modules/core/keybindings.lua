---@class DMFMod
local dmf = get_mod("DMF")

local InputUtils = require("scripts/managers/input/input_utils")

local MODIFIER_KEYS = {
  ["keyboard_left shift"]  = {160, "shift", "keyboard", 161},
  ["keyboard_right shift"] = {160, "shift", "keyboard", 161},
  ["keyboard_shift"]       = {160, "shift", "keyboard", 161},
  ["keyboard_left ctrl"]   = {162, "ctrl",  "keyboard", 163},
  ["keyboard_right ctrl"]  = {162, "ctrl",  "keyboard", 163},
  ["keyboard_ctrl"]        = {162, "ctrl",  "keyboard", 163},
  ["keyboard_left alt"]    = {164, "alt",   "keyboard", 165},
  ["keyboard_right alt"]   = {164, "alt",   "keyboard", 165},
  ["keyboard_alt"]         = {164, "alt",   "keyboard", 165},
}

-- Both are treated equally in keybinds, but these global keys aren't localized
local MODIFIER_KEYS_LOC_ALIAS = {
  keyboard_ctrl  = "keyboard_left ctrl",
  keyboard_alt   = "keyboard_left alt",
  keyboard_shift = "keyboard_left shift",
}

local _raw_keybinds_data = {}
local _keybinds = {}

local ERRORS = {
  PREFIX = {
    function_call = "[Keybindings] function_call 'mod.%s'"
  },
  REGULAR = {
    function_not_found = "[Keybindings] function_call 'mod.%s': function was not found."
  }
}

local SUPPORTED_DEVICES = {
  "keyboard",
  "mouse",
}

local MOUSE_KEY_PREFIX = "mouse "

-- #####################################################################################################################
-- ##### Local functions ###############################################################################################
-- #####################################################################################################################

local function is_in_gameplay_state()
  local ui_manager = Managers.ui

  if not ui_manager then
    return false
  end

  local game_state_name = ui_manager:get_current_state_name()
  local game_sub_state_name = ui_manager:get_current_sub_state_name()

  if game_state_name ~= "StateGameplay" or game_sub_state_name ~= "GameplayStateRun" then
    return false
  end

  local imgui_manager = Managers.imgui

  if imgui_manager and imgui_manager:using_input() then
    return false
  end

  if ui_manager:using_input() then
    return false
  end

  local state_managers = Managers.state
  local cinematic_manager = state_managers and state_managers.cinematic

  if cinematic_manager and cinematic_manager:cinematic_active() then
    return false
  end

  return true
end


-- Executes function for 'function_call' keybinds.
local function call_function(mod, function_name, keybind_is_pressed)
  if type(mod[function_name]) == "function" then
    dmf.safe_call_nr(mod, {ERRORS.PREFIX["function_call"], function_name}, mod[function_name], keybind_is_pressed)
  else
    mod:error(ERRORS.PREFIX["function_not_found"], function_name)
  end
end


-- If check of keybind's conditions is successful, performs keybind's action and returns 'true'.
local function perform_keybind_action(data, is_pressed, in_gameplay_state, active_top_view)
  -- Held keybinds must still receive their release action after gameplay input is blocked.
  local can_perform_action = data.global or data.release_action or in_gameplay_state

  if data.type == "view_toggle" and data.mod:is_enabled() then
    return dmf.keybind_toggle_view(data.mod, data.view_name, can_perform_action, is_pressed, active_top_view)
  end

  if not can_perform_action then
    return
  end

  if data.type == "mod_toggle" and not data.mod:get_internal_data("is_mutator") then
    dmf.mod_state_changed(data.mod:get_name(), not data.mod:is_enabled())
    return true
  elseif data.type == "function_call" and data.mod:is_enabled() then
    call_function(data.mod, data.function_name, is_pressed)
    return true
  end
end


-- #####################################################################################################################
-- ##### Input service functions #######################################################################################
-- #####################################################################################################################

local function is_modifier_pressed(modifier)
  return (Keyboard.button(MODIFIER_KEYS[modifier][1]) + Keyboard.button(MODIFIER_KEYS[modifier][4])) > 0
end

local function default_boolean()
  return false
end

local function default_vector3()
  return Vector3(0, 0, 0)
end

local function default_float()
  return 0
end

local function boolean_combine(value_one, value_two)
  return value_one or value_two
end

local function vector3_combine(value_one, value_two)
  if Vector3.length(value_two) < Vector3.length(value_one) then
    return value_one
  else
    return value_two
  end
end

local function float_combine(value_one, value_two)
  return math.max(value_one, value_two)
end

local ACTION_TYPES = {
  pressed = {
    device_func = "pressed",
    type = "boolean",
    default_device_func = default_boolean,
    combine_func = boolean_combine
  },
  held = {
    device_func = "held",
    type = "boolean",
    default_device_func = default_boolean,
    combine_func = boolean_combine
  },
  released = {
    device_func = "released",
    type = "boolean",
    default_device_func = default_boolean,
    combine_func = boolean_combine
  },
  axis = {
    device_func = "axis",
    type = "vector3",
    default_device_func = default_vector3,
    combine_func = vector3_combine
  },
  button = {
    device_func = "button",
    type = "float",
    default_device_func = default_float,
    combine_func = float_combine
  }
}


local function _enabler_func(cb, action_type, enablers)
  for _, enabler in ipairs(enablers) do
    if not enabler.device:held(enabler.index) then
      return ACTION_TYPES[action_type].default_device_func()
    end
  end

  return cb()
end


local function _disabler_func(cb, action_type, disablers)
  for _, disabler in ipairs(disablers) do
    if disabler.device:held(disabler.index) then
      return ACTION_TYPES[action_type].default_device_func()
    end
  end

  return cb()
end


local function get_corresponding_device(key_id)
  for _, device_type in pairs(SUPPORTED_DEVICES) do

    local device = Managers.input:_find_active_device(device_type)
    if device then

      local index = device:button_index(key_id)
      if index then
        return {
          device = device,
          index = index,
          key_id = key_id,
        }
      end

      index = device:axis_index(key_id)
      if index then
        return {
          device = device,
          index = index,
          key_id = key_id,
        }
      end
    end
  end
end


local function global_key_to_setting_key(global_name)
  local device_type = InputUtils.key_device_type(global_name)
  local local_name = device_type and InputUtils.local_key_name(global_name, device_type)

  if device_type == "mouse" and local_name then
    return MOUSE_KEY_PREFIX .. string.gsub(local_name, "_", " ")
  end

  return local_name
end


local function setting_key_to_global_key(setting_key)
  local mouse_key = string.match(setting_key, "^" .. MOUSE_KEY_PREFIX .. "(.+)$")

  if mouse_key then
    local local_name = string.gsub(mouse_key, " ", "_")
    local global_name = InputUtils.local_to_global_name(local_name, "mouse")

    return get_corresponding_device(global_name) and global_name or nil
  end

  for _, device_type in ipairs(SUPPORTED_DEVICES) do
    local global_name = InputUtils.local_to_global_name(setting_key, device_type)

    if get_corresponding_device(global_name) then
      return global_name
    end
  end
end


local function get_key_info(keybind)
  local main = keybind.main
  local e    = keybind.enablers
  local d    = keybind.disablers

  local info = get_corresponding_device(main)

  if info then
    if #e > 0 then
      local enablers = {}

      for _, key in ipairs(e) do
        local enabler = get_corresponding_device(key)

        if enabler then
          enablers[#enablers + 1] = enabler
        end
      end

      info.enablers = enablers
    end

    if #d > 0 then
      local disablers = {}

      for _, key in ipairs(d) do
        local disabler = get_corresponding_device(key)

        if disabler then
          disablers[#disablers + 1] = disabler
        end
      end

      info.disablers = disablers
    end
  end

  return info
end


local function create_eval_func(keybind)
  local info = get_key_info(keybind)
  if info then

    local eval_func
    if keybind.trigger == "held" then
      eval_func = callback(info.device, keybind.trigger, info.index)
    else
      local function func(device, trigger, index)
        return device[trigger](index)
      end

      eval_func = callback(func, info.device:raw_device(), keybind.trigger, info.index)
    end

    if info.enablers then
      eval_func = callback(_enabler_func, eval_func, keybind.trigger, info.enablers)
    end

    if info.disablers then
      eval_func = callback(_disabler_func, eval_func, keybind.trigger, info.disablers)
    end

    return eval_func
  end
end

-- #####################################################################################################################
-- ##### DMF internal functions and variables ##########################################################################
-- #####################################################################################################################

-- Checks for pressed and released keybinds, performs keybind actions.
-- * Right and left key modifiers (ctrl, alt, shift) are checked separately.
-- * If several mods bound the same keys, keybind action will be performed for all of them when pressed.
-- * Keybind is considered released when it was previously pressed and is no longer.
function dmf.check_keybinds()
  local in_gameplay_state = is_in_gameplay_state()
  local ui_manager = Managers.ui
  local active_top_view = ui_manager and ui_manager:active_top_view()

  -- For every keybind
  for _, keybind_data in ipairs(_keybinds) do

    -- If the keybind is pressed
    if keybind_data.eval_func() then

      if not keybind_data.pressed then
        local action_performed = perform_keybind_action(keybind_data, true, in_gameplay_state, active_top_view)

        -- Queue the release action if applicable
        if action_performed and keybind_data.trigger == "held" then
          keybind_data.release_action = true
        end

        -- Require the keybind to be released before it can be triggered again,
        -- even if its action was blocked when it was initially pressed
        keybind_data.pressed = true
      end

    -- If the keybind was previously but is no longer pressed
    elseif keybind_data.pressed then

      -- Reactivate the keybind
      keybind_data.pressed = nil

      -- Play the release action if applicable
      if keybind_data.release_action then
        perform_keybind_action(keybind_data, false, in_gameplay_state, active_top_view)
        keybind_data.release_action = nil
      end
    end
  end
end


-- Converts manageable (raw) table of keybinds data to a table of callbacks for checking pressed and
-- released keybinds. After initial call it must be called every time some keybind is added/removed.
function dmf.generate_keybinds()
  _keybinds = {}

  for mod, mod_keybinds in pairs(_raw_keybinds_data) do
    for _, raw_keybind_data in pairs(mod_keybinds) do

      local keybind_data = {
        mod       = mod,
        global    = raw_keybind_data.global,
        trigger   = raw_keybind_data.trigger,
        type      = raw_keybind_data.type,
        eval_func = create_eval_func(raw_keybind_data),

        function_name   = raw_keybind_data.function_name,
        view_name       = raw_keybind_data.view_name
      }

      if keybind_data.eval_func then
        table.insert(_keybinds, keybind_data)
      end
    end
  end
end


-- Adds/removes keybinds.
function dmf.add_mod_keybind(mod, setting_id, raw_keybind_data)
  if raw_keybind_data.main then
    _raw_keybinds_data[mod] = _raw_keybinds_data[mod] or {}
    _raw_keybinds_data[mod][setting_id] = raw_keybind_data
  elseif _raw_keybinds_data[mod] and _raw_keybinds_data[mod][setting_id] then
    _raw_keybinds_data[mod][setting_id] = nil
  end

  -- Keybind is changed from Mod Options.
  if dmf.all_mods_were_loaded then
    dmf.generate_keybinds()
  end
end


-- @TODO: So far it seems like any key can be a primary keybind, but is this actually true?
function dmf.can_bind_as_primary_key(key_id)
  return true
end


-- Translate keywatch result to array of setting key names
-- (Used in keybind widget for compatibility with legacy settings)
function dmf.keywatch_result_to_local_keys(keywatch_result)
  local keys = {}

  -- Get the local name of the main key
  if keywatch_result.main then

    local global_name = keywatch_result.main
    local local_name = global_key_to_setting_key(global_name)

    -- Check for a missing or unbindable primary key name
    if not local_name or not dmf.can_bind_as_primary_key(local_name) then
      return keys
    end

    keys[1] = local_name
  end

  -- Add the enablers keys as additional keys
  if keywatch_result.enablers then
    for _, global_name in ipairs(keywatch_result.enablers) do
      local local_name = global_key_to_setting_key(global_name)

      if local_name then
        keys[#keys + 1] = local_name
      end
    end
  end

  return keys
end


-- Translate array of setting key names to keywatch result
-- (Used in keybind widget for compatibility with legacy settings)
function dmf.local_keys_to_keywatch_result(keys)
  local keywatch_result = {
    enablers = {},
    disablers = {}
  }

  if type(keys) ~= "table" or #keys == 0 then
    return nil
  end

  if keys[1] then
    local local_name = keys[1]
    local global_name = setting_key_to_global_key(local_name)

    -- End early if our main key doesn't exist, and return an empty result
    if not global_name then
      return nil
    end

    if MODIFIER_KEYS_LOC_ALIAS[global_name] then
      global_name = MODIFIER_KEYS_LOC_ALIAS[global_name]
    end
    keywatch_result.main = global_name
  end

  -- Add all remaining keys to the enablers list
  for i = 2, #keys do
    local local_name = keys[i]
    local global_name = setting_key_to_global_key(local_name)

    if global_name then
      if MODIFIER_KEYS_LOC_ALIAS[global_name] then
        global_name = MODIFIER_KEYS_LOC_ALIAS[global_name]
      end
      keywatch_result.enablers[#keywatch_result.enablers + 1] = global_name
    end
  end

  return keywatch_result
end
