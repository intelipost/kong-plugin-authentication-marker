local typedefs = require "kong.db.schema.typedefs"

return {
  name = "kong-plugin-authentication-marker",
  fields = {
    { config = {
        type = "record",
        fields = {
          { text = { type = "string", default = "Hey" }, }

        },
      },
    },
  },
}