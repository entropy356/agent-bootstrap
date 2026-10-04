# agent-bootstrap

Agent 开工引导仓库。先 clone 这里：拿到仓库地图、认证方式和工作流程；
工具链（Rust / GitNexus / age）按需选装，多数纯读写任务可以不装。

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
| PAT | 用户生成（fine-grained，最小权限）， age 加密提供 | 长期 | 从环境变量或凭据管理器读取 |
| `ghs_token` | 用户生成 | 约 1 小时，用完即弃 | 无需 age 加密 |

共同规则：

- **令牌与 age 私钥都不要回显**：不出现在终端输出、日志、echo、代码、提交信息或任何仓库文件里，只引用环境变量名。
- 权限不够、找不到令牌就直接问用户，不要猜。
- age 私钥以文件路径使用（`age -d -i <keyfile>`），禁止 cat、粘贴、上传。

## 环境搭建（可选）

按任务需要选装：涉及 Rust 编译、GitNexus 或 age 加解密时才装；纯读写任务可跳过。

```bash
# 1) age（本仓库）——加解密敏感文件时
git clone https://github.com/entropy356/agent-bootstrap.git
cd agent-bootstrap && ./install.sh ~/toolchain
export PATH="$HOME/toolchain/usr/bin:$PATH"

# 2) Rust 1.99.0 + GitNexus（portable-toolchain-pack）——编译 / 代码索引时
git clone https://github.com/entropy356/portable-toolchain-pack.git
cd portable-toolchain-pack
./rust/install-rust.sh ~/rust-toolchain
./gitnexus/install-gitnexus.sh ~/gitnexus-toolchain
```

平台：x86_64 Linux（glibc）。age 仅依赖 libc6；`install.sh` 会先按
[`SHA256SUMS`](SHA256SUMS) 校验再解压，校验失败直接退出。

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
