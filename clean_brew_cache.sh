#!/bin/bash

# 交互式清理 Homebrew 脚本
# 检测并清理已通过其他方式卸载的软件在 Homebrew 中的残留信息

# 不使用 set -e，手动处理错误
set -o pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 临时文件
TEMP_DIR=$(mktemp -d)
BREW_LIST_CASKS="$TEMP_DIR/brew_list.txt"
INSTALLED_APPS="$TEMP_DIR/installed.txt"
MISSING_APPS="$TEMP_DIR/missing.txt"
SELECTED_FILE="$TEMP_DIR/selected.txt"

# 清理函数
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# 打印标题
print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BLUE}Homebrew 残留信息清理工具${NC}                            ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 检查依赖
check_dependencies() {
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}错误: 未找到 Homebrew${NC}"
        exit 1
    fi

    if ! command -v gum &> /dev/null; then
        echo -e "${YELLOW}提示: 未安装 gum (交互式工具)${NC}"
        echo -e "${YELLOW}正在安装 gum...${NC}"
        brew install gum
        echo ""
    fi
}

# 获取 brew 中记录的已安装 cask
get_brew_casks() {
    echo -e "${BLUE}🍺 正在获取 Homebrew 记录的应用...${NC}"
    brew list --cask 2>/dev/null > "$BREW_LIST_CASKS" || touch "$BREW_LIST_CASKS"

    local count=$(wc -l < "$BREW_LIST_CASKS" | tr -d ' ')
    echo -e "${GREEN}✓ Homebrew 记录了 $count 个应用${NC}"
    echo ""
}

# 获取 brew 中记录的已安装 formula
get_brew_formulas() {
    echo -e "${BLUE}🔧 正在获取 Homebrew 记录的 CLI 工具...${NC}"
    brew list --formula 2>/dev/null > "$TEMP_DIR/brew_formulas.txt" || touch "$TEMP_DIR/brew_formulas.txt"

    local count=$(wc -l < "$TEMP_DIR/brew_formulas.txt" | tr -d ' ')
    echo -e "${GREEN}✓ Homebrew 记录了 $count 个 CLI 工具${NC}"
    echo ""
}

# 获取应用程序目录中实际安装的应用
get_installed_apps() {
    echo -e "${BLUE}🔍 正在扫描应用程序目录...${NC}"
    ls -1 /Applications 2>/dev/null | grep -E "\.app$" | sed 's/\.app$//' > "$INSTALLED_APPS"

    local count=$(wc -l < "$INSTALLED_APPS" | tr -d ' ')
    echo -e "${GREEN}✓ 找到 $count 个已安装应用${NC}"
    echo ""
}

# cask 名称转应用名称的映射
cask_to_app_name() {
    local cask_name="$1"
    local app_name=""

    case "$cask_name" in
        "1password") app_name="1Password" ;;
        "1password-cli") return 1 ;; # CLI 工具，跳过
        "account-switcher") app_name="Account Switcher" ;;
        "aldente") app_name="AlDente" ;;
        "alt-tab") app_name="Alt-Tab" ;;
        "android-file-transfer") app_name="Android File Transfer" ;;
        "android-platform-tools") return 1 ;; # CLI 工具
        "antigravity-tools") app_name="Antigravity Tools" ;;
        "apipost") app_name="ApiPost" ;;
        "appcleaner") app_name="AppCleaner" ;;
        "applite") app_name="Applite" ;;
        "arc") app_name="Arc" ;;
        "backuploupe") app_name="BackupLoupe" ;;
        "bartender") app_name="Bartender 6" ;;
        "cc-switch") app_name="CC Switch" ;;
        "clashx-pro") app_name="ClashX Pro" ;;
        "claude") app_name="Claude" ;;
        "claude-code") return 1 ;; # CLI 工具，跳过
        "codex") app_name="Codex" ;;
        "codexbar") app_name="CodexBar" ;;
        "conductor") app_name="Conductor" ;;
        "db-browser-for-sqlite") app_name="DB Browser for SQLite" ;;
        "discord") app_name="Discord" ;;
        "firefox") app_name="Firefox" ;;
        "fork") app_name="Fork" ;;
        "gitbutler") app_name="GitButler" ;;
        "google-chrome") app_name="Google Chrome" ;;
        "google-chrome-beta") app_name="Google Chrome Beta" ;;
        "gray") app_name="Gray" ;;
        "hyper") app_name="Hyper" ;;
        "iina") app_name="IINA" ;;
        "input-source-pro") app_name="Input Source Pro" ;;
        "ice") app_name="Ice" ;;
        "keka") app_name="Keka" ;;
        "kekaexternalhelper") app_name="KekaExternalHelper" ;;
        "keycastr") app_name="KeyCastr" ;;
        "latest") app_name="Latest" ;;
        "launchos") app_name="LaunchOS" ;;
        "logoer") app_name="Logoer" ;;
        "loop") app_name="Loop" ;;
        "macupdater") app_name="MacUpdater" ;;
        "menuwhere") app_name="Menuwhere" ;;
        "microsoft-remote-desktop") app_name="Remote Desktop" ;;
        "monitorcontrol") app_name="MonitorControl" ;;
        "moonlight") app_name="Moonlight" ;;
        "mos") app_name="Mos" ;;
        "neteasemusic") app_name="NeteaseMusic" ;;
        "ngrok") app_name="ngrok" ;;
        "notion") app_name="Notion" ;;
        "obsidian") app_name="Obsidian" ;;
        "only-switch") app_name="Only Switch" ;;
        "opencode-desktop") app_name="OpenCode" ;;
        "orbstack") app_name="OrbStack" ;;
        "pearcleaner") app_name="Pearcleaner" ;;
        "qlcolorcode"|"qlimagesize"|"qlstephen") return 1 ;; # QuickLook 插件
        "qlmarkdown") app_name="QLMarkdown" ;;
        "qlvideo") app_name="QuickLook Video" ;;
        "qqmusic") app_name="QQMusic" ;;
        "quicklook-json"|"quicklookase"|"webpquicklook") return 1 ;; # QuickLook 插件
        "quickrecorder") app_name="QuickRecorder" ;;
        "raycast") app_name="Raycast" ;;
        "reminders-menubar") app_name="Reminders MenuBar" ;;
        "snipaste") app_name="Snipaste" ;;
        "stats") app_name="Stats" ;;
        "switchhosts") app_name="SwitchHosts" ;;
        "tabby") app_name="Tabby" ;;
        "telegram") app_name="Telegram" ;;
        "termhere") app_name="TermHere" ;;
        "todesk") app_name="ToDesk" ;;
        "topnotch") app_name="TopNotch" ;;
        "visual-studio-code") app_name="Visual Studio Code" ;;
        "visual-studio-code-insiders") app_name="Visual Studio Code - Insiders" ;;
        "warp") app_name="Warp" ;;
        "wechat") app_name="WeChat" ;;
        "whisky") app_name="Whisky" ;;
        "wireshark") app_name="Wireshark" ;;
        "wpsoffice-cn") app_name="wpsoffice" ;;
        *) return 1 ;;
    esac

    echo "$app_name"
    return 0
}

# 检测 brew 中已记录但实际已删除的应用
detect_missing_apps() {
    echo -e "${BLUE}🔎 正在检测已删除但 Homebrew 仍有记录的应用...${NC}"

    > "$MISSING_APPS"

    local total=$(wc -l < "$BREW_LIST_CASKS" | tr -d ' ')
    local current=0
    local checked=0

    while IFS= read -r cask_name; do
        ((current++))

        # 先尝试从 cask_to_app_name 获取应用名
        app_name=$(cask_to_app_name "$cask_name" 2>/dev/null)

        if [ $? -ne 0 ] || [ -z "$app_name" ]; then
            # 跳过字体和 CLI 工具
            if [[ "$cask_name" == font-* ]] || [[ "$cask_name" == *-cli ]]; then
                continue
            fi

            # 显示进度（仅对需要调用 brew info 的应用）
            ((checked++))
            echo -ne "\r  检查进度: $current/$total (正在检查: $cask_name...)" >&2

            # 如果映射失败，尝试从 brew info 提取路径
            app_path=$(brew info --cask "$cask_name" 2>/dev/null | grep -o '/Applications/[^(]*\.app' | head -1)

            if [ -n "$app_path" ]; then
                app_path=$(echo "$app_path" | xargs)
                app_name=$(basename "$app_path" .app)
            else
                # 如果都失败，跳过这个应用
                continue
            fi
        fi

        # 检查应用是否存在
        if [ ! -d "/Applications/${app_name}.app" ]; then
            echo "cask|${cask_name}|${app_name}" >> "$MISSING_APPS"
        fi
    done < "$BREW_LIST_CASKS"

    # 清除进度行
    echo -ne "\r\033[K"

    local count=$(wc -l < "$MISSING_APPS" | tr -d ' ')
    echo -e "${GREEN}✓ 检测到 $count 个已删除的 Cask 应用${NC}"
    echo ""
}

# 检测 brew 中已记录但实际已删除的 formula
detect_missing_formulas() {
    echo -e "${BLUE}🔎 正在检测已删除但 Homebrew 仍有记录的 CLI 工具...${NC}"

    local brew_prefix=$(brew --prefix)
    local total=$(wc -l < "$TEMP_DIR/brew_formulas.txt" | tr -d ' ')
    local current=0
    local missing_count=0

    while IFS= read -r formula_name; do
        ((current++))
        echo -ne "\r  检查进度: $current/$total" >&2

        # 检查 Cellar 目录是否存在
        if [ ! -d "$brew_prefix/Cellar/$formula_name" ]; then
            echo "formula|${formula_name}|${formula_name}" >> "$MISSING_APPS"
            ((missing_count++))
        fi
    done < "$TEMP_DIR/brew_formulas.txt"

    # 清除进度行
    echo -ne "\r\033[K"

    echo -e "${GREEN}✓ 检测到 $missing_count 个已删除的 Formula 工具${NC}"
    echo ""
}

# 检查是否有需要清理的项目
check_missing_items() {
    local count=$(wc -l < "$MISSING_APPS" | tr -d ' ')
    if [ "$count" -eq 0 ]; then
        echo -e "${GREEN}✓ 所有 Homebrew 记录的应用和工具都已正确安装，无需清理${NC}"
        echo ""
        exit 0
    fi

    echo -e "${YELLOW}⚠ 发现 $count 个已删除但 Homebrew 仍有记录的项目${NC}"
    echo ""
}

# 显示已删除应用列表并让用户选择
select_apps_to_clean() {
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}以下应用/工具已从系统删除，但 Homebrew 仍有记录：${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""

    # 准备选项列表
    local options=()
    while IFS='|' read -r type name display_name; do
        if [ "$type" = "cask" ]; then
            options+=("$name  [$display_name] [Cask]")
        else
            options+=("$name  [Formula]")
        fi
    done < "$MISSING_APPS"

    # 使用 gum 进行多选
    echo -e "${BLUE}请选择要清理的项目（空格选择，回车确认）：${NC}"
    echo ""

    gum choose --no-limit --height=20 "${options[@]}" > "$SELECTED_FILE" || {
        echo -e "${YELLOW}已取消操作${NC}"
        exit 0
    }

    if [ ! -s "$SELECTED_FILE" ]; then
        echo -e "${YELLOW}未选择任何项目，退出${NC}"
        exit 0
    fi

    echo ""
}

# 确认操作
confirm_action() {
    local count=$(wc -l < "$SELECTED_FILE" | tr -d ' ')
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}将要执行以下操作：${NC}"
    echo -e "  ${RED}• 从 Homebrew 数据库清理 $count 个项目的记录${NC}"
    echo -e "  ${GREEN}• 不会修改 Brewfile${NC}"
    echo -e "  ${GREEN}• 不会删除任何文件${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""

    if gum confirm "确认继续？"; then
        return 0
    else
        echo -e "${YELLOW}已取消操作${NC}"
        exit 0
    fi
}

# 清理选中的应用
clean_brew_info() {
    echo -e "${BLUE}🧹 正在清理 Homebrew 记录...${NC}"
    echo ""

    # 提前获取 sudo 权限，避免多次输入密码
    echo -e "${YELLOW}某些应用可能需要管理员权限，请输入密码：${NC}"
    sudo -v

    # 保持 sudo 权限活跃
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    local success_count=0
    local failed_apps=()

    while IFS= read -r line; do
        # 从选择的行中提取名称和类型
        # 格式: "name  [display_name] [Cask]" 或 "name  [Formula]"
        local name=$(echo "$line" | sed 's/  \[.*$//')
        local type=""

        if [[ "$line" == *"[Cask]"* ]]; then
            type="cask"
        elif [[ "$line" == *"[Formula]"* ]]; then
            type="formula"
        fi

        echo -e "${CYAN}清理: $name ${YELLOW}[$type]${NC}"

        # 根据类型使用不同的卸载命令
        if [ "$type" = "cask" ]; then
            if brew uninstall --cask --force "$name" 2>&1 | grep -qi "error"; then
                echo -e "${YELLOW}  ⚠ 清理失败${NC}"
                failed_apps+=("$name [Cask]")
            else
                echo -e "${GREEN}  ✓ 已清理 Homebrew 记录${NC}"
                ((success_count++))
            fi
        elif [ "$type" = "formula" ]; then
            if brew uninstall --force "$name" 2>&1 | grep -qi "error"; then
                echo -e "${YELLOW}  ⚠ 清理失败${NC}"
                failed_apps+=("$name [Formula]")
            else
                echo -e "${GREEN}  ✓ 已清理 Homebrew 记录${NC}"
                ((success_count++))
            fi
        fi
        echo ""
    done < "$SELECTED_FILE"

    echo -e "${GREEN}✓ 成功清理 $success_count 个项目的 Homebrew 记录${NC}"

    if [ ${#failed_apps[@]} -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}以下项目清理失败：${NC}"
        printf '  • %s\n' "${failed_apps[@]}"
    fi
}

# 显示完成摘要
show_summary() {
    local count=$(wc -l < "$SELECTED_FILE" | tr -d ' ')

    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ 清理完成！${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "  • 已清理 ${GREEN}$count${NC} 个项目的 Homebrew 记录"
    echo -e "  • Brewfile 未修改"
    echo -e "  • 查看状态: ${CYAN}brew list --cask${NC} 或 ${CYAN}brew list --formula${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}提示: 如果需要重新安装，运行 'brew bundle' 即可${NC}"
}

# 主函数
main() {
    print_header
    check_dependencies
    get_brew_casks
    get_brew_formulas
    get_installed_apps
    detect_missing_apps
    detect_missing_formulas
    check_missing_items
    select_apps_to_clean
    confirm_action
    clean_brew_info
    show_summary
}

# 运行主函数
main
