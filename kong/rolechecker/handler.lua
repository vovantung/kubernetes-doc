local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

local RoleChecker = {
  PRIORITY = 1005,
  VERSION = "1.0",
}

function RoleChecker:access(conf)
  local auth_header = kong.request.get_header("Authorization")
  if not auth_header then
    return kong.response.exit(401, { message = "Missing Authorization header" })
  end

  local token = auth_header:match("Bearer%s+(.+)")
  if not token then
    return kong.response.exit(401, { message = "Invalid Authorization header" })
  end

  local jwt, err = jwt_decoder:new(token)
  if err then
    return kong.response.exit(401, { message = "Invalid JWT token: " .. err })
  end

  local claims = jwt.claims
  local role = claims["role"]
  if not role then
    return kong.response.exit(403, { message = "Missing role in token" })
  end

  local path = kong.request.get_path()

  if role == "admin" then
    return
  elseif role == "user" then
    if path:find("^/user%-app") then
      return
    else
      return kong.response.exit(403, { message = "User role cannot access " .. path })
    end
  else
    return kong.response.exit(403, { message = "Unknown role: " .. role })
  end
end

return RoleChecker
