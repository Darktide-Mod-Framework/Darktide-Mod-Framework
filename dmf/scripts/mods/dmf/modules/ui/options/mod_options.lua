local dmf = get_mod("DMF")

local OptionsUtilities = require("scripts/utilities/ui/options")

local _type_template_map = {}

local _devices = {
  "keyboard",
  "mouse",
}

local _cancel_keys = {
  "keyboard_esc"
}

local _reserved_keys = {}

local ERRORS = {
  REGULAR = {
    invalid_widget_type = "[DMF Mod Options] (%s): \"%s\" is not a valid widget type " ..
                                              "in this version of Darktide Mod Framework.",
  },
}

-- ####################################################################################################################
-- ##### Local functions ##############################################################################################
-- ####################################################################################################################

-- #####################
-- ###### Header #######
-- #####################

-- Create header template
local create_header_template = function (self, params)

  local template = {
    category = params.category,
    display_name = params.readable_mod_name or params.title,
    group_name = params.mod_name,
    tooltip_text = params.tooltip,
    widget_type = "group_header",
  }
  return template
end
_type_template_map["header"] = create_header_template

-- ##########################
-- ###### Description #######
-- ##########################

-- Create description template
local create_description_template = function (self, params)

  local template = {
    category = params.category,
    group_name = params.mod_name,
    display_name = params.description,
    widget_type = "description",
    after = params.after
  }
  return template
end
_type_template_map["description"] = create_description_template

-- ##########################
-- ###### Group #############
-- ##########################

-- Create group template
local create_group_template = function(self, params)
  local template = {
    display_name = params.title,
    widget_type = "group_header",
    after = params.parent_index
  }
  return template
end
_type_template_map["group"] = create_group_template

-- ###########################
-- ###### Percent Slider #####
-- ###########################

-- Create percentage slider template
local create_percent_slider_template = function (self, params)

  params.on_value_changed_function = function(new_value)
    get_mod(params.mod_name):set(params.setting_id, new_value, true)

    return true
  end
  params.value_get_function = function()
    return get_mod(params.mod_name):get(params.setting_id)
  end

  params.display_name = params.title
  params.apply_on_drag = true
  params.default_value = params.default_value
  params.normalized_step_size = 1 / 100

  local template = OptionsUtilities.create_percent_slider_template(params)

  template.after = params.parent_index
  template.category = params.category
  template.indentation_level = params.depth
  template.tooltip_text = params.tooltip

  return template
end
_type_template_map["percent_slider"] = create_percent_slider_template


-- ###########################
-- ###### Value Slider #######
-- ###########################

-- Create value slider template
local create_value_slider_template = function (self, params)

  params.on_value_changed_function = function(new_value)
    get_mod(params.mod_name):set(params.setting_id, new_value, true)

    return true
  end
  params.value_get_function = function()
    return get_mod(params.mod_name):get(params.setting_id)
  end

  params.display_name = params.title
  params.apply_on_drag = true
  params.default_value = params.default_value
  params.max_value = params.range[2]
  params.min_value = params.range[1]
  params.num_decimals = params.decimals_number
  params.step_size_value = math.pow(10, params.decimals_number * -1)
  params.type = "value_slider"

  local template = OptionsUtilities.create_value_slider_template(params)

  template.after = params.parent_index
  template.category = params.category
  template.indentation_level = params.depth
  template.tooltip_text = params.tooltip

  return template
end
_type_template_map["value_slider"] = create_value_slider_template
_type_template_map["numeric"] = create_value_slider_template


-- ######################
-- ###### Checkbox ######
-- ######################

-- Create checkbox template
local create_checkbox_template = function (self, params)
  local template = {
    after = params.parent_index,
    category = params.category,
    default_value = params.default_value,
    display_name = params.title,
    indentation_level = params.depth,
    require_restart = params.require_restart,
    tooltip_text = params.tooltip,
    value_type = "boolean",
  }
  template.on_activated = function(new_value)
    get_mod(params.mod_name):set(params.setting_id, new_value, true)

    return true
  end
  template.get_function = function()
    return get_mod(params.mod_name):get(params.setting_id)
  end

  return template
end
_type_template_map["checkbox"] = create_checkbox_template


-- ########################
-- ###### Mod Toggle ######
-- ########################

-- Create mod toggle template
local create_mod_toggle_template = function (self, params)
  local template = {
    after = params.after,
    category = params.category,
    default_value = true,
    disabled = params.disabled,
    display_name = params.readable_mod_name or params.mod_name,
    indentation_level = 0,
    require_restart = params.require_restart,
    tooltip_text = params.description,
    value_type = "boolean",
  }

  template.on_activated = function(new_value)
    dmf.mod_state_changed(params.mod_name, new_value)

    return true
  end
  template.get_function = function()
    return get_mod(params.mod_name):is_enabled()
  end

  return template
end
_type_template_map["mod_toggle"] = create_mod_toggle_template


-- ######################
-- ###### Dropdown ######
-- ######################

-- Create dropdown template
local create_dropdown_template = function (self, params)

  for i = 1, #params.options do
    params.options[i].id = i - 1
    params.options[i].display_name = params.options[i].text
  end

  local template = {
    after = params.parent_index,
    category = params.category,
    default_value = params.default_value,
    display_name = params.title,
    indentation_level = params.depth,
    options = params.options,
    tooltip_text = params.tooltip,
    require_restart = params.require_restart,
    widget_type = "dropdown",
  }
  template.on_activated = function(new_value)
    get_mod(params.mod_name):set(params.setting_id, new_value, true)

    return true
  end
  template.get_function = function()
    return get_mod(params.mod_name):get(params.setting_id)
  end

  return template
end
_type_template_map["dropdown"] = create_dropdown_template


-- ###########################
-- ######### Keybind #########
-- ###########################

local set_keybind = function (self, keybind_data, keywatch_result)
  keybind_data.keys = keywatch_result

  local mod = get_mod(keybind_data.mod_name)
  dmf.add_mod_keybind(
    mod,
    keybind_data.setting_id,
    {
      global          = keybind_data.keybind_global,
      trigger         = keybind_data.keybind_trigger,
      type            = keybind_data.keybind_type,
      main            = keywatch_result.main,
      enablers        = keywatch_result.enablers,
      disablers       = keywatch_result.disablers,
      function_name   = keybind_data.function_name,
      view_name       = keybind_data.view_name,
    }
  )
  mod:set(keybind_data.setting_id, dmf.keywatch_result_to_local_keys(keywatch_result), true)
end


-- Create keybind template
local create_keybind_template = function (self, params)
  local template = {
    widget_type = "keybind",
    service_type = "Ingame",
    tooltip_text = params.tooltip,
    display_name = params.title,
    group_name = params.category,
    category = params.category,
    after = params.parent_index,
    devices = _devices,
    sort_order = params.sort_order,
    cancel_keys = _cancel_keys,
    reserved_keys = _reserved_keys,
    indentation_level = params.depth,
    mod_name = params.mod_name,
    setting_id = params.setting_id,
    keys = dmf.local_keys_to_keywatch_result(params.keys),
    default_value = dmf.local_keys_to_keywatch_result(params.default_value) or {},

    on_activated = function (new_value, old_value)

      -- Prevent unbinding the mod options menu
      if params.setting_id ~= "open_dmf_options" then

        -- Unbind the keybind if the new value is empty
        if not (new_value and new_value.main) then
          set_keybind(self, params, {})
          return true
        end

        -- Unbind the keybind if the new value matches a cancel key
        for i = 1, #_cancel_keys do
          local cancel_key = _cancel_keys[i]
          if cancel_key == new_value.main then
            set_keybind(self, params, {})
            return true
          end
        end
      end

      -- Don't modify the keybind if the new value is a reserved key
      for i = 1, #_reserved_keys do
        local reserved_key = _reserved_keys[i]
        if reserved_key == new_value.main then
          return false
        end
      end

      -- Get the keys of the new value
      local keys = dmf.keywatch_result_to_local_keys(new_value)

      -- Set the new keybind unless it would unbind the mod options menu
      if keys and #keys > 0 or params.setting_id ~= "open_dmf_options" then
        set_keybind(self, params, new_value)
        return true
      end

      return false
    end,

    get_function = function (template)
      local saved_keys = get_mod(template.mod_name):get(template.setting_id)
      local keywatch_result = dmf.local_keys_to_keywatch_result(saved_keys)

      return keywatch_result
    end,
  }

  return template
end
_type_template_map["keybind"] = create_keybind_template


-- ###########################
-- ###### Miscellaneous ######
-- ###########################

-- Get the template creation function associated with a given widget data type
local function widget_data_to_template(self, data)
  if data and data.type and type(data.type) == "string" and _type_template_map[data.type] then
    return _type_template_map[data.type](self, data)
  else
    dmf:dump(data, "widget", 1)
    dmf:error(ERRORS.REGULAR.invalid_widget_type, tostring(data.mod_name), tostring(data.type))
  end
end


-- Add a category for toggling mods
local function create_toggle_category(self, categories)
  local category = {
    can_be_reset = false,
    display_name = dmf:localize("toggle_mods"),
    custom       = true
  }
  categories[#categories + 1] = category
  return category
end


--  Add a mod category to the options view categories
local function create_mod_category(self, categories, widget_data)
  local category = {
    can_be_reset = widget_data.can_be_reset or true,
    display_name = widget_data.readable_mod_name or widget_data.mod_name or "",
    custom       = true
  }
  categories[#categories + 1] = category
  return category
end


-- Create an option template and handle index offsets
local function create_option_template(self, widget_data, category_name, index_offset)
  local template = widget_data_to_template(self, widget_data)
  if template then
    template.custom = true
    template.category = category_name
    template.after = template.after and template.after + index_offset or nil

    return template
  end
end

-- Insert a new item into a table before any items that pass the item_tester function
local function insert_before(tbl, item_tester, new_item)
  local copy = {}
  for _, item in ipairs(tbl) do
    if item_tester(item) then
      table.insert(copy, new_item)
    end
    table.insert(copy, item)
  end
  return copy
end


-- ####################################################################################################################
-- ##### Hooks ########################################################################################################
-- ####################################################################################################################

-- Add Mods Options title to global localization table
-- so that the SystemView options menu can localize it
dmf:add_global_localize_strings({
  -- TODO: copied from dmf/localization/dmf.lua, figure out a better way
  mods_options = {
    en = "Mod Options",
    es = "Configuración de mods",
    ru = "Настройки модов",
    ["zh-cn"] = "模组选项",
    ja = "Modオプション",
  }
})

local dmf_option_definition = {
  text = "mods_options",
  type = "button",
  icon = "content/ui/materials/icons/system/escape/settings",
  trigger_function = function()
    local context = {
      can_exit = true,
    }
    local view_name = "dmf_options_view"
    Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
  end,
}

local function is_options_button(item)
  return item.text == "loc_options_view_display_name"
end

-- Inject DMF Options button into the Esc menu
dmf:hook_require("scripts/ui/views/system_view/system_view_content_list", function(instance)
  -- Don't re-inject if it's already there
  if table.find_by_key(instance.default, "text", dmf_option_definition.text) then
    return
  end

  instance.default = insert_before(instance.default, is_options_button, dmf_option_definition)
  instance.StateMainMenu = insert_before(instance.StateMainMenu, is_options_button, dmf_option_definition)
end)

-- ####################################################################################################################
-- ##### DMF internal functions and variables #########################################################################
-- ####################################################################################################################

-- Add mod settings to options view
dmf.create_mod_options_settings = function (self, options_templates)
  local categories = options_templates.categories
  local settings = options_templates.settings

  -- Create the toggle category
  local toggle_category = create_toggle_category(self, categories)
  local toggle_index_offset = 0

  -- Create the toggle category header
  local toggle_header_data = {
    type = "header",
    category = toggle_category,
    title = dmf:localize("toggle_mods"),
    mod_name = "dmf",
    tooltip = dmf:localize("toggle_mods"),
  }
  local toggle_header = create_option_template(self, toggle_header_data, toggle_category.display_name, toggle_index_offset)
  if toggle_header then
    settings[#settings + 1] = toggle_header
  end

  -- Create the toggle category description
  local desc_widget_data = {
    mod_name = "dmf",
    description = dmf:localize("toggle_mods_description"),
    category = toggle_category.display_name,
    display_name = toggle_category.display_name,
    after = #settings,
    type = "description"
  }
  local desc_template = create_option_template(self, desc_widget_data, toggle_category.display_name, toggle_index_offset)

  if desc_template then
    settings[#settings + 1] = desc_template
    toggle_index_offset = toggle_index_offset + 1
  end

  -- Create a toggle for each mod; non-toggleable mods' toggles are disabled
  for _, mod_data in ipairs(dmf.options_widgets_data) do
    local toggle_widget_data = {
      mod_name = mod_data[1].mod_name,
      readable_mod_name = mod_data[1].readable_mod_name or mod_data[1].title,
      description = mod_data[1].description,
      disabled = not mod_data[1].is_togglable,
      category = toggle_category.display_name,
      after = #settings,
      type = "mod_toggle"
    }

    local toggle_template = create_option_template(self, toggle_widget_data, toggle_category.display_name, toggle_index_offset)
    if toggle_template then
      settings[#settings + 1] = toggle_template
      toggle_index_offset = toggle_index_offset + 1
    end
  end

  -- Create a category for every mod that has additional settings
  for _, mod_data in ipairs(dmf.options_widgets_data) do
    if #mod_data > 1 then
      local category = create_mod_category(self, categories, mod_data[1])

      local index_offset = 0

      -- Create the category header
      local template = create_option_template(self, mod_data[1], category.display_name, index_offset)
      if template then
        settings[#settings + 1] = template
      end

      -- Create the mod description
      if mod_data[1].description then
        local desc_widget_data = {
          mod_name = mod_data[1].mod_name,
          description = mod_data[1].description,
          category = category.display_name,
          display_name = category.display_name,
          after = #settings,
          type = "description"
        }
        local desc_template = create_option_template(self, desc_widget_data, category.display_name, index_offset)

        if desc_template then
          settings[#settings + 1] = desc_template
          index_offset = index_offset + 1
        end
      end

      -- Populate the category with options taken from the remaining options data
      for i = 2, #mod_data do
        local widget_data = mod_data[i]

        template = widget_data_to_template(self, widget_data)
        if template then
          template.custom = true
          template.category = category.display_name
          template.after = template.after + index_offset

          settings[#settings + 1] = template
        end
      end
    end
  end

  return options_templates
end


dmf.initialize_dmf_options_view = function ()
  dmf:add_require_path("dmf/scripts/mods/dmf/modules/ui/options/dmf_options_view")
  dmf:add_require_path("dmf/scripts/mods/dmf/modules/ui/options/dmf_options_view_definitions")
  dmf:add_require_path("dmf/scripts/mods/dmf/modules/ui/options/dmf_options_view_settings")
  dmf:add_require_path("dmf/scripts/mods/dmf/modules/ui/options/dmf_options_view_content_blueprints")

  dmf:register_view({
    view_name = "dmf_options_view",
    view_settings = {
      init_view_function = function (ingame_ui_context)
        return true
      end,
      class = "DMFOptionsView",
      disable_game_world = false,
      display_name = "loc_options_view_display_name",
      game_world_blur = 1.1,
      load_always = true,
      load_in_hub = true,
      package = "packages/ui/views/options_view/options_view",
      path = "dmf/scripts/mods/dmf/modules/ui/options/dmf_options_view",
      state_bound = true,
      enter_sound_events = {
        "wwise/events/ui/play_ui_enter_short"
      },
      exit_sound_events = {
        "wwise/events/ui/play_ui_back_short"
      },
      wwise_states = {
        options = "ingame_menu"
      }
    },
    view_transitions = {},
    view_options = {
      close_all = false,
      close_previous = false,
      close_transition_time = nil,
      transition_time = nil
    }
  })

  dmf:io_dofile("dmf/scripts/mods/dmf/modules/ui/options/dmf_options_view")
end

-- ####################################################################################################################
-- ##### Script #######################################################################################################
-- ####################################################################################################################
