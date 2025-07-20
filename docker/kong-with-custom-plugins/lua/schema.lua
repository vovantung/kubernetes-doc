local typedefs = require "kong.db.schema.typedefs"

return {
  name = "txu-plugins",  -- BẮT BUỘC
  fields = {
    { consumer = typedefs.no_consumer },  -- nếu muốn plugin áp dụng ở route/service/global chứ không theo consumer
    { config = {
        type = "record",
        fields = {
          { required_role = { type = "string" } },
        },
        entity_checks = {
          -- có thể thêm các logic kiểm tra ràng buộc nâng cao
        }
      }
    }
  }
}
