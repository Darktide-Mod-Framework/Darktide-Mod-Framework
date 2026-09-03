---@class DMFMod
local dmf = get_mod("DMF")

-- Note(Siku): This file could definitely use the hooking system if we could figure out a way.
-- It would requires hooks to be pushed higher in the loading order, but then we lose hooks printing to console
-- Unless we find a way to store our logging messages in memory before the console is loaded.

-- Local backup of the ffi library
local _ffi = dmf:persistent_table("_ffi")
_ffi.initialized = _ffi.initialized or false
if not _ffi.initialized then
  _ffi = dmf.deepcopy(Mods.lua.ffi)
end

local _console_data = dmf:persistent_table("dev_console_data")
if not _console_data.enabled then _console_data.enabled = false end
if not _console_data.original_print then _console_data.original_print = print end

local _log_to_developer_console

-- ####################################################################################################################
-- ##### Local functions ##############################################################################################
-- ####################################################################################################################

local function bind_dev_console_output()
  if not _ffi then
    return
  end

  _ffi.cdef([[
    void* CreateFileA(const char* lpFileName, uint32_t dwDesiredAccess, uint32_t dwShareMode, void* lpSecurityAttributes, uint32_t dwCreationDisposition, uint32_t dwFlagsAndAttributes, void* hTemplateFile);
    int SetStdHandle(uint32_t nStdHandle, void* hHandle);
  ]])

  local output_handle = _ffi.C.CreateFileA("CONOUT$", 0xC0000000, 0x3, nil, 0x3, 0, nil)
  local invalid_handle = _ffi.cast("void *", -1)

  if output_handle == nil or output_handle == invalid_handle then
    dmf:error("(developer console) could not open CONOUT$")
    return
  end

  if _ffi.C.SetStdHandle(0xfffffff5, output_handle) == 0 then
    dmf:error("(developer console) could not bind stdout to CONOUT$")
  end
end

local function disable_dev_console_close()
  if not _ffi then
    return
  end

  _ffi.cdef([[
    void* GetConsoleWindow(void);
    void* GetSystemMenu(void* hWnd, int bRevert);
    uint32_t EnableMenuItem(void* hMenu, uint32_t uIDEnableItem, uint32_t uEnable);
    int DrawMenuBar(void* hWnd);
  ]])

  local hwnd = _ffi.C.GetConsoleWindow()
  if hwnd == nil then
    dmf:error("(developer console) could not get the console window")
    return
  end

  local system_menu = _ffi.C.GetSystemMenu(hwnd, 0)
  if system_menu == nil then
    dmf:error("(developer console) could not get the console system menu")
    return
  end

  local SC_CLOSE = 0xf060
  local MF_GRAYED = 0x1
  if _ffi.C.EnableMenuItem(system_menu, SC_CLOSE, MF_GRAYED) == 0xffffffff then
    dmf:error("(developer console) could not disable the console close command")
    return
  end

  if _ffi.C.DrawMenuBar(hwnd) == 0 then
    dmf:error("(developer console) could not redraw the console menu bar")
  end
end

local function stringify_print_values(message, ...)
  local num_additional_values = select("#", ...)
  local values = {tostring(message)}

  for i = 1, num_additional_values do
    values[i + 1] = tostring(select(i, ...))
  end

  return table.concat(values, " ")
end

local function log_and_console_print(...)
  local print_message = stringify_print_values(...)

  CommandWindow.print(print_message)

  -- the game's print implementation builds a Log.info format string from these values. The first value is inserted
  -- without escaping '%', so Log.info parses its contents again. Bypass print and use a fixed format string here.
  Log.info(Log.DEFAULT_CATEGORY, "%s", print_message)
end

local function open_dev_console()

  if not _console_data.enabled then
    CommandWindow.open("Developer console")
    -- Closing the command window directly signals an application exit, so only DMF may close it safely.
    disable_dev_console_close()
    bind_dev_console_output()
    _console_data.enabled = true
  end

  print = log_and_console_print
end

local function close_dev_console()

  if _console_data.enabled then

    print = _console_data.original_print

    CommandWindow.close()

    -- CommandWindow won't close by itself, so it has to be closed through FFI
    if _ffi then
      dmf:pcall(function()
        if _ffi then
          _ffi.cdef([[
            void* FindWindowA(const char* lpClassName, const char* lpWindowName);
            int64_t SendMessageA(void* hWnd, unsigned int Msg, uint64_t wParam, int64_t lParam);
          ]])
          local WM_CLOSE = 0x10;
          local hwnd = _ffi.C.FindWindowA("ConsoleWindowClass", "Developer console")
          _ffi.C.SendMessageA(hwnd, WM_CLOSE, 0, 0)
        end
      end)

    -- Or manually closed by the user
    else
      dmf:warning(dmf:localize("dev_console_close_warning"))
    end

    _console_data.enabled = false
  end
end

-- ####################################################################################################################
-- ##### DMF internal functions and variables #########################################################################
-- ####################################################################################################################

dmf.developer_console_print = log_and_console_print

dmf.is_developer_console_logging_enabled = function()
  return _console_data.enabled and _log_to_developer_console
end

dmf.toggle_developer_console = function ()

  if dmf:get("developer_mode") then

    local show_console = not dmf:get("show_developer_console")
    dmf:set("show_developer_console", show_console)

    dmf.load_dev_console_settings()

    if show_console then
      dmf:echo(dmf:localize("dev_console_opened"))
    else
      dmf:echo(dmf:localize("dev_console_closed"))
    end
  end
end

dmf.load_dev_console_settings = function()

  _log_to_developer_console = dmf:get("log_to_developer_console") ~= false

  if dmf:get("developer_mode") and dmf:get("show_developer_console") then
    open_dev_console()
  else
    close_dev_console()
  end
end

-- ####################################################################################################################
-- ##### Script #######################################################################################################
-- ####################################################################################################################

dmf.load_dev_console_settings()
