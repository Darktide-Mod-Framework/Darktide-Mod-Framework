local dmf = get_mod("DMF")

local _show_debug_info = false

-- ####################################################################################################################
-- ##### Local functions ##############################################################################################
-- ####################################################################################################################

local function check_texture_availability(mod, texture_name)
  -- @TODO: Method for checking texture availability
end

-- ####################################################################################################################
-- ##### DMFMod #######################################################################################################
-- ####################################################################################################################

dmf.custom_textures = function (mod, ...)
  -- @TODO: Not implemented
end

dmf.custom_atlas = function (mod, ...)
  -- @TODO: Not implemented
end

dmf.inject_materials = function (mod, ...)
  -- @TODO: Not implemented
end

-- ####################################################################################################################
-- ##### Hooks ########################################################################################################
-- ####################################################################################################################

-- ####################################################################################################################
-- ##### DMF internal functions and variables #########################################################################
-- ####################################################################################################################

dmf.load_custom_textures_settings = function()
  _show_debug_info = dmf:get("developer_mode") and dmf:get("log_ui_renderers_info")
end

dmf.reset_guis = function()
  -- @TODO: Method to reset DMF-spawned guis
end

-- ####################################################################################################################
-- ##### Script #######################################################################################################
-- ####################################################################################################################

dmf.load_custom_textures_settings()