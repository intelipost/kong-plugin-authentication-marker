local BasePlugin = require "kong.plugins.base_plugin"
local constants = require "kong.constants"
local cjson = require("cjson")
local socket = require "socket"

local CustomHandler = BasePlugin:extend()

local priority_env_var = "AUTHENTICATION_MARKER_PRIORITY"
local priority
if os.getenv(priority_env_var) then
    priority = tonumber(os.getenv(priority_env_var))
else
    priority = 1005
end
kong.log.debug('AUTHENTICATION_MARKER_PRIORITY: ' .. priority)

CustomHandler.PRIORITY = priority
CustomHandler.VERSION = "1.1.0"

function CustomHandler:init_worker()
-- Implement logic for the init_worker phase here (http/stream)
kong.log("init_worker")
end


function CustomHandler:preread(config)
-- Implement logic for the preread phase here (stream)
kong.log("preread")
end


function CustomHandler:certificate(config)
-- Implement logic for the certificate phase here (http/stream)
kong.log("certificate")
end

function CustomHandler:rewrite(config)
-- Implement logic for the rewrite phase here (http)
kong.log("rewrite")
end

function CustomHandler:access(config)
kong.service.request.add_header("authentication-method", "jwt")

-- Implement logic for the rewrite phase here (http)
kong.log("access add header authentication-method")
end

function CustomHandler:header_filter(config)
-- Implement logic for the header_filter phase here (http)
kong.log("header_filter")
end

function CustomHandler:body_filter(config)
-- Implement logic for the body_filter phase here (http)
kong.log("body_filter")
end

function CustomHandler:log(config)
-- Implement logic for the log phase here (http/stream)
kong.log("log")
end

-- return the created table, so that Kong can execute it
return CustomHandler
