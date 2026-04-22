local function enable_transparency()
  local groups = {
    "Normal",
    "NormalFloat",
    "SignColumn",
    "EndOfBuffer",
    "NormalNC",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

return {
  {
    -- "navarasu/onedark.nvim",
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- require('onedark').setup {
      --	style = 'warmer'
      -- }
      --require('onedark').load()
      vim.cmd.colorscheme("monokai-nightasty")
      -- enable_transparency()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- theme = 'onedark',
      theme = "monokai-nightasty",
    },
  },
}
