---@class DMFMod
local dmf = get_mod("DMF")

--[[
  * chat commands
  * chat history
  * ctrl + c, ctrl + v
]]

local _chat_opened = false

local _commands_list = {}
local _command_index = 0 -- 0 => nothing selected
local _command_user_input = ""
local _command_completion = ""

local _commands_list_gui_draw

local _chat_history = {}
local _chat_history_index = 0
local _chat_history_enabled = true
local _chat_history_save = true
local _chat_history_max = 50
local _chat_history_remove_dups_last = false
local _chat_history_remove_dups_all = false
local _chat_history_save_commands_only = false

local _chat_message
local _previous_chat_message
local _queued_command

-- ####################################################################################################################
-- ##### Local functions ##############################################################################################
-- ####################################################################################################################

local function initialize_drawing_function()
  if not _commands_list_gui_draw then
    local commands_list_gui = dmf:io_dofile("dmf/scripts/mods/dmf/modules/ui/chat/commands_list_gui")
    _commands_list_gui_draw = commands_list_gui.draw
  end
end

local function destroy_command_gui()
  _commands_list_gui_draw = nil
end

local function clean_chat_notifications()
  if Managers.event then
    Managers.event:trigger("event_clear_notifications")
  end
end

local function clean_chat_history()
  _chat_history = {}
  _chat_history_index = 0
end

local function get_chat_index(chat_gui)
  return chat_gui._input_field_widget.content.caret_position
end

local function get_chat_message(chat_gui)
  return chat_gui._input_field_widget.content.input_text or ""
end

local function set_chat_message(chat_gui, message)
  _chat_message = message
  chat_gui._input_field_widget.content.input_text = message
  chat_gui._input_field_widget.content.caret_position = Utf8.string_length(_chat_message) + 1
end

local function get_common_command_prefix(commands)
  local common_prefix = commands[1].name

  for i = 2, #commands do
    local command_name = commands[i].name
    local common_length = math.min(#common_prefix, #command_name)

    while common_length > 0 and string.sub(common_prefix, 1, common_length) ~= string.sub(command_name, 1, common_length) do
      common_length = common_length - 1
    end

    common_prefix = string.sub(common_prefix, 1, common_length)
  end

  return common_prefix
end

-- ####################################################################################################################
-- ##### Hooks ########################################################################################################
-- ####################################################################################################################

-- Handle chat actions when the chat window is active
dmf:hook(CLASS.ConstantElementChat, "_handle_active_chat_input", function(func, self, input_service, ui_renderer, ...)
  initialize_drawing_function()

  _chat_message = get_chat_message(self)
  _chat_opened = true

  -- if message is sending
  if input_service:get("send_chat_message") then

    -- chat history
    if _chat_history_enabled
       and _chat_message ~= ""
       and not (_chat_history_remove_dups_last and (_chat_message == _chat_history[1]))
       and (not _chat_history_save_commands_only or (_command_index ~= 0)) then
      table.insert(_chat_history, 1, _chat_message)

      if #_chat_history == _chat_history_max + 1 then
        table.remove(_chat_history, #_chat_history)
      end

      if _chat_history_remove_dups_all then

        for i = 2, #_chat_history do
          if _chat_history[i] == _chat_message then
            table.remove(_chat_history, i)
            break
          end
        end
      end
    end

    -- command execution
    if _command_index ~= 0 then
      local args = {}
      for arg in string.gmatch(_chat_message, "%S+") do
        table.insert(args, arg)
      end
      table.remove(args, 1)

      _queued_command = {
        name = _commands_list[_command_index].name,
        args = args
      }

      _commands_list = {}
      _command_index = 0

      set_chat_message(self, "")

    elseif string.sub(_chat_message, 1, 1) == "/" then
      dmf:notify("%s", dmf:localize("chat_command_not_recognized") .. ": " .. _chat_message)
      set_chat_message(self, "")
      return
    end
  end

  -- getting state of 'tab', 'arrow right', 'arrow up' and 'arrow down' buttons
  local tab_pressed = false
  local arrow_right_pressed = false
  local arrow_up_pressed = false
  local arrow_down_pressed = false
  local left_ctrl_pressed = Keyboard.button(Keyboard.button_index("left ctrl")) ~= 0

  for _, stroke in ipairs(Keyboard.keystrokes()) do
    if stroke == Keyboard.TAB and not left_ctrl_pressed then
      tab_pressed = true
    -- game considers some "ctrl + [something]" combinations as arrow buttons,
    -- so I have to check for ctrl not pressed
    elseif stroke == Keyboard.RIGHT and not left_ctrl_pressed then
      arrow_right_pressed = true
    elseif stroke == Keyboard.UP and not left_ctrl_pressed then
      arrow_up_pressed = true
    elseif stroke == Keyboard.DOWN and not left_ctrl_pressed then
      arrow_down_pressed = true
    end
  end
  
  local old_chat_message = _chat_message
  local caret_at_end = Utf8.string_length(_chat_message) + 1 == get_chat_index(self)
  local command_tab_pressed = tab_pressed and string.sub(_chat_message, 1, 1) == "/"
  local result

  if not command_tab_pressed then
    result = func(self, input_service, ui_renderer, ...)
  end

  -- Get completion state
  local input_widget = self._input_field_widget
  local chat_closed = not input_widget.content.is_writing

  if chat_closed then
    set_chat_message(self, "")

    _chat_opened = false

    _commands_list = {}
    _command_index = 0
    _command_user_input = ""
    _command_completion = ""
    _chat_history_index = 0
  end

  if _chat_opened then
    -- chat history
    if _chat_history_enabled then

      if arrow_up_pressed then
        set_chat_message(self, old_chat_message)
      end

      -- message was modified by player
      if _chat_message ~= _previous_chat_message then
        _chat_history_index = 0
      end
      if arrow_up_pressed or arrow_down_pressed then

        local new_index = _chat_history_index + (arrow_up_pressed and 1 or -1)
        new_index = math.clamp(new_index, 0, #_chat_history)

        if _chat_history_index ~= new_index then
          if _chat_history[new_index] then

            set_chat_message(self, _chat_history[new_index])

            _previous_chat_message = _chat_message

            _chat_history_index = new_index
          else -- new_index == 0
            set_chat_message(self, "")
          end

          _command_user_input = _chat_message
          _command_completion = ""
        end
      end
    end

    caret_at_end = Utf8.string_length(_chat_message) + 1 == get_chat_index(self)

    if _command_completion ~= "" and
       (_chat_message ~= _command_user_input .. _command_completion or not caret_at_end) then
      _command_user_input = _chat_message
      _command_completion = ""
    elseif _command_completion == "" then
      _command_user_input = _chat_message
    end

    -- entered chat message starts with "/"
    if string.sub(_chat_message, 1, 1) == "/" then
      local has_command_arguments = string.find(_chat_message, " ")
      local command_name_contains = _command_user_input:match("%S+"):sub(2, -1)

      if has_command_arguments then
        _commands_list = dmf.get_commands_list(command_name_contains, true)
        _command_index = 0
        _command_completion = ""

        if #_commands_list > 0 and command_name_contains:lower() == _commands_list[1].name then
          _command_index = 1
        end
      else
        _commands_list = dmf.get_commands_list(command_name_contains)

        local autocomplete_pressed = (command_tab_pressed or arrow_right_pressed) and caret_at_end

        if autocomplete_pressed and #_commands_list == 1 then
          local completion = string.sub(_commands_list[1].name, #command_name_contains + 1)

          _command_user_input = _command_user_input .. completion
          _command_completion = ""
          _command_index = 1

          set_chat_message(self, _command_user_input)
        elseif autocomplete_pressed and #_commands_list > 1 then
          local common_prefix = get_common_command_prefix(_commands_list)

          if #common_prefix > #command_name_contains then
            local completion = string.sub(common_prefix, #command_name_contains + 1)

            _command_user_input = _command_user_input .. completion
            _command_completion = ""
            _command_index = 0

            set_chat_message(self, _command_user_input)
          else
            _command_index = _command_index % #_commands_list + 1
            _command_completion = string.sub(
              _commands_list[_command_index].name,
              #command_name_contains + 1
            )

            set_chat_message(self, _command_user_input .. _command_completion)
          end
        elseif _command_completion == "" then
          _command_index = 0

          if #_commands_list > 0 and command_name_contains:lower() == _commands_list[1].name then
            _command_index = 1
          end
        end
      end


    -- chat message was modified and doesn't start with '/'
    elseif #_commands_list > 0 then
      _commands_list = {}
      _command_index = 0
      _command_user_input = _chat_message
      _command_completion = ""
    end

  end

  return result
end)

dmf:hook(CLASS.ConstantElementChat, "_draw_widgets", function(
  func, self, dt, t, input_service, ui_renderer, render_settings, ...
)
  local result = func(self, dt, t, input_service, ui_renderer, render_settings, ...)

  if _chat_opened and #_commands_list > 0 then
    initialize_drawing_function()
    _commands_list_gui_draw(self, _commands_list, _command_index, ui_renderer)
  end

  return result
end)

-- ####################################################################################################################
-- ##### DMF internal functions and variables #########################################################################
-- ####################################################################################################################

dmf.load_chat_history_settings = function(clean_chat_history_)

  _chat_history_enabled            = dmf:get("chat_history_enable")
  _chat_history_save               = dmf:get("chat_history_save")
  _chat_history_max                = dmf:get("chat_history_buffer_size")
  _chat_history_remove_dups_last   = dmf:get("chat_history_remove_dups")
  _chat_history_remove_dups_all    = dmf:get("chat_history_remove_dups") and
                                    (dmf:get("chat_history_remove_dups_mode") == "all")
  _chat_history_save_commands_only = dmf:get("chat_history_commands_only")

  if _chat_history_enabled then
    dmf:command("clean_chat_history", dmf:localize("clean_chat_history"), clean_chat_history)
  else
    dmf:command_remove("clean_chat_history")
  end

  if not _chat_history_save then
    dmf:set("chat_history", nil)
  end

  if clean_chat_history_ then
    clean_chat_history()
  end
end

dmf.save_chat_history = function()
  if _chat_history_save then
    dmf:set("chat_history", _chat_history)
  end
end

dmf.execute_queued_chat_command = function()
  if _queued_command then
    dmf.run_command(_queued_command.name, unpack(_queued_command.args))
    _queued_command = nil
  end
end

dmf.destroy_command_gui = function()
  destroy_command_gui()
end

-- ####################################################################################################################
-- ##### Script #######################################################################################################
-- ####################################################################################################################

dmf.load_chat_history_settings()
dmf:command("clean_chat_notifications", dmf:localize("clean_chat_notifications"), clean_chat_notifications)

if _chat_history_save then
  _chat_history = dmf:get("chat_history") or _chat_history
end

initialize_drawing_function()
