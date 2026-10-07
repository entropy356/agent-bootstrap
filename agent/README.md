# Agent 开工引导

执行端 agent 从这里开始：认证方式、工作流程、工具链接。
工具链（Rust / GitNexus）按需选装，纯读写任务可不装。

## 仓库地图

| 仓库 | 地址 | 用途 |
|---|---|---|
| 本仓库 agent-bootstrap | `https://github.com/entropy356/agent-bootstrap` | 开工引导 + age 1.2.1 便携包 |
| portable-toolchain-pack | `https://github.com/entropy356/portable-toolchain-pack` | Rust 1.99.0（rustc+cargo+clippy+rustfmt）+ GitNexus 1.6.12 |
| dsh-pet-indesktop-rs | `https://github.com/entropy356/dsh-pet-indesktop-rs` | 项目代码与 issues |

## 认证方式

写操作（push、评论、调 API）需要认证，二选一：

| 方式 | 获取 | 有效期 | 使用方式 |
|---|---|---|---|
| PAT | 用户生成，经 age 交接 | 长期 | 从环境变量存取 |
| `ghs_token` | 用户生成 | 约 1 小时，用完即弃 | 无需 age 加密 |

**执行端 PAT 规格（用户生成时按此最小集）**：
fine-grained PAT，仓库范围仅 `dsh-pet-indesktop-rs`：

- `Contents: Read and write`（clone / push 分支）
- `Issues: Read and write`（评论、认领、打 label）
- `Pull requests: Read and write`（开 PR、响应审查）
- `Metadata: Read-only`（必选附带）
- 不给 Discussions 写权限（公共广播面收敛，反馈一律走 issue 评论）
- 不需要其他仓库权限：规范在主仓库 `SPEC.md`（公开），planning-center
  与执行端无关

规范/契约有疑问走 issue 评论或对话，不用 Discussions。

**PAT 的 age 交接流程**：

1. `age-keygen -o key.txt`（私钥只留在工作区），把**公钥**（`age1…`）发给用户；
2. 用户回加密的 `pat.age`；
3. `age -d -i key.txt pat.age > pat.txt`（明文只存工作区 `pat.txt`，
   不经 stdout 传递）。

共同规则：

- 私钥与令牌**不传输、不回显**：不出现在对话、终端输出、日志、代码、
  提交信息或任何仓库文件；`key.txt` / `pat.txt` / `pat.age` 已在
  `.gitignore`，禁止提交；
- 权限不够、找不到令牌直接问用户，不猜。

## 环境搭建（可选）

1. **age（本仓库）**：

   ```bash
   git clone https://github.com/entropy356/agent-bootstrap.git
   cd agent-bootstrap && ./install.sh ~/toolchain
   export PATH="$HOME/toolchain/usr/bin:$PATH"
   ```

   平台 x86_64 Linux（glibc）；`install.sh` 先按 [`SHA256SUMS`](../SHA256SUMS)
   校验再解压，失败即退出。

2. **Rust 1.99.0（含 clippy / rustfmt）+ GitNexus**：
   见 <https://github.com/entropy356/portable-toolchain-pack>（`rust/` 与
   `gitnexus/` 各带 install 脚本，免 root）。

## 工作流程

1. 确认认证方式；需要工具链按「环境搭建」选装。
2. 读主仓库根目录 **`SPEC.md`**（单一事实源），确认是最新版再动工。
3. clone `dsh-pet-indesktop-rs`，读 README 与 issues，领任务（见下节）。
4. 开工：改动 → 推送前自检 → commit → push。改 Rust 代码的 PR 推送前
   本地过 CI 同款门禁：

   ```bash
   cargo clippy -- -D warnings
   cargo fmt -- --check
   ```

   （沙箱 overlay 下报 incremental 错误时 `export CARGO_INCREMENTAL=0`。）
5. 敏感文件交接用 age（私钥规则见上）。
6. 信息不够就问用户，不编造。

## 领取 issue

1. 列 open issue，通读标题、正文、评论。
2. 选定后**先评论再开工**：在父任务 issue 下评论「认领」并简述计划；同时
   开执行 issue：标题 `exec: 一句话简述 (#N)`，正文两三行（父任务链接 +
   本次范围）；完成后 commit / PR 里 `closes` 指回执行 issue，父任务关闭
   条件由 planner 或 `closes #N` 兜底。
3. 开分支（`feat/xxx` / `fix/xxx`），提交信息引用编号。
4. 完成并验证后推送，用 `closes #N` 自动关闭。
5. 有进展回 issue 更新。
6. **反馈**：需用户即时裁决的问题（契约歧义、验收争议、外部阻塞）先在
   对话中直报用户，再落 issue 评论；其余反馈在相关 issue 评论（并行
   会话场景才 @ 相关方），评论开头带前缀——`[阻塞]`（无法继续，planner 优先处理）/ `[反馈]`
   （提示、疑问、非阻塞）。
