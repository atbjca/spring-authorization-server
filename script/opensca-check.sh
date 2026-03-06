#!/bin/bash
set -e  # 遇到错误立即退出

# ==================== 配置区 ====================
OPSCA_TOKEN="6c98b35d-52a8-4c02-9ead-1a95925e6526"
# ================================================

# 1. 检查 opensca-cli 是否存在
if ! command -v opensca-cli &> /dev/null; then
    echo "❌ 错误：opensca-cli 未找到"
    echo ""
    echo "安装方式："
    echo "  npm   : npm install -g @opensca/cli"
    echo "  官网  : https://opensca.xmirror.cn/"
    exit 1
fi

# 2. 获取项目信息（优化：只执行一次，增加引号保护）
BASE_PATH="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$BASE_PATH")"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

# 3. 检查 PROJECT_NAME 是否有效
if [[ -z "$PROJECT_NAME" ]]; then
    echo "❌ 错误：无法获取项目名称"
    exit 1
fi

# 4. 检查项目目录是否存在
if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "❌ 错误：项目目录不存在: $PROJECT_DIR"
    exit 1
fi

# 5. 生成统一的时间戳（关键优化）
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="opensca-${PROJECT_NAME}-${TIMESTAMP}.log"
REPORT_FILE="opensca-${PROJECT_NAME}-${TIMESTAMP}.html"

# 6. 切换到项目目录并执行扫描
echo "📂 项目目录: $PROJECT_DIR"
echo "🔍 开始扫描..."
echo "   日志文件: $LOG_FILE"
echo "   报告文件: $REPORT_FILE"
echo ""

cd "$PROJECT_DIR"

# 7. 执行扫描并检查返回值
if opensca-cli -token "$OPSCA_TOKEN" -path . -log "$LOG_FILE" -out "$REPORT_FILE"; then
    echo ""
    echo "✅ 扫描成功！"
    echo "📄 报告: $PROJECT_DIR/$REPORT_FILE"
    echo "📝 日志: $PROJECT_DIR/$LOG_FILE"
else
    echo ""
    echo "❌ 扫描失败，请检查日志: $LOG_FILE"
    exit 1
fi