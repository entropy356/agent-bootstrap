# portable-age

age 1.2.1 用户级便携包（public，免 root）。本 README 是 agent 开工引导。

## 仓库位置

| 仓库 | 地址 | 内容 |
|---|---|---|
| 本仓库 | `https://github.com/entropy356/portable-age` | age 1.2.1（加密工具） |
| portable-toolchain-pack | `https://github.com/entropy356/portable-toolchain-pack` | Rust 1.99.0（rustc+cargo）+ GitNexus 1.6.12 |
| dsh-pet-indesktop-rs | `https://github.com/entropy356/dsh-pet-indesktop-rs` | 项目代码与 issues |

三个仓库都是 public，clone 不需要 PAT。需要 PAT 的场景只有推送代码、
调 API 改 issue 等写操作；PAT 由用户生成（fine-grained，最小权限）并通过
私密渠道提供，仓库里不会有，找不到就直接问用户。

## 凭据规则（先读）

- **PAT 与 age 私钥都不要回显**：不出现在终端输出、日志、echo、代码、提交信息或任何仓库文件里。
- PAT 只从环境变量或凭据管理器读取，引用变量而不是字面值。
- age 私钥以文件路径使用（`age -d -i <keyfile>`），禁止 cat、粘贴、上传。

## 环境搭建

```bash
git clone https://github.com/entropy356/portable-age.git
cd portable-age && ./install.sh ~/toolchain
export PATH="$HOME/toolchain/usr/bin:$PATH"

# Rust 与 GitNexus 在 portable-toolchain-pack 里：
#   ./rust/install-rust.sh ~/rust-toolchain
#   ./gitnexus/install-gitnexus.sh ~/gitnexus-toolchain
```

平台：x86_64 Linux（glibc）。age 仅依赖 libc6；`install.sh` 会先按
[`SHA256SUMS`](SHA256SUMS) 校验再解压，校验失败直接退出。
