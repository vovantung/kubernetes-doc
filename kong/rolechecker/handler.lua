local BasePlugin = require "kong.plugins.base_plugin"
local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

local RoleCheckerHandler = BasePlugin:extend()

RoleCheckerHandler.PRIORITY = 1000

function RoleCheckerHandler:access(conf)
  RoleCheckerHandler.super.access(self)

  local token = kong.request.get_header("Authorization")
  if not token then
    return kong.response.exit(401, { message = "Missing Authorization header" })
  end

  token = token:gsub("Bearer ", "")

  local jwt, err = jwt_decoder:new(token)
  if err then
    return kong.response.exit(401, { message = "Invalid token" })
  end

  local role = jwt.claims.role
  if not role then
    return kong.response.exit(403, { message = "Missing role in token" })
  end

  if role ~= conf.required_role and role ~= "admin" then
    return kong.response.exit(403, { message = "Forbidden - insufficient role" })
  end
end

return RoleCheckerHandler
