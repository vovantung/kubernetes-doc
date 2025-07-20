local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

local RoleChecker = {
  PRIORITY = 10,
  VERSION = "1.0",
}

-- Hàm dùng chung gắn header
local function add_cors_headers()
  kong.response.set_header("Access-Control-Allow-Origin", "*")
  kong.response.set_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
  kong.response.set_header("Access-Control-Allow-Headers", "Authorization, Content-Type")
end

function RoleChecker:access(conf)
  
  local req_method = kong.request.get_method()
  local path = kong.request.get_path()

  -- Nếu là OPTIONS và plugin cấu hình không chạy preflight, thì bỏ qua



  if req_method == "OPTIONS" and path == "/get-role" then
    -- Set header cho response vì thoát sớm sẽ gây cors mặc định của kong sẽ không làm việc được với request này và sẽ không gán header giúp trình duyệt thấy hợp lệ và tiếp tục gửi request thật
    add_cors_headers()
    -- kong.response.exit(...) để tránh việc kong gọi đến service, vi đây là route không chứa service nên sẽ gây lỗi
    return kong.response.exit(200, {role = ""})

  elseif req_method == "OPTIONS" and conf.run_on_preflight == false then
    -- add_cors_headers()
    return
  end

  -- Nếu có path public, có thể mở lại điều kiện này
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


  if req_method == "GET" and path == "/get-role" then
    return kong.response.exit(200, {role = role})
  end

  if role == "ROLE_admin" then
    -- Admin được đi qua tất cả các path
    return
  elseif role == "ROLE_hrm" and path:match("^/hrm") then
    return
  else
    return kong.response.exit(403, { message = "Dừng lại - không đủ thẩm quyền truy cập!" })
  end

end

-- Phase: HEADER_FILTER (response đang trên đường trả về)
-- function RoleChecker:header_filter(conf)
--   add_cors_headers()
-- end

return RoleChecker
