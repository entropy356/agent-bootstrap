# Planner 入口

Planner 继任者从这里开始。四步拿到认证、进入工作仓库、接续进度。

## 1. 装 age（本仓库）

```bash
git clone https://github.com/entropy356/agent-bootstrap.git
cd agent-bootstrap && ./install.sh ~/toolchain
export PATH="$HOME/toolchain/usr/bin:$PATH"
```

平台：x86_64 Linux（glibc）。`install.sh` 会先按
[`SHA256SUMS`](../SHA256SUMS) 校验再解压，校验失败直接退出。

## 2. 解密 pat.enc 拿 PAT

用户会私下提供 `pat.enc`（age 加密的 PAT）与 age 私钥。解密：

```bash
age -d -i <私钥文件> pat.enc
```

安全规则（必须遵守）：

- **令牌与 age 私钥都不要回显**：不出现在终端输出、日志、echo、代码、提交信息或任何仓库文件里，只引用环境变量名（如 `export GH_TOKEN=$(age -d -i key.txt pat.enc)`）。
- age 私钥只以文件路径使用（`age -d -i <keyfile>`），禁止 cat、粘贴、上传。
- 权限不够、拿不到令牌就直接问用户，不要猜。

## 3. 进入 planning-center 接续工作

用 PAT clone 私有仓库 [planning-center](https://github.com/entropy356/planning-center)
（原 planner-bootstrap，planner 的工作仓库）：

- `README.md`：工作职责（拆 issue、跟踪进度、交接记录）
- `PROGRESS.md`：进度记录，**倒序**，从最上面读起即可接续

项目本体在 [dsh-pet-indesktop-rs](https://github.com/entropy356/dsh-pet-indesktop-rs)（公开）：
issues 即任务看板。Rust / GitNexus 工具链按需装，见
[portable-toolchain-pack](https://github.com/entropy356/portable-toolchain-pack)。

## 4. 有疑问

在 planning-center 提 issue（私有仓库，仅用户与 planner 可见），写清疑问与上下文；
需要用户决策的事项不要自行猜测推进。
