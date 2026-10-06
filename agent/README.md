# Agent 开工引导

执行端 agent 从这里开始。先读本页拿到认证方式、工作流程和工具链接；
工具链（Rust / GitNexus）按需选装，多数纯读写任务可以不装。

## 仓库地图

| 仓库 | 地址 | 用途 |
|---|---|---|
| 本仓库 agent-bootstrap | `https://github.com/entropy356/agent-bootstrap` | 开工引导 + age 1.2.1 便携包 |
| portable-toolchain-pack | `https://github.com/entropy356/portable-toolchain-pack` | Rust 1.99.0（rustc+cargo+clippy+rustfmt）+ GitNexus 1.6.12 |
| dsh-pet-indesktop-rs | `https://github.com/entropy356/dsh-pet-indesktop-rs` | 项目代码与 issues |

## 认证方式（先读）

写操作（push、评论、调 API）需要认证，二选一：

| 方式 | 获取 | 有效期 | 使用方式 |
|---|---|---|---|
| PAT | 用户生成，经 age 交接| 长期 | 从环境变量存取 |
| `ghs_token` | 用户生成 | 约 1 小时，用完即弃 | 无需 age 加密 |

**执行端 PAT 规格（2026-10-07 定稿；同日规范正文迁公开后，无需 planning-center 权限）**：
fine-grained PAT，仓库范围仅 `dsh-pet-indesktop-rs`，权限：

- `Contents: Read and write`（clone / push 分支）
- `Issues: Read and write`（评论、认领、打 label）
- `Pull requests: Read and write`（开 PR、响应审查）
- `Metadata: Read-only`（必选附带）
- **不给 Discussions 写权限**（公告位保护：Announcements 由 planner 独占发帖）；
  读公告用免认证的公开页面即可
- 不需要任何其他仓库的权限：规范正文在主仓库 `SPEC.md`（公开），
  planning-center 是 planner 私有工作仓库，执行端无权限也无需访问

规范/契约有疑问走 issue 评论或对话中转向用户，不用 Discussions。

PAT 的 age 交接流程（固定不变）：

1. agent 生成密钥对：`age-keygen -o key.txt`（私钥只留在工作区），把**公钥**发给用户。
2. 用户用该公钥加密 PAT 得到 `pat.age`，发回给 agent。
3. agent 用本地私钥解密到**固定文件** `pat.txt`：
   `age -d -i key.txt pat.age > pat.txt`（明文 PAT 只存工作区 `pat.txt`，
   不用 stdout 直接传递，避免混进终端记录）。

共同规则：

- **PAT和私钥不传输，不回显**：只存在工作区的 `key.txt`（私钥）和 `pat.txt`
  （解密后明文）里，不出现在对话、终端输出、日志、echo、代码、提交信息或
  任何仓库文件里。这两个文件连同 `pat.age` 已列入仓库 `.gitignore`，禁止提交。
- 权限不够、找不到令牌就直接问用户，不要猜。

## 环境搭建（可选）

按任务需要选装；纯读写任务可跳过。

1. **age（本仓库）**——加解密敏感文件时：

   ```bash
   git clone https://github.com/entropy356/agent-bootstrap.git
   cd agent-bootstrap && ./install.sh ~/toolchain
   export PATH="$HOME/toolchain/usr/bin:$PATH"
   ```

   平台：x86_64 Linux（glibc）。age 仅依赖 libc6；`install.sh` 会先按
   [`SHA256SUMS`](../SHA256SUMS) 校验再解压，校验失败直接退出。

2. **Rust 1.99.0（含 clippy / rustfmt） + GitNexus**——编译 / lint / 代码索引时：
   安装方法见 <https://github.com/entropy356/portable-toolchain-pack>（仓库内 rust/ 与 gitnexus/ 目录各带 install 脚本）。
   工具链自带与 CI 同版本的 clippy / rustfmt，装完即有。

## 工作流程

1. 确认认证方式（上表），需要工具链时按「环境搭建」选装。
2. **读规范正文 + 瞄一眼应急位**：规范正文是主仓库根目录的 **`SPEC.md`**
   （公开、clone 主仓库即得、单一事实源，动工前必读并确认最新版）；
   顺带看一眼主仓库 Discussions 的 **Announcements** 是否有应急公告——
   **正常状态下为空**（该位只用于临时应急广播，planner 独占）。
3. clone `dsh-pet-indesktop-rs`，从它的 README 和 issues 了解项目、领任务（见下节）。
4. 开工：改动 → **推送前自检** → commit → push（写操作需认证）。
   改了 Rust 代码的 PR，推送前先本地过一遍 CI 的同款门禁，别把 lint 问题
   留给 CI 烧一轮往返：

   ```bash
   cargo clippy -- -D warnings   # clippy 报警即失败
   cargo fmt -- --check          # 有 diff 先 cargo fmt
   ```

   （沙箱 overlay 文件系统下若编译报 incremental 目录错误，`export CARGO_INCREMENTAL=0` 再跑。）
5. 需要交接敏感文件时用 age 加解密（私钥规则见上）。
6. 信息不够就问用户，不要编造。

## 领取 issue

1. 列出 open issue ，通读标题、正文和已有评论。
2. 选定后**先评论再开工**：在父任务 issue 下评论「认领」并简述计划；同时
   **开一个执行 issue**：标题 `exec: 一句话简述 (#N)`，正文两三行（父任务链接 +
   本次执行范围），完成后在 commit / PR 里 `closes` 自己的执行 issue，
   并确保父任务的关闭条件被满足时由 planner 或 `closes #N` 指回。
3. 开分支（如 `feat/xxx`、`fix/xxx`），提交信息引用编号（`… (#5)`）。
4. 完成、验证通过后推送；commit 或 PR 里用 `closes #N` 等关键字自动关闭 issue。
5. 有进展回到 issue 下更新，别让 issue 长期无动静。
6. **反馈**：契约/验收标准的疑问直接在相关 issue 评论并 @ 用户；执行端 token
   无 Discussions 写权限，Announcements 只读，公告位由 planner 独占。
