package = "kong-plugin-authentication-marker"

version = "1.1.0-1"
-- The version '0.1.0' is the source code version, the trailing '1' is the version of this rockspec.
-- whenever the source version changes, the rockspec should be reset to 1. The rockspec version is only
-- updated (incremented) when this file changes, but the source remains the same.

local pluginName = package:match("^kong%-plugin%-(.+)$")  -- "authentication-marker"
supported_platforms = {"linux", "macosx"}

source = {
  url = "git://github.com/intelipost/kong-plugin-authentication-marker",
  tag = "master",
}
description = {
  summary = "A Kong plugin that will validate tokens issued by keycloak",
  homepage = "https://github.com/intelipost/kong-plugin-authentication-marker",
  license = "Apache 2.0"
}
dependencies = {
  "lua ~> 5"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.kong-plugin-authentication-marker.handler"] = "src/handler.lua",
    ["kong.plugins.kong-plugin-authentication-marker.schema"]  = "src/schema.lua",
  }
}