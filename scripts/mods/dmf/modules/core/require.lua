local dmf = get_mod("DMF")

local _io_requires = {}

-- Global store of objects created through require()
local _require_store = Mods.require_store

-- Global backup of the require() function
local _original_require = Mods.original_require

-- #####################################################################################################################
-- ##### Local functions ###############################################################################################
-- #####################################################################################################################

local function add_io_require_path(path)
  _io_requires[path] = true
end


local function remove_io_require_path(path)
  _io_requires[path] = nil
end


local function get_require_store(path)
  return _require_store[path]
end


local function original_require(path, ...)
  return _original_require(path, ...)
end

-- #####################################################################################################################
-- ##### DMFMod ########################################################################################################
-- #####################################################################################################################

--- Loads the given file with the same semantics as Lua's `require`.
---
--- This provides a unified API for both bundled and non-bundled mods.
---
--- @param path string The file to load
function DMFMod:require(path)
  local is_bundled = self:get_internal_data("is_bundled")

  if is_bundled then
    return require(path)
  else
    local loaded = self:io_dofile_unsafe(path)
    if loaded then
      package.loaded[path] = loaded
    end
    return loaded
  end
end

--- Loads the given file with the same semantics as Lua's `dofile`.
---
--- This provides a unified API for both bundled and non-bundled mods.
---
--- @param path string The file to load
function DMFMod:dofile(path)
  local is_bundled = self:get_internal_data("is_bundled")

  if is_bundled then
    return dofile(path)
  else
    return dmf.io_dofile_unsafe(self, path)
  end
end

-- Add a file path to be loaded through `io` instead of `require`.
--
-- Certain game systems will be given a path value and then call `require`
-- internally, where a mod cannot easily hook and replace the call.
--
-- This function allows non-bundled mods to inject a file such that these systems
-- can `require` them without additional hooks.
--
-- Bundled mods already have all their files available through regular `require`.
function DMFMod:add_require_path(path)
  add_io_require_path(path)
end

-- Remove a file path that was previously loaded through io instead of require()
function DMFMod:remove_require_path(path)
  remove_io_require_path(path)
end

-- Get all instances of a file created through require()
function DMFMod:get_require_store(path)
  return get_require_store(path)
end

-- Get a file through the original, unhooked require() function
function DMFMod:original_require(path, ...)
  return original_require(path, ...)
end

-- #####################################################################################################################
-- ##### Hooks #########################################################################################################
-- #####################################################################################################################

-- Handles the swap to io for registered files and the application of file hooks
dmf:hook(_G, "require", function(func, path, ...)
  if _io_requires[path] then
    local ret = dmf:io_dofile(path)
    package.loaded[path] = ret
    return ret
  else
    local result = func(path, ...)

    -- Apply any file hooks to the newly-required file
    local require_store = get_require_store(path)
    if require_store then
      dmf.apply_hooks_to_file(require_store, path, #require_store)
    end

    return result
  end
end)

-- #####################################################################################################################
-- ##### DMF internal functions and variables ##########################################################################
-- #####################################################################################################################

-- #####################################################################################################################
-- ##### Script ########################################################################################################
-- #####################################################################################################################
