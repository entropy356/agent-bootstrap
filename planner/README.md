# Planner 入口（继任通道）

Planner 继任者从这里开始。四步拿到认证、进入工作仓库、接续进度。

## 1. 装 age（本仓库）

```bash
git clone https://github.com/entropy356/agent-bootstrap.git
cd agent-bootstrap && ./install.sh ~/toolchain
export PATH="$HOME/toolchain/usr/bin:$PATH"
```

平台：x86_64 Linux（glibc）。`install.sh` 会先按
[`SHA256SUMS`](../SHA256SUMS) 校验再解压，校验失败直接退出。

## 2. 拿 PAT（age 公钥流程）

流程固定为：**agent 发公钥 → 用户加密 → 私钥不传输**。

1. 生成密钥对（私钥只留在本机，不发给任何人）：

   ```bash
   age-keygen -o key.txt   # key.txt 内含私钥与公钥注释行
   ```

2. 把其中的**公钥**（`age1…` 那行）发给用户，等用户用该公钥加密 PAT
   得到 `pat.age` 发回。
3. 用本地私钥解密到**固定文件** `pat.txt`（私钥只以文件路径使用，禁止
   cat、粘贴、上传；解密输出不走 stdout，避免混进终端记录）：

   ```bash
   age -d -i key.txt pat.age > pat.txt
   ```

安全规则（必须遵守）：

- **私钥永不传输**：私钥只在持有它的 agent 工作区里，不出现在对话、
  终端输出、日志、代码、提交信息或任何仓库文件里；需要新密钥时重新
  生成密钥对并走一遍上述流程，不要把旧私钥发出去。
- **令牌不要回显**：不出现在终端输出、日志、echo、代码、提交信息或任
  何仓库文件里。解密后的明文 PAT 固定存工作区 `pat.txt`，用的时候只引
  用环境变量（如 `export GH_TOKEN=$(cat pat.txt)`）。`key.txt`、
  `pat.txt`、`pat.age` 已列入仓库 `.gitignore`，禁止提交。
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

---

另见 [self/README.md](self/README.md)（克隆通道）：本页只交接权限与现状；
要成为「同一个我」（人格、判断、操作手册），走克隆通道。
