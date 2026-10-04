#!/usr/bin/env bash
# age 用户级安装脚本：把 age_*.deb 解压到指定前缀目录（无需 root）
# 用法: ./install.sh [目标目录]   （默认 ./toolchain）
#
# age 仅依赖 libc6（Debian 官方构建），解压后即可直接运行。
set -euo pipefail

PREFIX="${1:-./toolchain}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v dpkg-deb >/dev/null 2>&1; then
    echo "缺少依赖：dpkg-deb（提供于 dpkg 包）" >&2
    echo "Debian/Ubuntu 上可执行：sudo apt-get install -y dpkg" >&2
    exit 1
fi

# 1) 先校验 SHA256，避免下载中断留下损坏包
if command -v sha256sum >/dev/null 2>&1; then
    ( cd "$SCRIPT_DIR" && sha256sum -c SHA256SUMS )
else
    echo "警告：未找到 sha256sum，跳过完整性校验" >&2
fi

# 2) 解压到目标前缀
mkdir -p "$PREFIX"
for deb in "$SCRIPT_DIR"/age_*.deb; do
    echo "解压 $(basename "$deb") ..."
    dpkg-deb -x "$deb" "$PREFIX"
done

BINDIR="$PREFIX/usr/bin"

echo
echo "安装完成。使用方式（每次使用前设置环境变量）："
echo "  export PATH=\"$BINDIR:\$PATH\""
echo
echo "包含的工具："
"$BINDIR/age" --version
"$BINDIR/age-keygen" --version
