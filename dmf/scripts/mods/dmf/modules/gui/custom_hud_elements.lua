local dmf = get_mod("DMF")

local _player_hud
local _elements_data = {}

local ELEMENT_STATUS = table.enum("REGISTERED", "INJECTED")

local ERRORS = {
  THROWABLE = {
    -- inject_hud_element:
    element_already_exists = "hud element with class_name '%s' already exists.",
    visibility_group_already_exists = "visibility group with name '%s' already exists.",
    -- validate_element_data:
    class_name_wrong_type = "'class_name' must be a string, not %s.",
    filename_wrong_type = "'filename' must be a string, not %s.",
    visibility_groups_wrong_type = "'visibility_groups' must be a table, not %s.",
    visibility_groups_key_wrong_type = "'visibility_groups' table keys must be a number, not %s.",
    visibility_groups_value_wrong_type = "'visibility_groups' table values must be a string or table, not %s.",
    custom_visibility_group_name_wrong_type = "'visibility_group.name' must be a string, not %s.",
    custom_visibility_group_validation_function_wrong_type = [[
      'visibility_group.validation_function' must be a function, not %s.
    ]],
    custom_visibility_group_priority_wrong_type = "'visibility_group.priority' must be a number, not %s.",
    use_retained_mode_wrong_type = "'use_retained_mode' must be a boolean or nil, not %s.",
    use_hud_scale_wrong_type = "'use_hud_scale' must be a boolean or nil, not %s.",
    validation_func_wrong_type = "'validation_function' must be a function or nil, not %s."
  },
  PREFIX = {
    element_validation = "[Custom HUD Elements] (register_hud_element) Hud element data validation '%s'",
    element_injection = "[Custom HUD Elements] (inject_hud_element) Hud element injection '%s' ",
    ingamehud_hook_injection = "[Custom HUD Elements] Hud element injection '%s'"
  }
}

-- #####################################################################################################################
-- ##### Local functions ###############################################################################################
-- #####################################################################################################################

local function get_mod_hud_elements(mod)
  return table.filter(_elements_data, function(element_data)
    return element_data.mod == mod
  end)
end

local function remove_injected_hud_elements(mod)

  local visibility_groups_lookup = _player_hud._visibility_groups
  local elements_to_remove = mod and get_mod_hud_elements(mod) or _elements_data

  for element_name, element_data in pairs(elements_to_remove) do
    local element = _player_hud._elements[element_name]

    if element and element_data.status == ELEMENT_STATUS.INJECTED then

      local element_index = table.index_of(_player_hud._elements_array, element)
      if element_index ~= -1 then
        table.remove(_player_hud._elements_array, element_index)
      end

      local element_settings = element_data.element_settings

      if visibility_groups_lookup then
        for _, group_settings in ipairs(element_settings.custom_visibility_groups) do
          local index = table.find_by_key(visibility_groups_lookup, "name", group_settings.name)
          if index then
            table.remove(visibility_groups_lookup, index)
          end
        end

        for _, group_name in ipairs(element_settings.visibility_groups) do
          local _, visibility_group = table.find_by_key(visibility_groups_lookup, "name", group_name)
          local visible_elements = visibility_group and visibility_group.visible_elements

          if visible_elements then
            visible_elements[element_name] = nil
          end
        end
      end

      _player_hud._elements_hud_scale_lookup[element_name] = nil
      _player_hud._elements_hud_retained_mode_lookup[element_name] = nil
      _player_hud._elements[element_name] = nil

      if element.destroy then
        element:destroy(_player_hud._ui_renderer)
      end

      (mod or element_data.mod):remove_require_path(element_settings.filename)

      element_data.status = ELEMENT_STATUS.REGISTERED
    end
  end

end

-- @ THROWS_ERRORS
---@param visibility_groups VisibilityGroupSettings
local function inject_visibility_groups(visibility_groups)
  -- sort by priority desc?
  for i, visibility_group in ipairs(visibility_groups) do
    if table.find_by_key(_player_hud._visibility_groups, "name", visibility_group.name) then
      dmf.throw_error(ERRORS.THROWABLE.visibility_group_already_exists, visibility_group.name)
    end

    table.insert(_player_hud._visibility_groups, visibility_group.priority, {
      name = visibility_group.name,
      validation_function = visibility_group.validation_function
    })
  end

end

-- @ THROWS_ERRORS
---@param element_name string
local function inject_hud_element(element_name)
  local element_data = _elements_data[element_name]
  local element_settings = element_data.element_settings
  local mod = element_data.mod

  if element_data.status == ELEMENT_STATUS.INJECTED or not mod:is_enabled() then
    return
  end

  -- Check for collisions
  if _player_hud._elements[element_name] then
    dmf.throw_error(ERRORS.THROWABLE.element_already_exists, element_name)
  end

  inject_visibility_groups(element_settings.custom_visibility_groups)

  mod:add_require_path(element_settings.filename)
  _player_hud:_verify_elements({ element_settings })
  _player_hud:_setup_element(element_settings)

  element_data.status = ELEMENT_STATUS.INJECTED

  return true
end

-- @ THROWS_ERRORS
---@param element_settings HudElementSettings
local function validate_element_data(element_settings)
  if type(element_settings.class_name) ~= "string" then
    dmf.throw_error(ERRORS.THROWABLE.class_name_wrong_type, type(element_settings.class_name))
  end
  if type(element_settings.filename) ~= "string" then
    dmf.throw_error(ERRORS.THROWABLE.filename_wrong_type, type(element_settings.filename))
  end
  if element_settings.use_retained_mode and type(element_settings.use_retained_mode) ~= "boolean" then
    dmf.throw_error(ERRORS.THROWABLE.use_retained_mode_wrong_type, type(element_settings.use_retained_mode))
  end
  if element_settings.use_hud_scale and type(element_settings.use_hud_scale) ~= "boolean" then
    dmf.throw_error(ERRORS.THROWABLE.use_hud_scale_wrong_type, type(element_settings.use_hud_scale))
  end
  if type(element_settings.visibility_groups) ~= "table" then
    dmf.throw_error(ERRORS.THROWABLE.visibility_groups_wrong_type, type(element_settings.visibility_groups))
  end
  if element_settings.validation_function and type(element_settings.validation_function) ~= "function" then
    dmf.throw_error(ERRORS.THROWABLE.validation_func_wrong_type, type(element_settings.validation_function))
  end

  local visibility_groups = element_settings.visibility_groups
  for key, visibility_group in pairs(visibility_groups) do
    if type(key) ~= "number" then
      dmf.throw_error(ERRORS.THROWABLE.visibility_groups_key_wrong_type, type(key))
    end
    if type(visibility_group) ~= "string" and type(visibility_group) ~= "table" then
      dmf.throw_error(ERRORS.THROWABLE.visibility_groups_value_wrong_type, type(visibility_group))
    end

    if type(visibility_group) == "table" then
      if type(visibility_group.name) ~= "string" then
        dmf.throw_error(ERRORS.THROWABLE.custom_visibility_group_name_wrong_type, type(visibility_group.name))
      end
      if type(visibility_group.validation_function) ~= "function" then
        dmf.throw_error(
          ERRORS.THROWABLE.custom_visibility_group_validation_function_wrong_type,
          type(visibility_group.validation_function)
        )
      end
      if type(visibility_group.priority) ~= "number" then
        dmf.throw_error(ERRORS.THROWABLE.custom_visibility_group_priority_wrong_type, type(visibility_group.priority))
      end
    end
  end

end

-- #####################################################################################################################
-- ##### DMFMod ########################################################################################################
-- #####################################################################################################################

---@class HudElementSettings
---@field class_name          string   @ Name of the class containing the element logic
---@field visibility_groups   string[] @ Array of visibility group names for the element to be included in
---@field use_hud_scale       boolean  @ Set to `true` if the Hud Scale option should apply to the element
---@field use_retained_mode   boolean  @ Set to `true` if your element also uses retained mode (uncommon)
---@field validation_function function @ Determines whether to create the element. Omit to always enable the element

---@class VisibilityGroupSettings
---@field name                string   @ Name of the visibility group
---@field priority            number   @ Index to inject the group into; the first group to pass validation is active
---@field validation_function function @ Return true to enable the group, enabling all elements added to it

--[[
  Validates provided element settings, injects the element, and returns 'true' if everything is correct.
  * element_settings      [table]                          : Settings of the element to register
  ** class_name           [string]              (required) : Name of the class containing the element logic.
  ** visibility_groups    [table<number,string] (required) : Array of visibility group names for the element to be
                                                             included in. "alive" is most common.
  ** use_hud_scale        [boolean]             (optional) : Set to `true` if the Hud Scale option should apply
  ** use_retained_mode    [boolean]             (optional) : Set to `true` if your element uses retained mode (uncommon)
  ** validation_function  [function]            (optional) : Determines whether to create the element.
                                                             Omit to nil to always enable.
--]]
---@param element_settings HudElementSettings @ Settings of the element to register
function DMFMod:register_hud_element(element_settings)
  if dmf.check_wrong_argument_type(self, "register_hud_element", "element_settings", element_settings, "table") then
    return
  end

  element_settings = table.clone(element_settings)

  local element_name = element_settings.class_name

  if not dmf.safe_call_nrc(self,
    {
      ERRORS.PREFIX.element_validation,
      element_name
    },
    validate_element_data,
    element_settings
  ) then
    return
  end

  local custom_visibility_groups = {}
  for i, visibility_group in ipairs(element_settings.visibility_groups) do
    if type(visibility_group) == "table" then
      table.insert(custom_visibility_groups, visibility_group)
    end
  end

  for i, custom_visibility_group in ipairs(custom_visibility_groups) do
    local index = table.index_of(element_settings.visibility_groups, custom_visibility_group)
    if index then
      table.remove(element_settings.visibility_groups, index)
    end
  end

  element_settings.custom_visibility_groups = custom_visibility_groups

  _elements_data[element_name] = {
    mod = self,
    element_settings = element_settings,
    status = ELEMENT_STATUS.REGISTERED
  }

  if _player_hud then
    if not dmf.safe_call_nrc(self,
      {
        ERRORS.PREFIX.element_injection,
        element_name
      },
      inject_hud_element,
      element_name
    ) then
      _elements_data[element_name] = nil

      return
    end
  end

  return true
end

-- #####################################################################################################################
-- ##### Hooks #########################################################################################################
-- #####################################################################################################################

dmf:hook_safe(CLASS.UIHud, "_setup_elements", function(self)
  _player_hud = self
  for element_name, _ in pairs(_elements_data) do
    if not dmf.safe_call_nrc(dmf,
      {
        ERRORS.PREFIX.ingamehud_hook_injection,
        element_name
      },
      inject_hud_element,
      element_name
    ) then
      _elements_data[element_name] = nil
    end
  end
end)

dmf:hook(CLASS.UIHud, "destroy", function(func, self)
  remove_injected_hud_elements()
  _player_hud = nil

  func(self)
end)

-- #####################################################################################################################
-- ##### DMF internal functions and variables ##########################################################################
-- #####################################################################################################################
function dmf.inject_hud_elements(mod)
  if _player_hud then
    local elements_to_inject = get_mod_hud_elements(mod)

    for element_name, element_data in pairs(elements_to_inject) do
      if not dmf.safe_call_nrc(mod,
        {
          ERRORS.PREFIX.element_injection,
          element_name
        },
        inject_hud_element,
        element_name
      ) then
        _elements_data[element_name] = nil
      end
    end
  end
end

function dmf.remove_injected_hud_elements(mod)
  if _player_hud then
    remove_injected_hud_elements(mod)
  end
end

-- #####################################################################################################################
-- ##### Script ########################################################################################################
-- #####################################################################################################################

-- If DMF is reloaded mid-game, get ingame_hud.
_player_hud = Managers.ui and Managers.ui._hud
