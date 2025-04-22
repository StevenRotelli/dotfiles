local nvimtree = require("nvim-tree")

nvimtree.setup({
  filters = {
    custom = {
      ".DS_Store"
    },
  },
  -- renderer = {
  --   special_files = {}
  -- }
})
