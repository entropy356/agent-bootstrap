# age 1.2.1 用户级便携安装包

用户级（免 root）便携打包的 [age](https://age-encryption.org/) 1.2.1（含 `age-keygen`）：
现代文件加密工具。跨机器复制即可用，不污染系统环境。

- 来源：Debian 13 (trixie) 官方仓库 `age_1.2.1-1+b5_amd64.deb`，仅依赖 `libc6`（>= 2.34）
- 平台：x86_64 Linux（glibc）
- 许可：age 为 BSD-3-Clause（原项目）+ Debian 打包许可，可自由再分发

## 安装（免 root）

依赖：`dpkg`（提供 `dpkg-deb`）。Debian/Ubuntu 上
`sudo apt-get install -y dpkg`；缺失时脚本会明确提示并退出。

```bash
./install.sh ~/toolchain    # 默认 ./toolchain
```

之后每次使用前：

```bash
export PATH="$HOME/toolchain/usr/bin:$PATH"
```

脚本会先按 [`SHA256SUMS`](SHA256SUMS) 校验 `.deb` 完整性（校验不过直接退出），再解压并打印版本号验证。

## 相关仓库

| 仓库 | 远程地址 | 可见性 | 内容 |
|---|---|---|---|
| **本仓库** portable-age | `https://github.com/entropy356/portable-age` | public | age 1.2.1 |
| portable-toolchain-pack | `https://github.com/entropy356/portable-toolchain-pack` | private | Rust 1.99.0（rustc + cargo）+ GitNexus 1.6.12 |

本仓库是公开的，`git clone` **不需要任何凭据**。
portable-toolchain-pack 是私有的，拉取/推送需要 PAT，流程见下节。

## PAT 交换流程（两台机器间同步）

适用于 private 仓库 portable-toolchain-pack（本仓库无需此流程）。

### 1. 生成 PAT（在已登录 GitHub 的浏览器上）

GitHub → 右上角头像 → **Settings** → 左栏最下 **Developer settings** →
**Personal access tokens** → **Fine-grained tokens** → **Generate new token**：

- **Token name**：如 `toolchain-pack-pull-<机器名>`
- **Expiration**：90 天（到期前按第 4 步轮换）
- **Repository access**：Only select repositories → 勾选 `entropy356/portable-toolchain-pack`
- **Permissions → Repository permissions → Contents**：只拉取选 **Read-only**；需要推送才选 **Read and write**

最小权限原则：一个 token 只绑定一个仓库、一种权限，不要生成万能 token。

### 2. 交接 token（换机）

- 只走私密渠道：密码管理器、端到端加密传输
- **不要**写进聊天记录、邮件、截图或任何仓库文件（包括本仓库的脚本与 README）
- 新机器拿到后立即使用，旧机器不需要长期保存

### 3. 新机器上使用

```bash
# 本仓库（public，无需凭据）
git clone https://github.com/entropy356/portable-age.git

# private 仓库：token 拼在 URL 里一次性 clone
git clone https://<TOKEN>@github.com/entropy356/portable-toolchain-pack.git

# 或长期保存凭据（明文存 ~/.git-credentials，机器须自用且加密）
git config --global credential.helper store
git clone https://github.com/entropy356/portable-toolchain-pack.git
# 用户名 entropy356，密码处粘贴 TOKEN
```

推送时若 token 是 Read-only，会报 403，按第 1 步重建为 Read and write 或另发一个专用 push token。

### 4. 轮换与撤销

- 到期轮换：生成新 token → 新机器更新凭据 → 在 token 列表 **Revoke** 旧 token
- 疑似泄露：立即 Revoke，再按第 1 步重发
- token 列表入口同第 1 步（Fine-grained tokens 页面）

### 5. 双机日常同步

```bash
# 机器 A（工作机）更新后
git -C ~/portable-toolchain-pack pull && git -C ~/portable-age pull

# 机器 B 使用前同样 pull
```
