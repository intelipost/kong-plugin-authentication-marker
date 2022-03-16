local BasePlugin = require "kong.plugins.base_plugin"
local constants = require "kong.constants"
local cjson = require("cjson")
local socket = require "socket"
local jwt = require "resty.jwt"
local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

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

local function retrieve_token(conf)
    kong.log.debug('Calling retrieve_token()')

    local args = kong.request.get_query()
    for _, v in ipairs(conf.uri_param_names) do
        if args[v] then
            kong.log.debug('retrieve_token() args[v]: ' .. args[v])
            return args[v]
        end
    end

    local var = ngx.var
    for _, v in ipairs(conf.cookie_names) do
        kong.log.debug('retrieve_token() checking cookie: ' .. v)
        local cookie = var["cookie_" .. v]
        if cookie and cookie ~= "" then
            kong.log.debug('retrieve_token() cookie value: ' .. cookie)
            return cookie
        end
    end

    local authorization_header = kong.request.get_header("authorization")
    if authorization_header then
        kong.log.debug('retrieve_token() authorization_header: ' .. authorization_header)
        local iterator, iter_err = re_gmatch(authorization_header, "\\s*[Bb]earer\\s+(.+)")
        if not iterator then
            return nil, iter_err
        end

        local m, err = iterator()
        if err then
            return nil, err
        end

        if m and #m > 0 then
            return m[1]
        end
    end
end

function CustomHandler:access(config)
kong.service.request.add_header("authentication-method", "jwt")

local token, err = retrieve_token(config)

local token_type = type(token)
kong.log.debug('do_authentication() token_type: ' .. token_type)
if token_type ~= "string" then
    if token_type == "nil" then
        -- Retrieve token payload
        jwt_claims = retrieve_token_payload(conf.internal_request_headers)
        if not jwt_claims then
            return false, { status = 401, message = "Unauthorized" }
        end
        kong.log.debug('do_authentication() token_payload retrieved successfully')
    elseif token_type == "table" then
        return false, { status = 401, message = "Multiple tokens provided" }
    else
        return false, { status = 401, message = "Unrecognizable token" }
    end
end

-- Decode token
local jwt, err
if token then
    jwt, err = jwt_decoder:new(token)
    if err then
        return false, { status = 401, message = "Bad token; " .. tostring(err) }
    end
end

local key = "ABC123"
jwt["chris"] = {foo = "bar"}
local jwt_token = jwt:sign(key, table_of_jwt)

-- Implement logic for the rewrite phase here (http)
kong.log("access add header authentication-method jwt " .. jwt_token) 
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
