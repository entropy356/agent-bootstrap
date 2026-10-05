# agent-bootstrap

Agent / Planner 开工引导仓库 + age 1.2.1 便携包。
本仓库只做「入口」：按角色读对应文档，按需拿工具。

## 入口（按角色选）

| 角色 | 入口文档 | 内容 |
|---|---|---|
| 执行端 agent | [agent/README.md](agent/README.md) | 认证方式、工作流程、领取 issue、工具链链接 |
| planner | [planner/README.md](planner/README.md) | 装 age → 领取 PAT（agent 发公钥、用户加密，私钥不传输）→ 进入 planning-center |

## 文件位置

| 路径 | 说明 |
|---|---|
| `agent/README.md` | 执行端开工引导 |
| `planner/README.md` | planner 继任引导 |
| `age_1.2.1-1+b5_amd64.deb` | age 1.2.1 便携包（x86_64 Linux, glibc） |
| `install.sh` | 安装脚本：按 `SHA256SUMS` 校验后解压到目标目录 |
| `SHA256SUMS` | age 便携包校验和 |

## 其他仓库

- [dsh-pet-indesktop-rs](https://github.com/entropy356/dsh-pet-indesktop-rs)：项目代码与 issues
- [portable-toolchain-pack](https://github.com/entropy356/portable-toolchain-pack)：Rust 1.99.0 + GitNexus 1.6.12（按需选装）
- [planning-center](https://github.com/entropy356/planning-center)：planner 工作仓库（私有）
