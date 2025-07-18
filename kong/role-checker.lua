-- role-checker.lua
local BasePlugin = require "kong.plugins.base_plugin"
local kong = kong
local RoleChecker = BasePlugin:extend()

RoleChecker.VERSION  = "1.0.0"
RoleChecker.PRIORITY = 900

function RoleChecker:access(conf)
  RoleChecker.super.access(self)

  local headers = kong.request.get_headers()
  local role = headers["x-role"]

  local path = kong.request.get_path()

  if role == "admin" then
    return -- cho qua hết
  elseif role == "hrm" then
    if string.sub(path, 1, 4) == "/hrm" then
      return
    end
  end

  return kong.response.exit(403, { message = "Forbidden: insufficient role" })
end

return RoleChecker
