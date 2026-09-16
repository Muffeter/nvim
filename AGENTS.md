# Neovim 配置维护与智能体（Agent）工作规范

详细规则与约束定义请参阅同目录下的 **[AGENT.md](./AGENT.md)**。

---

### 快速原则概览
1. **文档先行，严禁凭空捏造**：修改前优先查阅 `:help`、本地插件 `doc/*.txt` 与本地源码，严防 API/配置项臆想。
2. **闭环验证与验收门禁**：修改完成后必须执行无头加载测试（`nvim --headless`）与 `:checkhealth` 确认无报错。
3. **有效修改后自动 Git Commit**：经测试有效的改动及时完成 atomic commit，确保可审查、可随时一键回滚。
4. **Windows & P4 环境适配**：路径必须兼顾 `/` 与 `\`，Junction 目录（如 `C:\wddm`）调用 P4 前必须通过 `vim.uv.fs_realpath()` 解析为真实物理路径。
5. **Mapleader 规范**：必须为单空格字符 `" "`，严禁设置为 `"<Space>"`。
