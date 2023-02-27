local dmf

-- Native mod object used by Fatshark mod manager
local dmf_mod_object = {}

-- Global backup of original print() method
local print = __print

-- #####################################################################################################################
-- ##### Initialization ################################################################################################
-- #####################################################################################################################

function dmf_mod_object:init()
  dofile("scripts/mods/dmf/modules/dmf_mod_data")
  dofile("scripts/mods/dmf/modules/dmf_mod_manager")
  -- dofile("scripts/mods/dmf/modules/dmf_dummy")
  dofile("scripts/mods/dmf/modules/dmf_package_manager")
  dofile("scripts/mods/dmf/modules/core/safe_calls")
  dofile("scripts/mods/dmf/modules/core/events")
  dofile("scripts/mods/dmf/modules/core/settings")
  dofile("scripts/mods/dmf/modules/core/logging")
  dofile("scripts/mods/dmf/modules/core/misc")
  dofile("scripts/mods/dmf/modules/core/persistent_tables")
  dofile("scripts/mods/dmf/modules/core/io")

  dmf = get_mod("DMF")

  dmf:dofile("scripts/mods/dmf/modules/debug/dev_console")
  dmf:dofile("scripts/mods/dmf/modules/debug/table_dump")
  dmf:dofile("scripts/mods/dmf/modules/core/hooks")
  dmf:dofile("scripts/mods/dmf/modules/core/require")
  dmf:dofile("scripts/mods/dmf/modules/core/toggling")
  dmf:dofile("scripts/mods/dmf/modules/core/keybindings")
  dmf:dofile("scripts/mods/dmf/modules/core/chat")
  dmf:dofile("scripts/mods/dmf/modules/core/localization")
  dmf:dofile("scripts/mods/dmf/modules/core/options")
  dmf:dofile("scripts/mods/dmf/modules/core/network")
  dmf:dofile("scripts/mods/dmf/modules/core/commands")
  dmf:dofile("scripts/mods/dmf/modules/gui/custom_textures")
  dmf:dofile("scripts/mods/dmf/modules/gui/custom_views")
  dmf:dofile("scripts/mods/dmf/modules/ui/chat/chat_actions")
  dmf:dofile("scripts/mods/dmf/modules/ui/options/mod_options")
  dmf:dofile("scripts/mods/dmf/modules/dmf_options")
  dmf:dofile("scripts/mods/dmf/modules/core/mutators/mutators_manager")

  dmf.delayed_chat_messages_hook()
end

-- #####################################################################################################################
-- ##### Events ########################################################################################################
-- #####################################################################################################################

function dmf_mod_object:update(dt)
  dmf.update_package_manager()
  dmf.mods_update_event(dt)
  dmf.check_keybinds()
  dmf.execute_queued_chat_command()

  if not dmf.all_mods_were_loaded and Managers.mod:all_mods_loaded() then

    dmf.generate_keybinds()
    dmf.initialize_dmf_options_view()
    dmf.create_network_dictionary()
    dmf.ping_dmf_users()

    dmf.all_mods_loaded_event()

    dmf.all_mods_were_loaded = true
  end
end


function dmf_mod_object:on_unload()
  print("DMF:ON_UNLOAD()")
  dmf.save_chat_history()
  dmf.save_unsaved_settings_to_file()
  dmf.destroy_command_gui()
end


function dmf_mod_object:on_reload()
  print("DMF:ON_RELOAD()")
  dmf.mods_unload_event(false)
  dmf.remove_custom_views()
  dmf.unload_all_resource_packages()
  dmf.hooks_unload()
  dmf.reset_guis()
  dmf.destroy_command_gui()
end


function dmf_mod_object:on_destroy()
  print("DMF:ON_DESTROY()")
  dmf.mods_unload_event(true)
end


function dmf_mod_object:on_game_state_changed(status, state)
  print("DMF:ON_GAME_STATE_CHANGED(), status: " .. tostring(status) .. ", state: " .. tostring(state))
  dmf.mods_game_state_changed_event(status, state)
  dmf.save_unsaved_settings_to_file()
  dmf.apply_delayed_hooks()
  dmf.destroy_command_gui()

  if status == "enter" and state == "StateIngame" then
    dmf.create_keybinds_input_service()
  end
end

-- #####################################################################################################################
-- ##### Return ########################################################################################################
-- #####################################################################################################################

return dmf_mod_object
