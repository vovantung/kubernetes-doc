local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

local RoleChecker = {
  PRIORITY = 1000,
  VERSION = "1.0",
}

function RoleChecker:access(conf)
  
  local req_method = kong.request.get_method()
  local path = kong.request.get_path()

  -- Bỏ qua preflight CORS requests
  if req_method == "OPTIONS" then
    return
  end

  -- Bỏ qua các route public như /health
  -- if req_method == "GET" and path == "/health" then
  --   return
  -- end

  -- kong.log.notice("[RoleChecker] Access phase started")
  -- kong.log.debug("[RoleChecker] Token after strip: ", token)
  -- kong.log.err("[RoleChecker] JWT decode error: ", err)

  local token = kong.request.get_header("Authorization")
  if not token then
    return kong.response.exit(401, { message = "Missing Authorization header" })
  end

  token = token:match("Bearer%s+(.+)")
  if not token then
    return kong.response.exit(401, { message = "Invalid Authorization format" })
  end


  local jwt, err = jwt_decoder:new(token)
  if err then
    return kong.response.exit(401, { message = "Invalid token" })
  end

  local role = jwt.claims.role
  if not role then
    return kong.response.exit(403, { message = "Missing role in token" })
  end

  if role == "ROLE_admin" then
    -- Admin được đi qua tất cả các path
    return
  elseif role == "ROLE_hrm" and path:match("^/hrm") then
    return
  else
    return kong.response.exit(403, { message = "Dung lai - khong du tham quyen truy cap" })
  end

end

return RoleChecker
