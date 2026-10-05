# Agent 开工引导

执行端 agent 从这里开始。先读本页拿到认证方式、工作流程和工具链接；
工具链（Rust / GitNexus）按需选装，多数纯读写任务可以不装。

## 仓库地图

| 仓库 | 地址 | 用途 |
|---|---|---|
| 本仓库 agent-bootstrap | `https://github.com/entropy356/agent-bootstrap` | 开工引导 + age 1.2.1 便携包 |
| portable-toolchain-pack | `https://github.com/entropy356/portable-toolchain-pack` | Rust 1.99.0（rustc+cargo）+ GitNexus 1.6.12 |
| dsh-pet-indesktop-rs | `https://github.com/entropy356/dsh-pet-indesktop-rs` | 项目代码与 issues |

## 认证方式（先读）

写操作（push、评论、调 API）需要认证，二选一：

| 方式 | 获取 | 有效期 | 使用方式 |
|---|---|---|---|
| PAT | 用户生成（fine-grained，最小权限），经 age 交接（流程见下） | 长期 | 从环境变量或凭据管理器读取 |
| `ghs_token` | 用户生成 | 约 1 小时，用完即弃 | 无需 age 加密 |

PAT 的 age 交接流程（固定不变）：**agent 发公钥 → 用户加密 → 私钥不传输**。

1. agent 生成密钥对：`age-keygen -o key.txt`（私钥只留在 agent 工作区）。
2. agent 把**公钥**（`age1…` 行）发给用户。
3. 用户用该公钥加密 PAT 得到 `pat.enc`，发回给 agent。
4. agent 用本地私钥解密：`age -d -i key.txt pat.enc`。

共同规则：

- **age 私钥永不传输**：只在持有它的 agent 工作区里，不出现在对话、终端
  输出、日志、echo、代码、提交信息或任何仓库文件里；需要新密钥时重新生
  成密钥对走上述流程，不外发旧私钥。
- **令牌不要回显**：不出现在终端输出、日志、echo、代码、提交信息或任何仓库文件里，只引用环境变量名。
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

2. **Rust 1.99.0 + GitNexus**——编译 / 代码索引时：
   安装方法见 <https://github.com/entropy356/portable-toolchain-pack>（仓库内 rust/ 与 gitnexus/ 目录各带 install 脚本）。

## 工作流程

1. 确认认证方式（上表），需要工具链时按「环境搭建」选装。
2. clone `dsh-pet-indesktop-rs`，从它的 README 和 issues 了解项目、领任务（见下节）。
3. 开工：改动 → commit → push（写操作需认证）。
4. 需要交接敏感文件时用 age 加解密（私钥规则见上）。
5. 信息不够就问用户，不要编造。

## 领取 issue

1. 列出 open issue（`gh issue list -R entropy356/dsh-pet-indesktop-rs` 或
   `GET /repos/entropy356/dsh-pet-indesktop-rs/issues?state=open`），通读标题、正文和已有评论。
2. 选定后**先评论再开工**：在 issue 下评论「认领」并简述计划，然后才开始动手。
3. 开分支（如 `feat/xxx`、`fix/xxx`），提交信息引用编号（`… (#5)`）。
4. 完成、验证通过后推送；commit 或 PR 里用 `closes #N` 等关键字自动关闭 issue，
   或完成后在 issue 下留言收尾。
5. 有进展回到 issue 下更新，别让 issue 长期无动静。
