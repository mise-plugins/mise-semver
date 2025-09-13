-- .luacheckrc configuration for mise-semver plugin

-- Globals defined by the vfox plugin system  
globals = {
    "PLUGIN",
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

-- Ignore unused arguments in hook functions and unused globals
unused_args = false
unused = false

-- Allow defined top-level variables and trailing whitespace
allow_defined_top = true