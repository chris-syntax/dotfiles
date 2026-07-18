return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  opts = {
    provider = "ollama",
    providers = {
      ollama = {
        endpoint = "http://localhost:11434",
        model = "deepseek-coder:6.7b",
        system_prompt = "You are a precise coding assistant. Answer concisely and focus only on the provided code and question.",
        -- optional but nice
        temperature = 0.2,
        max_tokens = 2048,
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
}
