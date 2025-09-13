-- .luacheckrc configuration for mise-semver plugin

-- Globals defined by the vfox plugin system
globals = {
    "PLUGIN"
}

-- Read-only globals from vfox environment
read_globals = {
    -- Standard Lua globals
    "require",
    "os",
    "io",
    "table",
    "string",
    "math",
    "loadfile",
    "error",
    "ipairs",
    "pairs",
    "print",
    "tostring",
    "tonumber",
    "type",
    "getmetatable",
    "setmetatable",

    -- vfox context object
    "ctx"
}

-- Ignore line length warnings
max_line_length = false

-- Ignore unused arguments in hook functions
unused_args = false

-- Allow trailing whitespace (can be auto-fixed)
allow_defined_top = true