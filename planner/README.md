# Planner 入口

每个需要写权限的 planner 会话从这里开始。四步拿到认证、进入工作仓库、
接续进度。

## 1. 装 age（本仓库）

```bash
git clone https://github.com/entropy356/agent-bootstrap.git
cd agent-bootstrap && ./install.sh ~/toolchain
export PATH="$HOME/toolchain/usr/bin:$PATH"
```

平台 x86_64 Linux（glibc）；`install.sh` 先按 [`SHA256SUMS`](../SHA256SUMS)
校验再解压，失败即退出。

## 2. 拿 PAT（age 公钥流程）

流程：**agent 发公钥 → 用户加密 → 私钥不传输**。

1. 生成密钥对（私钥只留在本机）：

   ```bash
   age-keygen -o key.txt   # key.txt 内含私钥与公钥注释行
   ```

2. 把**公钥**（`age1…` 那行）发给用户，等用户回加密的 `pat.age`；
3. 解密到固定文件（私钥只以文件路径使用，禁止 cat、粘贴、上传；解密
   输出不经 stdout）：

   ```bash
   age -d -i key.txt pat.age > pat.txt
   ```

安全规则：

- **私钥永不传输**：不出现在对话、终端输出、日志、代码、提交信息或任何
  仓库文件；需要新密钥时重新生成密钥对走一遍流程，不外发旧私钥；
- **令牌不回显**：用的时候只引用环境变量（`export GH_TOKEN=$(cat pat.txt)`）；
  `key.txt` / `pat.txt` / `pat.age` 已在 `.gitignore`，禁止提交；
- 权限不够、拿不到令牌直接问用户，不猜。

## 3. 进入 planning-center 接续工作

用 PAT clone 私有仓库 [planning-center](https://github.com/entropy356/planning-center)（planner 工作仓库）：

- `README.md`：工作职责与协作纪律；
- `PROGRESS.md`：进度记录，**倒序**，从最上面读起接续。

项目本体在 [dsh-pet-indesktop-rs](https://github.com/entropy356/dsh-pet-indesktop-rs)
（公开），issues 即任务看板；规范正文在主仓库 `SPEC.md`。Rust / GitNexus
工具链按需装，见 [portable-toolchain-pack](https://github.com/entropy356/portable-toolchain-pack)。

## 4. 有疑问

在 planning-center 提 issue（私有仓库，仅用户与 planner 可见），写清疑问
与上下文；需要用户决策的事项不自行猜测推进。
