local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

local RoleChecker = {
  PRIORITY = 1000,
  VERSION = "1.0",
}

function RoleChecker:access(conf)
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

  -- if role ~= conf.required_role and role ~= "ROLE_admin" then
  --   return kong.response.exit(403, { message = "Forbidden - insufficient role" })
  -- end

  local path = kong.request.get_path()

  if role == "ROLE_admin" then
    -- Admin được đi qua tất cả các path
    return
  elseif role == "ROLE_hrm" then
    if not path:match("^/hrm") then
      return kong.response.exit(403, { message = "Forbidden - HRM role only allowed on /hrm path" })
    end
  else
    return kong.response.exit(403, { message = "Forbidden - insufficient role" })
  end

end

return RoleChecker
