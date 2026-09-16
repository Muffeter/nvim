# Neovim 配置维护与智能体（Agent）工作规范

本文档用于约束并指导所有在此 Neovim 配置仓库中开展开发、修改、插件集成与调试工作的 Agent。所有操作必须严格遵守以下原则与执行门禁。

---

## 一、核心原则：文档先行，严禁凭空捏造（Doc-First Principle）

1. **查阅文档后再动笔**：
   - 严禁凭记忆或猜测配置项、API 字段或插件行为。
   - 修改前必须优先检索并查阅以下本地权威材料：
     1. **Neovim 官方本地帮助文档**：`runtime/doc/*.txt`，如 `:help options`、`:help telescope.defaults`、`:help vim.treesitter` 等。
     2. **插件本地安装包文档与 README**：位于 `C:\Users\ming.gui\AppData\Local\nvim-data\lazy\<plugin>\` 下的 `doc/*.txt` 和 `README.md`。
     3. **插件本地 Lua 源码**：遇到行为不确定、版本差异或多平台边界条件时，直接查阅 `nvim-data/lazy/<plugin>/lua/` 中的实际代码实现。
2. **版本敏感情境（Neovim Nightly & Plugin Versioning）**：
   - 当前环境运行的是 **Neovim Nightly（v0.13.0-dev）**，内部 API（如 `vim.treesitter`、LSP 客户端配置 `vim.lsp.config`）与稳定版存在显著重构差异。
   - 严禁复制互联网上针对旧版本（如 Neovim 0.9/0.10）的过期教程或过时 workaround，所有 API 调用必须以当前运行时的实际签名与返回类型为准。

---

## 二、严格的验证门禁与验收流程（Verification Gate）

在声称“完成工作”或向用户汇报之前，必须完成全套可验证性检查，绝不允许未经实测的代码交付：

1. **语法与无头加载测试（Headless Smoke Test）**：
   - 任何 Lua 文件修改后，必须运行无头 Neovim 执行测试，确保没有语法错误、循环依赖或启动异常：
     ```powershell
     nvim --headless -c "lua require('mappings'); require('plugins')" -c "qall!"
     ```
2. **功能闭环验证（Functional Verification）**：
   - 针对修改的具体功能执行针对性调用验证。例如：
     - 修改快捷键：检查 `vim.api.nvim_get_keymap('n')` 中对应的物理按键（如 `<Space>` 真实空格）是否被正确绑定。
     - 修改 LSP / 格式化 / 补全：启动对应 buffer 执行验证。
     - 修改浮窗/UI：通过无头模式模拟触发，捕获是否抛出 UI 或运行时异常。
3. **健康状态检查（Checkhealth Validation）**：
   - 当修改涉及 LSP、Tree-sitter、Telescope、Mason、Git/VCS 时，必要时运行 checkhealth 验证运行环境完备：
     ```powershell
     nvim --headless -c "checkhealth treesitter" -c "qall!"
     ```

---

## 三、有效修改后自动 Git Commit（Disciplined Version Control）

1. **原子化提交（Atomic Commits）**：
   - 当一个功能点、配置优化或 Bugfix 经过验证无误后，**主动且及时地进行本地 git commit**。
   - 确保每个 commit 粒度清晰独立，包含完整的修改与其对应的配置文件，绝不堆积大量互不相干的散碎变更。
2. **便于安全比对与随时回滚**：
   - 明确的提交历史使得用户随时可以通过 `git diff`、`git log` 审查改动，或在需要时执行 `git revert` / `git checkout` 瞬间恢复稳定工作环境。
3. **提交规范**：
   - 严格遵循 Conventional Commits 标准格式（`feat(scope): ...`, `fix(scope): ...`, `refactor(scope): ...`）。
   - 仅暂存并提交与当前修改直接相关的文件，绝不提交缓存垃圾或临时文件。

---

## 四、Windows 平台与 P4 (Perforce) 环境特异性规则

1. **路径分隔符与规范化陷阱**：
   - Windows 下文件路径可能混用正斜杠 `/` 与反斜杠 `\`。
   - 在路径切割、模式匹配、Telescope 格式化时，必须使用同时兼容两种分隔符的逻辑（如 `[^/\\]+`），或使用 `vim.fs` 标准函数，严禁硬编码单个 `\`。
2. **Junction 软链接与 Perforce Client Root 映射**：
   - 工程通常挂载在目录替身/软链接下（例如 `C:\wddm` 是实际磁盘路径 `C:\work\p4\ming.gui_client_ws\...` 的 Junction 挂载点）。
   - Perforce 命令行工具进行路径匹配时对 Client Root 极其敏感，传入软链接路径会导致 `Path is not under client root` 报错。
   - **规则**：调用 P4 命令前必须通过 `vim.uv.fs_realpath(filepath)` 转换为底层真实物理路径；展示给用户时再根据当前 `cwd` 映射回工整的工作区路径。
3. **Mapleader 规范**：
   - 在 Neovim 中，`vim.g.mapleader` 必须设置为真实的单空格字符 `" "`，**严禁**设置为字符串 `"<Space>"`，否则所有以 `<leader>` 开头的快捷键都会被解析为 7 个字符的字面量而失效。

---

## 五、代码质量与协作准则

1. **局部精确替换（Diff/Search-Replace）**：
   - 修改现有配置时，坚持最小侵入式精准编辑，禁止随意将整个大文件推倒重写，保留用户已有的自定习惯。
2. **极简整洁，无废话无冗余**：
   - 新增代码中严禁堆砌无意义的说明性注释、自夸性注释或废弃的死代码块。
   - 遵守全局指令规范：保持简练，用清晰自解释的代码替代冗长注释。
