# agent-bootstrap

Agent 开工引导仓库。先 clone 这里：拿到仓库地图、凭据规则、环境搭建和工作流程，
顺带装好 age（文件加密工具）。

## 仓库地图

| 仓库 | 地址 | 用途 |
|---|---|---|
| 本仓库 agent-bootstrap | `https://github.com/entropy356/agent-bootstrap` | 开工引导 + age 1.2.1 便携包 |
| portable-toolchain-pack | `https://github.com/entropy356/portable-toolchain-pack` | Rust 1.99.0（rustc+cargo）+ GitNexus 1.6.12 |
| dsh-pet-indesktop-rs | `https://github.com/entropy356/dsh-pet-indesktop-rs` | 项目代码与 issues |

三个仓库都是 public，clone 不需要 PAT。PAT 只在推送代码、调 API 写操作时需要，
由用户生成（fine-grained，最小权限）并通过私密渠道提供，仓库里不会有，
找不到就直接问用户。

## 凭据规则（先读）

- **PAT 与 age 私钥都不要回显**：不出现在终端输出、日志、echo、代码、提交信息或任何仓库文件里。
- PAT 只从环境变量或凭据管理器读取，引用变量而不是字面值。
- age 私钥以文件路径使用（`age -d -i <keyfile>`），禁止 cat、粘贴、上传。

## 环境搭建

```bash
# 1) age（本仓库）
git clone https://github.com/entropy356/agent-bootstrap.git
cd agent-bootstrap && ./install.sh ~/toolchain
export PATH="$HOME/toolchain/usr/bin:$PATH"

# 2) Rust 1.99.0 + GitNexus（portable-toolchain-pack）
git clone https://github.com/entropy356/portable-toolchain-pack.git
cd portable-toolchain-pack
./rust/install-rust.sh ~/rust-toolchain
./gitnexus/install-gitnexus.sh ~/gitnexus-toolchain
```

平台：x86_64 Linux（glibc）。age 仅依赖 libc6；`install.sh` 会先按
[`SHA256SUMS`](SHA256SUMS) 校验再解压，校验失败直接退出。

## 工作流程

1. 按「环境搭建」装好工具链。
2. clone `dsh-pet-indesktop-rs`，从它的 README 和 issues 了解项目、领任务。
3. 开工：改动 → commit → push（写操作需 PAT）。
4. 需要交接敏感文件时用本仓库的 age 加解密（私钥规则见上）。
5. 信息不够就问用户，不要编造。
