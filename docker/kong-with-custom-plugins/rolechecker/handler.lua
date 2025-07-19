local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

local RoleChecker = {
  PRIORITY = 1000,
  VERSION = "1.0",
}

function RoleChecker:access(conf)
  kong.log.notice("[RoleChecker] Access phase started")

  local token = kong.request.get_header("Authorization")
  if not token then
    kong.log.err("[RoleChecker] Missing Authorization header")
    return kong.response.exit(401, { message = "Missing Authorization header" })
  end

  token = token:gsub("Bearer ", "")
  kong.log.debug("[RoleChecker] Token after strip: ", token)

  local jwt, err = jwt_decoder:new(token)
  if err then
    kong.log.err("[RoleChecker] JWT decode error: ", err)
    return kong.response.exit(401, { message = "Invalid token" })
  end

  if not jwt.claims then
    kong.log.err("[RoleChecker] JWT claims missing")
    return kong.response.exit(401, { message = "Invalid token claims" })
  end

  local role = jwt.claims.role
  if not role then
    kong.log.err("[RoleChecker] Role missing in token")
    return kong.response.exit(403, { message = "Missing role in token" })
  end

  kong.log.notice("[RoleChecker] Role in token: ", role)

  local path = kong.request.get_path()
  kong.log.notice("[RoleChecker] Request path: ", path)

  if role == "ROLE_admin" then
    kong.log.notice("[RoleChecker] Admin role - full access")
    return
  elseif role == "ROLE_hrm" then
    if not path:match("^/hrm") then
      kong.log.warn("[RoleChecker] HRM role but invalid path: ", path)
      return kong.response.exit(403, { message = "Forbidden - HRM role only allowed on /hrm path" })
    end
  else
    kong.log.warn("[RoleChecker] Insufficient role: ", role)
    return kong.response.exit(403, { message = "Forbidden - insufficient role" })
  end
end

return RoleChecker
